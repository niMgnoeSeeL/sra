#!/bin/bash
set -e

BUILD_DIR="/workspaces/fuzzer/sense/build"
DEMO_DIR="/workspaces/fuzzer/sense/demo"

echo "=== Testing SampleFlowSrcPass (Struct Field) ==="
echo

# Step 1: Compile test program to IR
echo "[1] Compiling flow_struct.c to LLVM IR..."
cd "$DEMO_DIR"
clang-20 -O0 -g -S -emit-llvm -Xclang -disable-O0-optnone flow_struct.c -o flow_struct.ll
echo "✓ Generated flow_struct.ll"
echo

# Step 2: Run the pass
echo "[2] Running SampleFlowSrcPass..."
cd "$BUILD_DIR"
opt-20 -load-pass-plugin=./SampleFlowSrcPass.so \
  -passes='function(sample-flow-src)' \
  --src-line=14 --src-col-start=22 --src-col-end=28 \
  --src-file="$DEMO_DIR/flow_struct.c" \
  -S ../demo/flow_struct.ll -o flow_struct_sampled.ll
echo "✓ Generated flow_struct_sampled.ll"
echo

# Step 3: Verify instrumentation
echo "[3] Verifying instrumentation..."
if grep -q "call.*@sample_int" flow_struct_sampled.ll; then
  echo "✓ Found sample_int call in instrumented IR"
else
  echo "✗ ERROR: sample_int call not found!"
  exit 1
fi

# Show context around the sample call
echo
echo "Context around sample_int call:"
grep -B3 -A3 "call.*sample_int" flow_struct_sampled.ll | head -15
echo

# Step 4: Verify declaration
if grep -q "declare.*sample_int" flow_struct_sampled.ll; then
  echo "✓ Found sample_int declaration"
else
  echo "✗ ERROR: sample_int declaration not found!"
  exit 1
fi

echo
echo "=== All tests passed! ==="
