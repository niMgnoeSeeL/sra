#!/bin/bash
set -e

BUILD_DIR="../build"
DEMO_DIR="../demo"
PASS_SO="$BUILD_DIR/SampleFlowSrcPass.so"
SOURCE_FILE="$DEMO_DIR/flow_scalars.c"

echo "=== Testing Scalar Type Sampling (int and double) ==="

# Compile to LLVM IR with debug info and optnone disabled
echo "1. Compiling $SOURCE_FILE to IR..."
clang-20 -O0 -g -S -emit-llvm -Xclang -disable-O0-optnone \
  "$SOURCE_FILE" -o "$BUILD_DIR/flow_scalars.ll"

# Test case 1: int variable (line 8)
echo ""
echo "2. Running SampleFlowSrcPass for int variable 'x' (line 8)..."
opt-20 -load-pass-plugin="$PASS_SO" \
  -passes='function(sample-flow-src)' \
  --src-var-name=x --src-line=8 \
  --src-file="$SOURCE_FILE" \
  -S "$BUILD_DIR/flow_scalars.ll" -o "$BUILD_DIR/flow_scalars_x.ll"

# Test case 2: double variable (line 14)
echo ""
echo "3. Running SampleFlowSrcPass for double variable 'y' (line 14)..."
opt-20 -load-pass-plugin="$PASS_SO" \
  -passes='function(sample-flow-src)' \
  --src-var-name=y --src-line=14 \
  --src-file="$SOURCE_FILE" \
  -S "$BUILD_DIR/flow_scalars.ll" -o "$BUILD_DIR/flow_scalars_y.ll"

# Verify int sampling
echo ""
echo "4. Verifying int sampling in flow_scalars_x.ll..."
if grep -q "call i32 @sample_int" "$BUILD_DIR/flow_scalars_x.ll"; then
  echo "✓ Found sample_int call"
  grep "call i32 @sample_int" "$BUILD_DIR/flow_scalars_x.ll" | head -1
  
  # Check for load-sample-store pattern
  if grep -A 2 "call i64 @read" "$BUILD_DIR/flow_scalars_x.ll" | grep -q "load i32"; then
    echo "✓ Found load instruction after read()"
  fi
  
  if grep -A 3 "call i64 @read" "$BUILD_DIR/flow_scalars_x.ll" | grep -q "store i32"; then
    echo "✓ Found store instruction to save sampled value"
  fi
else
  echo "✗ sample_int call not found!"
  exit 1
fi

# Verify double sampling
echo ""
echo "5. Verifying double sampling in flow_scalars_y.ll..."
if grep -q "call double @sample_double" "$BUILD_DIR/flow_scalars_y.ll"; then
  echo "✓ Found sample_double call"
  grep "call double @sample_double" "$BUILD_DIR/flow_scalars_y.ll" | head -1
  
  # Check for load-sample-store pattern
  if grep -A 2 "call i64 @read" "$BUILD_DIR/flow_scalars_y.ll" | grep -q "load double"; then
    echo "✓ Found load instruction after read()"
  fi
  
  if grep -A 3 "call i64 @read" "$BUILD_DIR/flow_scalars_y.ll" | grep -q "store double"; then
    echo "✓ Found store instruction to save sampled value"
  fi
else
  echo "✗ sample_double call not found!"
  exit 1
fi

echo ""
echo "=== All scalar type tests passed! ==="
