#!/bin/bash
set -e

BUILD_DIR="/workspaces/fuzzer/sense/build"
DEMO_DIR="/workspaces/fuzzer/sense/demo"

echo "=== Testing SampleFlowSrcPass (Multi-Dimensional Array) ==="
echo

# Step 1: Compile test program to IR
echo "[1] Compiling flow_mdarray.c to LLVM IR..."
cd "$DEMO_DIR"
clang-20 -O0 -g -S -emit-llvm -Xclang -disable-O0-optnone flow_mdarray.c -o flow_mdarray.ll
echo "✓ Generated flow_mdarray.ll"
echo

# Step 2: Run the pass (using line:col mode for array element access)
echo "[2] Running SampleFlowSrcPass..."
cd "$BUILD_DIR"

# Find the column range for matrix[1] - need to check the IR
MATRIX_COL_START=22
MATRIX_COL_END=31

opt-20 -load-pass-plugin=./SampleFlowSrcPass.so \
  -passes='function(sample-flow-src)' \
  --src-line=8 --src-col-start=$MATRIX_COL_START --src-col-end=$MATRIX_COL_END \
  --src-file="$DEMO_DIR/flow_mdarray.c" \
  -S ../demo/flow_mdarray.ll -o flow_mdarray_sampled.ll
echo "✓ Generated flow_mdarray_sampled.ll"
echo

# Step 3: Verify instrumentation
echo "[3] Verifying instrumentation..."
if grep -q "sample_bytes" flow_mdarray_sampled.ll; then
  echo "✓ Found sample_bytes call in instrumented IR"
else
  echo "✗ ERROR: sample_bytes call not found!"
  exit 1
fi

# Show context around the sample call
echo
echo "Context around sample_bytes call:"
grep -B3 -A3 "call.*sample_bytes" flow_mdarray_sampled.ll | head -15
echo

# Step 4: Verify it's sampling the correct size (16 bytes for one row, not 64 bytes for entire matrix)
if grep -q "sample_bytes.*i32 16" flow_mdarray_sampled.ll; then
  echo "✓ Correctly sampling 16 bytes (one row)"
else
  echo "✗ ERROR: Expected sample_bytes with i32 16!"
  grep "sample_bytes" flow_mdarray_sampled.ll
  exit 1
fi

# Step 5: Verify NOT sampling 64 bytes (entire matrix)
if grep -q "sample_bytes.*i32 64" flow_mdarray_sampled.ll; then
  echo "✗ ERROR: Sampling 64 bytes (entire matrix) instead of 16 bytes (one row)!"
  exit 1
else
  echo "✓ Not sampling entire matrix (would be 64 bytes)"
fi

echo
echo "=== All tests passed! ==="
