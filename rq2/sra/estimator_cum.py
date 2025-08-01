import copy
from itertools import product
from typing import List, Set, Tuple

import numpy as np
from IPython.core.display_functions import display

from sra.estimator import (
    Graph,
    get_nodes_can_reach,
    get_nodes_to_reach,
    gotu_regression,
    is_notebook,
    NoStartNodeError,
)


def frequency_estimation(cum_obs: np.ndarray) -> np.ndarray:
    if max(cum_obs) == 0:
        return np.zeros(len(cum_obs))
    return cum_obs / cum_obs.max()


def laplace_estimation(cum_obs: np.ndarray) -> np.ndarray:
    return (cum_obs + 2) / (cum_obs.max() + 4)


def gotu_estimation(cum_obs: np.ndarray, debug: bool = False) -> np.ndarray:
    num_obs = max(cum_obs)
    num_nodes = len(cum_obs)
    if num_obs == 0:
        return np.zeros(num_nodes)
    alpha, beta = gotu_regression(cum_obs, num_obs)
    P_0_all = np.exp(alpha) / num_obs
    probs = [
        cum_obs[i] / num_obs * (1 + 1 / cum_obs[i]) ** (beta + 1)
        if cum_obs[i]
        else P_0_all / len([e for e in cum_obs if e == 0])
        for i in range(num_nodes)
    ]
    return probs / sum(probs) * (cum_obs.sum() / num_obs)


def structure_estimation(
    num_covered: np.ndarray,
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
    node2numcovered = dict(zip(observable_nodes, num_covered))
    if max(num_covered) == 0:
        covered_nodes = set()
    else:
        covered_nodes = {
            node for node, num in zip(observable_nodes, num_covered) if num > 0
        }
    if target_node in covered_nodes:
        return node2numcovered[target_node] / max(num_covered), 0, -1

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
        start_idx = 0  # if graph.is_main else 1
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
            else graph.get_function_start(target_func)
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
                        (node2numcovered[source_node] / max(num_covered))
                        * alpha
                        / (node2numcovered[source_node] + 2 * alpha)
                    )
                    if debug:
                        print(
                            f"{source_node=}, num_covered={node2numcovered[source_node]}, counterfactual_prob={(node2numcovered[source_node] / max(num_covered))} * {alpha / (node2numcovered[source_node] + 2 * alpha)} = {counterfactual_prob}"
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
                        (node2numcovered[source_node] / max(num_covered))
                        * alpha
                        / (node2numcovered[source_node] + 2 * alpha)
                    )
                    print(
                        f"{source_node=}, num_covered={node2numcovered[source_node]}, counterfactual_prob={(node2numcovered[source_node] / max(num_covered))} * {alpha / (node2numcovered[source_node] + 2 * alpha)} = {counterfactual_prob}"
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
                    (node2numcovered[source_node] / max(num_covered))
                    * alpha
                    / (node2numcovered[source_node] + 2 * alpha)
                ) * len(graph.edge_dict[extended_source])
                start_edge = 0
        else:
            counterfactual_prob = 1
            if path_unit in starting_path_units:
                counterfactual_prob = alpha / (max(num_covered) + 2 * alpha)
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
