#!/bin/bash
set -e

BUILD_DIR="../build"
DEMO_DIR="../demo"
PASS_SO="$BUILD_DIR/SampleFlowSinkPass.so"
SOURCE_FILE="$DEMO_DIR/flow_simple.c"

echo "=== Testing Byte Array Sink Tracking ==="

# Compile to LLVM IR with debug info and optnone disabled
echo "1. Compiling $SOURCE_FILE to IR..."
clang-20 -O0 -g -S -emit-llvm -Xclang -disable-O0-optnone \
  "$SOURCE_FILE" -o "$BUILD_DIR/flow_simple.ll"

# Test case: buf sink at line 9 (log(x)) and line 10 (printf)
# For this test, let's focus on the printf sink which uses buf directly
echo ""
echo "2. Running SampleFlowSinkPass for buf in printf (line 10, col 17-20)..."
opt-20 -load-pass-plugin="$PASS_SO" \
  -passes='function(sample-flow-sink)' \
  --sink-line=10 --sink-col-start=16 --sink-col-end=19 \
  --sink-var-name=buf --sink-id=2 \
  --sink-file="$SOURCE_FILE" \
  -S "$BUILD_DIR/flow_simple.ll" -o "$BUILD_DIR/flow_simple_buf_sink.ll"

# Verify sink tracking
echo ""
echo "3. Verifying buf sink tracking in flow_simple_buf_sink.ll..."
if grep -q "call void @sample_report_sink" "$BUILD_DIR/flow_simple_buf_sink.ll"; then
  echo "✓ Found sample_report_sink call"
  grep "call void @sample_report_sink" "$BUILD_DIR/flow_simple_buf_sink.ll" | head -1
  
  # Check that report call is BEFORE printf() call
  if grep -B 2 "call i32 (ptr, ...) @printf" "$BUILD_DIR/flow_simple_buf_sink.ll" | grep -q "sample_report_sink"; then
    echo "✓ sample_report_sink called BEFORE printf()"
  fi
  
  # Verify size is 16 bytes (array size)
  if grep "call void @sample_report_sink" "$BUILD_DIR/flow_simple_buf_sink.ll" | grep -q "i32 16"; then
    echo "✓ Correct size: 16 bytes"
  fi
else
  echo "✗ sample_report_sink call not found!"
  exit 1
fi

echo ""
echo "=== Byte array sink tracking test passed! ==="
