# Taint Flow Reachability Estimator — Change Guide

## Overview

These changes add a **taint flow reachability estimator** to the fuzzing monitor. It uses SRA's structural reachability analysis to predict the probability that each uncovered taint flow will be completed during fuzzing, based on observed coverage + CFG structure.

---

## New Files

### 1. `fuzzer/sense/monitor/reachability_estimator.py` (core implementation)

The main module. Bridges the monitor's flow model (`.flowdb`) with SRA's CFG model (`cfg_inter` JSON).

**Key components:**

- **`FlowReachability`** (dataclass): Result object for one flow estimate — contains probability, coverage state, and the anchor node used.

- **`FlowChain`** (dataclass): Pre-computed data for one flow — ordered mapping from flow locations to CFG nodes, plus transition probabilities between consecutive pairs.

- **`_find_cfg_node_by_line()`**: Maps a `.flowdb` source line number to a CFG node by searching for nodes where `line_no in node["linenums"]`. Falls back to `_find_function_entry_by_line()` for function parameter/declaration lines that don't appear in any basic block.

- **`_find_function_entry_by_line()`**: Fallback for unmapped lines — searches for functions whose entry node's linenums range contains the target line (handles K&R-style C parameter declarations).

- **`_compute_twopoint_prob()`**: Computes structural transition probability between two CFG nodes. Dispatches to `SimpleGraph.get_twopoint_prob()` for intra-procedural pairs, or `_compute_interprocedural_prob()` for cross-function pairs.

- **`_compute_interprocedural_prob()`**: Handles cross-function transitions by backward-slicing the call graph, enumerating call-level paths, decomposing into segments (`src_node→actual_in`, `formal_in→actual_in`, `formal_in→dst_node`), and computing per-segment twopoint probabilities. Mirrors `estimator.py:structure_estimation()` steps 1.1-1.3.

- **`ReachabilityEstimator`** (class): Main class integrated into the monitor.
  - `__init__()`: Accepts `FlowDatabase` + optional `Graph`. If `Graph` is provided, pre-computes flow chains and transition probabilities (one-time expensive step).
  - `update(analysis)`: Called per-execution to update coverage counters (fast, on hot path).
  - `estimate_all()`: Returns `Dict[flow_id, FlowReachability]` using the three-case algorithm:
    - **Case 1** (completed): `P = completions / total_executions`
    - **Case 2** (partially covered): `P = P_empirical(anchor) × product(transitions to sink)`
    - **Case 3** (nothing covered): `P = P_SRA(entry→source) × product(all transitions)`
  - `report()`: Human-readable table of estimates.

### 2. `fuzzer/sense/tests/test_reachability_estimator.py` (unit tests)

15 tests covering the full pipeline. Uses **synthetic CFGs** built programmatically (no LLVM toolchain needed):

- `build_linear_cfg()`: Single-function linear path (all twopoint probs = 1.0)
- `build_branching_cfg()`: Single-function with if-else branch (twopoint prob < 1.0)
- `build_interprocedural_cfg()`: Two functions (`main` calls `foo`) with inter-proc edges

**Test coverage:**

| Test | What it verifies |
|------|-----------------|
| `test_find_cfg_node_by_line` | CFG node lookup by line number |
| `test_graph_construction_*` (3 tests) | Graph builds from linear/branching/inter-proc CFGs |
| `test_twopoint_prob_linear` | Twopoint = 1.0 on linear path |
| `test_twopoint_prob_branching` | Twopoint < 1.0 at branches, = 1.0 at merge |
| `test_estimator_init_no_graph` | Laplace fallback when no CFG provided |
| `test_estimator_with_linear_cfg` | Full Case 3 → Case 2 → Case 1 progression |
| `test_estimator_with_branching_cfg` | Branch probability affects estimate |
| `test_estimator_report` | Report output format |
| `test_estimator_fallback_no_mapping` | Graceful degradation for unmapped locations |
| `test_estimator_anchor_deepest_covered` | Anchor selection: deepest covered node |
| `test_estimator_case3_nothing_covered` | SRA structure estimation path |
| `test_multiple_flows` | Multiple flows tracked simultaneously |
| `test_interprocedural_chain` | Cross-function flow chains |

### 3. `fuzzer/sense/sra/` (vendored SRA library)

Copy of `rq2/sra/` for devcontainer accessibility. The devcontainer only mounts `sra/fuzzer/` → `/workspaces/fuzzer/`, so `rq2/` is inaccessible inside it. Both `reachability_estimator.py` and `monitor.py` have dual-path import logic that tries the vendored copy first, then falls back to `rq2/`.

---

## Modified Files

### 4. `fuzzer/sense/monitor/config.py`

Added `CFGConfig` dataclass and wired it into `MonitorConfig`:

```python
@dataclass
class CFGConfig:
    """Control flow graph configuration for reachability estimation."""
    cfg_path: Optional[str] = None  # Path to pre-built cfg_inter JSON
```

Also added to `MonitorConfig`:
- Field: `cfg: CFGConfig = field(default_factory=CFGConfig)`
- YAML loading: `cfg=CFGConfig(**data.get('cfg', {}))`

### 5. `fuzzer/sense/monitor/flow_monitor.py`

Added `--cfg` CLI option:

```python
@click.option(
    '--cfg',
    type=click.Path(exists=True, path_type=Path),
    help='Path to pre-built cfg_inter JSON for SRA reachability estimation'
)
```

Wired into `load_config()` to set `cfg.cfg.cfg_path`.

### 6. `fuzzer/sense/monitor/monitor.py`

Three integration points in `FlowMonitor`:

**a) Import + SRA path setup** (top of file):

```python
from reachability_estimator import ReachabilityEstimator

# Add SRA to path (vendored copy + fallback to rq2/)
_sra_local = str(Path(__file__).resolve().parents[1])
_sra_rq2 = str(Path(__file__).resolve().parents[3] / "rq2")
```

**b) CFG loading in `__init__()`**: Loads `cfg_inter` JSON, converts linenums from lists back to sets (JSON serialization loses set type), constructs SRA `Graph`, creates `ReachabilityEstimator`.

```python
sra_graph = None
if config.cfg.cfg_path:
    sra_graph = self._load_cfg(config.cfg.cfg_path)
self.reachability = ReachabilityEstimator(flow_db, sra_graph)
```

**c) New `_load_cfg()` static method**: Loads JSON, does `linenums` list→set conversion, constructs `Graph`.

**d) Per-execution update** in `_process_execution()`:

```python
self.reachability.update(analysis)
```

**e) Report in `_print_statistics()`**: Prints reachability estimates alongside existing statistics.

---

## Algorithm Details

### Estimation Cases

A flow is a linear chain: `source → int_1 → int_2 → ... → int_k → sink`

**Case 1 — Flow already completed at least once:**
```
P = completions / total_executions
```
Simple empirical frequency — the flow has been fully exercised.

**Case 2 — At least one flow node covered (but flow not completed):**
```
anchor = deepest covered node (closest to sink in chain)
P = P_empirical(anchor) × P(anchor→next) × P(next→next+1) × ... × P(last→sink)
```
Where `P_empirical = node_hits / total_executions`, and each `P(A→B)` is a pre-computed SRA twopoint transition probability.

**Case 3 — Nothing covered at all:**
```
P = P_SRA(program_entry → source) × P(source→int_1) × ... × P(int_k→sink)
```
Where `P_SRA` uses SRA's full `structure_estimation()` algorithm (backward-slice call graph, enumerate call-level paths, decompose into path units, compute counterfactual × twopoint probabilities).

**Fallback:** When no CFG is available or mapping fails:
```
P = P(source) × P(sink) × P(uncovered_intermediate)^n_uncovered
P(unseen) = alpha / (total_executions + 2*alpha)     # alpha=2.0
```

### Twopoint Probability

The structural transition probability `P(A → B)` is computed differently depending on whether A and B are in the same function:

- **Intra-procedural** (same function): `SimpleGraph.get_twopoint_prob(A, B)` which works by forward/backward slicing the CFG to isolate the relevant subgraph, decomposing via immediate post-dominators into independent segments, and enumerating paths through each segment.

- **Inter-procedural** (different functions): Decomposes via the call graph — backward-slice to destination function, enumerate call-level paths, decompose each path into segments (`src→actual_in`, `formal_in→actual_in`, `formal_in→dst`), compute per-segment intra-procedural twopoint probabilities, and combine (product within path, sum across paths).

---

## Usage

```bash
# Generate CFG from LLVM IR (done at build time via cfggen.py)
# This produces cfg_inter.json

# Run the monitor with CFG-based reachability estimation:
python flow_monitor.py --flowdb program.flowdb --cfg cfg_inter.json --output results.jsonl
```

Without `--cfg`, the estimator still works but falls back to Laplace smoothing for all flows (no structural analysis).

---

## Architecture Diagram

```
.flowdb (source/sink/intermediate locations)
    │
    ├── FlowDatabase (flow_db.py) ──── flow definitions
    │                                        │
    │                                        ▼
    │                               ReachabilityEstimator.__init__()
    │                                        │
    │   cfg_inter.json ──→ Graph ──→ _precompute_flow_chains()
    │   (from cfggen.py)              │
    │                                 ├── _find_cfg_node_by_line()  [map locations → nodes]
    │                                 └── _compute_twopoint_prob()  [pre-compute P(A→B)]
    │                                        │
    │                                        ▼
    │                                   FlowChain objects (cached)
    │
    ▼
monitor.py main loop:
    for each execution:
        analysis = process_execution(shm_data)
        estimator.update(analysis)          ← fast: update counters
        ...
        estimates = estimator.estimate_all() ← Case 1/2/3 logic
        report = estimator.report()
```

---

## Known Limitations

- **`structure_estimation` fails for targets in `main()`**: When the target node is in the `main` function, backward-slicing the call graph produces a trivial graph with no callers, causing a `KeyError`. The Laplace fallback handles this gracefully.

- **Line number matching is approximate**: The `.flowdb` locations use `file:line:col`, but we only match on line number against CFG node linenums. Multiple nodes can share the same line number (ambiguous match — we take the first and log a warning).

- **Function parameter/declaration lines**: Lines corresponding to function parameters (especially K&R-style C) don't appear in any basic block's linenums. The `_find_function_entry_by_line()` fallback maps these to the function's entry node within a 20-line window.

---

## Dependencies

The SRA library requires: `numpy`, `graphviz`, `scikit-learn`, `pydot`

Install (if not already available):
```bash
pip install numpy graphviz scikit-learn pydot
```
