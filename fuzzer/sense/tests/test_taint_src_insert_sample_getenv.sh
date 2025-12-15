#!/bin/bash
set -e

BUILD_DIR="/workspaces/fuzzer/sense/build"
DEMO_DIR="/workspaces/fuzzer/sense/demo"

echo "=== Testing SampleFlowSrcPass ==="
echo

# Step 1: Compile test program to IR (without optnone)
echo "[1] Compiling flow_getenv.c to LLVM IR..."
cd "$DEMO_DIR"
clang-20 -O0 -g -S -emit-llvm -Xclang -disable-O0-optnone flow_getenv.c -o flow_getenv.ll
echo "✓ Generated flow_getenv.ll"
echo

# Step 2: Run the pass
echo "[2] Running SampleFlowSrcPass..."
cd "$BUILD_DIR"
opt-20 -load-pass-plugin=./SampleFlowSrcPass.so \
    -passes='function(sample-flow-src)' \
    --src-line=6 \
    --src-col-start=10 \
    --src-col-end=16 \
    --src-var-name="getenv" \
    --src-file="$DEMO_DIR/flow_getenv.c" \
    "$DEMO_DIR/flow_getenv.ll" \
    -S -o flow_getenv_sampled.ll
echo "✓ Generated flow_getenv_sampled.ll"
echo

# Step 3: Verify instrumentation
echo "[3] Verifying instrumentation..."
if grep -q "call void @sample_bytes" flow_getenv_sampled.ll; then
    echo "✓ Found sample_bytes call in instrumented IR"
    echo
    echo "Context around sample_bytes call:"
    grep -B3 -A3 "call void @sample_bytes" flow_getenv_sampled.ll
    echo
else
    echo "✗ ERROR: sample_bytes call not found!"
    exit 1
fi

# Step 4: Verify insertion point, aka, where is @sample_bytes called?
# The line before the call must be: %{R} = call ptr @getenv(ptr noundef...
# The line after the call must be: ret ptr %{R}
echo "[4] Verifying insertion point..."

if grep -B1 "call void @sample_bytes" flow_getenv_sampled.ll | grep -q "%[0-9]\+ = call ptr @getenv(ptr noundef"; then
    echo "✓ Insertion point before sample_bytes call is correct"
    echo "Previous line:"
    grep -B1 "call void @sample_bytes" flow_getenv_sampled.ll | head -n1
else
    echo "✗ ERROR: Insertion point before sample_bytes call is incorrect"
    exit 1
fi

# The line after the call must be: ret ptr %{R}
if grep -A1 "call void @sample_bytes" flow_getenv_sampled.ll | grep -q "ret ptr"; then
    echo "✓ Insertion point after sample_bytes call is correct"
    echo "Next line:"
    grep -A1 "call void @sample_bytes" flow_getenv_sampled.ll | tail -n1
else
    echo "✗ ERROR: Insertion point after sample_bytes call is incorrect"
    exit 1
fi

echo

# Step 5: Check declaration
echo "[5] Verifying sample_bytes declaration..."
if grep -q "declare void @sample_bytes" flow_getenv_sampled.ll; then
    echo "✓ Found sample_bytes declaration"
else
    echo "✗ ERROR: sample_bytes declaration not found!"
    exit 1
fi

echo
echo "=== All tests passed! ==="
