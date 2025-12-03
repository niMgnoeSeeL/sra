#!/bin/bash
# Build and test DynamoRIO-based buffer tracking prototype

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
make -j$(nproc)

echo "=== Creating Test Input ==="
# Create a test input file with 100 bytes
python3 -c "import sys; sys.stdout.buffer.write(b'A' * 100)" > /tmp/test_input.bin

echo ""
echo "=== Running Target Under DynamoRIO ==="
echo ""

# Run with DynamoRIO
$DYNAMORIO_HOME/bin64/drrun -c "$DYNAMO_DIR/build/libtrack_reads.so" -- "$DYNAMO_DIR/build/target" < /tmp/test_input.bin

echo ""
echo "=== Test Complete ==="
echo "Check the output above for:"
echo "  - 1. malloc tracking"
echo "      [DR] malloc(1024) = 0x..."
echo "      [DR] malloc(4096) = 0x..."
echo "  - 2. taint_sink entered"
echo "      [DR] taint_sink entered: buf=0x... len=100"
echo "  - 3. taint_sink left: bytes read count (should be exactly 50)"
echo "      [DR] taint_sink read 50 bytes in region [0x... .. 0x...) (alloc size=1024)"
echo "  - 4. first/last offsets (should show 0 and 98)"
echo "      [DR] first offset=0, last offset=98"
echo "  - 5. free tracking"
echo "      [DR] free(0x...)"
