#!/usr/bin/env python3
"""
Generate cfg_inter.json from an instrumented LLVM IR file.
This is required for the SRA reachability estimator.
"""

import sys
import os
import argparse
import subprocess

# Add sense directory to path for SRA imports
sys.path.insert(0, "/workspaces/fuzzer/sense")

from sra.cfggen import parse_ll, parse_dotfiles, gen_cfg_inter, save_cfg_inter


def dump_cfg_from_ll(ll_file, opt_path="/usr/bin/opt-20"):
    """
    Generate .dot files from an existing .ll file using opt.

    Args:
        ll_file: Full path to the .ll file
        opt_path: Path to opt binary

    Returns:
        Subprocess output
    """
    # Determine LLVM version for correct CLI flags
    try:
        version_output = subprocess.check_output([opt_path, "--version"], text=True)
        major = int(version_output.split("version")[1].split(".")[0].strip())
    except Exception:
        major = 0

    legacy = major and major < 18
    pass_flag = "-dot-cfg" if legacy else "-passes=dot-cfg"
    pm_flag = "-enable-new-pm=0" if legacy else ""

    # Run opt to generate .dot files
    cmd = f"{opt_path} {pass_flag} {ll_file} -disable-output {pm_flag}"
    print(f"[CFG Generator] Running: {cmd}")
    return subprocess.check_output(cmd, shell=True, stderr=subprocess.STDOUT)


def generate_cfg_inter(source_dir, source_name, opt_path="/usr/bin/opt-20"):
    """
    Generate cfg_inter.json from an existing instrumented LLVM IR file.

    Args:
        source_dir: Directory containing the .ll file
        source_name: Name without .ll extension
        opt_path: Path to opt binary
    """
    ll_file = os.path.join(source_dir, f"{source_name}.ll")
    output_file = os.path.join(source_dir, "cfg_inter.json")

    if not os.path.exists(ll_file):
        raise FileNotFoundError(f"LLVM IR file not found: {ll_file}")

    print(f"[CFG Generator] Processing {ll_file}")

    # Change to source directory for .dot file generation
    cur_dir = os.getcwd()
    os.chdir(source_dir)

    try:
        # Step 1: Generate .dot files from existing .ll file
        print(f"[CFG Generator] Step 1: Generating .dot files from instrumented IR...")

        # Remove old .dot files
        os.system("rm -f .*.dot")

        # Generate new .dot files
        dump_cfg_from_ll(f"{source_name}.ll", opt_path)

        # Step 2: Parse and build cfg_inter
        print(f"[CFG Generator] Step 2: Parsing LLVM IR and .dot files...")
        debug_info_dict, blocks_dict = parse_ll(ll_file)
        dotfiles = [f for f in os.listdir(source_dir) if f.startswith(".") and f.endswith(".dot")]
        print(f"[CFG Generator] Found {len(dotfiles)} .dot files")

        if not dotfiles:
            raise RuntimeError("No .dot files were generated. The .ll file may not contain debug info.")

        cfgs_intra, node_to_bb = parse_dotfiles(dotfiles, source_dir, debug_info_dict, blocks_dict, non_overlap_lineidx=False)
        cfg_inter = gen_cfg_inter(cfgs_intra)

        # Step 3: Save to JSON
        print(f"[CFG Generator] Step 3: Saving cfg_inter to {output_file}")
        save_cfg_inter(cfg_inter, output_file)

        print(f"[CFG Generator] ✅ Successfully generated {output_file}")
        print(f"[CFG Generator] CFG contains {len(cfg_inter.get('nodes', []))} nodes and {len(cfg_inter.get('edges', []))} edges")

        return output_file

    finally:
        # Restore original directory
        os.chdir(cur_dir)


def main():
    parser = argparse.ArgumentParser(
        description="Generate cfg_inter.json from instrumented LLVM IR file"
    )
    parser.add_argument(
        "--source-dir",
        required=True,
        help="Directory containing the instrumented .ll file"
    )
    parser.add_argument(
        "--source-name",
        required=True,
        help="Name without .ll extension (e.g., 'totinfo_fuzz.instrumented')"
    )
    parser.add_argument(
        "--opt-path",
        default="/usr/bin/opt-20",
        help="Path to opt binary (default: /usr/bin/opt-20)"
    )

    args = parser.parse_args()

    try:
        output_file = generate_cfg_inter(
            args.source_dir,
            args.source_name,
            args.opt_path
        )
        print(f"\n✅ Success! CFG saved to: {output_file}")
        return 0
    except Exception as e:
        print(f"\n❌ Error: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc()
        return 1


if __name__ == "__main__":
    sys.exit(main())
