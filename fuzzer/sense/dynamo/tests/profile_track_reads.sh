#!/bin/bash
# Build and profile DynamoRIO-based buffer tracking prototype

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DYNAMO_DIR="$SCRIPT_DIR/.."

echo "=== Building DynamoRIO Client and Target Programs ==="
cd "$DYNAMO_DIR"
rm -rf build
mkdir -p build
cd build

# Configure with DynamoRIO
cmake -DDynamoRIO_DIR=$DYNAMORIO_HOME/cmake ..
make -j$(nproc) >/dev/null

echo ""
echo "=== Profiling Persistent Target target_persist.c (10000 iterations) ==="

echo "Running with DynamoRIO (10 runs)..."
dynamo_total_time=$( (
for i in $(seq 1 10); do
    { time $DYNAMORIO_HOME/bin64/drrun -c "$DYNAMO_DIR/build/libtrack_reads.so" -- "$DYNAMO_DIR/build/target_persist" >/dev/null 2>&1; } 2>&1
done
) | grep real | awk '{print $2}' | sed 's/m/ /; s/s//' | awk '{ total += $1 * 60 + $2 } END { print total }')

dynamo_avg_time=$(echo "$dynamo_total_time / 10" | bc -l)
printf "  DynamoRIO average: %.3fs\n" $dynamo_avg_time

echo "Running natively (10 runs)..."
native_total_time=$( (
for i in $(seq 1 10); do
    { time "$DYNAMO_DIR/build/target_persist" >/dev/null 2>&1; } 2>&1
done
) | grep real | awk '{print $2}' | sed 's/m/ /; s/s//' | awk '{ total += $1 * 60 + $2 } END { print total }')

native_avg_time=$(echo "$native_total_time / 10" | bc -l)
printf "  Native average:    %.3fs\n" $native_avg_time

slowdown=$(echo "$dynamo_avg_time / $native_avg_time" | bc -l)
printf "  Slowdown:          %.2fx\n" $slowdown

echo ""

echo "=== Profiling Normal Target target.c ==="
echo "=== Creating Test Input ==="
# Create a test input file with 100 bytes
python3 -c "import sys; sys.stdout.buffer.write(b'A' * 100)" > /tmp/test_input.bin

echo "Running with DynamoRIO (10 runs)..."
dynamo_total_time=$( (
for i in $(seq 1 10); do
    { time $DYNAMORIO_HOME/bin64/drrun -c "$DYNAMO_DIR/build/libtrack_reads.so" -- "$DYNAMO_DIR/build/target" < /tmp/test_input.bin; } 2>&1
done
) | grep real | awk '{print $2}' | sed 's/m/ /; s/s//' | awk '{ total += $1 * 60 + $2 } END { print total }')


dynamo_avg_time=$(echo "$dynamo_total_time / 10" | bc -l)
printf "  DynamoRIO average: %.3fs\n" $dynamo_avg_time

echo "Running natively (10 runs)..."
native_total_time=$( (
for i in $(seq 1 10); do
    { time "$DYNAMO_DIR/build/target" < /tmp/test_input.bin; } 2>&1
done
) | grep real | awk '{print $2}' | sed 's/m/ /; s/s//' | awk '{ total += $1 * 60 + $2 } END { print total }')

native_avg_time=$(echo "$native_total_time / 10" | bc -l)
printf "  Native average:    %.3fs\n" $native_avg_time

slowdown=$(echo "$dynamo_avg_time / $native_avg_time" | bc -l)
printf "  Slowdown:          %.2fx\n" $slowdown

echo ""

echo "Profiling finished."