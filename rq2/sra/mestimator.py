import sys
from typing import List, Set, Tuple
import numpy as np

from sra.estimator import SimpleGraph


def get_nodes_can_reach(
    simple_graph: SimpleGraph, target_node: str, start_candidate: Set[str]
) -> Tuple[Set[str], Set[str]]:
    """
    find nodes in the {start_candidate} such that there is a path from the node
    to the {target_node} that any node except the starting node is not in the
    start_candidate in {simple_graph}.
    """
    if target_node in start_candidate:
        return {target_node}, {target_node}, {target_node}
    visited = set()
    nodes_can_reach = set()
    top_nodes = set()

    queue = [target_node]
    while len(queue):
        node = queue.pop(0)
        if node in visited:
            continue
        visited.add(node)
        if node in start_candidate:
            nodes_can_reach.add(node)
        else:
            if len(simple_graph.get_parents(node)) == 0:
                top_nodes.add(node)
            else:
                queue.extend(simple_graph.get_parents(node))
    return nodes_can_reach, top_nodes, visited


def structure_estimation(
    obss: np.ndarray,
    graph: SimpleGraph,
    target_node: str,
    observable_nodes: List[str],
    alpha: float,
    option: str,
    debug: bool = False,
):
    # steps
    # 0. Check whether the target node is already observed.
    # 2. For each path, compute the probability of the path.
    # 3. return the sum of the probabilities of all paths.

    # 0. Check whether the target node is already observed.
    if option == "chunk":
        num_covered = np.sum(obss, axis=0)
        node2numcovered = dict(zip(observable_nodes, num_covered))
    elif option == "cum":
        num_covered = obss
        node2numcovered = dict(zip(observable_nodes, num_covered))
    is_not_observed = (
        len(obss) == 0
        if option == "raw"
        else max(node2numcovered) == 0
        if option == "cum"
        else len(obss)
    )
    if is_not_observed:
        covered_nodes = set()
        if option == "raw":
            node2numcovered = dict(
                zip(observable_nodes, [0] * len(observable_nodes))
            )
    else:
        if option == "raw":
            num_covered = np.sum(obss, axis=0)
            node2numcovered = dict(zip(observable_nodes, num_covered))
        covered_nodes = {
            node for node, num in zip(observable_nodes, num_covered) if num > 0
        }
    total_obs = (
        len(obss)
        if option == "raw"
        else max(num_covered)
        if option == "cum"
        else np.sum(max(row) for row in obss)
    )
    if target_node in covered_nodes:
        print("target node is already observed")
        return node2numcovered[target_node] / total_obs, 0, -1

    # 2. Compute the path unit-level paths
    starting_candidate = (
        covered_nodes if len(covered_nodes) else {graph.start_node}
    )
    nodes_can_reach, top_nodes, visited = get_nodes_can_reach(
        graph, target_node, starting_candidate
    )
    if (
        len(nodes_can_reach) == 1
        and list(nodes_can_reach)[0] == graph.start_node
    ):
        max_coverage = 0
    elif len(nodes_can_reach) == 0:
        observable_top_nodes = {
            node for node in top_nodes if node in observable_nodes
        }
        print(
            f"WARNING::no path to the target node; use top_nodes instead: {observable_top_nodes}"
        )
        nodes_can_reach = observable_top_nodes
        max_coverage = -1
    else:
        max_coverage = max(node2numcovered[node] for node in nodes_can_reach)

    path_prob_dict = {}
    path_length_dict = {}
    for source_node in nodes_can_reach:
        if source_node == target_node:
            path_prob_dict[source_node] = alpha / (total_obs + 2 * alpha)
            path_length_dict[source_node] = -1
            continue
        starting_cand_under_source = graph.get_childs(source_node)
        if source_node in starting_cand_under_source:
            starting_cand_under_source.remove(source_node)
        nodes_can_reach_under_source, _, _ = get_nodes_can_reach(
            graph, target_node, starting_cand_under_source
        )
        unreached_childs = {
            node
            for node in nodes_can_reach_under_source
            if node not in covered_nodes and node in observable_nodes
        }
        assert unreached_childs
        prob_from_source = 0
        length_from_source = sys.maxsize
        for uncovered_source_node in nodes_can_reach_under_source:
            counterfactual_prob = (
                (node2numcovered[source_node] / total_obs)
                if node2numcovered[source_node]
                else (alpha / (total_obs + 2 * alpha))
            ) * (
                alpha
                / (node2numcovered[source_node] + alpha * len(unreached_childs))
            )
            if (
                hasattr(graph, "cache_dict")
                and (uncovered_source_node, target_node)
                in graph.cache_dict["twopoint_prob"]
            ):
                twopoint_prob, length = graph.cache_dict["twopoint_prob"][
                    (uncovered_source_node, target_node)
                ]
            else:
                twopoint_prob, length = graph.get_twopoint_prob(
                    uncovered_source_node, target_node, debug=debug
                )
                if hasattr(graph, "cache_dict"):
                    graph.cache_dict["twopoint_prob"][
                        (uncovered_source_node, target_node)
                    ] = (twopoint_prob, length)
            prob_from_source += counterfactual_prob * twopoint_prob
            length_from_source = min(length_from_source, length + 1)
        path_prob_dict[source_node] = prob_from_source
        path_length_dict[source_node] = (
            length_from_source
            if node2numcovered[source_node] > 0
            or source_node == graph.start_node
            else -1
        )
    assert (
        set(path_length_dict.values()) == {-1}
        or min(path_length_dict.values()) > 0
    )
    return (
        sum(path_prob_dict.values()),
        min(path_length_dict.values()),
        max_coverage,
    )
