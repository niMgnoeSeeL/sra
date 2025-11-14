#!/bin/bash
set -e

WORKDIR=/workspaces/fuzzer
SUBJECT=/workspaces/fuzzer/subjects/totinfo
FT_DIR=/workspaces/fuzzer/fuzztastic
BUILD_DIR=$WORKDIR/sense/build
FUZZ_DIR=$(mktemp -d /tmp/totinfo_fuzz.XXXXXX)
LDFLAGS="$LDFLAGS -lm -lfuzztasticrt -L$BUILD_DIR  -lsample_runtime -lflow_runtime -ldf_coverage_runtime -lxxhash"
TIMEOUT=7200
cd $WORKDIR

# Instrument totinfo with taint tracking for the nl_iruntrusted SARIF file
echo "=== Instrumenting totinfo with taint tracking ==="
OUTPUT="$FUZZ_DIR/totinfo_nl_iruntrusted.instrumented.ll"
LLVM_SYMBOLIZER_PATH="/usr/bin/llvm-symbolizer-20" \
/workspaces/fuzzer/sense/build/taint-orchestrator \
    --sarif $SUBJECT/totinfo_nl_iruntrusted.sarif \
    --input $SUBJECT/totinfo.ll \
    --output $OUTPUT \
    --compile-db $SUBJECT/compile_commands.json \
    --pass-dir $WORKDIR/sense/build \
    --verbose
echo "=== Finished instrumenting totinfo ==="


# Run fuzztastic instrumentation on the instrumented totinfo
echo "=== Running fuzztastic instrumentation on totinfo_nl_iruntrusted ==="
cd $FT_DIR
FT_OUTPUT="$FUZZ_DIR/totinfo_nl_iruntrusted.ft.bc"
FT_OUTPUT_JSON="$FUZZ_DIR/totinfo_nl_iruntrusted.ft.json"
poetry run fuzztastic/ instrument --input-bc "$OUTPUT" --output-bc "$FT_OUTPUT" --output "$FT_OUTPUT_JSON"
echo "=== Finished fuzztastic instrumentation ==="

# Compile with afl-cc
echo "=== Compiling totinfo_nl_iruntrusted with afl-cc ==="
$WORKDIR/AFLplusplus/afl-clang-fast -O0 -fno-inline "$FT_OUTPUT" $LDFLAGS -o "$FUZZ_DIR/totinfo_nl_iruntrusted_afl"
echo "=== Finished compiling totinfo_nl_iruntrusted with afl-cc ==="

echo "Fuzzing binary and related files are in: $FUZZ_DIR"
ls -l $FUZZ_DIR

echo "=== Start fuzzing ==="
FUZZ_CAMP=$(mktemp -d $FUZZ_DIR/fuzz_campaign.XXXX)
fuzzing_cmd="timeout $TIMEOUT $WORKDIR/AFLplusplus/afl-fuzz -i $SUBJECT/seed_corpus/ -o $FUZZ_CAMP -- $FUZZ_DIR/totinfo_nl_iruntrusted_afl"

export AFL_TRY_AFFINITY=1
export AFL_NO_SYNC=1

# Launch Flow Monitor
rm /dev/shm/flow_events_* || true
rm /dev/shm/df_coverage_* || true
echo "🚀 Launching Flow Monitor"
python3 $WORKDIR/sense/monitor/flow_monitor.py \
    --flowdb "$OUTPUT.flowdb" \
    --config "$WORKDIR/sense/monitor/configs/development.yaml" \
    --output "$FUZZ_CAMP/totinfo.jsonl" \
    --log-level INFO \
    --log-file "$FUZZ_CAMP/totinfo.log" \
    --cleanup-on-exit &
FLOW_MONITOR_PID=$!
echo "Flow Monitor PID: $FLOW_MONITOR_PID, Log: $FUZZ_CAMP/totinfo.log"

sleep 20  # Give Flow Monitor time to start

# Launch Fuzztastic
echo "🚀 Launching FuzzTastic with command: $fuzzing_cmd"
cd $FT_DIR
poetry run fuzztastic/ monitor --input "$FT_OUTPUT_JSON" --command "$fuzzing_cmd" --visualization --output "$FUZZ_CAMP/coverages"

# Cleanup
kill $FLOW_MONITOR_PID
rm /dev/shm/flow_events_* || true
rm /dev/shm/df_coverage_* || true

echo "=== Fuzzing campaign completed ==="
