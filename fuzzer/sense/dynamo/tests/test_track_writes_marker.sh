#!/bin/bash
# Build and test DynamoRIO-based buffer tracker

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

echo ""
echo "=== Running Target Under DynamoRIO ==="
echo ""

# Run with DynamoRIO
$DYNAMORIO_HOME/bin64/drrun -thread_private -c "$DYNAMO_DIR/build/libtrack_writes_marker.so" -- "$DYNAMO_DIR/build/target_marker_writes"

echo ""
echo "=== Test Complete ==="
echo "Check the output above for:"
echo "  - 1. Thread initialized"
echo "      [DR] Thread ....1 initialized"
echo "      [DR] Thread ....2 initialized"
echo "  - 2. taint_sink entered"
echo "      [DR] Start tracking sink_id=42 ptr=0x... (base=0x..., offset=0, alloc_size=1024)"
echo "  - 3. taint_sink left: bytes read count"
echo "      [DR] End tracking sink_id=42: read x bytes in full allocation [0x... .. 0x...] (size=1024)"
echo "  - 4. Max distance"
echo "      [DR]   Max distance from ptr: [90-150]"
echo "  - 5. Thread exiting"
echo "      [DR] Thread ....1 exiting"
echo "      [DR] Thread ....2 exiting"