#!/bin/bash
set -e

WORKDIR=/workspaces/fuzzer
SUBJECT=/workspaces/fuzzer/subjects/mini_httpd-1.29
FT_DIR=/workspaces/fuzzer/fuzztastic
BUILD_DIR=$WORKDIR/sense/build
FUZZ_DIR=$(mktemp -d /tmp/mini_httpd_fuzz.XXXXXX)
LDFLAGS="$LDFLAGS -lcrypt -lfuzztasticrt -L$BUILD_DIR -lsample_runtime -lflow_runtime -ldf_coverage_runtime -lxxhash"
TIMEOUT=60
cd $WORKDIR

# BUILD mini_httpd subject with debug info and compile_commands.json
echo "=== Building mini_httpd subject ==="
cd $SUBJECT
./BUILD.sh
echo "=== Finished building mini_httpd subject ==="

cd $WORKDIR
# Instrument mini_httpd with taint tracking for the nl_iruntrusted SARIF file
echo "=== Instrumenting mini_httpd with taint tracking ==="
OUTPUT="$FUZZ_DIR/harness.instrumented.ll"
LLVM_SYMBOLIZER_PATH="/usr/bin/llvm-symbolizer-20" \
/workspaces/fuzzer/sense/build/taint-orchestrator \
    --sarif $SUBJECT/mini_httpd_iruntrusted.sarif \
    --input $SUBJECT/harness.ll \
    --output $OUTPUT \
    --compile-db $SUBJECT/compile_commands.json \
    --pass-dir $WORKDIR/sense/build \
    --verbose
echo "=== Finished instrumenting mini_httpd ==="


# Run fuzztastic instrumentation on the instrumented mini_httpd
echo "=== Running fuzztastic instrumentation on mini_httpd ==="
cd $FT_DIR
FT_OUTPUT="$FUZZ_DIR/harness.ft.bc"
FT_OUTPUT_JSON="$FUZZ_DIR/harness.ft.json"
poetry run fuzztastic/ instrument --input-bc "$OUTPUT" --output-bc "$FT_OUTPUT" --output "$FT_OUTPUT_JSON"
echo "=== Finished fuzztastic instrumentation ==="

# Compile with afl-cc
echo "=== Compiling mini_httpd with afl-cc ==="
$WORKDIR/AFLplusplus/afl-clang-fast -O0 -fno-inline "$FT_OUTPUT" $LDFLAGS -o "$FUZZ_DIR/harness_afl"
echo "=== Finished compiling mini_httpd with afl-cc ==="

echo "Fuzzing binary and related files are in: $FUZZ_DIR"
ls -l $FUZZ_DIR

echo "=== Start fuzzing ==="
FUZZ_CAMP=$(mktemp -d $FUZZ_DIR/fuzz_campaign.XXXX)
fuzzing_cmd="timeout $TIMEOUT $WORKDIR/AFLplusplus/afl-fuzz -i $SUBJECT/seed_corpus2/ -o $FUZZ_CAMP -- $FUZZ_DIR/harness_afl @@"

export AFL_TRY_AFFINITY=1
export AFL_NO_SYNC=1

# Launch Flow Monitor
find /dev/shm/ -maxdepth 1 -name 'flow_events_*' -delete
find /dev/shm/ -maxdepth 1 -name 'df_coverage_*' -delete
echo "🚀 Launching Flow Monitor"
python3 $WORKDIR/sense/monitor/flow_monitor.py \
    --flowdb "$OUTPUT.flowdb" \
    --config "$WORKDIR/sense/monitor/configs/development.yaml" \
    --output "$FUZZ_CAMP/mini_httpd.jsonl" \
    --log-level INFO \
    --log-file "$FUZZ_CAMP/mini_httpd.log" \
    --cleanup-on-exit &
FLOW_MONITOR_PID=$!
echo "Flow Monitor PID: $FLOW_MONITOR_PID, Log: $FUZZ_CAMP/mini_httpd.log"

sleep 5  # Give Flow Monitor time to start

# Launch Fuzztastic
echo "🚀 Launching FuzzTastic with command: $fuzzing_cmd"
cd $FT_DIR
poetry run fuzztastic/ monitor --input "$FT_OUTPUT_JSON" --command "$fuzzing_cmd" --visualization --output "$FUZZ_CAMP/coverages"

# Cleanup
kill $FLOW_MONITOR_PID
echo "Waiting for Flow Monitor to exit gracefully..."
wait $FLOW_MONITOR_PID 2>/dev/null || true
echo "Flow Monitor stopped. Cleaning up shared memory..."
find /dev/shm/ -maxdepth 1 -name 'flow_events_*' -delete
find /dev/shm/ -maxdepth 1 -name 'df_coverage_*' -delete

echo "=== Fuzzing campaign completed ==="
