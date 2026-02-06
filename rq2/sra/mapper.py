import json
import sys
import time
from typing import Dict, List, Set, Tuple, Union, Any

import numpy as np

sys.path.append("") # set the root directory of the project
from sra.cfggen import gen_cfg_inter, generate_data, parse_dotfiles, parse_ll


def get_bbs_fuzz(bbs_fuzz_path: str) -> List[Dict]:
    return json.load(open(bbs_fuzz_path, "r"))["basic_blocks"]


def get_bbs_fuzz_of_func(func_name: str, bbs_fuzz: List[Dict]):
    for bb in bbs_fuzz:
        if bb["function"] == func_name:
            yield bb

def get_node_from_bb_lineno_fuzz(cfg_inter: Dict, func_name: str, line_no: int) -> Tuple[str, Any]:
    """
    Get the node name from LLVM dot files, by the function name and line_no.
    """
    for node, node_info in cfg_inter["nodes"].items():
        if (
            node_info["linenums"] is not None 
            and node_info["func"] == func_name
            and line_no in node_info["linenums"]
        ):
            return node, node_info
    return None


def get_mapping(
    functions: List[str],
    bbs_fuzz: List[Dict],
    node_to_obs_bb: Dict,
    cfg_inter: Dict,
    small_fuzzdat: np.array = None,
    debug: bool = False,
) -> Tuple[Dict[int, Set[str]], Dict[str, Union[int, Set[int]]]]:
    map_fuzz_to_obs_node = {}
    map_obs_to_fuzz_node = {}
    for function in functions:
        if debug:
            print(f"[{function}]")
        nodes_obs_of_func = [
            (node_obs, bb_obs_idx)
            for node_obs, bb_obs_idx in node_to_obs_bb.items()
            if bb_obs_idx[0] == function
        ]
        bbs_fuzz_of_func = list(get_bbs_fuzz_of_func(function, bbs_fuzz))
        if len(nodes_obs_of_func) == len(bbs_fuzz_of_func):
            for bb_fuzz, (node_obs, bb_obs_idx) in zip(
                bbs_fuzz_of_func, nodes_obs_of_func
            ):
                map_fuzz_to_obs_node[bb_fuzz["id"]] = {node_obs}
                map_obs_to_fuzz_node[node_obs] = bb_fuzz["id"]
        else:
            num_bb_obs_idx = len(
                {
                    bb_obs_idx
                    for node_obs, bb_obs_idx in nodes_obs_of_func
                    if cfg_inter["nodes"][node_obs]["linenums"] is not None
                    and cfg_inter["nodes"][node_obs]["linenums"] != {0}
                    and not cfg_inter["nodes"][node_obs]["nopred"]
                }
            )
            if (
                function in ["main", "Caseerror", "exit_here"]
                and len(bbs_fuzz_of_func) - num_bb_obs_idx == 1
            ):
                bbs_fuzz_of_func = bbs_fuzz_of_func[:-1]
            if num_bb_obs_idx == len(bbs_fuzz_of_func):
                curr_bb_obs_idx = nodes_obs_of_func[0][1]
                curr_bbs_fuzz_idx = 0
                for node_obs, bb_idx_obs in nodes_obs_of_func:
                    if (
                        cfg_inter["nodes"][node_obs]["linenums"] is None
                        or cfg_inter["nodes"][node_obs]["linenums"] == {0}
                        or cfg_inter["nodes"][node_obs]["nopred"]
                    ):
                        continue
                    if bb_idx_obs != curr_bb_obs_idx:
                        curr_bb_obs_idx = bb_idx_obs
                        curr_bbs_fuzz_idx += 1
                    # special treatment for jsoncpp program
                    if (
                        not "c++/5.4.0"
                        in bbs_fuzz_of_func[curr_bbs_fuzz_idx]["file"]
                    ):
                        assert cfg_inter["nodes"][node_obs][
                            "linenums"
                        ].intersection(
                            set(bbs_fuzz_of_func[curr_bbs_fuzz_idx]["lines"])
                        )
                    if (
                        bbs_fuzz_of_func[curr_bbs_fuzz_idx]["id"]
                        not in map_fuzz_to_obs_node
                    ):
                        map_fuzz_to_obs_node[
                            bbs_fuzz_of_func[curr_bbs_fuzz_idx]["id"]
                        ] = set()
                    map_fuzz_to_obs_node[
                        bbs_fuzz_of_func[curr_bbs_fuzz_idx]["id"]
                    ].add(node_obs)
                    map_obs_to_fuzz_node[node_obs] = bbs_fuzz_of_func[
                        curr_bbs_fuzz_idx
                    ]["id"]
            else:
                print(
                    f"WARNING: Function {function} has {len(bbs_fuzz_of_func)} basic blocks in fuzzing data, but there's {num_bb_obs_idx} basic blocks to match in the observation data."
                )
                print("match only with the line numbers.")
                for node_obs, bb_obs_idx in nodes_obs_of_func:
                    if (
                        cfg_inter["nodes"][node_obs]["linenums"] is None
                        or cfg_inter["nodes"][node_obs]["linenums"] == {0}
                        or cfg_inter["nodes"][node_obs]["nopred"]
                    ):
                        continue
                    for bb_fuzz in bbs_fuzz_of_func:
                        if cfg_inter["nodes"][node_obs][
                            "linenums"
                        ].intersection(set(bb_fuzz["lines"])):
                            if bb_fuzz["id"] not in map_fuzz_to_obs_node:
                                map_fuzz_to_obs_node[bb_fuzz["id"]] = set()
                            map_fuzz_to_obs_node[bb_fuzz["id"]].add(node_obs)
                            if node_obs not in map_obs_to_fuzz_node:
                                map_obs_to_fuzz_node[node_obs] = set()
                            map_obs_to_fuzz_node[node_obs].add(bb_fuzz["id"])
        if debug:
            bb_fuzz_id_to_dict = {
                bb_dict["id"]: bb_dict for bb_dict in bbs_fuzz
            }
            for node_obs, bb_obs_idx in nodes_obs_of_func:
                bb_fuzz_idxs = map_obs_to_fuzz_node.get(node_obs, -1)
                if type(bb_fuzz_idxs) == int:
                    print(
                        f"{bb_fuzz_idxs=:8d} {node_obs=:20s} {str(bb_obs_idx):35s} obs_node_lines={cfg_inter['nodes'][node_obs]['linenums']}"
                        + (
                            f" vs fuzz_node_lines={bb_fuzz_id_to_dict[bb_fuzz_idxs]['lines']}"
                            if bb_fuzz_idxs != -1
                            else ""
                        )
                    )
                elif type(bb_fuzz_idxs) == set:
                    fuzz_node_lines = set()
                    for bb_fuzz_idx in bb_fuzz_idxs:
                        fuzz_node_lines = fuzz_node_lines.union(
                            bb_fuzz_id_to_dict[bb_fuzz_idx]["lines"]
                        )
                    print(
                        f"bb_fuzz_idxs={str(bb_fuzz_idxs)} {node_obs=:20s} {str(bb_obs_idx):35s} obs_node_lines={cfg_inter['nodes'][node_obs]['linenums']} vs fuzz_node_lines={fuzz_node_lines}"
                    )
            print()
    return map_fuzz_to_obs_node, map_obs_to_fuzz_node


def fuzzdat_to_obs(
    fuzz_dat: np.ndarray,
    cfg_inter: Dict,
    bbs_fuzz: List[Dict],
    map_fuzz_to_obs_node: Dict[int, Set[str]],
    nodenames: List[str],
    debug: bool = False,
):
    obs = []
    # generate matrix
    M = np.zeros((fuzz_dat.shape[1], len(cfg_inter["nodes"])))
    for idx, bb_fuzz in enumerate(bbs_fuzz):
        bb_fuzz_id = bb_fuzz["id"]
        if bb_fuzz_id in map_fuzz_to_obs_node:
            corr_node_set = map_fuzz_to_obs_node[bb_fuzz_id]
            for corr_node in corr_node_set:
                node_idx = nodenames.index(corr_node)
                M[idx, node_idx] = 1
    zero_idxs = [idx for idx, val in enumerate(np.sum(M, axis=0)) if val == 0]
    for cov_idx, coverage in enumerate(fuzz_dat, 1):
        if debug:
            start = time.time()
        new_coverage = np.max(np.multiply(coverage.reshape(-1, 1), M), axis=0)
        if debug:
            end = time.time()
            print(f"DEBUG::{cov_idx=}/{len(fuzz_dat)} {end-start:.2f}s")
        obs.append(new_coverage)
    ret = np.array(obs)
    ret[:, zero_idxs] = -1
    return ret


if __name__ == "__main__":
    debug = True
    dotfiles = generate_data("converter", "tcas")
    functions = [fname.split(".")[1] for fname in dotfiles]
    debug_info_dict, blocks_dict = parse_ll("converter/tcas.ll")
    print(len(blocks_dict["Inhibit_Biased_Climb"]))
    print(blocks_dict["Inhibit_Biased_Climb"])
    cfgs_intra, node_to_bb = parse_dotfiles(
        dotfiles,
        "converter",
        debug_info_dict,
        blocks_dict,
        non_overlap_lineidx=False,
    )
    cfg_inter = gen_cfg_inter(cfgs_intra)

    bbs_fuzz_path = "converter/ft_tcas.json"
    bbs_fuzz = get_bbs_fuzz(bbs_fuzz_path)
    map_fuzz_to_obs_node, map_obs_to_fuzz_node = get_mapping(
        functions, bbs_fuzz, node_to_bb, cfg_inter, debug
    )
