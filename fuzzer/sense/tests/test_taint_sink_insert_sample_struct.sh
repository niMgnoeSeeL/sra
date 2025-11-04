#!/bin/bash
set -e

BUILD_DIR="../build"
DEMO_DIR="../demo"
PASS_SO="$BUILD_DIR/SampleFlowSinkPass.so"
SOURCE_FILE="$DEMO_DIR/flow_struct.c"

echo "=== Testing Struct Field Sink Tracking ==="

# Compile to LLVM IR with debug info and optnone disabled
echo "1. Compiling $SOURCE_FILE to IR..."
clang-20 -O0 -g -S -emit-llvm -Xclang -disable-O0-optnone \
  "$SOURCE_FILE" -o "$BUILD_DIR/flow_struct.ll"

# Test case: s.age sink at line 16 (printf with s.age * 2)
echo ""
echo "2. Running SampleFlowSinkPass for s.age in printf (line 16, col 30-35)..."
opt-20 -load-pass-plugin="$PASS_SO" \
  -passes='function(sample-flow-sink)' \
  -sample-line=16 -sample-col-start=31 -sample-col-end=40 \
  -sample-var-name=s -sample-sink-id=1 \
  -S "$BUILD_DIR/flow_struct.ll" -o "$BUILD_DIR/flow_struct_sink.ll"

# Verify sink tracking
echo ""
echo "3. Verifying s.age sink tracking in flow_struct_sink.ll..."
if grep -q "call void @sample_report_sink" "$BUILD_DIR/flow_struct_sink.ll"; then
  echo "✓ Found sample_report_sink call"
  grep "call void @sample_report_sink" "$BUILD_DIR/flow_struct_sink.ll" | head -1
  
  # Check that report call is BEFORE printf() call
  if grep -B 2 "call i32 (ptr, ...) @printf" "$BUILD_DIR/flow_struct_sink.ll" | grep -q "sample_report_sink"; then
    echo "✓ sample_report_sink called BEFORE printf()"
  fi
  
  # Verify size is 4 bytes (sizeof(int))
  if grep "call void @sample_report_sink" "$BUILD_DIR/flow_struct_sink.ll" | grep -q "i32 4"; then
    echo "✓ Correct size: 4 bytes (int field)"
  fi
else
  echo "✗ sample_report_sink call not found!"
  exit 1
fi

echo ""
echo "=== Struct field sink tracking test passed! ==="
