#!/bin/bash

set -e

WORKDIR=/workspaces/fuzzer
SUBJECT="/workspaces/fuzzer/subjects/siemens-suite/totinfo"
CORPUS=$SUBJECT/seed_corpus
SARIF="$SUBJECT/taint_reports/Siemens-totinfo_CODEQLCWE-190_ArithmeticTainted.sarif"
FT_DIR=/workspaces/fuzzer/fuzztastic
BUILD_DIR=$WORKDIR/sense/build
FUZZ_DIR=$(mktemp -d /tmp/totinfo.XXXXXX)
HARNESS_LDFLAGS="-L$SUBJECT -lcrypto -ldl -pthread -lm"
LDFLAGS="$LDFLAGS $HARNESS_LDFLAGS -lfuzztasticrt -L$BUILD_DIR -lsample_runtime -lflow_runtime -ldf_coverage_runtime -lxxhash"
TIMEOUT=60
cd $WORKDIR

# Step 1: BUILD totinfo subject with debug info and compile_commands.json
echo "=== Building totinfo subject ==="
cd $SUBJECT
./BUILD.sh
echo "=== Finished building totinfo subject ==="

cd $WORKDIR
# Step 2: Instrument totinfo with taint tracking
echo "=== Instrumenting totinfo with taint tracking ==="
OUTPUT="$FUZZ_DIR/totinfo_fuzz.instrumented.ll"
/workspaces/fuzzer/sense/build/taint-orchestrator \
    --sarif $SARIF \
    --source-dir $SUBJECT \
    --input $SUBJECT/totinfo_fuzz.ll \
    --output $OUTPUT \
    --compile-db $SUBJECT/compile_commands.json \
    --pass-dir $WORKDIR/sense/build \
    --verbose

# The orchestrator creates the final file with .dfcov.ll extension
# We need to use that for CFG generation and fuzzing
if [ -f "$OUTPUT.dfcov.ll" ]; then
    mv "$OUTPUT.dfcov.ll" "$OUTPUT"
fi
echo "=== Finished instrumenting totinfo ==="

# Step 2.5: Generate CFG for reachability analysis
echo "=== Generating CFG for reachability estimator ==="
python3 $WORKDIR/sense/monitor/generate_cfg.py \
    --source-dir "$FUZZ_DIR" \
    --source-name "totinfo_fuzz.instrumented" \
    --opt-path /usr/bin/opt-20
echo "=== Finished generating CFG ==="

# Step 3: Run fuzztastic instrumentation on the instrumented totinfo
echo "=== Running fuzztastic instrumentation on totinfo ==="
cd $FT_DIR
FT_OUTPUT="$FUZZ_DIR/harness.ft.bc"
FT_OUTPUT_JSON="$FUZZ_DIR/harness.ft.json"
poetry run fuzztastic/ instrument --input-bc "$OUTPUT" --output-bc "$FT_OUTPUT" --output "$FT_OUTPUT_JSON"
echo "=== Finished fuzztastic instrumentation ==="

# Step 4: Compile with afl-cc
echo "=== Compiling totinfo with afl-cc ==="
$WORKDIR/AFLplusplus/afl-clang-fast -O0 -fno-inline "$FT_OUTPUT" $LDFLAGS -o "$FUZZ_DIR/harness_afl"
echo "=== Finished compiling totinfo with afl-cc ==="

echo "Fuzzing binary and related files are in: $FUZZ_DIR"
ls -l $FUZZ_DIR

echo "=== Start fuzzing ==="
FUZZ_CAMP=$(mktemp -d $FUZZ_DIR/fuzz_campaign.XXXX)
fuzzing_cmd="timeout $TIMEOUT $WORKDIR/AFLplusplus/afl-fuzz -i $CORPUS -o $FUZZ_CAMP -- $FUZZ_DIR/harness_afl"

export AFL_TRY_AFFINITY=1
export AFL_NO_SYNC=1

# Step 5: Launch Flow Monitor
find /dev/shm/ -maxdepth 1 -name 'flow_events_*' -delete
find /dev/shm/ -maxdepth 1 -name 'df_coverage_*' -delete
echo "🚀 Launching Flow Monitor with Reachability Estimator"
python3 $WORKDIR/sense/monitor/flow_monitor.py \
    --flowdb "$OUTPUT.flowdb" \
    --cfg "$FUZZ_DIR/cfg_inter.json" \
    --config "$WORKDIR/sense/monitor/configs/development.yaml" \
    --output "$FUZZ_CAMP/totinfo.jsonl" \
    --log-level DEBUG \
    --log-file "$FUZZ_CAMP/totinfo.log" \
    --cleanup-on-exit &
FLOW_MONITOR_PID=$!
echo "Flow Monitor PID: $FLOW_MONITOR_PID, Log: $FUZZ_CAMP/totinfo.log"
echo "Reachability estimation enabled with CFG: $FUZZ_DIR/cfg_inter.json"

sleep 5  # Give Flow Monitor time to start

# Step 6: Launch Fuzztastic + AFL
echo "Launching Fuzztastic + AFL..."
echo "Command: $fuzzing_cmd"

cd "$FT_DIR"
poetry run fuzztastic/ monitor \
    --input "$FT_OUTPUT_JSON" \
    --command "$fuzzing_cmd" \
    --visualization \
    --output "$FUZZ_CAMP/coverages" || true  # Don't fail on timeout


# Step 7: Cleanup
echo "  Cleaning up..."
kill $FLOW_MONITOR_PID 2>/dev/null || true
wait $FLOW_MONITOR_PID 2>/dev/null || true
find /dev/shm/ -maxdepth 1 -name 'flow_events_*' -delete
find /dev/shm/ -maxdepth 1 -name 'df_coverage_*' -delete

echo "✓ Fuzzing campaign complete for totinfo"
echo "  Results in: $FUZZ_CAMP"