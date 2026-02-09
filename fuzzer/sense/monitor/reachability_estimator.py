"""
Reachability estimator for taint flow coverage probability.

This module integrates SRA (Statistical Reachability Analysis) with the
fuzzing monitor to predict how likely each uncovered taint flow is to be
completed. It bridges two worlds:

  1. The monitor's flow model: flows are defined in .flowdb files as linear
     chains of source -> intermediate_1 -> ... -> intermediate_k -> sink,
     where each location is identified by file:line:col.

  2. SRA's CFG model: a program is represented as an inter-procedural control
     flow graph (cfg_inter JSON), where nodes are basic blocks with line
     numbers, and edges are intra/inter-procedural transitions.

The estimator works in two phases:

  PRE-COMPUTATION (at startup, once):
    - Map each flow location (file:line:col from .flowdb) to a CFG node
      by matching line numbers against node["linenums"] sets.
    - For each consecutive pair of nodes in each flow chain, compute the
      SRA "twopoint" structural transition probability using SimpleGraph's
      post-dominator decomposition and path enumeration algorithm.
    - These transition probabilities are cached in FlowChain objects.

  ESTIMATION (per execution, incrementally):
    As fuzzing executions come in, the estimator tracks which flow nodes
    have been covered, then applies one of three cases:

    Case 1 (flow already completed):
      P = completions / total_executions
      Simple empirical frequency — the flow has been fully exercised.

    Case 2 (at least one flow node covered):
      Find the "anchor" — the deepest covered node (closest to sink).
      P = P_empirical(anchor) * product(transition_probs from anchor to sink)
      This combines observed coverage with structural reachability.

    Case 3 (nothing covered at all):
      Use SRA's full structure_estimation to estimate P(program_entry -> source),
      then multiply by all transition probabilities along the chain.
      P = P_SRA(->source) * product(all transition_probs to sink)

  FALLBACK:
    When no CFG is available, or when flow locations can't be mapped to CFG
    nodes, the estimator falls back to Laplace smoothing:
      P_unseen = alpha / (total_executions + 2*alpha)

Dependencies:
  - SRA library (rq2/sra/ or vendored at fuzzer/sense/sra/)
    Specifically: sra.estimator.Graph, sra.estimator.SimpleGraph,
    sra.estimator.structure_estimation, sra.estimator.get_nodes_to_reach
  - flow_db.FlowDatabase (parses .flowdb files)
  - event_processor.ExecutionAnalysis (per-execution coverage data)

Usage:
  # At monitor startup:
  graph = Graph(cfg_inter)  # Load pre-built CFG
  estimator = ReachabilityEstimator(flow_db, graph=graph)

  # Per execution:
  estimator.update(analysis)

  # Query estimates:
  estimates = estimator.estimate_all()  # Dict[flow_id, FlowReachability]
  report = estimator.report()  # Human-readable summary
"""

import sys
import time
import logging
from pathlib import Path
from typing import Dict, List, Optional, Set, Tuple
from dataclasses import dataclass, field
from collections import defaultdict

from flow_db import FlowDatabase, FlowDef
from event_processor import ExecutionAnalysis

# --- SRA library path setup ---
# The SRA library lives at rq2/sra/ in the repo root. Inside the devcontainer,
# only fuzzer/ is mounted (at /workspaces/fuzzer), so rq2/ is inaccessible.
# To solve this, we maintain a vendored copy at fuzzer/sense/sra/.
# This path setup tries the vendored copy first (for devcontainer), then
# falls back to rq2/ (for development on the host or in CI).
_sra_local = str(Path(__file__).resolve().parents[1])  # fuzzer/sense/
_sra_rq2 = str(Path(__file__).resolve().parents[3] / "rq2")  # sra/rq2/
for _p in [_sra_local, _sra_rq2]:
    if _p not in sys.path:
        sys.path.insert(0, _p)

logger = logging.getLogger(__name__)

# Laplace smoothing parameter — controls the strength of prior belief for
# unseen events. Matches the default used in SRA's structure_estimation().
# With alpha=2: P_unseen = 2/(N+4) where N = total executions.
ALPHA = 2.0


@dataclass
class FlowReachability:
    """
    Result of estimating reachability for a single taint flow.

    Returned by ReachabilityEstimator.estimate_all() for each flow_id.
    Contains both the probability estimate and diagnostic information
    about the current coverage state of the flow.
    """
    flow_id: int
    probability: float          # Estimated probability of completing this flow [0, 1]
    source_covered: bool        # Whether the source location has been triggered
    sink_covered: bool          # Whether the sink location has been triggered
    intermediates_total: int    # Total intermediate locations in this flow
    intermediates_covered: int  # Number of intermediate locations covered so far
    coverage_fraction: float    # intermediates_covered / intermediates_total
    # The "anchor" is the deepest covered node (closest to sink) in the flow chain.
    # Used in Case 2 estimation as the starting point for probability multiplication.
    # Format: "{type}_{loc_id}" e.g. "intermediate_3" or "source_1"
    anchor_node: Optional[str] = None

    def __str__(self) -> str:
        anchor = f", anchor={self.anchor_node}" if self.anchor_node else ""
        return (f"Flow {self.flow_id}: "
                f"P={self.probability:.6f} "
                f"(src={'Y' if self.source_covered else 'N'}, "
                f"sink={'Y' if self.sink_covered else 'N'}, "
                f"intermediates={self.intermediates_covered}/{self.intermediates_total}"
                f"{anchor})")


@dataclass
class FlowChain:
    """
    Pre-computed data for a single flow's node chain and transition probabilities.

    Built once at estimator initialization. Contains the ordered mapping from
    flow locations (source/intermediates/sink) to CFG nodes, and the SRA
    twopoint transition probability between each consecutive pair.

    Example for a flow: source(line 10) -> intermediate(line 20) -> sink(line 40)
      chain = [("source", 1, "main_entry"), ("intermediate", 3, "node_A"), ("sink", 2, "node_C")]
      transition_probs = [0.5, 1.0]  # P(main_entry->node_A)=0.5, P(node_A->node_C)=1.0

    If a location cannot be mapped to a CFG node, its cfg_node_id is None and
    the corresponding transition_probs entry is also None. In this case,
    fully_mapped=False and the estimator falls back to Laplace smoothing.
    """
    flow_id: int
    # Ordered list of (location_type, location_id, cfg_node_id) tuples.
    # location_type is "source", "intermediate", or "sink".
    # cfg_node_id is None if the location couldn't be mapped to a CFG node.
    chain: List[Tuple[str, int, Optional[str]]]
    # transition_probs[i] = P(chain[i] -> chain[i+1]) via SRA twopoint probability.
    # None if either endpoint is unmapped or the twopoint computation failed.
    transition_probs: List[Optional[float]]
    # True if ALL locations in the chain were successfully mapped to CFG nodes.
    fully_mapped: bool


def _find_cfg_node_by_line(cfg_inter: dict, line_no: int, func_name: str = None) -> Optional[str]:
    """
    Find a CFG node whose linenums set contains the given source line number.

    This is how we bridge the flow model (file:line:col locations from .flowdb)
    to the CFG model (basic block nodes from LLVM IR). Each CFG node has a
    "linenums" set of source line numbers that map to instructions in that
    basic block. We search for nodes where `line_no in node["linenums"]`.

    Pattern borrowed from rq2/sra/mapper.py:get_node_from_bb_lineno_fuzz().

    Args:
        cfg_inter: The inter-procedural CFG dict (with "nodes" and "edges")
        line_no: Source line number to match (from .flowdb location)
        func_name: If provided, restrict search to nodes in this function

    Returns:
        CFG node ID string, or None if no match found.
        If multiple nodes match, returns the first and logs a warning.
        Falls back to _find_function_entry_by_line() for unmatched lines
        that may correspond to function parameters/declarations.
    """
    # Search all CFG nodes for one whose linenums contains our target line
    candidates = []
    for node, node_info in cfg_inter["nodes"].items():
        if node_info.get("linenums") is None:
            continue
        if func_name and node_info.get("func") != func_name:
            continue
        if line_no in node_info["linenums"]:
            candidates.append((node, node_info))

    if not candidates:
        logger.debug("_find_cfg_node_by_line: no node found for line=%d func=%s "
                      "(searched %d nodes)", line_no, func_name, len(cfg_inter["nodes"]))

        # Fallback: The line may correspond to a function parameter or declaration
        # (e.g. K&R-style C parameter declarations like "int r;" on line 297).
        # These lines don't appear in any basic block's linenums because they
        # aren't executable instructions. We try to map them to the function's
        # entry node instead, since that's where control flow begins.
        entry_node = _find_function_entry_by_line(cfg_inter, line_no, func_name)
        if entry_node:
            logger.info("_find_cfg_node_by_line: line=%d likely a function parameter/declaration, "
                         "mapping to entry node=%s (func=%s)",
                         line_no, entry_node, cfg_inter["nodes"][entry_node].get("func"))
            return entry_node

        return None

    if len(candidates) > 1:
        logger.warning("_find_cfg_node_by_line: multiple nodes match line=%d func=%s: %s "
                        "(using first)", line_no, func_name,
                        [(n, ni.get("func")) for n, ni in candidates])

    node, node_info = candidates[0]
    logger.debug("_find_cfg_node_by_line: line=%d func=%s -> node=%s (func=%s, linenums=%s)",
                  line_no, func_name, node, node_info.get("func"), node_info.get("linenums"))
    return node


def _find_function_entry_by_line(cfg_inter: dict, line_no: int, func_name: str = None) -> Optional[str]:
    """
    Find the entry node of a function that likely contains the given line number.

    This is used as a fallback when a line (e.g., function parameter) doesn't
    appear in any CFG node's linenums.

    Strategy: Find functions where line_no is between the function signature
    and the first executable statement, suggesting it's a function parameter.

    Args:
        cfg_inter: The inter-procedural CFG dict
        line_no: Source line number
        func_name: Optional function name hint

    Returns:
        Entry node ID, or None if not found
    """
    # Group nodes by function
    func_nodes = {}
    for node_id, node_info in cfg_inter["nodes"].items():
        func = node_info.get("func")
        if not func:
            continue
        if func_name and func != func_name:
            continue
        if func not in func_nodes:
            func_nodes[func] = []
        func_nodes[func].append((node_id, node_info))

    # For each function, find entry node and check if line_no is in the signature
    for func, nodes in func_nodes.items():
        # Find entry node (node with entry=True)
        entry_candidates = [(nid, ni) for nid, ni in nodes if ni.get("entry") == True]
        if not entry_candidates:
            continue

        entry_node_id, entry_info = entry_candidates[0]
        entry_linenums = entry_info.get("linenums", [])

        if not entry_linenums:
            continue

        # Entry linenums typically includes:
        # [function_signature_line, first_executable_line, ...]
        # e.g., [296, 308, 309, 311] for InfoTbl
        # Line 299 (parameter) would be BETWEEN 296 and 308
        min_entry_line = min(entry_linenums)
        max_entry_line = max(entry_linenums)

        # Check if line_no is between min and max of entry node,
        # OR slightly before (within 20 lines) to catch parameters
        if (min_entry_line - 20) <= line_no <= max_entry_line:
            # Likely a function parameter or part of function signature
            logger.debug("_find_function_entry_by_line: line=%d is within function %s "
                          "signature range [%d, %d], mapping to entry node %s",
                          line_no, func, min_entry_line, max_entry_line, entry_node_id)
            return entry_node_id

    return None


def _compute_twopoint_prob(graph, src_node: str, dst_node: str) -> Optional[float]:
    """
    Compute the structural transition probability P(src_node -> dst_node).

    This is the core bridge between the flow chain and SRA's structural
    analysis. For each consecutive pair of flow locations, we compute how
    likely it is that control flow will reach dst_node from src_node, based
    purely on the CFG structure (not observed coverage).

    Two cases:
      - Intra-procedural (same function): Uses SimpleGraph.get_twopoint_prob()
        directly, which works by forward/backward slicing to isolate the
        relevant subgraph, decomposing via immediate post-dominators into
        independent segments, and enumerating paths through each segment.

      - Inter-procedural (different functions): Decomposes via the call graph.
        Backward-slices to find call-level paths, then computes per-segment
        twopoint probabilities through the call chain. See
        _compute_interprocedural_prob() for details.

    Args:
        graph: SRA Graph object (contains intra_cfgs and call_graph)
        src_node: Source CFG node ID (e.g. "main_entry", "node_A")
        dst_node: Destination CFG node ID

    Returns:
        Probability float in [0, 1], or None if computation fails
        (e.g. nodes not reachable, graph structure issues)
    """
    src_func = graph.cfg["nodes"][src_node]["func"]
    dst_func = graph.cfg["nodes"][dst_node]["func"]

    try:
        if src_func == dst_func:
            # Intra-procedural: use SimpleGraph directly
            logger.debug("_compute_twopoint_prob: intra-procedural %s -> %s (func=%s)",
                          src_node, dst_node, src_func)
            t0 = time.monotonic()
            prob, length = graph.intra_cfgs[src_func].get_twopoint_prob(
                src_node, dst_node
            )
            elapsed_ms = (time.monotonic() - t0) * 1000
            logger.debug("_compute_twopoint_prob: %s -> %s = %.6f (path_length=%s, %.1fms)",
                          src_node, dst_node, prob, length, elapsed_ms)
            return prob
        else:
            # Inter-procedural: decompose via call graph
            logger.debug("_compute_twopoint_prob: inter-procedural %s (func=%s) -> %s (func=%s)",
                          src_node, src_func, dst_node, dst_func)
            t0 = time.monotonic()
            prob = _compute_interprocedural_prob(graph, src_node, dst_node,
                                                  src_func, dst_func)
            elapsed_ms = (time.monotonic() - t0) * 1000
            logger.debug("_compute_twopoint_prob: inter-proc %s -> %s = %s (%.1fms)",
                          src_node, dst_node, prob, elapsed_ms)
            return prob
    except Exception as e:
        logger.warning("_compute_twopoint_prob: FAILED %s -> %s: %s (%s)",
                        src_node, dst_node, type(e).__name__, e)
        return None


def _compute_interprocedural_prob(graph, src_node: str, dst_node: str,
                                   src_func: str, dst_func: str) -> Optional[float]:
    """
    Compute inter-procedural transition probability across function boundaries.

    When a flow chain crosses function boundaries (e.g. source in main(),
    sink in foo()), we need to account for the call graph structure.

    Algorithm (mirrors rq2/sra/estimator.py:structure_estimation steps 1.1-1.3):
      1. Backward-slice the call graph from dst_func to find all functions
         that can transitively call it.
      2. Enumerate acyclic call-level paths through the sliced call graph
         (e.g. [main, helper, foo]).
      3. Filter to paths that include src_func, then trim to start from src_func.
      4. Decompose each call-level path into segments:
         - First segment: src_node -> actual_in (call site for next function)
         - Middle segments: formal_in -> actual_in (through intermediate functions)
         - Last segment: formal_in -> dst_node (within destination function)
      5. For each segment, compute intra-procedural twopoint probability.
      6. Path probability = product of all segment probabilities.
      7. Total probability = sum across all call-level paths (multiple call
         paths can reach the same destination).

    The inter-procedural edge naming convention:
      - "call_foo-actual_in": the call site in the caller
      - "call_foo-actual_out": the return site in the caller
      - "foo-formal_in": the entry point in the callee
      - "foo-formal_out": the exit point in the callee

    Args:
        graph: SRA Graph object
        src_node, dst_node: CFG node IDs
        src_func, dst_func: Function names containing src/dst nodes

    Returns:
        Probability float, or None if no valid call path exists
    """
    from sra.estimator import get_nodes_to_reach

    try:
        # Step 1: Backward-slice the call graph to dst_func.
        # This gives us a subgraph of only the functions that can transitively
        # reach dst_func through the call chain.
        logger.debug("_compute_interprocedural_prob: backward-slicing call graph to %s", dst_func)
        sliced_callgraph = graph.call_graph.get_backward_slice_graph(
            dst_func, can_have_no_start_node=True
        )
        calllv_paths, calllv_cycles = sliced_callgraph.get_paths_and_cycles(
            can_have_no_start_node=True
        )
        logger.debug("_compute_interprocedural_prob: found %d call-level paths, %d cycles "
                      "from backward slice to %s",
                      len(calllv_paths), len(calllv_cycles), dst_func)
        for i, path in enumerate(calllv_paths):
            logger.debug("  call-level path[%d]: %s", i, " -> ".join(path))
    except Exception as e:
        logger.warning("_compute_interprocedural_prob: call graph slicing failed "
                        "%s -> %s: %s (%s)", src_func, dst_func, type(e).__name__, e)
        return None

    # Step 2: Filter to call-level paths that include src_func.
    # We only care about paths where control can flow from src_func to dst_func.
    relevant_paths = [
        path for path in calllv_paths
        if src_func in path
    ]

    if not relevant_paths:
        logger.debug("_compute_interprocedural_prob: no call-level path from %s to %s "
                      "(total paths=%d)", src_func, dst_func, len(calllv_paths))
        return None

    logger.debug("_compute_interprocedural_prob: %d relevant paths (through %s) out of %d total",
                  len(relevant_paths), src_func, len(calllv_paths))

    total_prob = 0.0

    # Step 3: For each relevant call-level path, decompose into segments and
    # compute the product of intra-procedural twopoint probabilities.
    for path_idx, path in enumerate(relevant_paths):
        # Trim path to start from src_func (discard functions before it)
        start_idx = path.index(src_func)
        path = path[start_idx:]
        logger.debug("  path[%d] (trimmed): %s", path_idx, " -> ".join(path))

        if len(path) < 2:
            # src_func == dst_func, shouldn't happen (handled above)
            logger.debug("  path[%d]: skipping single-function path (len=%d)", path_idx, len(path))
            continue

        path_prob = 1.0

        # First segment: src_node -> actual_in (call site for the next function).
        # get_nodes_to_reach() finds the actual_in call-site nodes in path[0]
        # that call path[1]. There may be multiple call sites for the same callee.
        nodes_to_reach = get_nodes_to_reach(graph, path[1], path[0])
        if not nodes_to_reach:
            logger.debug("  path[%d]: no call sites for %s in %s, skipping",
                          path_idx, path[1], path[0])
            continue

        logger.debug("  path[%d]: first segment %s -> call sites for %s: %s",
                      path_idx, src_node, path[1], nodes_to_reach)

        # Sum probabilities across all call sites (multiple call sites = multiple
        # paths to reach the callee, so probabilities are additive).
        segment_prob = 0.0
        for call_site in nodes_to_reach:
            try:
                prob, _ = graph.intra_cfgs[path[0]].get_twopoint_prob(
                    src_node, call_site
                )
                logger.debug("  path[%d]: twopoint %s -> %s = %.6f",
                              path_idx, src_node, call_site, prob)
                segment_prob += prob
            except Exception as e:
                logger.debug("  path[%d]: twopoint %s -> %s failed: %s",
                              path_idx, src_node, call_site, e)
                continue

        if segment_prob == 0.0:
            logger.debug("  path[%d]: first segment prob=0, skipping path", path_idx)
            continue
        path_prob *= segment_prob
        logger.debug("  path[%d]: first segment prob=%.6f, running path_prob=%.6f",
                      path_idx, segment_prob, path_prob)

        # Middle segments: for each intermediate function in the call chain,
        # compute P(formal_in -> actual_in) to the next function's call site.
        # formal_in is the synthetic entry node created by SRA for inter-proc edges.
        for idx in range(1, len(path) - 1):
            curr_func = path[idx]
            next_func = path[idx + 1]
            formal_in = f"{curr_func}-formal_in"
            nodes_to_reach = get_nodes_to_reach(graph, next_func, curr_func)

            logger.debug("  path[%d]: intermediate segment %s (formal_in) -> call sites for %s: %s",
                          path_idx, curr_func, next_func, nodes_to_reach)

            segment_prob = 0.0
            for call_site in nodes_to_reach:
                try:
                    prob, _ = graph.intra_cfgs[curr_func].get_twopoint_prob(
                        formal_in, call_site
                    )
                    logger.debug("  path[%d]: twopoint %s -> %s = %.6f",
                                  path_idx, formal_in, call_site, prob)
                    segment_prob += prob
                except Exception as e:
                    logger.debug("  path[%d]: twopoint %s -> %s failed: %s",
                                  path_idx, formal_in, call_site, e)
                    continue

            if segment_prob == 0.0:
                logger.debug("  path[%d]: intermediate segment %s prob=0, aborting path",
                              path_idx, curr_func)
                path_prob = 0.0
                break
            path_prob *= segment_prob
            logger.debug("  path[%d]: intermediate segment %s prob=%.6f, running path_prob=%.6f",
                          path_idx, curr_func, segment_prob, path_prob)

        if path_prob == 0.0:
            continue

        # Last segment: within dst_func, compute P(formal_in -> dst_node).
        # This is the probability of reaching the destination within its function.
        formal_in = f"{dst_func}-formal_in"
        try:
            prob, _ = graph.intra_cfgs[dst_func].get_twopoint_prob(
                formal_in, dst_node
            )
            path_prob *= prob
            logger.debug("  path[%d]: last segment %s -> %s = %.6f, final path_prob=%.6f",
                          path_idx, formal_in, dst_node, prob, path_prob)
        except Exception as e:
            logger.debug("  path[%d]: last segment %s -> %s failed: %s",
                          path_idx, formal_in, dst_node, e)
            continue

        total_prob += path_prob
        logger.debug("  path[%d]: contributed %.6f, running total_prob=%.6f",
                      path_idx, path_prob, total_prob)

    logger.debug("_compute_interprocedural_prob: %s -> %s total_prob=%.6f (%d paths evaluated)",
                  src_node, dst_node, total_prob, len(relevant_paths))
    return total_prob if total_prob > 0 else None


class ReachabilityEstimator:
    """
    Estimates taint flow completion probability using SRA structure estimation.

    This is the main class that integrates into the fuzzing monitor. It maintains
    incremental coverage state across executions and computes probability estimates
    on demand.

    Lifecycle:
      1. __init__: Load flow definitions, map locations to CFG nodes, pre-compute
         transition probabilities between consecutive chain nodes.
      2. update(analysis): Called once per fuzzing execution to update coverage state.
      3. estimate_all() / report(): Query current probability estimates.

    The estimator is designed to be efficient for the monitoring hot path:
      - Expensive twopoint computations are done once at startup (pre-computation)
      - Per-execution updates are O(flows * intermediates) — just bookkeeping
      - Estimation is O(flows * chain_length) — just multiplication
    """

    def __init__(self, flow_db: FlowDatabase, graph=None):
        """
        Initialize the reachability estimator.

        If a Graph is provided, pre-computes flow chains and twopoint transition
        probabilities for all flows. This can take several seconds for large CFGs
        but is done only once.

        Args:
            flow_db: Flow database with flow definitions (from .flowdb file)
            graph: SRA Graph object (optional). If None, all estimates use the
                   Laplace smoothing fallback instead of structural analysis.
        """
        self.flow_db = flow_db
        self.graph = graph

        # --- Incremental coverage state (updated by self.update()) ---

        self.total_executions: int = 0  # Total fuzzing executions observed

        # Per-flow counters: how many executions triggered each flow's source/sink
        self.flow_source_hits: Dict[int, int] = defaultdict(int)
        self.flow_sink_hits: Dict[int, int] = defaultdict(int)
        # Per-flow: set of intermediate location IDs that have been covered at
        # least once across all executions
        self.flow_intermediate_coverage: Dict[int, Set[int]] = defaultdict(set)
        # Per-flow: how many executions completed the full flow (source+sink+all intermediates)
        self.flow_completions: Dict[int, int] = defaultdict(int)

        # Per-CFG-node hit counts, accumulated across all executions.
        # Used to compute P_empirical(node) = node_hits[node] / total_executions
        # for the anchor node in Case 2 estimation.
        self.node_hits: Dict[str, int] = defaultdict(int)

        # --- Pre-computed data (built once at init) ---

        # Flow chains: maps flow_id -> FlowChain with ordered node mapping
        # and pre-computed transition probabilities
        self.flow_chains: Dict[int, FlowChain] = {}

        if graph is not None:
            logger.info("ReachabilityEstimator: graph provided with %d nodes, %d functions; "
                         "pre-computing flow chains for %d flows",
                         len(graph.cfg["nodes"]), len(graph.intra_cfgs), len(flow_db.flows))
            t0 = time.monotonic()
            self._precompute_flow_chains()
            elapsed = time.monotonic() - t0
            fully_mapped = sum(1 for c in self.flow_chains.values() if c.fully_mapped)
            logger.info("ReachabilityEstimator: pre-computation done in %.3fs — "
                         "%d/%d chains fully mapped, %d partially mapped",
                         elapsed, fully_mapped, len(self.flow_chains),
                         len(self.flow_chains) - fully_mapped)
        else:
            logger.info("ReachabilityEstimator: no graph provided, will use Laplace fallback "
                         "for all %d flows", len(flow_db.flows))

        logger.info("ReachabilityEstimator initialized: flows=%d, graph=%s, alpha=%.1f",
                     len(flow_db.flows), 'yes' if graph else 'no', ALPHA)

    def _precompute_flow_chains(self) -> None:
        """
        For each flow, build the ordered chain of CFG nodes and compute
        twopoint transition probabilities between consecutive pairs.

        This is the expensive one-time setup step. For each flow:
          1. Look up the CFG node for source, each intermediate, and sink
             (by matching .flowdb line numbers against node linenums)
          2. For each consecutive pair (chain[i], chain[i+1]), compute the
             SRA twopoint probability (intra- or inter-procedural)
          3. Store the result in self.flow_chains[flow_id]
        """
        cfg_inter = self.graph.cfg
        total_nodes = len(cfg_inter["nodes"])
        logger.info("_precompute_flow_chains: mapping %d flows against CFG with %d nodes",
                      len(self.flow_db.flows), total_nodes)

        for flow_id, flow_def in self.flow_db.flows.items():
            logger.debug("_precompute_flow_chains: building chain for flow %d "
                          "(src=%d, sink=%d, intermediates=%s)",
                          flow_id, flow_def.source_id, flow_def.sink_id,
                          flow_def.intermediate_ids)
            t0 = time.monotonic()
            chain = self._build_flow_chain(flow_id, flow_def, cfg_inter)
            elapsed_ms = (time.monotonic() - t0) * 1000
            self.flow_chains[flow_id] = chain

            if chain.fully_mapped:
                logger.info("Flow %d: chain fully mapped (%d nodes, %.1fms) — "
                             "nodes=[%s], transition_probs=%s",
                             flow_id, len(chain.chain), elapsed_ms,
                             ", ".join(f"{t}:{lid}={n}" for t, lid, n in chain.chain),
                             [f"{p:.6f}" if p is not None else "None" for p in chain.transition_probs])
            else:
                mapped = [(loc_type, loc_id, cfg_node)
                          for loc_type, loc_id, cfg_node in chain.chain if cfg_node is not None]
                unmapped = [(loc_type, loc_id)
                            for loc_type, loc_id, cfg_node in chain.chain if cfg_node is None]
                logger.warning("Flow %d: INCOMPLETE mapping (%.1fms) — "
                                "mapped=%d/%d, unmapped_locations=%s, "
                                "mapped_locations=[%s], transition_probs=%s",
                                flow_id, elapsed_ms,
                                len(mapped), len(chain.chain), unmapped,
                                ", ".join(f"{t}:{lid}={n}" for t, lid, n in mapped),
                                [f"{p:.6f}" if p is not None else "None" for p in chain.transition_probs])

    def _build_flow_chain(self, flow_id: int, flow_def: FlowDef,
                          cfg_inter: dict) -> FlowChain:
        """
        Build the ordered chain of (type, id, cfg_node) for a flow
        and compute transition probabilities between consecutive nodes.
        """
        # Build ordered chain: source, intermediates (in order), sink
        chain: List[Tuple[str, int, Optional[str]]] = []

        # Source
        src_def = self.flow_db.get_source(flow_def.source_id)
        if src_def:
            src_node = _find_cfg_node_by_line(cfg_inter, src_def.location.line)
            logger.debug("Flow %d: source id=%d at %s -> cfg_node=%s",
                          flow_id, flow_def.source_id, src_def.location, src_node)
        else:
            src_node = None
            logger.warning("Flow %d: source id=%d not found in flow_db", flow_id, flow_def.source_id)
        chain.append(("source", flow_def.source_id, src_node))

        # Intermediates (in the order they appear in the flow definition)
        for loc_id in flow_def.intermediate_ids:
            int_def = self.flow_db.get_intermediate(loc_id)
            if int_def:
                int_node = _find_cfg_node_by_line(cfg_inter, int_def.location.line)
                logger.debug("Flow %d: intermediate id=%d at %s -> cfg_node=%s",
                              flow_id, loc_id, int_def.location, int_node)
            else:
                int_node = None
                logger.warning("Flow %d: intermediate id=%d not found in flow_db", flow_id, loc_id)
            chain.append(("intermediate", loc_id, int_node))

        # Sink
        sink_def = self.flow_db.get_sink(flow_def.sink_id)
        if sink_def:
            sink_node = _find_cfg_node_by_line(cfg_inter, sink_def.location.line)
            logger.debug("Flow %d: sink id=%d at %s -> cfg_node=%s",
                          flow_id, flow_def.sink_id, sink_def.location, sink_node)
        else:
            sink_node = None
            logger.warning("Flow %d: sink id=%d not found in flow_db", flow_id, flow_def.sink_id)
        chain.append(("sink", flow_def.sink_id, sink_node))

        # Check if fully mapped
        fully_mapped = all(cfg_node is not None for _, _, cfg_node in chain)

        # Compute transition probabilities between consecutive pairs
        transition_probs: List[Optional[float]] = []
        for i in range(len(chain) - 1):
            src_type, src_lid, src_cfg = chain[i]
            dst_type, dst_lid, dst_cfg = chain[i + 1]

            if src_cfg is not None and dst_cfg is not None:
                logger.debug("Flow %d: computing transition[%d] %s:%d(%s) -> %s:%d(%s)",
                              flow_id, i, src_type, src_lid, src_cfg, dst_type, dst_lid, dst_cfg)
                prob = _compute_twopoint_prob(self.graph, src_cfg, dst_cfg)
                if prob is None:
                    logger.warning("Flow %d: transition[%d] %s -> %s returned None "
                                    "(twopoint computation failed)",
                                    flow_id, i, src_cfg, dst_cfg)
                transition_probs.append(prob)
            else:
                logger.debug("Flow %d: transition[%d] skipped — src_cfg=%s, dst_cfg=%s "
                              "(unmapped node)", flow_id, i, src_cfg, dst_cfg)
                transition_probs.append(None)

        return FlowChain(
            flow_id=flow_id,
            chain=chain,
            transition_probs=transition_probs,
            fully_mapped=fully_mapped,
        )

    def update(self, analysis: ExecutionAnalysis) -> None:
        """
        Update coverage state with a new execution's results.

        Called once per fuzzing execution by the monitor's main loop.
        Extracts source/sink events and coverage bitmap data from the
        ExecutionAnalysis, then updates all per-flow and per-node counters.

        This is on the hot path — called for every execution — so it
        avoids expensive computations. The actual probability estimation
        is deferred to estimate_all().

        Args:
            analysis: ExecutionAnalysis from the event processor, containing
                      source_events, sink_events, completed_flows, and
                      coverage_hits (loc_id -> hit_count from shared memory)
        """
        self.total_executions += 1

        source_ids_seen = {e.id for e in analysis.source_events}
        sink_ids_seen = {e.id for e in analysis.sink_events}

        logger.debug("update: exec #%d pid=%d — %d source events (ids=%s), "
                      "%d sink events (ids=%s), %d completed flows, "
                      "%d coverage entries",
                      self.total_executions, analysis.pid,
                      len(analysis.source_events), source_ids_seen,
                      len(analysis.sink_events), sink_ids_seen,
                      len(analysis.completed_flows),
                      len(analysis.coverage_hits))

        for flow_id, flow_def in self.flow_db.flows.items():
            src_hit = flow_def.source_id in source_ids_seen
            sink_hit = flow_def.sink_id in sink_ids_seen
            completed = any(fc.flow_id == flow_id for fc in analysis.completed_flows)

            if src_hit:
                self.flow_source_hits[flow_id] += 1
            if sink_hit:
                self.flow_sink_hits[flow_id] += 1

            new_intermediates = []
            for loc_id in flow_def.intermediate_ids:
                if loc_id in analysis.coverage_hits:
                    was_new = loc_id not in self.flow_intermediate_coverage[flow_id]
                    self.flow_intermediate_coverage[flow_id].add(loc_id)
                    if was_new:
                        new_intermediates.append(loc_id)

            if completed:
                self.flow_completions[flow_id] += 1

            if src_hit or sink_hit or new_intermediates or completed:
                logger.debug("update: flow %d — src_hit=%s (total=%d), sink_hit=%s (total=%d), "
                              "new_intermediates=%s (total_covered=%d/%d), "
                              "completed=%s (total_completions=%d)",
                              flow_id, src_hit, self.flow_source_hits[flow_id],
                              sink_hit, self.flow_sink_hits[flow_id],
                              new_intermediates,
                              len(self.flow_intermediate_coverage.get(flow_id, set())),
                              len(flow_def.intermediate_ids),
                              completed, self.flow_completions[flow_id])

        # Update per-CFG-node hit counts
        # Map flow location coverage back to CFG nodes
        nodes_updated = {}
        for flow_id, chain in self.flow_chains.items():
            flow_def = self.flow_db.flows[flow_id]

            # Source node
            if flow_def.source_id in source_ids_seen:
                _, _, cfg_node = chain.chain[0]
                if cfg_node:
                    self.node_hits[cfg_node] += 1
                    nodes_updated[cfg_node] = self.node_hits[cfg_node]

            # Intermediate nodes
            for i, loc_id in enumerate(flow_def.intermediate_ids):
                if loc_id in analysis.coverage_hits:
                    _, _, cfg_node = chain.chain[i + 1]  # +1 because chain[0] is source
                    if cfg_node:
                        hit_count = analysis.coverage_hits[loc_id]
                        self.node_hits[cfg_node] += hit_count
                        nodes_updated[cfg_node] = self.node_hits[cfg_node]

            # Sink node
            if flow_def.sink_id in sink_ids_seen:
                _, _, cfg_node = chain.chain[-1]
                if cfg_node:
                    self.node_hits[cfg_node] += 1
                    nodes_updated[cfg_node] = self.node_hits[cfg_node]

        if nodes_updated:
            logger.debug("update: CFG node hits updated: %s",
                          {n: h for n, h in sorted(nodes_updated.items())})

        logger.debug("update: after exec #%d — total_node_hits=%d across %d unique nodes",
                      self.total_executions, sum(self.node_hits.values()), len(self.node_hits))

    def estimate_all(self) -> Dict[int, FlowReachability]:
        """Estimate reachability for all flows."""
        logger.debug("estimate_all: computing estimates for %d flows "
                      "(total_executions=%d)", len(self.flow_db.flows), self.total_executions)
        t0 = time.monotonic()
        results = {}
        for flow_id, flow_def in self.flow_db.flows.items():
            results[flow_id] = self._estimate_flow(flow_id, flow_def)
        elapsed_ms = (time.monotonic() - t0) * 1000
        logger.debug("estimate_all: completed in %.1fms — %d flows estimated", elapsed_ms, len(results))
        return results

    def _estimate_flow(self, flow_id: int, flow_def: FlowDef) -> FlowReachability:
        """
        Estimate reachability for a single flow using the anchor-and-multiply algorithm.

        This implements the three-case estimation logic:

        Case 1 — Flow already completed at least once:
          Return empirical frequency: P = completions / total_executions.
          This is the most reliable estimate since we have direct evidence.

        Case 2 — At least one flow node has been covered (but flow not completed):
          Find the "anchor" — the deepest covered node in the chain (closest
          to the sink). The intuition is that the fuzzer has already reached
          this point, so we only need to estimate the remaining distance.
          P = P_empirical(anchor) * product(transition_probs from anchor to sink)
          where P_empirical = node_hits / total_executions.

        Case 3 — Nothing covered at all:
          Use SRA's full structure_estimation() to estimate the probability of
          reaching the source from the program entry point, then multiply by
          all transition probabilities along the entire chain.
          P = P_SRA(entry -> source) * product(all transition_probs)
          Falls back to Laplace smoothing if structure_estimation fails (e.g.
          when the target is in main() and the call graph is trivial).
        """
        source_covered = self.flow_source_hits.get(flow_id, 0) > 0
        sink_covered = self.flow_sink_hits.get(flow_id, 0) > 0
        covered_intermediates = self.flow_intermediate_coverage.get(flow_id, set())
        total_intermediates = len(flow_def.intermediate_ids)
        covered_count = len(covered_intermediates)
        coverage_fraction = covered_count / total_intermediates if total_intermediates > 0 else 1.0

        logger.debug("_estimate_flow: flow %d — src_covered=%s (hits=%d), "
                      "sink_covered=%s (hits=%d), intermediates=%d/%d covered=%s, "
                      "completions=%d, total_executions=%d",
                      flow_id, source_covered, self.flow_source_hits.get(flow_id, 0),
                      sink_covered, self.flow_sink_hits.get(flow_id, 0),
                      covered_count, total_intermediates, covered_intermediates,
                      self.flow_completions.get(flow_id, 0), self.total_executions)

        # Case 1: Already completed — return empirical frequency
        completions = self.flow_completions.get(flow_id, 0)
        if completions > 0 and self.total_executions > 0:
            prob = completions / self.total_executions
            logger.info("_estimate_flow: flow %d -> CASE 1 (completed): "
                         "P = %d/%d = %.6f",
                         flow_id, completions, self.total_executions, prob)
            return FlowReachability(
                flow_id=flow_id,
                probability=prob,
                source_covered=source_covered,
                sink_covered=sink_covered,
                intermediates_total=total_intermediates,
                intermediates_covered=covered_count,
                coverage_fraction=coverage_fraction,
            )

        # No graph or no chain: fall back to Laplace
        chain = self.flow_chains.get(flow_id)
        if not chain or not chain.fully_mapped or self.graph is None:
            reason = ("no graph" if self.graph is None
                      else "no chain" if not chain
                      else "incomplete mapping")
            logger.debug("_estimate_flow: flow %d -> FALLBACK (reason=%s)", flow_id, reason)
            return self._estimate_flow_fallback(flow_id, flow_def, source_covered,
                                                 sink_covered, covered_count,
                                                 total_intermediates, coverage_fraction)

        # Build a boolean array parallel to chain: True if that node has been covered.
        # This is used to find the anchor (deepest covered node closest to sink).
        # chain[0] = source, chain[1..k] = intermediates, chain[-1] = sink
        chain_covered = []
        chain_covered.append(source_covered)
        for loc_id in flow_def.intermediate_ids:
            chain_covered.append(loc_id in covered_intermediates)
        chain_covered.append(sink_covered)

        logger.debug("_estimate_flow: flow %d chain coverage: %s",
                      flow_id,
                      [f"{chain.chain[i][0]}:{chain.chain[i][1]}={'Y' if c else 'N'}"
                       for i, c in enumerate(chain_covered)])

        # Find the deepest covered node (closest to sink) by scanning backward.
        # This is the "anchor" — the point from which we estimate remaining distance.
        # The deeper the anchor, the fewer transitions we need to multiply through,
        # generally yielding higher (more confident) probability estimates.
        anchor_idx = None
        for i in range(len(chain_covered) - 1, -1, -1):
            if chain_covered[i]:
                anchor_idx = i
                break

        if anchor_idx is not None:
            # Case 2: At least one node covered
            # P = P_empirical(anchor) * product(transition_probs from anchor to sink)
            _, loc_id, cfg_node = chain.chain[anchor_idx]
            anchor_name = f"{chain.chain[anchor_idx][0]}_{loc_id}"

            logger.debug("_estimate_flow: flow %d -> CASE 2 (anchor): "
                          "anchor_idx=%d, anchor=%s, cfg_node=%s, "
                          "remaining_transitions=%d",
                          flow_id, anchor_idx, anchor_name, cfg_node,
                          len(chain.chain) - 1 - anchor_idx)

            # Empirical probability of the anchor node
            if cfg_node and cfg_node in self.node_hits:
                p_anchor = self.node_hits[cfg_node] / self.total_executions
                logger.debug("_estimate_flow: flow %d anchor P_empirical(%s) = %d/%d = %.6f",
                              flow_id, cfg_node, self.node_hits[cfg_node],
                              self.total_executions, p_anchor)
            else:
                # Covered via source/sink event tracking but no CFG hit count
                loc_type = chain.chain[anchor_idx][0]
                if loc_type == "source":
                    p_anchor = self.flow_source_hits[flow_id] / self.total_executions
                    logger.debug("_estimate_flow: flow %d anchor P_empirical(source_event) = "
                                  "%d/%d = %.6f",
                                  flow_id, self.flow_source_hits[flow_id],
                                  self.total_executions, p_anchor)
                elif loc_type == "sink":
                    p_anchor = self.flow_sink_hits[flow_id] / self.total_executions
                    logger.debug("_estimate_flow: flow %d anchor P_empirical(sink_event) = "
                                  "%d/%d = %.6f",
                                  flow_id, self.flow_sink_hits[flow_id],
                                  self.total_executions, p_anchor)
                else:
                    p_anchor = ALPHA / (self.total_executions + 2 * ALPHA)
                    logger.debug("_estimate_flow: flow %d anchor P_laplace(intermediate) = "
                                  "%.1f/(%.0f+%.1f) = %.6f",
                                  flow_id, ALPHA, self.total_executions, 2 * ALPHA, p_anchor)

            # Multiply transition probabilities from anchor to sink
            probability = p_anchor
            transition_detail = []
            for i in range(anchor_idx, len(chain.chain) - 1):
                tp = chain.transition_probs[i]
                if tp is not None:
                    probability *= tp
                    transition_detail.append(f"T[{i}]={tp:.6f}")
                else:
                    # Transition prob unavailable, use Laplace fallback
                    laplace = ALPHA / (self.total_executions + 2 * ALPHA)
                    probability *= laplace
                    transition_detail.append(f"T[{i}]=Laplace({laplace:.6f})")

            logger.info("_estimate_flow: flow %d -> CASE 2: P = P_anchor(%.6f) * %s = %.8f "
                         "(anchor=%s)",
                         flow_id, p_anchor, " * ".join(transition_detail) if transition_detail else "1",
                         probability, anchor_name)

            return FlowReachability(
                flow_id=flow_id,
                probability=probability,
                source_covered=source_covered,
                sink_covered=sink_covered,
                intermediates_total=total_intermediates,
                intermediates_covered=covered_count,
                coverage_fraction=coverage_fraction,
                anchor_node=anchor_name,
            )
        else:
            # Case 3: Nothing covered — estimate P(-> source) via SRA, then multiply all
            src_cfg_node = chain.chain[0][2]

            logger.debug("_estimate_flow: flow %d -> CASE 3 (nothing covered): "
                          "estimating P(entry -> %s) via SRA",
                          flow_id, src_cfg_node)

            # Use SRA structure estimation to get P(reaching source from program entry)
            p_reach_source = self._estimate_reach_from_entry(src_cfg_node)

            # Multiply all transition probabilities from source to sink
            probability = p_reach_source
            transition_detail = []
            for i, tp in enumerate(chain.transition_probs):
                if tp is not None:
                    probability *= tp
                    transition_detail.append(f"T[{i}]={tp:.6f}")
                else:
                    laplace = ALPHA / (self.total_executions + 2 * ALPHA)
                    probability *= laplace
                    transition_detail.append(f"T[{i}]=Laplace({laplace:.6f})")

            logger.info("_estimate_flow: flow %d -> CASE 3: P = P_reach_source(%.8f) * %s = %.8f",
                         flow_id, p_reach_source,
                         " * ".join(transition_detail) if transition_detail else "1",
                         probability)

            return FlowReachability(
                flow_id=flow_id,
                probability=probability,
                source_covered=source_covered,
                sink_covered=sink_covered,
                intermediates_total=total_intermediates,
                intermediates_covered=covered_count,
                coverage_fraction=coverage_fraction,
            )

    def _estimate_reach_from_entry(self, target_node: str) -> float:
        """
        Estimate P(program_entry -> target_node) using SRA structure estimation.

        Used in Case 3 when no flow node has been covered. Constructs a
        binary observation matrix from accumulated node_hits and calls
        structure_estimation() which performs the full SRA algorithm:
        backward-slice call graph, enumerate call-level paths, decompose
        into path units, compute counterfactual * twopoint probabilities.

        Known limitation: structure_estimation() can fail with a KeyError
        when the target is in main() (trivial call graph with no callers).
        In this case, we fall back to Laplace smoothing.
        """
        if self.graph is None or target_node is None:
            fallback = ALPHA / (self.total_executions + 2 * ALPHA) if self.total_executions > 0 else 0.0
            logger.debug("_estimate_reach_from_entry: target_node=%s, graph=%s -> "
                          "Laplace fallback=%.6f",
                          target_node, 'yes' if self.graph else 'no', fallback)
            return fallback

        try:
            from sra.estimator import structure_estimation
            import numpy as np

            # Get all observable nodes (all nodes in the CFG)
            observable_nodes = list(self.graph.cfg["nodes"].keys())

            # Build observation matrix from our accumulated node_hits
            # Each "execution" is summarized as a single observation row
            if self.total_executions > 0 and self.node_hits:
                obs_row = np.array([
                    1 if node in self.node_hits and self.node_hits[node] > 0 else 0
                    for node in observable_nodes
                ], dtype=float).reshape(1, -1)
                covered_count = int(np.sum(obs_row))
                logger.debug("_estimate_reach_from_entry: target=%s, observable_nodes=%d, "
                              "covered_nodes=%d/%d, total_executions=%d",
                              target_node, len(observable_nodes), covered_count,
                              len(observable_nodes), self.total_executions)
            else:
                obs_row = np.zeros((0, len(observable_nodes)))
                logger.debug("_estimate_reach_from_entry: target=%s, no coverage data "
                              "(total_executions=%d, node_hits=%d)",
                              target_node, self.total_executions, len(self.node_hits))

            t0 = time.monotonic()
            prob, dist, maxcov = structure_estimation(
                obs_row, self.graph, target_node, observable_nodes, ALPHA
            )
            elapsed_ms = (time.monotonic() - t0) * 1000
            logger.info("_estimate_reach_from_entry: target=%s -> prob=%.8f "
                         "(dist=%d, maxcov=%s, %.1fms)",
                         target_node, prob, dist, maxcov, elapsed_ms)
            return prob

        except Exception as e:
            fallback = ALPHA / (self.total_executions + 2 * ALPHA) if self.total_executions > 0 else 0.0
            logger.warning("_estimate_reach_from_entry: SRA structure_estimation FAILED "
                            "for target=%s: %s (%s) -> Laplace fallback=%.6f",
                            target_node, type(e).__name__, e, fallback)
            return fallback

    def _estimate_flow_fallback(self, flow_id, flow_def, source_covered,
                                 sink_covered, covered_count,
                                 total_intermediates, coverage_fraction) -> FlowReachability:
        """
        Fallback estimation using Laplace smoothing when no CFG is available.

        Used when: (a) no Graph was provided at init, (b) the flow chain
        couldn't be fully mapped to CFG nodes, or (c) structure estimation
        failed.

        Formula: P = P(source) * P(sink) * P(uncovered_intermediate)^n_uncovered
        where P(unseen) = alpha / (total_executions + 2*alpha)
        and P(seen) = hits / total_executions
        """
        if self.total_executions == 0:
            logger.debug("_estimate_flow_fallback: flow %d -> P=0.0 (no executions yet)", flow_id)
            return FlowReachability(
                flow_id=flow_id, probability=0.0,
                source_covered=source_covered, sink_covered=sink_covered,
                intermediates_total=total_intermediates,
                intermediates_covered=covered_count,
                coverage_fraction=coverage_fraction,
            )

        p_source = (self.flow_source_hits[flow_id] / self.total_executions
                     if source_covered
                     else ALPHA / (self.total_executions + 2 * ALPHA))
        p_sink = (self.flow_sink_hits[flow_id] / self.total_executions
                   if sink_covered
                   else ALPHA / (self.total_executions + 2 * ALPHA))

        uncovered = total_intermediates - covered_count
        p_per_uncovered = ALPHA / (self.total_executions + 2 * ALPHA)
        p_intermediates = p_per_uncovered ** uncovered if uncovered > 0 else 1.0

        prob = p_source * p_sink * p_intermediates
        logger.info("_estimate_flow_fallback: flow %d -> P = P_src(%.6f) * P_sink(%.6f) * "
                     "P_intermediates(%.6f^%d=%.6f) = %.8f",
                     flow_id, p_source, p_sink, p_per_uncovered, uncovered,
                     p_intermediates, prob)

        return FlowReachability(
            flow_id=flow_id,
            probability=prob,
            source_covered=source_covered, sink_covered=sink_covered,
            intermediates_total=total_intermediates,
            intermediates_covered=covered_count,
            coverage_fraction=coverage_fraction,
        )

    def report(self) -> str:
        """Generate a human-readable report of reachability estimates."""
        logger.debug("report: generating reachability report")
        estimates = self.estimate_all()

        if not estimates:
            return "No flows to estimate."

        sorted_flows = sorted(estimates.values(), key=lambda r: r.probability)

        lines = []
        lines.append("=" * 90)
        lines.append("FLOW REACHABILITY ESTIMATES (SRA)")
        lines.append("=" * 90)
        lines.append(f"Total executions: {self.total_executions}")
        lines.append(f"Flows tracked: {len(estimates)}")
        lines.append(f"Flows completed: {sum(1 for fid in self.flow_completions if self.flow_completions[fid] > 0)}")
        lines.append(f"Flows with CFG mapping: {sum(1 for c in self.flow_chains.values() if c.fully_mapped)}")
        lines.append("")

        lines.append(f"{'Flow':<8} {'Prob':<14} {'Src':<5} {'Sink':<6} {'Interm':<10} {'Cov%':<8} {'Anchor'}")
        lines.append("-" * 90)

        for r in sorted_flows:
            anchor = r.anchor_node or "-"
            lines.append(
                f"{r.flow_id:<8} "
                f"{r.probability:<14.8f} "
                f"{'Y' if r.source_covered else 'N':<5} "
                f"{'Y' if r.sink_covered else 'N':<6} "
                f"{r.intermediates_covered}/{r.intermediates_total:<7} "
                f"{r.coverage_fraction:>6.1%}  "
                f"{anchor}"
            )

        lines.append("=" * 90)

        logger.info("report: generated report for %d flows (total_executions=%d)",
                     len(estimates), self.total_executions)
        return "\n".join(lines)
