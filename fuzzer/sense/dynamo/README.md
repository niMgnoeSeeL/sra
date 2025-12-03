# Dynamic Buffer Tracking with DynamoRIO

## Overview

This prototype demonstrates using **DynamoRIO** for dynamic, byte-precise tracking of which bytes in heap-allocated buffers are actually read/written by external functions (taint sources and sinks).

**This directory contains multiple dynamic tracking clients, including engineering examples. The production-ready one is `track_reads_marker.c`, for its detail, refer to `TOOL.md`.**

**Goal**: Answer quantitative questions like:
> For a given execution and buffer, *which bytes* were actually written or read, and how many?

This is finer-grained than classic taint analysis, which only answers "Is this object tainted?" rather than "How many bytes / which offsets are tainted or consumed?"

---

## 1. Problem Statement

C/C++ programs pass pointers to buffers to **external functions** that act as:
- **Taint sources** (e.g., `read`, `recv`): *write* data into a buffer
- **Taint sinks** (e.g., `SSL_write`, `BIO_write`, logging): *read* data from a buffer

For effective fuzzing and vulnerability analysis, we need byte-level precision:
- "This sink read bytes 15 and 64–127 of this buffer"0
- "The source wrote exactly 173 bytes starting at offset 0"

---

## 2. Design: Stack vs Heap Policy

We assume each pointer `v` can be traced back to a **single allocation** `A`.

### 2.1. Static objects (stack / globals / struct fields)

For these, the **capacity** `Cap(A)` is statically known from the type:
- `char buf[1024];` → 1024 bytes
- `int x;` → `sizeof(int)` bytes
- `struct S { ... } s;` → `sizeof(S)` bytes

**Policy**: Use **static may-taint approximation**
- Any taint source/sink touching such an object is assumed to taint/read the **entire object**
- This is cheap, simple, and acceptable since these regions are typically small

### 2.2. Dynamic heap buffers (`malloc` / `new`)

For heap allocations, sizes are dynamic and buffers are often large and heavily reused.  
A "whole buffer is tainted" assumption is too imprecise.

**Policy**: Use **dynamic, byte-precise tracking**
- Track each heap allocation `(base, size)` at runtime
- For sources: use return values + buffer metadata
- For sinks: dynamically observe which bytes are actually accessed

---

## 3. Architecture

```

 Application Process (under DynamoRIO)                       │

                                                              │
  malloc(1024) ──────► [DR tracks: base=0x..., size=1024]   │
        │                                                     │
        v                                                     │
  buf = 0x...                                                │
        │                                                     │
        v                                                     │
  read(fd, buf,  [writes 100 bytes]                │1024) 
        │                                                     │
        v                                                     │
  taint_sink(buf, 100)                                       │
        │                                                     │
        ├─► [DR pre-wrap]                                    │
        │    - Enable instrumentation                         │
        │    - Allocate read_mask[1024]                      │
        │                                                     │
        ├─► [Sink executes]                                  │
        │    - Each memory read triggers callback            │
        │    - on_mem_read(addr=buf+i, size=1)              │
        │    - Sets read_mask[i] = 1                         │
        │                                                     │
        └─► [DR post-wrap]                                   │
             - Count bits set in read_mask                    │
             - Report: "50 bytes read, offsets 0-98"         │
                                                              │
  free( [DR untracks allocation]                │buf) ──
                                                              │

```

### How It Works

The DynamoRIO client (`libtrack_reads.so`) attached to a compiled target binary:

1. **Tracks heap allocations** (base + size) by wrapping `malloc`/`free`
2. **Detects sink function calls** by wrapping target functions (using debug symbols if not exported)
3. **Instruments memory reads** - every memory read instruction inside the sink triggers a callback
4. **Maintains a per-byte read mask** for the tracked buffer
5. **Reports precise access patterns** on sink return

**Result**: For this concrete run, "this sink read exactly these offsets of that buffer."

### Key Technical Details

**Function Wrapping:**
- Uses `drsyms` extension to find non-exported functions via debug symbols
- Falls back to `dr_get_proc_address` for exported symbols
- Wraps `malloc`/`free` in libc.so.6 to track all heap allocations

**Malloc Argument Handling:**
- Saves size argument in `pre_malloc` wrapper
- Retrieves it in `post_malloc` via user_data (can't reliably read args in post-wrapper)

**Instrumentation:**
- Uses `drmgr_register_bb_instrumentation_event` for basic block instrumentation
- `drutil_insert_get_mem_addr` computes effective addresses
- `dr_insert_clean_call` inserts callbacks to `on_mem_read`

---

## 4. Building and Testing

### 4.1. Prerequisites

- DynamoRIO 11.3.0 (automatically installed in dev container at `/opt/dynamorio`)
- CMake 3.20+
- Target program with debug symbols (`-g` flag)

### 4.2. Quick Start

```bash
cd /workspaces/fuzzer/sense/dynamo
./test_track_reads.sh
```

This script will:
1. Build the DynamoRIO client (`libtrack_reads.so`)
2. Compile the demo target program
3. Create test input
4. Run target under DynamoRIO
5. Report precise byte-level access patterns

### 4.3. Expected Output

```
== track_reads loaded ==
[DR] module loaded: target
[DR] found taint_sink via debug symbols at 0x...
[DR] successfully wrapped taint_sink in target
[DR] wrapped malloc in libc.so.6
[DR] wrapped free in libc.so.6
[DR] malloc(1024) = 0x...
[main] read 100 bytes
[DR] taint_sink entered: buf=0x... len=100
[taint_sink] sum = 3200
[DR] taint_sink read 50 bytes in region [0x... .. 0x...) (alloc size=1024)
[DR]   first offset=0, last offset=98
[DR] free(0x...)
== track_reads exiting ==
```

**Key observation**: Even though 100 bytes were passed to the sink, only 50 were actually read (every other byte), and DynamoRIO precisely tracks this!

### 4.4. VS Code Tasks

```
Ctrl+Shift+B → "dynamo:cmake-config" - Configure CMake with DynamoRIO
              "dynamo:build"         - Build the client library
              "dynamo:test"          - Run full test suite
```

---

## 5. Implementation Status

### ✅ Completed

- [x] DynamoRIO client with malloc/free tracking
- [x] Per-byte read mask for precise tracking
- [x] Function wrapping using debug symbols (drsyms extension)
- [x] Wraps non-exported functions via `drsym_lookup_symbol`
- [x] Clean call instrumentation with correct argument passing
- [x] Build system with CMake (separate from LLVM passes)
- [x] Automated test script
- [x] VS Code integration tasks

### 🔧 Key Bug Fixes Applied

1. **DynamoRIO Version**: Upgraded from 10.0.0 (has SIGFPE bug) to 11.3.0 stable
2. **API Compatibility**: Use `dr_register_exit_event` (not `drmgr_register_exit_event`) for 11.3.0
3. **OUT Macro**: Removed `OUT` macro (not defined in DR 11.3.0)
4. **Malloc Wrapper**: Save size in `pre_malloc`, read from user_data in `post_malloc`
5. **Symbol Lookup**: Use drsyms extension to find non-exported functions

### 🚧 Environment

- **DynamoRIO Version**: 11.3.0 (stable release)
- **Installation Path**: `/opt/dynamorio`
- **Required Build Flag**: Target must have debug symbols (`-g`)

---

## 6. Demo Target Program

The test target (`/workspaces/fuzzer/subjects/DR_demo/target.c`) demonstrates the concept:

```c
#define MAX_BUF 1024

void taint_sink(const uint8_t *buf, size_t len) {
    size_t sum = 0;
    // Read every other byte (50% of buffer)
    for (size_t i = 0; i < len; i += 2)
        sum += buf[i];
    fprintf(stderr, "[taint_sink] sum = %zu\n", sum);
}

int main(void) {
    uint8_t *buf = malloc(MAX_BUF);
    ssize_t n = read(0, buf, MAX_BUF);
    fprintf(stderr, "[main] read %zd bytes\n", n);
    taint_sink(buf, (size_t)n);
    free(buf);
    return 0;
}
```

This simple pattern (reading every other byte) is precisely detected by the DynamoRIO instrumentation.

---

## 7. Future Work

### 7.1. Integration with Static Instrumentation Passes

**Update SampleFlowSrcPass (Source Tracking):**
```cpp
// After identifying the base allocation
if (isHeapAllocation(Base)) {
    // HEAP: Use DynamoRIO for precise byte-level tracking
    insertDynamicSourceMarker(Base, AllocatedType);
} else {
    // STACK/GLOBAL: Use static over-approximation
    insertReportCall(/* ... existing code ... */);
}
```

**Heap Allocation Detection:**
```cpp
bool isHeapAllocation(Value *Base) {
    if (auto *Call = dyn_cast<CallInst>(Base)) {
        Function *Callee = Call->getCalledFunction();
        if (Callee && (Callee->getName() == "malloc" || 
                       Callee->getName() == "calloc" ||
                       Callee->getName() == "realloc" ||
                       Callee->getName() == "new" ||
                       Callee->getName() == "operator new")) {
            return true;
        }
    }
    return false;
}
```

**Update SampleFlowSinkPass (Sink Tracking):**
```cpp
if (isHeapAllocation(Base)) {
    // HEAP: Mark for DynamoRIO tracking
    insertDynamicSinkMarker(SinkID, Base, Size);
} else {
    // STACK/GLOBAL: Use static instrumentation
    insertReportCall(/* ... existing code ... */);
}
```

### 7.2. Client Enhancements

**Needed:**
- [ ] Support multiple concurrent sinks (currently single global state)
- [ ] Wrap additional allocators: `calloc`, `realloc`, C++ `new`/`delete`
- [ ] Source tracking (write instrumentation) in addition to sinks (reads)
- [ ] Structured output format (JSON/binary) instead of stderr
- [ ] IPC mechanism for communication with static passes

**Communication Options:**
- **Shared memory IPC**: Static pass writes `(sink_id, ptr, size)` to shm, DR client reads
- **Configuration file**: Static pass writes JSON with sink metadata, DR client reads at startup
- **Marker functions**: Static pass inserts `__dr_register_sink(id, ptr, size)`, DR wraps it
- **Unix socket**: For real-time fuzzer integration

**Structured Output Format:**
```c
typedef struct {
    uint32_t sink_id;
    uint64_t base_addr;
    uint64_t alloc_size;
    uint32_t bytes_read;
    uint32_t first_offset;
    uint32_t last_offset;
    uint8_t *read_mask;  // optional: full bitmap
} sink_report_t;
```

### 7.3. Performance Optimization

**Current overhead**: ~100-1000x slowdown (typical for full DynamoRIO instrumentation)

**Optimization strategies:**
- [ ] Context-sensitive instrumentation (only inside sink functions)
- [ ] DynamoRIO's partial instrumentation mode
- [ ] Cache frequently-accessed allocations
- [ ] Lock-free data structures for multi-threading
- [ ] Consider Intel PT for lower overhead

**Hybrid approach:**
```

 Most executions: Static instrumentation│  (fast, over-approximate)
  └─> Good enough for fuzzing feedback  │

 Rare executions: DynamoRIO tracking   │  (slow, precise)
  └─> Enable for new/interesting paths  │
  └─> Triggered by AFL's stability     │

```

### 7.4. Fuzzer Integration

**Compilation phase:**
```bash
# Instrument target with taint passes
clang -fpass-plugin=SampleFlowSrcPass.so \
      -fpass-plugin=SampleFlowSinkPass.so \
      -DUSE_DYNAMIC_TRACKING -g \
      target.c -o target
```

**Fuzzing phase:**
```bash
# Run AFL with DynamoRIO client
afl-fuzz -i in -o out -- \
  drrun -c libtrack_reads.so -- \
  ./target @@
```

**Analysis phase:**
```python
# Parse DR output to extract sensitivity data
for execution in fuzzing_campaign:
    for sink in execution.sinks:
        sensitivity[sink.id] = sink.bytes_read / sink.alloc_size
```

### 7.5. Testing Roadmap

- [ ] Multiple concurrent allocations
- [ ] Nested sink calls
- [ ] Multi-threaded targets
- [ ] Different allocation types (malloc, calloc, new, etc.)
- [ ] Source tracking (write instrumentation)
- [ ] Large buffers (>1MB)
- [ ] Alignment and offset edge cases

---

## 8. References

- **DynamoRIO Documentation**: https://dynamorio.org/
- **DynamoRIO Clients**: https://github.com/DynamoRIO/dynamorio/tree/master/clients
- **Dr. Memory Paper**: "Practical Memory Checking with Dr. Memory" (memory tracking patterns)
- **DynamoRIO Issue #5437**: SIGFPE bug in version 10.0.0 (fixed in 11.3.0)
- **DynamoRIO Users Group**: https://groups.google.com/g/DynamoRIO-Users
