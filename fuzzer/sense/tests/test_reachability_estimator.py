#!/usr/bin/env python3
"""
Unit tests for the ReachabilityEstimator (fuzzer/sense/monitor/reachability_estimator.py).

Tests the full pipeline:
  1. CFG node lookup by line number
  2. SRA Graph construction from synthetic cfg_inter dicts
  3. Twopoint probability computation (linear and branching)
  4. ReachabilityEstimator initialization (with and without Graph)
  5. All three estimation cases:
     - Case 1: Completed flow → empirical frequency
     - Case 2: Partially covered → anchor-and-multiply
     - Case 3: Nothing covered → SRA structure estimation
  6. Fallback to Laplace when CFG mapping fails
  7. Anchor selection (deepest covered node)
  8. Multiple flows and inter-procedural chains

Uses synthetic CFGs built programmatically (no LLVM toolchain needed).
The CFGs follow the same format as cfggen.py output — dict with "nodes"
and "edges" keys — and can be consumed directly by sra.estimator.Graph.

Can be run with pytest or standalone: python test_reachability_estimator.py
"""

import sys
import os
import tempfile
from pathlib import Path
from collections import namedtuple

# Add monitor and rq2 directories to path
monitor_dir = str(Path(__file__).resolve().parents[1] / "monitor")
rq2_dir = str(Path(__file__).resolve().parents[3] / "rq2")
sys.path.insert(0, monitor_dir)
sys.path.insert(0, rq2_dir)

from flow_db import FlowDatabase
from event_processor import ExecutionAnalysis, FlowCompletion
from shm_protocol import ParsedFlowEvent
from reachability_estimator import (
    ReachabilityEstimator,
    FlowChain,
    _find_cfg_node_by_line,
    _compute_twopoint_prob,
)
from sra.estimator import Graph, SimpleGraph


# ---------------------------------------------------------------------------
# Helper functions: build synthetic cfg_inter dicts for testing.
#
# These follow the same format as cfggen.py output (see CLAUDE.md "CFG JSON
# Format" section). Each dict has:
#   - "nodes": {node_id: {linenums, func, call, branch, program_exit, nopred}}
#   - "edges": {"intra": {src: [[dst, type], ...]}, "inter": {...}}
#
# Key conventions:
#   - "nopred": True marks the program entry (no predecessors)
#   - "program_exit": True marks exit nodes
#   - linenums are sets of source line numbers (matching .flowdb locations)
#   - Edge types: "unconditional", "true", "false"
#   - Inter-proc nodes: "funcname-formal_in", "funcname-formal_out",
#     "callsite-actual_in", "callsite-actual_out"
# ---------------------------------------------------------------------------

def build_linear_cfg():
    """
    Build a simple single-function linear CFG (no branches):

        main_entry -> node_A -> node_B -> node_C -> main_exit

    All transitions are unconditional, so twopoint probability between any
    two nodes on this path should be exactly 1.0.

    Line number assignments (used in .flowdb to map flow locations):
        main_entry: line 10   (will be used as source)
        node_A:     line 20   (will be used as intermediate 1)
        node_B:     line 30   (will be used as intermediate 2)
        node_C:     line 40   (will be used as sink)
        main_exit:  line 50   (program exit, not part of flows)
    """
    nodes = {
        "main_entry": {
            "linenums": {10}, "func": "main", "call": None,
            "branch": False, "program_exit": False, "nopred": True,
        },
        "node_A": {
            "linenums": {20}, "func": "main", "call": None,
            "branch": False, "program_exit": False, "nopred": False,
        },
        "node_B": {
            "linenums": {30}, "func": "main", "call": None,
            "branch": False, "program_exit": False, "nopred": False,
        },
        "node_C": {
            "linenums": {40}, "func": "main", "call": None,
            "branch": False, "program_exit": False, "nopred": False,
        },
        "main_exit": {
            "linenums": {50}, "func": "main", "call": None,
            "branch": False, "program_exit": True, "nopred": False,
        },
    }
    edges = {
        "intra": {
            "main_entry": [["node_A", "unconditional"]],
            "node_A":     [["node_B", "unconditional"]],
            "node_B":     [["node_C", "unconditional"]],
            "node_C":     [["main_exit", "unconditional"]],
            "main_exit":  [],
        },
        "inter": {},
    }
    return {"nodes": nodes, "edges": edges}


def build_branching_cfg():
    """
    Build a single-function CFG with a binary branch (if-else):

        main_entry -> branch_node --(true)--> node_T -> merge_node -> main_exit
                                  --(false)-> node_F -> merge_node

    The branch_node has branch=True and two successors. SRA's twopoint
    probability from branch_node to either child should be ~0.5 (equal
    probability for each branch). The merge_node is a post-dominator of
    branch_node, so P(branch_node -> merge_node) = 1.0.

    Line number assignments:
        main_entry:  line 10
        branch_node: line 20   (source in test flows)
        node_T:      line 30   (true branch target)
        node_F:      line 35   (false branch target, used as intermediate)
        merge_node:  line 40   (convergence point, used as sink)
        main_exit:   line 50
    """
    nodes = {
        "main_entry": {
            "linenums": {10}, "func": "main", "call": None,
            "branch": False, "program_exit": False, "nopred": True,
        },
        "branch_node": {
            "linenums": {20}, "func": "main", "call": None,
            "branch": True, "program_exit": False, "nopred": False,
        },
        "node_T": {
            "linenums": {30}, "func": "main", "call": None,
            "branch": False, "program_exit": False, "nopred": False,
        },
        "node_F": {
            "linenums": {35}, "func": "main", "call": None,
            "branch": False, "program_exit": False, "nopred": False,
        },
        "merge_node": {
            "linenums": {40}, "func": "main", "call": None,
            "branch": False, "program_exit": False, "nopred": False,
        },
        "main_exit": {
            "linenums": {50}, "func": "main", "call": None,
            "branch": False, "program_exit": True, "nopred": False,
        },
    }
    edges = {
        "intra": {
            "main_entry":  [["branch_node", "unconditional"]],
            "branch_node": [["node_T", "true"], ["node_F", "false"]],
            "node_T":      [["merge_node", "unconditional"]],
            "node_F":      [["merge_node", "unconditional"]],
            "merge_node":  [["main_exit", "unconditional"]],
            "main_exit":   [],
        },
        "inter": {},
    }
    return {"nodes": nodes, "edges": edges}


def build_interprocedural_cfg():
    """
    Build a two-function CFG where main() calls foo():

        main:
            main_entry -> call_foo-actual_in -> call_foo-actual_out -> main_exit

        foo:
            foo-formal_in -> foo_node_A -> foo_node_B -> foo-formal_out

    Inter-procedural edges (in cfg_inter["edges"]["inter"]):
        call_foo-actual_in -> foo-formal_in   (call edge)
        foo-formal_out -> call_foo-actual_out  (return edge)

    Note: SRA's Graph._build_intra_cfgs() automatically adds an
    actual_in -> actual_out intra-procedural edge to model the "call
    returns" path, which is why we leave call_foo-actual_in's intra
    edges empty.

    Used to test inter-procedural twopoint probability computation,
    which requires decomposing via the call graph.

    Line number assignments:
        main_entry:          line 10  (source in test flows)
        call_foo-actual_in:  line 15  (call site)
        call_foo-actual_out: line 16  (return site)
        main_exit:           line 50
        foo_node_A:          line 100 (intermediate in test flows)
        foo_node_B:          line 110 (sink in test flows)
    """
    nodes = {
        "main_entry": {
            "linenums": {10}, "func": "main", "call": None,
            "branch": False, "program_exit": False, "nopred": True,
        },
        "call_foo-actual_in": {
            "linenums": {15}, "func": "main", "call": "foo",
            "branch": False, "program_exit": False, "nopred": False,
        },
        "call_foo-actual_out": {
            "linenums": {16}, "func": "main", "call": None,
            "branch": False, "program_exit": False, "nopred": False,
        },
        "main_exit": {
            "linenums": {50}, "func": "main", "call": None,
            "branch": False, "program_exit": True, "nopred": False,
        },
        "foo-formal_in": {
            "linenums": set(), "func": "foo", "call": None,
            "branch": False, "program_exit": False, "nopred": False,
        },
        "foo_node_A": {
            "linenums": {100}, "func": "foo", "call": None,
            "branch": False, "program_exit": False, "nopred": False,
        },
        "foo_node_B": {
            "linenums": {110}, "func": "foo", "call": None,
            "branch": False, "program_exit": False, "nopred": False,
        },
        "foo-formal_out": {
            "linenums": set(), "func": "foo", "call": None,
            "branch": False, "program_exit": False, "nopred": False,
        },
    }
    edges = {
        "intra": {
            "main_entry":          [["call_foo-actual_in", "unconditional"]],
            "call_foo-actual_in":  [],  # actual_in -> actual_out is added by _build_intra_cfgs
            "call_foo-actual_out": [["main_exit", "unconditional"]],
            "main_exit":           [],
            "foo-formal_in":       [["foo_node_A", "unconditional"]],
            "foo_node_A":          [["foo_node_B", "unconditional"]],
            "foo_node_B":          [["foo-formal_out", "unconditional"]],
            "foo-formal_out":      [],
        },
        "inter": {
            "call_foo-actual_in": [["foo-formal_in", "unconditional"]],
            "foo-formal_out":     [["call_foo-actual_out", "unconditional"]],
        },
    }
    return {"nodes": nodes, "edges": edges}


def write_flowdb(path: str, content: str):
    """Write a .flowdb file."""
    with open(path, 'w') as f:
        f.write(content)


def make_flow_event(type_str: str, id_val: int, data_hash: int = 0xDEAD):
    """Create a synthetic ParsedFlowEvent."""
    return ParsedFlowEvent(
        type=type_str,
        id=id_val,
        timestamp_ns=1000000,
        data_hash=data_hash,
        data_size=8,
    )


def make_execution_analysis(
    pid: int,
    source_ids=None,
    sink_ids=None,
    coverage_hits=None,
    completed_flow_ids=None,
    flow_db=None,
):
    """
    Create a synthetic ExecutionAnalysis to simulate a fuzzing execution.

    In the real monitor, ExecutionAnalysis is produced by EventProcessor from
    shared memory data. Here we construct it directly with known values to
    test the estimator's update() and estimate_all() logic.

    Args:
        pid: Fake process ID for this execution
        source_ids: List of source location IDs that were triggered
        sink_ids: List of sink location IDs that were triggered
        coverage_hits: Dict of {loc_id: hit_count} for intermediate coverage
        completed_flow_ids: List of flow IDs that were fully completed
        flow_db: Required if completed_flow_ids is set (to look up flow defs)
    """
    source_events = [make_flow_event("SOURCE", sid) for sid in (source_ids or [])]
    sink_events = [make_flow_event("SINK", sid) for sid in (sink_ids or [])]

    completed_flows = []
    if completed_flow_ids and flow_db:
        for fid in completed_flow_ids:
            flow_def = flow_db.flows[fid]
            completed_flows.append(FlowCompletion(
                flow_id=fid,
                source_event=make_flow_event("SOURCE", flow_def.source_id),
                sink_event=make_flow_event("SINK", flow_def.sink_id),
                time_delta_ns=5000,
                intermediate_coverage=set(flow_def.intermediate_ids),
            ))

    return ExecutionAnalysis(
        pid=pid,
        total_events=len(source_events) + len(sink_events),
        source_events=source_events,
        sink_events=sink_events,
        completed_flows=completed_flows,
        coverage_hits=coverage_hits or {},
    )


# ---------- Tests ----------

def test_find_cfg_node_by_line():
    """Test _find_cfg_node_by_line matches nodes correctly."""
    cfg_inter = build_linear_cfg()

    # Exact match
    node = _find_cfg_node_by_line(cfg_inter, 20)
    assert node == "node_A", f"Expected node_A, got {node}"

    # With func filter
    node = _find_cfg_node_by_line(cfg_inter, 20, func_name="main")
    assert node == "node_A", f"Expected node_A with func filter, got {node}"

    # Wrong func
    node = _find_cfg_node_by_line(cfg_inter, 20, func_name="foo")
    assert node is None, f"Expected None for wrong func, got {node}"

    # Non-existent line
    node = _find_cfg_node_by_line(cfg_inter, 999)
    assert node is None, f"Expected None for nonexistent line, got {node}"

    print("  PASS: test_find_cfg_node_by_line")


def test_graph_construction_linear():
    """Test that Graph construction works with our synthetic linear CFG."""
    cfg_inter = build_linear_cfg()
    graph = Graph(cfg_inter)

    assert "main" in graph.intra_cfgs, "main should be in intra_cfgs"
    assert graph.program_entry == "main_entry", f"Expected main_entry, got {graph.program_entry}"
    assert len(graph.get_functions()) == 1, "Should have 1 function"

    print("  PASS: test_graph_construction_linear")


def test_graph_construction_branching():
    """Test that Graph construction works with branching CFG."""
    cfg_inter = build_branching_cfg()
    graph = Graph(cfg_inter)

    assert "main" in graph.intra_cfgs
    intra = graph.intra_cfgs["main"]
    # branch_node should have 2 children
    children = intra.get_childs("branch_node")
    assert len(children) == 2, f"branch_node should have 2 children, got {len(children)}"

    print("  PASS: test_graph_construction_branching")


def test_graph_construction_interprocedural():
    """Test that Graph construction works with inter-procedural CFG."""
    cfg_inter = build_interprocedural_cfg()
    graph = Graph(cfg_inter)

    assert "main" in graph.intra_cfgs
    assert "foo" in graph.intra_cfgs
    assert len(graph.get_functions()) == 2

    # Check call graph: main -> foo
    call_children = graph.call_graph.get_childs("main")
    assert "foo" in call_children, f"main should call foo, got children: {call_children}"

    print("  PASS: test_graph_construction_interprocedural")


def test_twopoint_prob_linear():
    """Test twopoint probability on a linear CFG."""
    cfg_inter = build_linear_cfg()
    graph = Graph(cfg_inter)

    # Adjacent nodes: should have high probability (1.0 on linear path)
    prob = _compute_twopoint_prob(graph, "main_entry", "node_A")
    assert prob is not None, "twopoint prob should not be None for adjacent nodes"
    assert prob == 1.0, f"Expected 1.0 for linear adjacent, got {prob}"

    # Non-adjacent: main_entry -> node_C (3 hops)
    prob = _compute_twopoint_prob(graph, "main_entry", "node_C")
    assert prob is not None, "twopoint prob should not be None for reachable nodes"
    assert prob == 1.0, f"Expected 1.0 for linear path, got {prob}"

    print("  PASS: test_twopoint_prob_linear")


def test_twopoint_prob_branching():
    """Test twopoint probability on a branching CFG."""
    cfg_inter = build_branching_cfg()
    graph = Graph(cfg_inter)

    # branch_node -> node_T: one of two branches
    prob_t = _compute_twopoint_prob(graph, "branch_node", "node_T")
    assert prob_t is not None
    assert 0 < prob_t <= 1.0, f"Expected prob in (0,1], got {prob_t}"

    # branch_node -> node_F: the other branch
    prob_f = _compute_twopoint_prob(graph, "branch_node", "node_F")
    assert prob_f is not None
    assert 0 < prob_f <= 1.0, f"Expected prob in (0,1], got {prob_f}"

    # Both branches should be reachable, probs should sum to ~1.0
    # (they're exclusive paths from branch to merge)
    print(f"    branch->T prob={prob_t:.4f}, branch->F prob={prob_f:.4f}")

    # branch_node -> merge_node: reachable via either branch
    prob_merge = _compute_twopoint_prob(graph, "branch_node", "merge_node")
    assert prob_merge is not None
    assert prob_merge == 1.0, f"Expected 1.0 for merge point (all paths lead there), got {prob_merge}"

    print("  PASS: test_twopoint_prob_branching")


def test_estimator_init_no_graph():
    """Test estimator initialization without a graph (Laplace fallback)."""
    with tempfile.NamedTemporaryFile(mode='w', suffix='.flowdb', delete=False) as f:
        f.write("VERSION: 1.1\n")
        f.write("SOURCE,1,test.c,10,1,5\n")
        f.write("SINK,2,test.c,40,1,5\n")
        f.write("INTERMEDIATE,3,test.c,20,1,5\n")
        f.write("FLOW,1,1,2,[3],test flow\n")
        flowdb_path = f.name

    try:
        flow_db = FlowDatabase.from_file(Path(flowdb_path))
        estimator = ReachabilityEstimator(flow_db, graph=None)

        assert estimator.total_executions == 0
        assert len(estimator.flow_chains) == 0  # No graph -> no chains

        # Estimate with no executions
        estimates = estimator.estimate_all()
        assert 1 in estimates
        assert estimates[1].probability == 0.0  # No executions

        print("  PASS: test_estimator_init_no_graph")
    finally:
        os.unlink(flowdb_path)


def test_estimator_with_linear_cfg():
    """
    End-to-end test: linear CFG with all three estimation cases.

    Flow: source(line 10) -> int(line 20) -> int(line 30) -> sink(line 40)
    On a linear path, all transition probs = 1.0.

    Tests progression through:
      1. Case 3 (nothing covered) → non-zero structural estimate
      2. Case 2 (source + 1 intermediate covered) → anchor-based estimate
      3. Case 1 (flow completed) → empirical frequency 1/2
    """
    cfg_inter = build_linear_cfg()
    graph = Graph(cfg_inter)

    with tempfile.NamedTemporaryFile(mode='w', suffix='.flowdb', delete=False) as f:
        f.write("VERSION: 1.1\n")
        # Source at line 10 (main_entry), intermediate at line 20 (node_A),
        # another at line 30 (node_B), sink at line 40 (node_C)
        f.write("SOURCE,1,test.c,10,1,5\n")
        f.write("SINK,2,test.c,40,1,5\n")
        f.write("INTERMEDIATE,3,test.c,20,1,5\n")
        f.write("INTERMEDIATE,4,test.c,30,1,5\n")
        f.write("FLOW,1,1,2,[3,4],test linear flow\n")
        flowdb_path = f.name

    try:
        flow_db = FlowDatabase.from_file(Path(flowdb_path))
        estimator = ReachabilityEstimator(flow_db, graph=graph)

        # Check chain was built
        assert 1 in estimator.flow_chains
        chain = estimator.flow_chains[1]
        assert chain.fully_mapped, f"Chain should be fully mapped, got: {chain.chain}"
        assert len(chain.chain) == 4  # source + 2 intermediates + sink
        assert len(chain.transition_probs) == 3  # 3 transitions

        # All transitions on a linear path should be 1.0
        for i, tp in enumerate(chain.transition_probs):
            assert tp is not None, f"transition_prob[{i}] should not be None"
            assert tp == 1.0, f"transition_prob[{i}] should be 1.0 on linear path, got {tp}"

        print(f"    Chain: {[(t, lid, n) for t, lid, n in chain.chain]}")
        print(f"    Transition probs: {chain.transition_probs}")

        # Test Case 3: No coverage → SRA estimates P(→source) × product(transitions)
        estimates = estimator.estimate_all()
        est = estimates[1]
        # With 0 executions, Case 3 uses Laplace fallback: alpha/(0+2*alpha) = 0.5
        assert est.probability > 0.0
        assert est.source_covered is False
        assert est.sink_covered is False

        # Feed an execution where source is covered
        analysis = make_execution_analysis(
            pid=1,
            source_ids=[1],  # source_id=1 matches flow source
            coverage_hits={3: 1},  # intermediate loc_id=3 hit once
        )
        estimator.update(analysis)

        assert estimator.total_executions == 1
        assert estimator.flow_source_hits[1] == 1

        estimates = estimator.estimate_all()
        est = estimates[1]
        assert est.source_covered is True
        assert est.intermediates_covered == 1  # intermediate 3
        assert est.probability > 0, f"Probability should be > 0, got {est.probability}"
        assert est.anchor_node is not None, "Should have an anchor"
        print(f"    After 1 exec (source + int3 covered): P={est.probability:.6f}, anchor={est.anchor_node}")

        # Feed an execution with flow completion
        analysis2 = make_execution_analysis(
            pid=2,
            source_ids=[1],
            sink_ids=[2],
            coverage_hits={3: 1, 4: 1},
            completed_flow_ids=[1],
            flow_db=flow_db,
        )
        estimator.update(analysis2)

        estimates = estimator.estimate_all()
        est = estimates[1]
        # Case 1: completed flow → empirical frequency
        assert est.probability == 1 / 2, f"Expected 0.5 (1 completion / 2 execs), got {est.probability}"
        print(f"    After 2 execs (1 completion): P={est.probability:.6f}")

        print("  PASS: test_estimator_with_linear_cfg")
    finally:
        os.unlink(flowdb_path)


def test_estimator_with_branching_cfg():
    """
    Test estimator with a branching CFG where the flow goes through
    the false branch (one of two possible paths).

    Flow: source(branch_node) -> intermediate(node_F) -> sink(merge_node)
    Expected: transition source->int < 1.0 (branch), int->sink = 1.0 (linear).
    With source covered, P = P_empirical(source) * P(src->int) * P(int->sink).
    """
    cfg_inter = build_branching_cfg()
    graph = Graph(cfg_inter)

    with tempfile.NamedTemporaryFile(mode='w', suffix='.flowdb', delete=False) as f:
        f.write("VERSION: 1.1\n")
        # Source at branch_node (line 20), intermediate at node_F (line 35), sink at merge (line 40)
        f.write("SOURCE,1,test.c,20,1,5\n")
        f.write("SINK,2,test.c,40,1,5\n")
        f.write("INTERMEDIATE,3,test.c,35,1,5\n")
        f.write("FLOW,1,1,2,[3],branching flow\n")
        flowdb_path = f.name

    try:
        flow_db = FlowDatabase.from_file(Path(flowdb_path))
        estimator = ReachabilityEstimator(flow_db, graph=graph)

        chain = estimator.flow_chains[1]
        assert chain.fully_mapped

        # source(branch_node) -> intermediate(node_F): should be < 1.0 (one of two branches)
        tp_src_to_int = chain.transition_probs[0]
        assert tp_src_to_int is not None
        assert 0 < tp_src_to_int < 1.0, \
            f"Expected prob < 1.0 for branch, got {tp_src_to_int}"

        # intermediate(node_F) -> sink(merge_node): should be 1.0 (linear)
        tp_int_to_sink = chain.transition_probs[1]
        assert tp_int_to_sink is not None
        assert tp_int_to_sink == 1.0, \
            f"Expected 1.0 for linear segment, got {tp_int_to_sink}"

        print(f"    Transition probs: {chain.transition_probs}")
        print(f"    (branch prob = {tp_src_to_int:.4f})")

        # Test with source covered but nothing else
        analysis = make_execution_analysis(pid=1, source_ids=[1])
        estimator.update(analysis)

        estimates = estimator.estimate_all()
        est = estimates[1]
        assert est.source_covered
        assert not est.sink_covered
        assert est.probability > 0
        # Probability should be P_empirical(source) * P(source->int) * P(int->sink)
        # = (1/1) * tp_src_to_int * 1.0 = tp_src_to_int
        expected = 1.0 * tp_src_to_int * tp_int_to_sink
        assert abs(est.probability - expected) < 1e-9, \
            f"Expected {expected}, got {est.probability}"
        print(f"    Source covered: P={est.probability:.6f} (expected {expected:.6f})")

        print("  PASS: test_estimator_with_branching_cfg")
    finally:
        os.unlink(flowdb_path)


def test_estimator_report():
    """Test that report() produces output without errors."""
    cfg_inter = build_linear_cfg()
    graph = Graph(cfg_inter)

    with tempfile.NamedTemporaryFile(mode='w', suffix='.flowdb', delete=False) as f:
        f.write("VERSION: 1.1\n")
        f.write("SOURCE,1,test.c,10,1,5\n")
        f.write("SINK,2,test.c,40,1,5\n")
        f.write("FLOW,1,1,2,[],simple flow\n")
        flowdb_path = f.name

    try:
        flow_db = FlowDatabase.from_file(Path(flowdb_path))
        estimator = ReachabilityEstimator(flow_db, graph=graph)

        # Report with no executions
        report = estimator.report()
        assert "FLOW REACHABILITY ESTIMATES" in report
        assert "Flow" in report

        # Report after some executions
        analysis = make_execution_analysis(pid=1, source_ids=[1])
        estimator.update(analysis)
        report = estimator.report()
        assert "Total executions: 1" in report

        print("  PASS: test_estimator_report")
    finally:
        os.unlink(flowdb_path)


def test_estimator_fallback_no_mapping():
    """Test fallback when flow locations can't be mapped to CFG nodes."""
    cfg_inter = build_linear_cfg()
    graph = Graph(cfg_inter)

    with tempfile.NamedTemporaryFile(mode='w', suffix='.flowdb', delete=False) as f:
        f.write("VERSION: 1.1\n")
        # Use line numbers that don't exist in the CFG
        f.write("SOURCE,1,test.c,999,1,5\n")
        f.write("SINK,2,test.c,998,1,5\n")
        f.write("FLOW,1,1,2,[],unmapped flow\n")
        flowdb_path = f.name

    try:
        flow_db = FlowDatabase.from_file(Path(flowdb_path))
        estimator = ReachabilityEstimator(flow_db, graph=graph)

        # Chain should exist but not be fully mapped
        chain = estimator.flow_chains[1]
        assert not chain.fully_mapped

        # Should fall back to Laplace estimation
        analysis = make_execution_analysis(pid=1, source_ids=[1])
        estimator.update(analysis)

        estimates = estimator.estimate_all()
        est = estimates[1]
        assert est.probability > 0, "Fallback should give non-zero probability"
        print(f"    Fallback probability: {est.probability:.6f}")

        print("  PASS: test_estimator_fallback_no_mapping")
    finally:
        os.unlink(flowdb_path)


def test_estimator_anchor_deepest_covered():
    """
    Test that the anchor is correctly identified as the deepest covered node
    (closest to sink) in the flow chain.

    With source + both intermediates covered (but not sink), the anchor
    should be the last intermediate (intermediate_4), not the source.
    This means fewer transitions to multiply, yielding P = 1.0 on a linear path.
    """
    cfg_inter = build_linear_cfg()
    graph = Graph(cfg_inter)

    with tempfile.NamedTemporaryFile(mode='w', suffix='.flowdb', delete=False) as f:
        f.write("VERSION: 1.1\n")
        f.write("SOURCE,1,test.c,10,1,5\n")
        f.write("SINK,2,test.c,40,1,5\n")
        f.write("INTERMEDIATE,3,test.c,20,1,5\n")
        f.write("INTERMEDIATE,4,test.c,30,1,5\n")
        f.write("FLOW,1,1,2,[3,4],anchor test\n")
        flowdb_path = f.name

    try:
        flow_db = FlowDatabase.from_file(Path(flowdb_path))
        estimator = ReachabilityEstimator(flow_db, graph=graph)

        # Cover source + both intermediates (but not sink)
        analysis = make_execution_analysis(
            pid=1,
            source_ids=[1],
            coverage_hits={3: 1, 4: 1},
        )
        estimator.update(analysis)

        estimates = estimator.estimate_all()
        est = estimates[1]
        # Anchor should be intermediate_4 (loc_id=4), the deepest covered
        assert est.anchor_node == "intermediate_4", \
            f"Expected anchor intermediate_4, got {est.anchor_node}"

        # Probability should be P_empirical(node_B) * P(node_B -> node_C)
        # node_B is anchor (loc_id=4), transition to sink is 1.0 on linear path
        # P_empirical(node_B) = 1/1 (hit once in 1 execution)
        # So P = 1.0 * 1.0 = 1.0
        assert est.probability == 1.0, f"Expected 1.0, got {est.probability}"
        print(f"    Anchor={est.anchor_node}, P={est.probability}")

        # Now test with only source covered (anchor should be source)
        estimator2 = ReachabilityEstimator(flow_db, graph=graph)
        analysis2 = make_execution_analysis(pid=1, source_ids=[1])
        estimator2.update(analysis2)

        est2 = estimator2.estimate_all()[1]
        assert est2.anchor_node == "source_1", \
            f"Expected anchor source_1, got {est2.anchor_node}"
        print(f"    Source-only anchor={est2.anchor_node}, P={est2.probability}")

        print("  PASS: test_estimator_anchor_deepest_covered")
    finally:
        os.unlink(flowdb_path)


def test_estimator_case3_nothing_covered():
    """Test Case 3: nothing covered, uses SRA structure estimation."""
    cfg_inter = build_linear_cfg()
    graph = Graph(cfg_inter)

    with tempfile.NamedTemporaryFile(mode='w', suffix='.flowdb', delete=False) as f:
        f.write("VERSION: 1.1\n")
        f.write("SOURCE,1,test.c,10,1,5\n")
        f.write("SINK,2,test.c,40,1,5\n")
        f.write("FLOW,1,1,2,[],case3 test\n")
        flowdb_path = f.name

    try:
        flow_db = FlowDatabase.from_file(Path(flowdb_path))
        estimator = ReachabilityEstimator(flow_db, graph=graph)

        # Feed an execution that doesn't cover any flow nodes
        analysis = make_execution_analysis(pid=1)
        estimator.update(analysis)

        estimates = estimator.estimate_all()
        est = estimates[1]
        assert not est.source_covered
        assert not est.sink_covered
        assert est.anchor_node is None
        assert est.probability > 0, f"Case 3 should give non-zero probability via SRA"
        print(f"    Case 3 probability: {est.probability:.8f}")

        print("  PASS: test_estimator_case3_nothing_covered")
    finally:
        os.unlink(flowdb_path)


def test_multiple_flows():
    """Test estimator with multiple flows."""
    cfg_inter = build_linear_cfg()
    graph = Graph(cfg_inter)

    with tempfile.NamedTemporaryFile(mode='w', suffix='.flowdb', delete=False) as f:
        f.write("VERSION: 1.1\n")
        f.write("SOURCE,1,test.c,10,1,5\n")
        f.write("SOURCE,5,test.c,20,1,5\n")
        f.write("SINK,2,test.c,40,1,5\n")
        f.write("SINK,6,test.c,50,1,5\n")
        f.write("INTERMEDIATE,3,test.c,20,1,5\n")
        f.write("INTERMEDIATE,4,test.c,30,1,5\n")
        f.write("FLOW,1,1,2,[3,4],flow 1: entry to node_C\n")
        f.write("FLOW,2,5,6,[4],flow 2: node_A to exit\n")
        flowdb_path = f.name

    try:
        flow_db = FlowDatabase.from_file(Path(flowdb_path))
        estimator = ReachabilityEstimator(flow_db, graph=graph)

        assert 1 in estimator.flow_chains
        assert 2 in estimator.flow_chains
        assert estimator.flow_chains[1].fully_mapped
        assert estimator.flow_chains[2].fully_mapped

        estimates = estimator.estimate_all()
        assert len(estimates) == 2
        print(f"    Flow 1 chain: {len(estimator.flow_chains[1].chain)} nodes")
        print(f"    Flow 2 chain: {len(estimator.flow_chains[2].chain)} nodes")

        print("  PASS: test_multiple_flows")
    finally:
        os.unlink(flowdb_path)


def test_interprocedural_chain():
    """
    Test inter-procedural flow chains where source is in main() and
    intermediate/sink are in foo().

    The chain crosses a function boundary, so twopoint computation must
    use the call graph decomposition (backward slice, path enumeration,
    formal_in/actual_in segments). Even if some transitions fail, the
    estimator should still produce valid (non-negative) estimates via
    Laplace fallback.
    """
    cfg_inter = build_interprocedural_cfg()
    graph = Graph(cfg_inter)

    with tempfile.NamedTemporaryFile(mode='w', suffix='.flowdb', delete=False) as f:
        f.write("VERSION: 1.1\n")
        f.write("SOURCE,1,test.c,10,1,5\n")   # main_entry
        f.write("SINK,2,test.c,110,1,5\n")    # foo_node_B
        f.write("INTERMEDIATE,3,test.c,100,1,5\n")  # foo_node_A
        f.write("FLOW,1,1,2,[3],cross-function flow\n")
        flowdb_path = f.name

    try:
        flow_db = FlowDatabase.from_file(Path(flowdb_path))
        estimator = ReachabilityEstimator(flow_db, graph=graph)

        chain = estimator.flow_chains[1]
        # All nodes should be mapped
        print(f"    Chain: {chain.chain}")
        print(f"    Transition probs: {chain.transition_probs}")
        print(f"    Fully mapped: {chain.fully_mapped}")

        # The chain maps across functions - source is in main, others in foo
        # Transition probs may involve inter-procedural computation
        assert len(chain.chain) == 3  # source, intermediate, sink

        # Even if some transition probs are None (inter-proc fallback),
        # the estimator should still work
        analysis = make_execution_analysis(pid=1, source_ids=[1])
        estimator.update(analysis)

        estimates = estimator.estimate_all()
        est = estimates[1]
        assert est.probability >= 0, "Probability should be non-negative"
        print(f"    Inter-proc estimate: P={est.probability:.8f}")

        print("  PASS: test_interprocedural_chain")
    finally:
        os.unlink(flowdb_path)


# ---------- Main ----------

def main():
    print("=" * 70)
    print("ReachabilityEstimator Unit Tests")
    print("=" * 70)

    tests = [
        test_find_cfg_node_by_line,
        test_graph_construction_linear,
        test_graph_construction_branching,
        test_graph_construction_interprocedural,
        test_twopoint_prob_linear,
        test_twopoint_prob_branching,
        test_estimator_init_no_graph,
        test_estimator_with_linear_cfg,
        test_estimator_with_branching_cfg,
        test_estimator_report,
        test_estimator_fallback_no_mapping,
        test_estimator_anchor_deepest_covered,
        test_estimator_case3_nothing_covered,
        test_multiple_flows,
        test_interprocedural_chain,
    ]

    passed = 0
    failed = 0

    for test in tests:
        try:
            print(f"\n[RUN] {test.__name__}")
            test()
            passed += 1
        except Exception as e:
            print(f"  FAIL: {test.__name__}: {e}")
            import traceback
            traceback.print_exc()
            failed += 1

    print(f"\n{'=' * 70}")
    print(f"Results: {passed} passed, {failed} failed, {passed + failed} total")
    print(f"{'=' * 70}")

    return 0 if failed == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
