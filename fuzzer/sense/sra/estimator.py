import copy
from enum import Enum
from itertools import product
import time
from typing import Dict, List, Set, Tuple

import numpy as np
import pandas as pd
from graphviz import Digraph
from IPython import get_ipython
from IPython.core.display_functions import display
from sklearn.linear_model import LinearRegression

from sra.cfggen import convert_to_dot


def is_notebook() -> bool:
    # sourcery skip: assign-if-exp, boolean-if-exp-identity, merge-duplicate-blocks, remove-unnecessary-cast, switch
    try:
        shell = get_ipython().__class__.__name__
        if shell == "ZMQInteractiveShell":
            return True  # Jupyter notebook or qtconsole
        elif shell == "TerminalInteractiveShell":
            return False  # Terminal running IPython
        else:
            return False  # Other type (?)
    except NameError:
        return False


def frequency_estimation(obss: np.ndarray) -> np.ndarray:
    if obss.shape[0] == 0:
        return np.zeros(obss.shape[1])
    return np.sum(obss, axis=0) / obss.shape[0]


def laplace_estimation(obss: np.ndarray, alpha: float) -> np.ndarray:
    return (np.sum(obss, axis=0) + alpha) / (len(obss) + 2 * alpha)


def gotu_freq_freq(occurs: np.ndarray) -> Dict[int, int]:
    f_n = {}
    for n in occurs:
        if n in f_n:
            f_n[n] += 1
        else:
            f_n[n] = 1
    return f_n


def gotu_smooth(f_n: Dict[int, int], num_obs: int) -> Dict[int, float]:
    ordered_n = [0] + sorted(list(f_n.keys())) + [num_obs + 1]
    return {
        ordered_n[idx]: f_n[ordered_n[idx]]
        / (0.5 * (ordered_n[idx + 1] - ordered_n[idx - 1]))
        for idx in range(1, len(ordered_n) - 1)
    }


def gotu_fit(Z_n: Dict[int, float]) -> Tuple[float, float]:
    X = np.array(list(Z_n.keys())).reshape(-1, 1)
    y = np.array(list(Z_n.values())).reshape(-1, 1)
    X = np.log(X)
    y = np.log(y)
    model = LinearRegression().fit(X, y)
    return model.intercept_[0], model.coef_[0][0]


def gotu_regression(
    occurs: np.ndarray, num_obs: int, debug: bool = False
) -> Tuple[float, float]:
    f_n = gotu_freq_freq(occurs)
    Z_n = gotu_smooth(f_n, num_obs)
    if debug and is_notebook():
        temp_df = pd.DataFrame(
            {
                "freq": list(Z_n.keys()),
                "f_n": [f_n[n] for n in Z_n.keys()],
                "Z_n": list(Z_n.values()),
            }
        )
        display(temp_df)
    alpha, beta = gotu_fit({k: v for k, v in Z_n.items() if k > 0})
    return alpha, beta


def gotu_estimation(obss: np.ndarray, debug: bool = False) -> np.ndarray:
    occurs = np.sum(obss, axis=0)
    num_obs = len(obss)
    num_nodes = len(occurs)
    if num_obs == 0:
        return np.zeros(num_nodes)
    alpha, beta = gotu_regression(occurs, num_obs)
    P_0_all = np.exp(alpha) / num_obs
    probs = [
        occurs[i] / num_obs * (1 + 1 / occurs[i]) ** (beta + 1)
        if occurs[i]
        else P_0_all / len([e for e in occurs if e == 0])
        for i in range(num_nodes)
    ]
    return probs / sum(probs) * (np.sum(occurs) / num_obs)


class EdgeType(Enum):
    INTER = 0
    INTRA = 1


class BranchType(Enum):
    NULL = 0
    TRUE = 1
    FALSE = 2


def get_branch_type(v) -> BranchType:
    if v is None:
        return BranchType.NULL
    elif v:
        return BranchType.TRUE
    else:
        return BranchType.FALSE


def get_branch_val(btype: BranchType) -> bool:
    if btype == BranchType.NULL:
        return None
    elif btype == BranchType.TRUE:
        return True
    else:
        return False


class NoStartNodeError(Exception):
    pass


class SimpleGraph:
    def __init__(
        self,
        edge_dict: Dict[str, Set[str]],
        start_node: str,
        can_have_edge_to_start_node: bool = False,
    ):
        self.start_node = start_node
        self.edge_dict = edge_dict
        self.nodes = set(self.edge_dict.keys())
        self.edge_dict_rev = {node: set() for node in self.nodes}
        for src, dsts in self.edge_dict.items():
            for dst in dsts:
                self.edge_dict_rev[dst].add(src)
        self.edge_tups = set()
        for src, dsts in self.edge_dict.items():
            for dst in dsts:
                self.edge_tups.add((src, dst))
        if (
            self.start_node not in self.edge_dict_rev
            and self.start_node == "main"
        ):
            D = self.draw()
            if is_notebook():
                display(D)
        if (
            not can_have_edge_to_start_node
            and self.edge_dict_rev[self.start_node] != set()
        ):
            print(f"{self.start_node=}")
            print(f"{self.edge_dict_rev[self.start_node]=}")
            raise NoStartNodeError("start node should not have incoming edges")
        self.ends = {
            node for node in self.nodes if len(self.edge_dict[node]) == 0
        }
        self.dom_dict = self.get_dominators()
        self.pdom_dict = self.get_post_dominators()

    def get_parents(self, node: str) -> Set[str]:
        return self.edge_dict_rev[node]

    def get_childs(self, node: str) -> Set[str]:
        return self.edge_dict[node]

    def get_ancestors(self, node: str) -> Set[str]:
        ancestors = set()
        visited = set()
        q = [node]
        while len(q):
            node = q.pop(0)
            if node in visited:
                continue
            visited.add(node)
            parents = self.get_parents(node)
            q.extend(parents)
            ancestors.update(parents)
        return ancestors

    def get_descendents(self, node: str) -> Set[str]:
        descendents = set()
        visited = set()
        q = [node]
        while len(q):
            node = q.pop(0)
            if node in visited:
                continue
            visited.add(node)
            childs = self.get_childs(node)
            q.extend(childs)
            descendents.update(childs)
        return descendents

    def get_dominators(self) -> Dict[str, Set[str]]:
        dominant_dict = {self.start_node: {self.start_node}}
        for k in self.edge_dict_rev:
            if k != self.start_node:
                dominant_dict[k] = set(self.edge_dict_rev.keys())
        changed = True
        while changed:
            changed = False
            for k in self.edge_dict_rev:
                if k == self.start_node:
                    continue
                intersect_dom = set(self.edge_dict_rev.keys())
                for parent in self.edge_dict_rev[k]:
                    intersect_dom = intersect_dom.intersection(
                        dominant_dict[parent]
                    )
                new_set = intersect_dom.union({k})
                if new_set != dominant_dict[k]:
                    changed = True
                    dominant_dict[k] = new_set
        return dominant_dict

    def get_post_dominators(self) -> Dict[str, Set[str]]:
        pdominant_dict = {end_node: {end_node} for end_node in self.ends}
        for k in self.edge_dict:
            if k not in self.ends:
                pdominant_dict[k] = set(self.edge_dict.keys())
        changed = True
        while changed:
            changed = False
            for k in self.edge_dict:
                if k in self.ends:
                    continue
                intersect_pdom = set(self.edge_dict.keys())
                for child in self.edge_dict[k]:
                    intersect_pdom = intersect_pdom.intersection(
                        pdominant_dict[child]
                    )
                new_set = intersect_pdom.union({k})
                if new_set != pdominant_dict[k]:
                    changed = True
                    pdominant_dict[k] = new_set
        return pdominant_dict

    def get_backward_slice_graph(
        self, crit_node: str, can_have_no_start_node: bool = False
    ) -> "SimpleGraph":
        crit_ancestors = self.get_ancestors(crit_node)
        crit_ancestors.add(crit_node)
        if self.start_node not in crit_ancestors and not can_have_no_start_node:
            raise NoStartNodeError("start node not in backward slice")
        new_edge_dict = {node: set() for node in crit_ancestors}
        for src, dst in self.edge_tups:
            if src in crit_ancestors and dst in crit_ancestors:
                new_edge_dict[src].add(dst)
        backward_slice = SimpleGraph(
            new_edge_dict,
            self.start_node if self.start_node in crit_ancestors else None,
            can_have_edge_to_start_node=True,
        )
        backward_slice.ends = {crit_node}
        backward_slice.pdom_dict = backward_slice.get_post_dominators()
        return backward_slice

    def get_forward_slice_graph(self, crit_node: str) -> "SimpleGraph":
        crit_descendents = self.get_descendents(crit_node)
        crit_descendents.add(crit_node)
        new_edge_dict = {node: set() for node in crit_descendents}
        for src, dst in self.edge_tups:
            if src in crit_descendents and dst in crit_descendents:
                new_edge_dict[src].add(dst)
        return SimpleGraph(
            new_edge_dict, crit_node, can_have_edge_to_start_node=True
        )

    def get_paths_and_cycles(
        self, can_have_no_start_node: bool = False
    ) -> List[List[str]]:
        # sourcery skip: raise-specific-error
        """
        get paths and cycles in the graph
        """
        paths = []
        cycles = set()
        visited_path = set()
        if self.start_node is None:
            if can_have_no_start_node:
                q = [
                    [node]
                    for node in self.nodes
                    if node not in self.edge_dict_rev
                    or not len(self.edge_dict_rev[node])
                ]
            else:
                raise NoStartNodeError("start node not in graph")
        else:
            q = [[self.start_node]]
        start_time = time.time()
        while len(q):
            path = q.pop(0)
            if tuple(path) in visited_path:
                raise Exception("should not happen")
            visited_path.add(tuple(path))
            node = path[-1]
            if node in path[:-1]:
                first_occur_idx = path.index(node)
                cycle = tuple(path[first_occur_idx:])
                cycles.add(cycle)
                continue
            if node in self.ends:
                paths.append(path)
            else:
                q.extend(path + [dst] for dst in self.edge_dict[node])
            if len(q) > 1000000:
                raise Exception("too many paths")
            if start_time + 1 < time.time():
                raise TimeoutError("too long")
        return paths, cycles

    def is_loop_entry(self, node: str, single_exit: bool):
        if single_exit:
            return any(
                node in self.pdom_dict[child] for child in self.edge_dict[node]
            )
        else:
            raise NotImplementedError()

    def get_impdom(self, node: str) -> str:
        pdoms = self.pdom_dict[node]
        pdom_immediate = None
        for node1 in pdoms:
            if node1 == node:
                continue
            is_immediate = True
            for node2 in pdoms:
                if node1 == node2 or node2 == node:
                    continue
                if node1 in self.pdom_dict[node2]:
                    is_immediate = False
                    break
            if is_immediate:
                pdom_immediate = node1
                break
        return pdom_immediate

    def get_impdom_list(self) -> List[str]:
        assert len(self.ends) == 1
        impdom_list = [self.start_node]
        while True:
            next_impdom = self.get_impdom(impdom_list[-1])
            impdom_list.append(next_impdom)
            if next_impdom in self.ends:
                break
        return impdom_list

    def get_twopoint_prob(
        self,
        source: str,
        destination: str,
        single_exit: bool = True,
        debug: bool = False,
    ) -> Tuple[float, int]:
        if source == destination:
            return 1.0, 0
        if debug:
            print(f"{source=} {destination=} {single_exit=}")
        if "formal_in" not in source:
            forward_slice_graph = self.get_forward_slice_graph(source)
        else:
            forward_slice_graph = self
        dice_graph = forward_slice_graph.get_backward_slice_graph(destination)
        impdom_list = dice_graph.get_impdom_list()
        if debug:
            print(f"{impdom_list=}")
        src_dest_pairs = [
            (impdom_list[i], impdom_list[i + 1])
            for i in range(len(impdom_list) - 1)
        ]
        queue = []
        for src, dest in src_dest_pairs:
            if debug:
                print(f"sub (src, dest): ({src}, {dest}):", end=" ")
            if dest in self.pdom_dict[src]:
                if debug:
                    print(f"{dest} post dominates {src}. Skip.")
                continue
            else:
                if debug:
                    print("Add.")
                queue.append((src, dest))
        if debug:
            print(f"{queue=}")

        twopoint_probs, twopoint_lengths = {}, {}
        for src, dest in queue:
            tmp_dice_graph = dice_graph.get_forward_slice_graph(
                src
            ).get_backward_slice_graph(dest)
            try:
                paths, cycles = tmp_dice_graph.get_paths_and_cycles()
            except TimeoutError as e:
                print(
                    "WARNING:: timeout in get_paths_and_cycles. For now, let the twopoint probability be 1.0 (length 0)."
                )
                twopoint_probs[(src, dest)] = 1.0
                twopoint_lengths[(src, dest)] = 0
                continue
            if debug:
                if not len(paths):
                    print("paths: no path.")
                else:
                    print(f"paths ({len(paths)}):")
                    cnt = 0
                    for path in paths:
                        print(path)
                        cnt += 1
                        if cnt > 5:
                            print("...")
                            break
                if not len(cycles):
                    print("cycles: no cycle.")
                else:
                    print(f"cycles ({len(cycles)}):")
                    cnt = 0
                    for cycle in cycles:
                        print(cycle)
                        cnt += 1
                        if cnt > 5:
                            print("...")
                            break
            path_probs, path_lengths = {}, {}
            for path in paths:
                assert path[0] == src and path[-1] == dest
                path_prob = 1.0
                path_len = 0
                if single_exit:
                    for i in range(len(path) - 2, -1, -1):
                        if debug:
                            print(f"[{i=}] {path[i]} -> {path[i+1]}")
                        # i = (3, 2, 1, 0) for path (0, 1, 2, 3, 4)
                        if len(self.edge_dict[path[i]]) == 1:
                            if debug:
                                print(f"single edge, {path_prob=}")
                            continue
                        path_len += 1
                        if self.is_loop_entry(path[i], single_exit):
                            if path[i] in self.pdom_dict[path[i + 1]]:
                                path_prob *= 1.0 / (1.0 + path_prob)
                                if debug:
                                    print(
                                        f"loop entry to loop start (body), {path_prob=}"
                                    )
                            else:
                                if debug:
                                    print(
                                        f"loop entry to loop exit, {path_prob=}"
                                    )
                                continue
                        else:
                            path_prob *= 1.0 / len(self.edge_dict[path[i]])
                            if debug:
                                print(
                                    f"num childs: {len(self.edge_dict[path[i]])}, {path_prob=}"
                                )
                else:
                    raise NotImplementedError()
                path_probs[tuple(path)] = path_prob
                path_lengths[tuple(path)] = path_len
                if debug:
                    print(f"{path} : {path_prob} (len: {path_len})")
            twopoint_probs[(src, dest)] = sum(path_probs.values())
            twopoint_lengths[(src, dest)] = max(path_lengths.values())
            if debug:
                print(
                    f"{src} -> {dest} : {twopoint_probs[(src, dest)]} (min length: {twopoint_lengths[(src, dest)]})"
                )
        total_prob = np.prod(list(twopoint_probs.values()))
        total_length = sum(list(twopoint_lengths.values()))
        if debug:
            print(
                f"P({source} -> {destination}) = {total_prob} (min length: {total_length})"
            )
        return total_prob, total_length

    def draw(self) -> Digraph:
        D = Digraph()
        for source, destinations in self.edge_dict.items():
            for destination in destinations:
                D.edge(source, destination)
        return D


class Graph:
    def __init__(self, cfg, start_func: str = "main") -> None:
        self.cfg = cfg
        functions = self.get_functions()
        if start_func not in functions:
            raise ValueError(
                f"start_func {start_func} is not in functions {functions}"
            )
        self.start_func = start_func
        self.edge_tups: Set[
            Tuple[str, str, EdgeType, BranchType]
        ] = self._build_edge_tups()
        self.edge_dict: Dict[
            str : Set[Tuple[str, EdgeType, BranchType]]
        ] = self._build_edge_dict()
        self.edge_dict_rev: Dict[
            str : Set[Tuple[str, EdgeType, BranchType]]
        ] = self._reverse_dict(self.edge_dict)
        self.program_entry = [
            node
            for node in self.edge_dict_rev
            if len(self.edge_dict_rev[node]) == 0
        ][0]
        self.call_graph = self._build_call_graph()
        self.intra_cfgs: Dict[str, SimpleGraph] = self._build_intra_cfgs()

    def _build_edge_tups(self) -> Set[Tuple[str, str, EdgeType, BranchType]]:
        edge_tups = set()
        for source, destination_tups in self.cfg["edges"]["intra"].items():
            for destination, branch_type in destination_tups:
                edge_tups.add(
                    (
                        source,
                        destination,
                        EdgeType.INTRA,
                        get_branch_type(branch_type),
                    )
                )
        for source, destination_tups in self.cfg["edges"]["inter"].items():
            for destination, branch_type in destination_tups:
                edge_tups.add(
                    (
                        source,
                        destination,
                        EdgeType.INTER,
                        get_branch_type(branch_type),
                    )
                )
        return edge_tups

    def _build_edge_dict(
        self,
    ) -> Dict[str, Set[Tuple[str, EdgeType, BranchType]]]:
        # sourcery skip: dict-comprehension, set-comprehension
        edge_dict = {node: set() for node in self.cfg["nodes"]}
        for source, destination_tups in self.cfg["edges"]["intra"].items():
            for destination, branch_type in destination_tups:
                edge_dict[source].add(
                    (
                        destination,
                        EdgeType.INTRA,
                        get_branch_type(branch_type),
                    )
                )
        for source, destination_tups in self.cfg["edges"]["inter"].items():
            for destination, branch_type in destination_tups:
                edge_dict[source].add(
                    (
                        destination,
                        EdgeType.INTER,
                        get_branch_type(branch_type),
                    )
                )
        return edge_dict

    def _reverse_dict(
        self, d: Dict[str, Set[Tuple[str, EdgeType, BranchType]]]
    ) -> Dict[str, Set[Tuple[str, EdgeType]]]:
        rev_dict = {node: set() for node in d}
        for k, vs in d.items():
            for v, edge_type, branch_type in vs:
                rev_dict[v].add((k, edge_type, branch_type))
        return rev_dict

    def get_parents(self, node: str) -> Set[str]:
        return [
            node for node, edge_type, branch_type in self.edge_dict_rev[node]
        ]

    def get_ancestors(self, node: str) -> Set[str]:
        ancestors = set()
        visited = set()
        q = [node]
        while len(q):
            node = q.pop(0)
            if node in visited:
                continue
            visited.add(node)
            parents = self.get_parents(node)
            q.extend(parents)
            ancestors.update(parents)
        return ancestors

    def get_functions(self) -> Set[str]:
        functions = set()
        for node in self.cfg["nodes"]:
            node_attr_dict = self.cfg["nodes"][node]
            functions.add(node_attr_dict["func"])
        return functions

    def _build_call_graph(self) -> Tuple[SimpleGraph, bool]:
        functions = self.get_functions()
        call_dict = {func: set() for func in functions}
        for source, destination_tups in self.cfg["edges"]["inter"].items():
            for destination, branch_type in destination_tups:
                if "actual_in" in source and "formal_in" in destination:
                    source_func = self.cfg["nodes"][source]["func"]
                    destination_func = destination.replace("-formal_in", "")
                    call_dict[source_func].add(destination_func)
        return SimpleGraph(call_dict, self.start_func)  # , "main" in functions

    def _build_intra_cfgs(self) -> Set[str]:
        intra_cfgs = {}
        functions = self.get_functions()
        for function in functions:
            nodes_in_function = {
                node
                for node in self.cfg["nodes"]
                if self.cfg["nodes"][node]["func"] == function
            }
            edges_in_function = {
                (edge[0], edge[1])
                for edge in self.edge_tups
                if edge[0] in nodes_in_function
                and edge[1] in nodes_in_function
                and edge[1] != f"{function}-formal_in"  # remove recursive calls
                and edge[0] != f"{function}-formal_out"
            }
            # link call site (actual-in) and return site (actual-out)
            for node in nodes_in_function:
                if "actual_in" in node:
                    actual_out = node.replace("-actual_in", "-actual_out")
                    assert actual_out in nodes_in_function
                    edges_in_function.add((node, actual_out))
            edge_dict_in_function = {node: set() for node in nodes_in_function}
            for source, destination in edges_in_function:
                if source not in edge_dict_in_function:
                    edge_dict_in_function[source] = set()
                edge_dict_in_function[source].add(destination)
            if function != "main":
                start_node = f"{function}-formal_in"
            else:
                start_node = self.program_entry
            assert start_node in nodes_in_function
            intra_cfg = SimpleGraph(edge_dict_in_function, start_node)
            intra_cfgs[function] = intra_cfg
        return intra_cfgs

    def get_nodes_in_function(self, func: str) -> Set[str]:
        return self.intra_cfgs[func].nodes

    def draw(self, hightlight: Dict = None) -> Digraph:
        return convert_to_dot(self.cfg, hightlight)

    def get_function_start(self, func: str) -> str:
        return self.intra_cfgs[func].start_node


def get_nodes_can_reach(
    simple_graph: SimpleGraph, target_node: str, start_candidate: Set[str]
) -> Set[str]:
    """
    find nodes in the {start_candidate} such that there is a path from the node
    to the {target_node} that any node except the starting node is not in the
    start_candidate in {simple_graph}.
    """
    if target_node in start_candidate:
        return {target_node}
    visited = set()
    nodes_can_reach = set()
    queue = [target_node]
    while len(queue):
        node = queue.pop(0)
        if node in visited:
            continue
        visited.add(node)
        if node in start_candidate:
            nodes_can_reach.add(node)
        else:
            queue.extend(simple_graph.get_parents(node))
    return nodes_can_reach


def get_nodes_to_reach(
    graph: Graph, target_func: str, source_func: str
) -> Set[str]:
    """
    find actual-in nodes calling {target_func} in {graph}
    """
    nodes_in_source_func = graph.get_nodes_in_function(source_func)
    source_to_target_func = {
        edge_tup[0]
        for edge_tup in graph.edge_dict_rev[f"{target_func}-formal_in"]
    }
    return nodes_in_source_func.intersection(source_to_target_func)


def structure_estimation(
    obss: np.ndarray,
    graph: Graph,
    target_node: str,
    observable_nodes: List[str],
    alpha: float,
    debug: bool = False,
):
    # steps
    # 0. Check whether the target node is already observed.
    # 1. Get paths {p1, ..., pn} wherer p1 is one of the reached node, pn is
    #    the target node, and pi (2 <= i <= n) is unreached node, and there is
    #    no cycle in the path.
    # 2. For each path, compute the probability of the path.
    # 3. return the sum of the probabilities of all paths.

    # 1. Get paths
    # 1.1. Backward slice the call graph
    # 1.2. Compute the call-level paths
    # 1.3. Identify path units to compute, represent call-level paths to series
    #      of path units

    # 0. Check whether the target node is already observed.
    if len(obss) == 0:
        covered_nodes = set()
        node2numcovered = dict(
            zip(observable_nodes, [0] * len(observable_nodes))
        )
    else:
        num_covered = np.sum(obss, axis=0)
        node2numcovered = dict(zip(observable_nodes, num_covered))
        covered_nodes = {
            node for node, num in zip(observable_nodes, num_covered) if num > 0
        }
    if target_node in covered_nodes:
        return node2numcovered[target_node] / len(obss), 0, -1

    if debug and is_notebook():
        display(graph.call_graph.draw())
    # 1.1. Backward slice the call graph
    target_func = graph.cfg["nodes"][target_node]["func"]
    if debug:
        print(f"target_func: {target_func}")
    if hasattr(graph, "cache_dict") and target_func in graph.cache_dict["func"]:
        sliced_callgraph, calllv_paths, calllv_cycles = copy.deepcopy(
            graph.cache_dict["func"][target_func]
        )
        if debug and is_notebook():
            display(sliced_callgraph.draw())
    else:
        sliced_callgraph = graph.call_graph.get_backward_slice_graph(
            target_func, can_have_no_start_node=True
        )
        if debug and is_notebook():
            display(sliced_callgraph.draw())
        # 1.2. Compute the call-level paths
        calllv_paths, calllv_cycles = sliced_callgraph.get_paths_and_cycles(
            can_have_no_start_node=True
        )
        if debug:
            print(f"calllv_paths: {calllv_paths}")
        if hasattr(graph, "cache_dict"):
            graph.cache_dict["func"][target_func] = (
                copy.deepcopy(sliced_callgraph),
                copy.deepcopy(calllv_paths),
                copy.deepcopy(calllv_cycles),
            )
    # 1.3. Identify path units to compute, represent call-level paths to series
    #      of path units
    covered_funcs = {graph.cfg["nodes"][node]["func"] for node in covered_nodes}
    calllv_paths_from_reached = set()
    for path in calllv_paths:
        start_idx = 0
        for idx, func in enumerate(path):
            if func in covered_funcs:
                start_idx = idx
        calllv_paths_from_reached.add(tuple(path[start_idx:]))
    if debug:
        print(f"calllv_paths_from_reached: {calllv_paths_from_reached}")
    #### if target function is reached, then there's unique path: {target_func}
    pathunitlv_paths: List[List[List[Tuple[str, str, str]]]] = []
    path_units: Set[Tuple[str, str, str]] = set()
    starting_path_units: Set[Tuple[str, str, str]] = set()
    if (
        len(calllv_paths_from_reached) == 1
        and (target_func,) in calllv_paths_from_reached
    ):
        starting_candidate = (
            covered_nodes.intersection(graph.get_nodes_in_function(target_func))
            if len(covered_nodes)
            else {graph.get_function_start(target_func)}
        )
        fix_starting_candidate = set()
        for start_cand in starting_candidate:
            for start_cand_dom in graph.intra_cfgs[target_func].dom_dict[
                start_cand
            ]:
                if (
                    start_cand_dom in observable_nodes
                    and start_cand_dom not in starting_candidate
                ):
                    print(
                        f"WARNING::Dominator {start_cand_dom} of {start_cand} is not in starting_candidate. Adding it to starting_candidate."
                    )
                    fix_starting_candidate.add(start_cand_dom)
        starting_candidate = starting_candidate.union(fix_starting_candidate)
        nodes_can_reach = get_nodes_can_reach(
            graph.intra_cfgs[target_func], target_node, starting_candidate
        )
        if len(nodes_can_reach) == 1 and list(nodes_can_reach)[
            0
        ] == graph.get_function_start(target_func):
            max_coverage = 0
        else:
            max_coverage = max(
                node2numcovered[node] for node in nodes_can_reach
            )
        for node_can_reach in nodes_can_reach:
            path_units.add((node_can_reach, target_node, target_func))
            starting_path_units.add((node_can_reach, target_node, target_func))
            pathunitlv_paths.append(
                [[(node_can_reach, target_node, target_func)]]
            )
    else:
        max_coverage = 0
        for path in calllv_paths_from_reached:
            #### first func: node_can_reach -> actual-in
            pathunitlv_path = []
            pathunits_of_edge = []
            nodes_to_reach = get_nodes_to_reach(graph, path[1], path[0])
            starting_candidate = (
                covered_nodes.intersection(graph.get_nodes_in_function(path[0]))
                if len(covered_nodes)
                else graph.get_function_start(path[0])
            )
            if len(starting_candidate) == 0 and len(covered_nodes):
                if debug:
                    print(
                        "WARNING::There are covered nodes, but none of the path entry is covered. program might have multiple entry point. For now, use the function start."
                    )
                starting_candidate = graph.get_function_start(path[0])
            for node_to_reach in nodes_to_reach:
                nodes_can_reach = get_nodes_can_reach(
                    graph.intra_cfgs[path[0]], node_to_reach, starting_candidate
                )
                for node_can_reach in nodes_can_reach:
                    path_units.add((node_can_reach, node_to_reach, path[0]))
                    starting_path_units.add(
                        (node_can_reach, node_to_reach, path[0])
                    )
                    pathunits_of_edge.append(
                        (node_can_reach, node_to_reach, path[0])
                    )
                    if node_can_reach in node2numcovered:
                        max_coverage = max(
                            max_coverage, node2numcovered[node_can_reach]
                        )
            if not len(pathunits_of_edge):
                raise Exception("No intra-control-flow path found.")
            pathunitlv_path.append(pathunits_of_edge)

            #### intermediate funcs: formal-in -> actual-in
            for idx in range(1, len(path) - 1):
                pathunits_of_edge = []
                curr_func = path[idx]
                next_func = path[idx + 1]
                node_can_reach = f"{curr_func}-formal_in"
                nodes_to_reach = get_nodes_to_reach(graph, next_func, curr_func)
                for node_to_reach in nodes_to_reach:
                    path_units.add((node_can_reach, node_to_reach, curr_func))
                    pathunits_of_edge.append(
                        (node_can_reach, node_to_reach, curr_func)
                    )
                pathunitlv_path.append(pathunits_of_edge)
            #### last func = target_func: formal-in -> target_node
            path_units.add((f"{path[-1]}-formal_in", target_node, path[-1]))
            pathunitlv_path.append(
                [(f"{path[-1]}-formal_in", target_node, path[-1])]
            )
            pathunitlv_paths.append(pathunitlv_path)
    if debug:
        print(f"{len(path_units)=}")
        print(f"{len(starting_path_units)=}")
        print(f"{len(pathunitlv_paths)=}")
        print(f"{path_units=}")
        print(f"{starting_path_units=}")
        print(f"{pathunitlv_paths=}")

    # 2. Compute the path unit-level paths
    pathunit_prob_dict = {}
    pathunit_length = {}
    for path_unit in path_units:
        source_node, destination_node, func = path_unit
        if source_node in covered_nodes:
            assert len(graph.edge_dict[source_node])
            if len(graph.edge_dict[source_node]) == 1:
                child = source_node
                cnt = 0
                while len(graph.edge_dict[child]) == 1:
                    cnt += 1
                    if cnt > 10:
                        raise Exception("Infinite loop")
                    if debug:
                        print(
                            f"Num children of {child} is 1. Proceeding to next child."
                        )
                    prev = child
                    if "actual_in" in child:
                        child = child.replace("actual_in", "actual_out")
                    else:
                        child = list(graph.edge_dict[child])[0][0]
                    if child in observable_nodes:
                        print("WARNING::The only child is observable.")
                        child = prev
                        break
                extended_source = child
            else:
                extended_source = source_node
            if len(graph.edge_dict[extended_source]) == 2:
                child1, child2 = graph.edge_dict[extended_source]
                child1, child2 = child1[0], child2[0]
                if child1 in covered_nodes or child2 in covered_nodes:
                    if child1 in covered_nodes:
                        uncovered_source_node = child2
                    else:
                        uncovered_source_node = child1
                    counterfactual_prob = (
                        (node2numcovered[source_node] / len(obss))
                        * alpha
                        / (node2numcovered[source_node] + 2 * alpha)
                    )
                    if debug:
                        print(
                            f"{source_node=}, num_covered={node2numcovered[source_node]}, counterfactual_prob={(node2numcovered[source_node] / len(obss))} * {alpha / (node2numcovered[source_node] + 2 * alpha)} = {counterfactual_prob}"
                        )
                        print(f"{uncovered_source_node=}")
                    start_edge = 1
                else:
                    print(
                        f"WARNING::Weird situation. Both children of {source_node} are not covered."
                    )
                    for child in graph.edge_dict[source_node]:
                        print(f"{child=}")
                    print(
                        f"For now, let's keep the source node is a uncovered source node, counterfactual_prob = laplace"
                    )
                    uncovered_source_node = source_node
                    counterfactual_prob = (
                        (node2numcovered[source_node] / len(obss))
                        * alpha
                        / (node2numcovered[source_node] + 2 * alpha)
                    )
                    print(
                        f"{source_node=}, num_covered={node2numcovered[source_node]}, counterfactual_prob={(node2numcovered[source_node] / len(obss))} * {alpha / (node2numcovered[source_node] + 2 * alpha)} = {counterfactual_prob}"
                    )
                    start_edge = 0
            else:
                if not len(graph.edge_dict[extended_source]) > 2:
                    print(
                        f"WARNING::The number of children of {extended_source} is {len(graph.edge_dict[extended_source])}"
                    )
                    print(
                        f"Unexpected situation. First observed in totinfo main entry (Node0x120714fd0)."
                    )
                uncovered_source_node = source_node
                counterfactual_prob = (
                    (node2numcovered[source_node] / len(obss))
                    * alpha
                    / (node2numcovered[source_node] + 2 * alpha)
                ) * len(graph.edge_dict[extended_source])
                start_edge = 0
        else:
            counterfactual_prob = 1
            if path_unit in starting_path_units:
                counterfactual_prob = alpha / (
                    sum(max(row) for row in obss) + 2 * alpha
                )
            uncovered_source_node = source_node
            if debug:
                print(f"{uncovered_source_node=}, {counterfactual_prob=}")
            start_edge = 0
        if (
            hasattr(graph, "cache_dict")
            and (uncovered_source_node, destination_node)
            in graph.cache_dict["twopoint_prob"]
        ):
            twopoint_prob, length = graph.cache_dict["twopoint_prob"][
                (uncovered_source_node, destination_node)
            ]
        else:
            twopoint_prob, length = graph.intra_cfgs[func].get_twopoint_prob(
                uncovered_source_node, destination_node, debug=debug
            )
            if hasattr(graph, "cache_dict"):
                graph.cache_dict["twopoint_prob"][
                    (uncovered_source_node, destination_node)
                ] = (twopoint_prob, length)
        pathunit_prob_dict[path_unit] = counterfactual_prob * twopoint_prob
        pathunit_length[path_unit] = start_edge + length
        if debug:
            print(
                f"{path_unit=}: {pathunit_prob_dict[path_unit]=} (length={pathunit_length[path_unit]})"
            )

    # 3. Compute the path-level probabilities
    path_prob_dict, path_length_dict = {}, {}
    if debug:
        print("Compute the path-level probabilities")
    for pathunitlv_path in pathunitlv_paths:
        if debug:
            print(f"\t{pathunitlv_path=}")
        for unique_path in product(*pathunitlv_path):
            if debug:
                print(f"\t\t{unique_path=}")
            path_prob_dict[unique_path] = 1
            for path_unit in unique_path:
                path_prob_dict[unique_path] *= pathunit_prob_dict[path_unit]
            path_length_dict[unique_path] = sum(
                pathunit_length[path_unit] for path_unit in unique_path
            )
            if debug:
                print(
                    f"\t\t{unique_path=}: {path_prob_dict[unique_path]=} (length={path_length_dict[unique_path]})"
                )
    return (
        sum(path_prob_dict.values()),
        min(path_length_dict.values()),
        max_coverage,
    )


def compute_re(esti: np.ndarray, gt: np.ndarray) -> float:
    return np.array(
        [
            (
                np.abs((np.log(e_esti) - np.log(e_gt)) / np.log(e_gt))
                if e_esti != 0
                else np.nan
            )
            for e_esti, e_gt in zip(esti, gt)
        ]
    )
