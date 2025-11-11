#!/bin/bash
set -e

BUILD_DIR="../build"
DEMO_DIR="../demo"
PASS_SO="$BUILD_DIR/SampleFlowSinkPass.so"
SOURCE_FILE="$DEMO_DIR/flow_scalars.c"

echo "=== Testing Scalar Type Sink Tracking (int and double) ==="

# Compile to LLVM IR with debug info and optnone disabled
echo "1. Compiling $SOURCE_FILE to IR..."
clang-20 -O0 -g -S -emit-llvm -Xclang -disable-O0-optnone \
  "$SOURCE_FILE" -o "$BUILD_DIR/flow_scalars.ll"

# Test case 1: int variable sink (line 9, log(x))
echo ""
echo "2. Running SampleFlowSinkPass for int variable 'x' (line 9, col 7-8)..."
opt-20 -load-pass-plugin="$PASS_SO" \
  -passes='function(sample-flow-sink)' \
  --sink-line=9 --sink-col-start=7 --sink-col-end=8 \
  --sink-var-name=x --sink-id=1 \
  --sink-file="$SOURCE_FILE" \
  -S "$BUILD_DIR/flow_scalars.ll" -o "$BUILD_DIR/flow_scalars_x_sink.ll"

# Test case 2: double variable sink (line 15, log(y))
echo ""
echo "3. Running SampleFlowSinkPass for double variable 'y' (line 15, col 7-8)..."
opt-20 -load-pass-plugin="$PASS_SO" \
  -passes='function(sample-flow-sink)' \
  --sink-line=15 --sink-col-start=7 --sink-col-end=8 \
  --sink-var-name=y --sink-id=2 \
  --sink-file="$SOURCE_FILE" \
  -S "$BUILD_DIR/flow_scalars.ll" -o "$BUILD_DIR/flow_scalars_y_sink.ll"

# Verify int sink tracking
echo ""
echo "4. Verifying int sink tracking in flow_scalars_x_sink.ll..."
if grep -q "call void @sample_report_sink" "$BUILD_DIR/flow_scalars_x_sink.ll"; then
  echo "✓ Found sample_report_sink call"
  grep "call void @sample_report_sink" "$BUILD_DIR/flow_scalars_x_sink.ll" | head -1
  
  # Check that report call is BEFORE log() call
  if grep -B 2 "call i32 @log" "$BUILD_DIR/flow_scalars_x_sink.ll" | grep -q "sample_report_sink"; then
    echo "✓ sample_report_sink called BEFORE log()"
  fi
else
  echo "✗ sample_report_sink call not found!"
  exit 1
fi

# Verify double sink tracking
echo ""
echo "5. Verifying double sink tracking in flow_scalars_y_sink.ll..."
if grep -q "call void @sample_report_sink" "$BUILD_DIR/flow_scalars_y_sink.ll"; then
  echo "✓ Found sample_report_sink call"
  grep "call void @sample_report_sink" "$BUILD_DIR/flow_scalars_y_sink.ll" | head -1
  
  # Check that report call is BEFORE log() call
  if grep -B 2 "call double @log" "$BUILD_DIR/flow_scalars_y_sink.ll" | grep -q "sample_report_sink"; then
    echo "✓ sample_report_sink called BEFORE log()"
  fi
else
  echo "✗ sample_report_sink call not found!"
  exit 1
fi

echo ""
echo "=== All scalar sink tracking tests passed! ==="
