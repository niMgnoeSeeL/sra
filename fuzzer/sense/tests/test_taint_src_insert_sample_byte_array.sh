#!/bin/bash
set -e

BUILD_DIR="/workspaces/fuzzer/sense/build"
DEMO_DIR="/workspaces/fuzzer/sense/demo"

echo "=== Testing SampleFlowSrcPass ==="
echo

# Step 1: Compile test program to IR (without optnone)
echo "[1] Compiling flow_simple.c to LLVM IR..."
cd "$DEMO_DIR"
clang-20 -O0 -g -S -emit-llvm -Xclang -disable-O0-optnone flow_simple.c -o flow_simple.ll
echo "✓ Generated flow_simple.ll"
echo

# Step 2: Run the pass
echo "[2] Running SampleFlowSrcPass..."
cd "$BUILD_DIR"
opt-20 -load-pass-plugin=./SampleFlowSrcPass.so \
    -passes='function(sample-flow-src)' \
    -sample-line=7 \
    -sample-col-start=9 \
    -sample-col-end=12 \
    "$DEMO_DIR/flow_simple.ll" \
    -S -o flow_simple_sampled.ll
echo "✓ Generated flow_simple_sampled.ll"
echo

# Step 3: Verify instrumentation
echo "[3] Verifying instrumentation..."
if grep -q "call void @sample_bytes" flow_simple_sampled.ll; then
    echo "✓ Found sample_bytes call in instrumented IR"
    echo
    echo "Context around sample_bytes call:"
    grep -B3 -A3 "call void @sample_bytes" flow_simple_sampled.ll
    echo
else
    echo "✗ ERROR: sample_bytes call not found!"
    exit 1
fi

# Step 4: Verify insertion point, aka, where is @sample_bytes called?
# The line before the call must be: %{R} = call ptr @fgets(ptr noundef...
# The line after the call must be: #dbg_declare
echo "[4] Verifying insertion point..."
# The line before the call must be: %{R} = call ptr @fgets(ptr noundef...
if grep -B1 "call void @sample_bytes" flow_simple_sampled.ll | grep -q "%[0-9]\+ = call ptr @fgets(ptr noundef"; then
    echo "✓ Insertion point before sample_bytes call is correct"
    echo "Previous line:"
    grep -B1 "call void @sample_bytes" flow_simple_sampled.ll | head -n1
else
    echo "✗ ERROR: Insertion point before sample_bytes call is incorrect"
    exit 1
fi

# The line after the call must be: #dbg_declare
if grep -A1 "call void @sample_bytes" flow_simple_sampled.ll | grep -q "#dbg_declare"; then
    echo "✓ Insertion point after sample_bytes call is correct"
    echo "Next line:"
    grep -A1 "call void @sample_bytes" flow_simple_sampled.ll | tail -n1
else
    echo "✗ ERROR: Insertion point after sample_bytes call is incorrect"
    exit 1
fi

echo

# Step 5: Check declaration
if grep -q "declare void @sample_bytes" flow_simple_sampled.ll; then
    echo "✓ Found sample_bytes declaration"
else
    echo "✗ ERROR: sample_bytes declaration not found!"
    exit 1
fi

echo
echo "=== All tests passed! ==="
