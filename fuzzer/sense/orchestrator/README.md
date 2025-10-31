# Taint Flow Instrumentation Orchestrator

This orchestrator automates the instrumentation of taint flows from SARIF specifications using the SRC_ID/SINK_ID architecture.

## Architecture Overview

```
SARIF Input → FlowManager → ID Assignment → Instrumentation → Instrumented IR
                   ↓              ↓                ↓
              Parse Flows    SRC_ID/SINK_ID   opt Commands
```

### Components

1. **FlowManager** (`FlowManager.h/cpp`)
   - Tracks taint flows from SARIF
   - Assigns unique SRC_ID to each source location
   - Assigns unique SINK_ID to each sink location
   - Handles deduplication: same location = same ID

2. **SARIFParser** (`SARIFParser.h/cpp`)
   - Parses SARIF JSON format (from CodeQL, etc.)
   - Extracts source → sink flows
   - Converts to SourceLocation structures

3. **ASTAnalyzer** (`ASTAnalyzer.h/cpp`)
   - Clang AST analysis to extract variable names
   - Finds AST nodes at source locations
   - Extracts variable names for fallback instrumentation
   - Always provides variable name to passes when available

4. **InstrumentationStrategy** (`InstrumentationStrategy.h/cpp`)
   - Generates opt commands for SampleFlowSrcPass (and SampleFlowSinkPass)
   - Passes SRC_ID/SINK_ID parameters to LLVM passes
   - Passes both line:col and variable name to passes
   - Executes instrumentation pipeline

5. **ServiceComm** (`ServiceComm.h/cpp`)
   - Placeholder for future runtime service integration
   - Will correlate (SRC_ID, SINK_ID) events at runtime
   - Flow tracking currently implemented in flow_runtime.c/h

## ID Assignment Strategy

**Key Insight:** IDs are assigned to **locations**, not flows.

- Each unique source location → one `SRC_ID`
- Each unique sink location → one `SINK_ID`
- Each flow is defined by `(SRC_ID, SINK_ID)` pair

**Example:**
```
Flow 1: file.c:7:9-12 → file.c:42:5-10
Flow 2: file.c:7:9-12 → file.c:55:3-8
Flow 3: file.c:15:4-7 → file.c:42:5-10

Assignment:
  SRC_ID=1: file.c:7:9-12   (shared by Flow 1 and Flow 2)
  SRC_ID=2: file.c:15:4-7
  SINK_ID=1: file.c:42:5-10 (shared by Flow 1 and Flow 3)
  SINK_ID=2: file.c:55:3-8

Flow Definitions:
  Flow 1 = (SRC_ID=1, SINK_ID=1)
  Flow 2 = (SRC_ID=1, SINK_ID=2)
  Flow 3 = (SRC_ID=2, SINK_ID=1)
```

## Usage

### Basic Usage

```bash
./taint-orchestrator \
  --sarif flows.sarif \
  --input program.ll \
  --output program.instrumented.ll \
  --pass-dir ./build
```

### Full Options

```
Required:
  --sarif <file>       SARIF file with taint flow specifications
  --input <file>       Input LLVM IR file (.ll)
  --output <file>      Output instrumented LLVM IR file (.ll)
  --pass-dir <dir>     Directory containing pass plugin .so files

Optional:
  --opt-path <path>    Path to opt binary (default: opt)
  --compile-args <...> Compilation arguments for AST analysis
  --verbose            Enable verbose output
  --help               Show help message
```

## Workflow Example

### 1. Generate LLVM IR from source

```bash
clang -S -emit-llvm -g -O0 -Xclang -disable-O0-optnone \
  program.c -o program.ll
```

### 2. Create SARIF specification

See Example `demo/flow_scalars.sarif` produced by CodeQL:


### 3. Run orchestrator

```bash
./taint-orchestrator \
  --sarif flows.sarif \
  --input program.ll \
  --output program.instrumented.ll \
  --pass-dir .
```

Output:
```
=== Taint Flow Instrumentation Orchestrator ===

[Step 1] Parsing SARIF file: flows.sarif
[SARIFParser] Successfully parsed 1 flows from flows.sarif

[Step 2] Building flow database and assigning IDs
[FlowManager] Added flow #1: SRC_ID=1 (program.c:7:9-12) → SINK_ID=1 (program.c:10:5-8)

=== Flow Manager Summary ===
Total flows: 1
Unique sources: 1
Unique sinks: 1
...

[Step 5] Executing instrumentation pipeline (2 passes)
[InstrumentationStrategy] Executing: opt -load-pass-plugin=./SampleFlowSrcPass.so ...
[InstrumentationStrategy] Successfully instrumented source at program.c:7:9-12
...

=== Instrumentation Complete ===
Flows processed: 1
Sources instrumented: 1
Sinks instrumented: 1
Output: program.instrumented.ll
```

### 4. Compile instrumented IR

```bash
clang program.instrumented.ll libsample_runtime.a libflow_runtime.a -o program
```

### 5. Run and observe

```bash
# Basic mode
./program
# Output: [flow_runtime] SOURCE: SRC_ID=1, ptr=0x7fff..., size=4

# Verbose mode with hex dump
FLOW_VERBOSE=1 ./program
# Output: [flow_runtime] SOURCE: SRC_ID=1, ptr=0x7fff..., size=4
#         [flow_runtime]   Data (hex): 01 02 03 04

# Log to file
FLOW_LOG_FILE=trace.log ./program
```

## Integration with Passes

The orchestrator invokes LLVM passes with these parameters:

### SampleFlowSrcPass

```bash
opt -load-pass-plugin=./SampleFlowSrcPass.so \
    -passes=sample-flow-src \
    -sample-line=7 \
    -sample-col-start=9 \
    -sample-col-end=12 \
    -sample-var-name=x \
    -sample-src-id=1 \
    input.ll -S -o output.ll
```

Pass tries line:col mode first, falls back to var-name mode if anchor not found.

### SampleFlowSinkPass (TODO: implement)

```bash
opt -load-pass-plugin=./SampleFlowSinkPass.so \
    -passes=sample-flow-sink \
    -sample-line=10 \
    -sample-col-start=5 \
    -sample-col-end=8 \
    -sample-var-name=y \
    -sample-sink-id=1 \
    input.ll -S -o output.ll
```

(SampleFlowSinkPass not yet implemented)

## Runtime Interface

### Sampling Runtime (sample_runtime.c)

```c
// Sampling functions
int sample_int(int x);                    // Sample int32
double sample_double(double x);           // Sample double
void sample_bytes(void* ptr, int len);    // Sample byte array
```

### Flow Tracking Runtime (flow_runtime.c)

```c
// Flow tracking with IDs
void sample_report_source(void* data, int size, int src_id);
void sample_report_sink(void* data, int size, int sink_id);
```

Environment variables:
- `FLOW_VERBOSE=1` - Enable verbose logging with hex dumps
- `FLOW_LOG_FILE=path` - Log to file instead of stderr

### Future: Runtime Service Integration

The runtime service will correlate events:
- When data from `SRC_ID=1` reaches `SINK_ID=1`
- Report: "Flow #1 triggered: (SRC_ID=1, SINK_ID=1)"

## Architecture Diagram

```
┌─────────────────┐
│  SARIF File     │ (CodeQL output)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  SARIFParser    │ Parse JSON → Flows
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  FlowManager    │ Assign SRC_ID/SINK_ID
└────────┬────────┘
         │
         ├──────────────┬──────────────┐
         ▼              ▼              ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│ SRC_ID=1     │ │ SRC_ID=2     │ │ SINK_ID=1    │
│ loc: 7:9-12  │ │ loc: 15:4-7  │ │ loc: 42:5-10 │
└──────┬───────┘ └──────┬───────┘ └──────┬───────┘
       │                │                │
       ▼                ▼                ▼
┌──────────────────────────────────────────────┐
│     InstrumentationStrategy                  │
│   Generate opt commands with IDs             │
└──────────────────┬───────────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────────┐
│  opt + SampleFlowSrcPass/SinkPass            │
│  Insert sample_report_source/sink()          │
└──────────────────┬───────────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────────┐
│  Instrumented LLVM IR                        │
│  + sample_report_source(data, size, src_id)  │
│  + sample_report_sink(data, size, sink_id)   │
└──────────────────────────────────────────────┘
```
