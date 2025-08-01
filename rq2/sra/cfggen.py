import copy
from difflib import Differ
import os
import pprint
import re
import subprocess
import sys
from typing import Dict, List, Set, Tuple, Final
import json

import pydot
from graphviz import Digraph

regex_call = r"call\s(\w+\s)+@(?!llvm)(\w+)\("
regex_line = r"line:\s(\d+)"
regex_debugid = r"!dbg\s!(\d+)"
regex_branch = r"(\\l\|{<s\d+>[-\w]+(\|<s\d+>[-\w]+)+}}\")"


def generate_data_from_ll(path: str, llfile: str) -> List[str]:
    # move to path
    cur_dir = os.getcwd()
    os.chdir(path)

    # remove old files
    os.system("rm .*.dot")

    try:
        ret = subprocess.check_output(
            f"opt -dot-cfg {llfile} -disable-output -enable-new-pm=0",
            shell=True,
            stderr=subprocess.STDOUT,
        )
    except subprocess.CalledProcessError as e:
        print(e.output)
        raise e
    ## parse output to get dotfile list
    stdout = ret.decode("utf-8")
    dotfiles = [
        "." + line.split(" ")[1].strip("'.") for line in stdout.splitlines()
    ]
    print(f"dotfiles: {dotfiles}")

    # return to cur_dir
    os.chdir(cur_dir)

    return dotfiles


def dump_cfg(filename: str, opt_path: str | None = None) -> bytes:
    opt_path = opt_path or "opt"

    # --- figure out whether this ‘opt’ is legacy or new PM-only ----------
    try:
        version_out = subprocess.check_output(
            [opt_path, "--version"], text=True, stderr=subprocess.STDOUT
        )
        m = re.search(r"LLVM version (\d+)", version_out)
        major = int(m.group(1)) if m else 0
    except Exception:
        # fall back to legacy spelling when we can’t determine the version
        major = 0

    legacy = major and major < 18

    # --- choose the right CLI flags --------------------------------------
    pass_flag = "-dot-cfg" if legacy else "-passes=dot-cfg"
    pm_flag   = "-enable-new-pm=0" if legacy else ""

    # --- run opt ----------------------------------------------------------
    cmd = f"{opt_path} {pass_flag} {filename}.ll -disable-output {pm_flag}"
    return subprocess.check_output(cmd, shell=True, stderr=subprocess.STDOUT)


def generate_data(path: str, filename: str, clang_path: str = None, opt_path: str = None) -> List[str]:
    # move to path
    cur_dir = os.getcwd()
    os.chdir(path)

    # remove old files
    try:
        os.system(f"rm {filename}.ll")
        os.system("rm .*.dot")
    except Exception as e:
        pass

    # generate .ll, dotfiles
    clang_path = clang_path if clang_path else "clang"
    os.system(
        f"{clang_path} -g -gcolumn-info -S -emit-llvm -Xclang -disable-O0-optnone {filename}.c -o {filename}.ll 2> /dev/null"
    )

    try:
        ret = dump_cfg(filename, opt_path)
    except subprocess.CalledProcessError as e:
        print(e.output)
        raise e
    ## parse output to get dotfile list
    stdout = ret.decode("utf-8")
    dotfiles = [
        "." + line.split(" ")[1].strip("'.") for line in stdout.splitlines()
    ]
    print(f"dotfiles: {dotfiles}")

    # return to cur_dir
    os.chdir(cur_dir)

    return dotfiles


def parse_ll(ll_path: str) -> Tuple[Dict[int, str], Dict[str, str]]:
    with open(ll_path) as f:
        lines = f.readlines()

    debug_start_line_idx = [
        i for i, line in enumerate(lines) if line.startswith("!0")
    ][0]
    debug_lines = lines[debug_start_line_idx:]
    debug_info_dict = {
        int(line.split(" = ")[0][1:]): line.split(" = ")[1].strip()
        for line in debug_lines
    }

    subprogram_debug_line = [
        (idx, line)
        for idx, line in enumerate(lines)
        if line.startswith("define")
    ]
    subprogram_idx_tup = [
        (idx, line.split("@")[1].split("(")[0])
        for idx, line in subprogram_debug_line
    ]
    blocks_dict = {}
    for func_start_line, function_name in subprogram_idx_tup:
        curr_line = func_start_line
        blocks = []
        block = []
        in_block_flag = True
        while True:
            line = lines[curr_line]
            if not in_block_flag and not re.match("\d+:", line):
                break
            if line == "\n":
                if len(block):
                    blocks.append(block)
                    block = []
                in_block_flag = False
            elif re.match("\d+:", line):
                in_block_flag = True
                block.append(line)
            else:
                block.append(line)
            curr_line += 1
        blocks = ["".join(block) for block in blocks]
        blocks_dict[function_name] = blocks
    return debug_info_dict, blocks_dict


def generate_graph(dotpath: str) -> pydot.Dot:
    """generate graph from .dot file"""
    return pydot.graph_from_dot_file(dotpath)[0]


def extract_nodes_edges(graph) -> Tuple[List[pydot.Node], List[pydot.Edge]]:
    """extract nodes and edges from graph"""
    nodes = graph.get_nodes()
    nodes = [node for node in nodes if node.get_name() != '"\\n"']
    edges = graph.get_edges()
    return nodes, edges


def get_min_debug_id(nodes: List[pydot.Node]) -> int:
    debug_ids = set()
    for node in nodes:
        label = node.get_attributes()["label"]
        matches = re.findall("!(\d+)", label, re.MULTILINE)
        if len(matches):
            debug_ids.update([int(match) for match in matches])
    return min(debug_ids)


def parse_node_label(
    node_label: str, block: str, function_in_consideration: Set[str]
) -> Tuple[List[Tuple[List[str], Set[int], str]], bool, str, bool]:
    """parse node label each call in the basic block"""
    # sourcery skip: raise-specific-error

    br_flag, br_templete = False, None
    if re.findall(regex_branch, node_label):
        if not node_label.endswith('\\l|{<s0>T|<s1>F}}"'):
            br_templete = re.findall(regex_branch, node_label)[0][0].rstrip('"')
        br_flag = True
        node_label = re.sub(regex_branch, '}"', node_label, 0, re.MULTILINE)

    bbs = []
    curr_bb = []
    curr_debug_id = set()
    for codeline in block.split("\n"):
        curr_bb.append(codeline)
        if debugid_matches := re.findall(regex_debugid, codeline, re.MULTILINE):
            debug_id = int(debugid_matches[0])
            curr_debug_id.add(debug_id)
        if call_matches := re.findall(regex_call, codeline, re.MULTILINE):
            if len(call_matches) > 1:
                print(f"{codeline=}")
                print(f"{call_matches=}")
                raise Exception("More than one call in a line")
            callee = call_matches[0][-1]
            if callee not in function_in_consideration:
                continue
            bbs.append((curr_bb, curr_debug_id, callee))
            curr_bb = []
            curr_debug_id = set()
    if len(curr_debug_id):
        bbs.append((curr_bb, curr_debug_id, None))

    return (
        bbs,
        br_flag,
        br_templete,
        "unreachable" in node_label,
    )


_TOP_LEVEL_SEP: Final[str] = "|"           # record-field separator at depth 0


def extract_ir_from_dot_label(label: str) -> str:
    """
    Return the LLVM-IR body contained in a GraphViz record `label=` string
    produced by `clang -dot-cfg`.

    Works with LLVM 10 → trunk and for both unconditional and conditional
    basic blocks.
    """
    # 1) unquote the attribute and un-escape GraphViz sequences
    decoded = bytes(label.strip('"'), "utf-8").decode("unicode_escape")

    # 2) drop the outermost braces  { … }
    if decoded.startswith("{") and decoded.endswith("}"):
        inner = decoded[1:-1]
    else:                               # defensive fallback
        inner = decoded

    # 3.0) newer LLVM, in dot files, 
    # each block label is followed by a separator |
    # we need to remove this pattern "\d+:\\l|"
    # so that the block body is still at index 0
    inner = re.sub(r"\d+:\\l\|", "", inner)

    # 3) walk the string, tracking nested braces, and stop at the FIRST
    #    top-level "|" (if any).  That yields the IR body for both
    #    unconditional and conditional blocks.
    depth = 0
    ir_chars = []
    for ch in inner:
        if ch == "{" :
            depth += 1
        elif ch == "}":
            depth -= 1
        elif ch == _TOP_LEVEL_SEP and depth == 0:
            break                       # reached successor-port sub-record
        ir_chars.append(ch)

    ir_field = "".join(ir_chars)

    # 4) tidy up:   remove the block label "%bb:" if still present,
    #               translate "\l" line-breaks, strip misc escapes,
    #               normalise away ", align N" (optional).
    ir_field = re.sub(r"^\s*%[\w\.\d]+:\s*", "", ir_field)     # header
    ir_field = (ir_field
                .replace("\\l", "\n")
                .replace("\\\\", "\\")
                .replace('\\"', '"'))
    ir_field = re.sub(r",\s*align\s+\d+", "", ir_field)        # align N
    ir_field = ir_field.rstrip().replace("\n...", "")
    # remove empty first line
    if ir_field.startswith("\n"):
        ir_field = ir_field[1:]
    # remove first line if it is number with colon
    if re.match(r"^\s*\d+:\s", ir_field):
        ir_field = "\n".join(ir_field.split("\n")[1:])
    return ir_field.rstrip()                                   # final trim


def parse_dotfiles(
    dotfiles: List[str],
    path: str,
    debug_info_dict: Dict[int, str],
    blocks_dict: Dict[str, str],
    non_overlap_lineidx: bool,
    debug: bool = False,
) -> Tuple[Dict, Dict]:  # sourcery skip: raise-specific-error
    """
    The second return dictionary maps from the node to the basic block in the
    original LLVM IR.
    """
    cfgs_intra = {}
    node_to_bb = {}
    function_in_consideration = set()
    for dotfile in dotfiles:
        function_name = ".".join(dotfile.strip(".").split(".")[:-1])
        function_in_consideration.add(function_name)
    for dotfile in dotfiles:
        function_name = ".".join(dotfile.strip(".").split(".")[:-1])
        if debug:
            print(f"Processing function_name: {function_name}")

        # extract nodes and edges from graph
        dotpath = os.path.join(path, dotfile)
        graph = generate_graph(dotpath)
        nodes, edges = extract_nodes_edges(graph)

        if debug:
            print(
                f"Parsing sanity check {len(blocks_dict[function_name])=} {len(nodes)=}, {len(edges)=}"
            )
        assert len(nodes) == len(blocks_dict[function_name])

        for i in range(len(nodes)):
            node = nodes[i]
            node_label = node.get_attributes()["label"]
            # if debug:
            #     print(f"DEBUG:: {node_label}")
            
            modified_node_label = extract_ir_from_dot_label(node_label)

            block = blocks_dict[function_name][i]
            if "No predecessors!" in block:
                continue
            if i == 0:
                block = "\n".join(block.split("\n")[1:])
            modified_block = (
                re.sub(r";\s.+\n", "\n", block, 0, re.MULTILINE)
            )
            # Remove all ', align N' where N is any number
            modified_block = re.sub(r", align \d+", "", modified_block).rstrip("\n}")

            # remove the first line if it starts with "\s{number}:\s"
            if re.match(r"\s*\d+:\s", modified_block):
                modified_block = "\n".join(
                    modified_block.split("\n")[1:]
                )
            
            # remove lines with debugger msg like #dbg_
            modified_block = re.sub(r".*#dbg_.*\n?", "", modified_block)

            # modifed_block doesn't contain some debugger lines
            blur_idx = lambda s: re.sub(
                "#\d+", "#num", re.sub(r"!\d+", "!num", s)
            )
            if blur_idx(modified_node_label) != blur_idx(modified_block):
                d = Differ()
                print("WARNING")
                print(f"{i=}")
                print("node_label:")
                print(modified_node_label)
                print("block:")
                print(modified_block)
                result = list(
                    d.compare(
                        blur_idx(modified_node_label).splitlines(),
                        blur_idx(modified_block).splitlines(),
                    )
                )
                print("Diff:")
                print("\n".join(result))
                print("End diff.")
                raise Exception("node_label != block")
        if debug:
            print("Parsing sanity check passed")

        node_dict, edge_dict = {}, {}
        cfg = {"nodes": node_dict}
        # parse nodes
        if non_overlap_lineidx:
            prev_lines = set()
        for block_idx, (node, block) in enumerate(
            zip(nodes, blocks_dict[function_name])
        ):
            node_name = node.get_name()
            node_label = node.get_attributes()["label"]
            (
                bbs,
                br_flag,
                br_templete,
                end_program_flag,
            ) = parse_node_label(node_label, block, function_in_consideration)
            if "No predecessors!" in block:
                nopred_flag = True
            else:
                nopred_flag = False
            if not len(bbs):
                node_dict[node_name] = {
                    "linenums": None,
                    "call": None,
                    "branch": False,
                    "program_exit": False,
                    "nopred": nopred_flag,
                }
                node_to_bb[node_name] = (function_name, block_idx)
            for idx, (text, debug_ids, call) in enumerate(bbs):
                node_name_with_idx = (
                    f"{node_name}-{idx}" if len(bbs) > 1 else node_name
                )
                lines = set()
                for debug_id in debug_ids:
                    try:
                        debug_info = debug_info_dict[debug_id]
                    except KeyError as e:
                        print(f"{function_name=}")
                        print(f"{node_name=}")
                        print(f"{text=}")
                        print(f"{debug_ids=}")
                        # raise exception with call stack
                        raise e
                    linenum = int(
                        re.findall(regex_line, debug_info, re.MULTILINE)[0]
                    )
                    lines.add(linenum)
                if non_overlap_lineidx:
                    lines -= prev_lines
                if len(lines) == 0:
                    lines = None
                node_attr = {
                    "linenums": lines,
                    "call": call,
                    "branch": False,
                    "program_exit": False,
                    "nopred": False,
                }
                if idx == 0:
                    node_attr["nopred"] = nopred_flag
                if idx == len(bbs) - 1:
                    if br_flag:
                        node_attr["branch"] = True
                        node_attr["branch_templete"] = br_templete
                    if end_program_flag:
                        node_attr["program_exit"] = True
                else:
                    edge_dict[node_name_with_idx] = {
                        (f"{node_name}-{idx + 1}", None)
                    }
                node_dict[node_name_with_idx] = node_attr
                node_to_bb[node_name_with_idx] = (function_name, block_idx)
                if non_overlap_lineidx:
                    prev_lines = lines or set()

        # parse edges
        for edge in edges:
            branch = None
            edge_source = edge.get_source()
            if ":" in edge_source:
                edge_source, branch = edge_source.split(":")
            if edge_source not in node_dict:
                corresponding_nodes = [
                    node for node in node_dict if node.startswith(edge_source)
                ]
                order = [
                    int(node.split("-")[1]) for node in corresponding_nodes
                ]
                edge_source = corresponding_nodes[order.index(max(order))]
            assert edge_source in node_dict
            if branch is not None:
                source_node = node_dict[edge_source]
                if not source_node["branch"]:
                    print(f"{edge_source=}")
                    print(f"{source_node=}")
                    raise Exception(f"{edge_source=} is not a branch node")
                if source_node["branch_templete"] is None:
                    branch = branch == "s0"
            edge_destination = edge.get_destination()
            if edge_destination not in node_dict:
                if f"{edge_destination}-0" not in node_dict:
                    raise Exception(
                        f"Node {edge_destination} and {edge_destination}-0 not found"
                    )
                edge_destination = f"{edge_destination}-0"
            if edge_source not in edge_dict:
                edge_dict[edge_source] = set()
            edge_dict[edge_source].add(
                (
                    edge_destination,
                    branch,
                )
            )
        cfg["edges"] = edge_dict
        
        # check one entry node and whether there is multiple exit nodes
        # first, check special case of single node
        if len(edge_dict) == 0:
            unique_node = list(
                {
                    node
                    for node in cfg["nodes"]
                    if not cfg["nodes"][node]["nopred"]
                }
            )[0]
            cfg["entry"] = unique_node
            cfg["exit"] = {unique_node}
        else:
            rev_edge_map = {}
            for source, destination_tups in edge_dict.items():
                for destination_tup in destination_tups:
                    destination = destination_tup[0]
                    if destination not in rev_edge_map:
                        rev_edge_map[destination] = {source}
                    else:
                        rev_edge_map[destination].add(source)
            entry_nodes = {
                node
                for node in edge_dict
                if node not in rev_edge_map
                and cfg["nodes"][node]["nopred"] == False
            }
            if len(entry_nodes) != 1:
                print(f"Nodes: {cfg['nodes']}")
                print(f"Edge dict: {edge_dict}")
                print(f"Reverse edge map: {rev_edge_map}")
                raise Exception(
                    f"Multiple entry nodes in {dotfile}: {entry_nodes}"
                )
            cfg["entry"] = entry_nodes.pop()
            exit_nodes = {
                node for node in rev_edge_map if node not in edge_dict
            }
            cfg["exit"] = exit_nodes
        cfgs_intra[function_name] = cfg
    return cfgs_intra, node_to_bb


def gen_cfg_inter(cfgs_intra: Dict) -> Dict:
    # sourcery skip: raise-specific-error
    # check there's no overlap between node names
    node_names = set()
    for cfg in cfgs_intra.values():
        for node_name in cfg["nodes"].keys():
            if node_name not in node_names:
                node_names.add(node_name)
            else:
                raise Exception("Overlap in node names!")

    cfg_inter = {"nodes": {}}
    for func, cfg in cfgs_intra.items():
        entry = cfg["entry"]
        exits = cfg["exit"]
        for node_name, node in cfg["nodes"].items():
            assert node_name not in cfg_inter["nodes"]
            cfg_inter["nodes"][node_name] = node
            cfg_inter["nodes"][node_name]["func"] = func
            if node_name == entry:
                cfg_inter["nodes"][node_name]["entry"] = True
            if node_name in exits:
                cfg_inter["nodes"][node_name]["exit"] = True
            # TODO: Check if this node is a loop head
    cfg_inter["edges"] = {"intra": {}, "inter": {}}
    for func, cfg in cfgs_intra.items():
        for source, destinations in cfg["edges"].items():
            assert source not in cfg_inter["edges"]["intra"]
            cfg_inter["edges"]["intra"][source] = set(destinations)

    # add inter-procedural edges: add formal-in, out, actual-in, out nodes
    # (actual-in -> formal-in -> ... -> formal-out -> actual-out)
    ## 1. add formal-in, out
    cfg_inter["edges"]["inter"] = {}
    for func, cfg in cfgs_intra.items():
        if func == "main":
            continue
        fin_node_name = f"{func}-formal_in"
        fin_attr = {
            "linenums": None,
            "call": None,
            "branch": None,
            "func": func,
        }
        cfg_inter["nodes"][fin_node_name] = fin_attr
        fout_node_name = f"{func}-formal_out"
        fout_attr = {
            "linenums": None,
            "call": None,
            "branch": None,
            "func": func,
        }
        cfg_inter["nodes"][fout_node_name] = fout_attr

        entry_node = cfg["entry"]
        cfg_inter["edges"]["inter"][fin_node_name] = {(entry_node, None)}
        exit_nodes = cfg["exit"]
        for exit_node in exit_nodes:
            if not cfg["nodes"][exit_node]["program_exit"]:
                cfg_inter["edges"]["inter"][exit_node] = {
                    (fout_node_name, None)
                }

    new_nodes = {}

    ## 2. add actual-in, out
    ### split calling node into node before call and node after call
    for node_name, node_attr in cfg_inter["nodes"].items():
        if "call" not in node_attr:
            print(f"{node_name} does not call key")
            print(node_attr)
            raise Exception("No call key")
        if node_attr["call"]:
            prev_call_node_name = node_name
            after_call_node_name = f"{node_name}-X"
            ### add node after call
            after_call_node_attr = {
                "linenums": None,
                "call": None,
                "branch": node_attr["branch"],
                "func": node_attr["func"],
            }
            prev_call_node_attr = node_attr
            prev_call_node_attr["branch"] = None
            new_nodes[after_call_node_name] = after_call_node_attr
            ### move outgoing edges from prev_call_node to after_call_node
            if prev_call_node_name in cfg_inter["edges"]["intra"]:
                outgoing = copy.deepcopy(
                    cfg_inter["edges"]["intra"][prev_call_node_name]
                )
                cfg_inter["edges"]["intra"][after_call_node_name] = outgoing
                cfg_inter["edges"]["intra"][prev_call_node_name] = set()
            ### add actual-in, out nodes
            ain_node_name = f"{node_name}-actual_in"
            ain_attr = {
                "linenums": None,
                "call": None,
                "branch": None,
                "func": node_attr["func"],
            }
            new_nodes[ain_node_name] = ain_attr
            aout_node_name = f"{node_name}-actual_out"
            aout_attr = {
                "linenums": None,
                "call": None,
                "branch": None,
                "func": node_attr["func"],
            }
            new_nodes[aout_node_name] = aout_attr
            ### add edge actual-in to formal-in, formal-out to actual-out
            if not f"{node_attr['call']}-formal_in" in cfg_inter["nodes"]:
                print("Error")
                print(f"{node_attr['call']}-formal_in")
                print(list(cfg_inter["nodes"].keys()))
                raise Exception("formal_in not in cfg_inter")
            assert f"{node_attr['call']}-formal_out" in cfg_inter["nodes"]
            cfg_inter["edges"]["inter"][ain_node_name] = {
                (f"{node_attr['call']}-formal_in", None)
            }
            if (
                f"{node_attr['call']}-formal_out"
                not in cfg_inter["edges"]["inter"]
            ):
                cfg_inter["edges"]["inter"][
                    f"{node_attr['call']}-formal_out"
                ] = set()
            cfg_inter["edges"]["inter"][f"{node_attr['call']}-formal_out"].add(
                (aout_node_name, None)
            )
            ### add edge prev_call_node to actual-in, actual-out to after_call_node
            cfg_inter["edges"]["inter"][prev_call_node_name] = {
                (ain_node_name, None)
            }
            cfg_inter["edges"]["inter"][aout_node_name] = {
                (after_call_node_name, None)
            }

    for node_name, node_attr in new_nodes.items():
        cfg_inter["nodes"][node_name] = node_attr

    return cfg_inter


class SetEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, set):
            return sorted(obj)
        return json.JSONEncoder.default(self, obj)


def save_cfg_inter(cfg_inter: Dict, output_file: str):
    with open(output_file, "w") as f:
        json.dump(cfg_inter, f, indent=4, cls=SetEncoder)


def convert_to_dot(cfg_inter: Dict, hightlight: Dict = None) -> Digraph:
    # sourcery skip: raise-specific-error
    nodes_label_format = (
        lambda node_name, lines, entry, exit: f"[{node_name}]\\n\\{{{','.join([str(l) for l in sorted(lines)])}\\}}"
    )
    branch_node_label_format = (
        lambda node_name, lines, branch_templete: f"{{[{node_name}]\\l\\{{{','.join([str(l) for l in sorted(lines)])}\\}}{branch_templete}"
    )
    call_node_label_format = (
        lambda node_name, lines: f"{{[{node_name}]\\l\\{{{','.join([str(l) for l in sorted(lines)])}\\}}\\l|{{<call>call|<ret>ret}}}}"
    )
    call_and_branch_node_label_format = (
        lambda node_name, lines: f"{{[{node_name}]\\l\\{{{','.join([str(l) for l in sorted(lines)])}\\}}\\l|{{<call>call|{{<ret>ret|{{<T>T|<F>F}}}}}}}}"
    )

    graph = Digraph()
    functions = {node_attr["func"] for node_attr in cfg_inter["nodes"].values()}

    # add nodes
    for function in functions:
        nodes_in_func = {
            node
            for node, node_attr in cfg_inter["nodes"].items()
            if node_attr["func"] == function
        }
        nodes_of_return = {
            node for node in nodes_in_func if node.endswith("-X")
        }
        nodes_of_call = {node[:-2] for node in nodes_of_return}
        with graph.subgraph(name=f"cluster_{function}") as c:
            c.attr(label=function)
            for node in nodes_in_func:
                if "actual_in" in node:
                    node_name = "actual_in"
                elif "actual_out" in node:
                    node_name = "actual_out"
                elif "formal_in" in node:
                    node_name = "formal_in"
                elif "formal_out" in node:
                    node_name = "formal_out"
                else:
                    node_name = f"{node[4:]}{',entry' if 'entry' in cfg_inter['nodes'][node] else ''}{',exit' if 'exit' in cfg_inter['nodes'][node] else ''}"

                if node_name in [
                    "actual_in",
                    "actual_out",
                    "formal_in",
                    "formal_out",
                ]:
                    c.node(node, shape="plain", label=node_name)
                    continue

                if "entry" in cfg_inter["nodes"][node]:
                    color = "lightskyblue"
                elif "exit" in cfg_inter["nodes"][node]:
                    color = "springgreen"
                else:
                    color = None
                if node in nodes_of_return:
                    continue
                if node in nodes_of_call:
                    node_of_return = f"{node}-X"
                    if cfg_inter["nodes"][node_of_return]["branch"]:
                        c.node(
                            node,
                            label=call_and_branch_node_label_format(
                                node_name,
                                cfg_inter["nodes"][node]["linenums"] or [],
                            ),
                            shape="record",
                            style="filled",
                            fillcolor=color if color else "lightgrey",
                        )
                    else:
                        c.node(
                            node,
                            label=call_node_label_format(
                                node_name,
                                cfg_inter["nodes"][node]["linenums"] or [],
                            ),
                            shape="record",
                            style="filled",
                            fillcolor=color if color else "lightgrey",
                        )
                elif cfg_inter["nodes"][node]["branch"]:
                    if cfg_inter["nodes"][node]["branch_templete"] is not None:
                        _label = branch_node_label_format(
                            node_name,
                            cfg_inter["nodes"][node]["linenums"] or [],
                            cfg_inter["nodes"][node]["branch_templete"]
                            or "\\l|{<T>T|<F>F}}",
                        )
                    c.node(
                        node,
                        label=branch_node_label_format(
                            node_name,
                            cfg_inter["nodes"][node]["linenums"] or [],
                            cfg_inter["nodes"][node]["branch_templete"]
                            or "\\l|{<T>T|<F>F}}",
                        ),
                        shape="record",
                        style="filled",
                        fillcolor=color if color else "white",
                    )
                else:
                    c.node(
                        node,
                        label=nodes_label_format(
                            node_name,
                            cfg_inter["nodes"][node]["linenums"] or [],
                            "entry" in cfg_inter["nodes"][node],
                            "exit" in cfg_inter["nodes"][node],
                        ),
                        shape="record",
                        style="filled",
                        fillcolor=color if color else "white",
                    )

    # add edges
    nodes_of_return = {
        node for node, _ in cfg_inter["nodes"].items() if node.endswith("-X")
    }
    nodes_of_call = {node[:-2] for node in nodes_of_return}
    for source, destinations in cfg_inter["edges"]["intra"].items():
        if source in nodes_of_call and len(destinations):
            raise Exception(f"{source} is a call node")
        for (destination, edge_type) in destinations:
            assert destination not in nodes_of_return
            if source in nodes_of_return:
                call_node = source[:-2]
                if edge_type is None:
                    source_fixed = f"{call_node}:ret"
                else:
                    assert type(edge_type) is bool
                    if edge_type:
                        source_fixed = f"{call_node}:T"
                    else:
                        source_fixed = f"{call_node}:F"
            elif edge_type is None:
                source_fixed = source
            else:
                if type(edge_type) is bool:
                    if edge_type:
                        source_fixed = f"{source}:T"
                    else:
                        source_fixed = f"{source}:F"
                else:
                    assert type(edge_type) is str
                    source_fixed = f"{source}:{edge_type}"
            graph.edge(source_fixed, destination)

    for source, destinations in cfg_inter["edges"]["inter"].items():
        for (destination, edge_type) in destinations:
            assert (
                "actual_in" in source
                or "actual_out" in source
                or "formal_in" in source
                or "formal_out" in source
                or "actual_in" in destination
                or "actual_out" in destination
                or "formal_in" in destination
                or "formal_out" in destination
            )
            if "actual_in" in source and "formal_in" in destination:
                graph.edge(source, destination, color="red", style="dashed")
            elif "formal_out" in source and "actual_out" in destination:
                graph.edge(source, destination, color="red", style="dashed")
            elif "actual_in" in destination:
                source_fixed = f"{source}:call"
                graph.edge(
                    source_fixed, destination, color="orange", style="dashed"
                )
            elif "actual_out" in source:
                destination_fixed = f"{destination[:-2]}:ret"
                graph.edge(
                    source, destination_fixed, color="orange", style="dashed"
                )
            else:
                if source in nodes_of_return:
                    call_node = source[:-2]
                    if edge_type is None:
                        source_fixed = f"{call_node}:ret"
                    else:
                        assert type(edge_type) is bool
                        if edge_type:
                            source_fixed = f"{call_node}:T"
                        else:
                            source_fixed = f"{call_node}:F"
                elif edge_type is None:
                    source_fixed = source
                else:
                    if type(edge_type) is bool:
                        if edge_type:
                            source_fixed = f"{source}:T"
                        else:
                            source_fixed = f"{source}:F"
                    else:
                        assert type(edge_type) is str
                        source_fixed = f"{source}:{edge_type}"
                graph.edge(
                    source_fixed, destination, color="orange", style="dashed"
                )

    if hightlight is not None:
        if "nodes" in hightlight:
            for color, nodes in hightlight["nodes"].items():
                nodes_update = {
                    node[:-2] if node.endswith("-X") else node for node in nodes
                }
                for node in nodes_update:
                    graph.node(node, penwidth="3", color=color)
        if "edges" in hightlight:
            for edge in hightlight["edges"]:
                graph.edge(edge[0], edge[1], color="magenta", penwidth="3")

    return graph


if __name__ == "__main__":
    file = sys.argv[1]
    path, filename = os.path.split(file)
    filename = filename.split(".")[0]
    print(f"path: {path}")
    print(f"filename: {filename}")

    dotfiles = generate_data(path, filename)
    debug_info_dict, blocks_dict = parse_ll(
        os.path.join(path, f"{filename}.ll")
    )
    cfgs_intra = parse_dotfiles(dotfiles, path, debug_info_dict, blocks_dict)
    cfg_inter = gen_cfg_inter(cfgs_intra)
    save_cfg_inter(cfg_inter, os.path.join(path, f"{filename}.cfg.json"))
    graph = convert_to_dot(cfg_inter)
    graph.render(os.path.join(path, f"{filename}.gv"))
