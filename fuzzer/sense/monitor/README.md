# Monitor Service Design & Implementation

## Table of Contents
1. [Overview](#overview)
2. [Design Decisions](#design-decisions)
3. [Architecture](#architecture)
4. [Communication Protocol](#communication-protocol)
5. [Data Structures](#data-structures)
6. [Process Discovery](#process-discovery)
7. [Implementation Plan](#implementation-plan)
8. [Configuration](#configuration)
9. [FAQ](#faq)

---

## Overview

The **monitor service** is a standalone Python component that receives runtime events from instrumented programs and correlates them to detect dataflow coverage and taint flow completions. It runs as a separate process from the target program and communicates via shared memory for high performance.

### Key Responsibilities

1. **Flow Event Correlation**: Detect when a complete dataflow is covered in an execution
2. **Coverage Tracking**: Monitor which intermediate dataflow locations are executed
3. **Complete Flow Detection**: A flow is only "complete" if source + sink + ALL intermediates are covered
4. **Statistics Tracking**: Per-flow completion counts, timing statistics, coverage percentages
5. **Streaming Output**: JSONL format for real-time analysis during fuzzing campaigns

---

## Design Decisions

### 1. Implementation Language: Python
- Based on Fuzztastic's architecture
- Uses standard Python `open()` and `read()` to access shared memory files (no external dependencies)
- Uses `ctypes.from_buffer_copy()` for efficient binary parsing
- Easy to parse `.flowdb` files

### 2. Communication Model: One-Way (Runtime → Monitor)
- **No feedback from monitor to instrumented program**
- Monitor passively observes execution via shared memory
- Instrumented program never blocks waiting for monitor
- Monitor processes data after execution completes
- **No PID tracking**: PIDs are reused by OS; we rely on shared memory file existence
- Once processed and cleaned up, files don't exist, so no reprocessing

### 3. Execution Model: One Process Per Input (AFL Normal Mode)
- Each fuzzer input = new process with new PID
- Each execution is independent
- **One shared memory region per execution** (not shared across executions)
- Monitor discovers completed executions and reads their memory

### 4. Data Hashing Strategy
- **Hash computed in flow_runtime.c** (not in monitor)
- Uses **xxHash64** - extremely fast, 64-bit output, seed=0
- Only fixed-size hashes transmitted via shared memory
- No need to transmit actual data - hash provides data fingerprint
- Collision probability ~10^-19 (negligible)
- **Note**: Source and sink typically hash different data (e.g., input buffer vs. parsed value)

---

## High-Level Architecture

```
┌─────────────────────────────────────┐
│   Instrumented Target Program       │
│            (PID = 12345)            │
│                                     │
│  ┌─────────────┐  ┌──────────────┐ │
│  │flow_runtime │  │df_cov_runtime│ │
│  │             │  │              │ │
│  │ - source()  │  │ - hit()      │ │
│  │ - sink()    │  │              │ │
│  └──────┬──────┘  └──────┬───────┘ │
│         │                │         │
└─────────┼────────────────┼─────────┘
          │                │
          │   /flow_       │ /df_coverage_
          │   events_      │ 12345
          │   12345        │
          ▼                ▼
┌────────────────────────────────────┐
│      Monitor Service (Python)      │
│                                    │
│  ┌──────────────────────────────┐  │
│  │   Process Discovery          │  │
│  │   - Poll /dev/shm/           │  │
│  │   - Detect completed PIDs    │  │
│  └──────────────────────────────┘  │
│                                    │
│  ┌──────────────────────────────┐  │
│  │   Event Processor            │  │
│  │   - Read source/sink events  │  │
│  │   - Read coverage map        │  │
│  │   - Correlate flows          │  │
│  └──────────────────────────────┘  │
│                                    │
│  ┌──────────────────────────────┐  │
│  │   Flow Database (.flowdb)    │  │
│  │   - Flow definitions         │  │
│  │   - (src,sink) → flow_id     │  │
│  │   - flow_id → intermediate[] │  │
│  └──────────────────────────────┘  │
└────────────────────────────────────┘
```

## Detailed Monitor Service Dataflow

```
┌─────────────────────────────────────────────────────────────────┐
│                     MONITOR SERVICE INTERNALS                    │
└─────────────────────────────────────────────────────────────────┘

1. INITIALIZATION (flow_monitor.py)
   ┌────────────────────────────────────┐
   │  Load Configuration                │
   │  • YAML with inheritance support  │
   │  • CLI argument overrides          │
   │  • Environment variable overrides  │
   └────────────┬───────────────────────┘
                │
                ▼
   ┌────────────────────────────────────┐
   │  Parse Flow Database (.flowdb)     │
   │  • Load SOURCE definitions         │
   │  • Load SINK definitions           │
   │  • Load INTERMEDIATE definitions   │
   │  • Load FLOW definitions           │
   │  • Build lookup tables:            │
   │    - flows[flow_id] → FlowDef     │
   └────────────┬───────────────────────┘
                │
                ▼
   ┌────────────────────────────────────┐
   │  Initialize Monitor (monitor.py)   │
   │  • Create EventProcessor           │
   │  • Create Statistics tracker       │
   │  • Setup output (stdout/file)      │
   │  • Configure logging               │
   └────────────┬───────────────────────┘
                │
                ▼

2. MAIN MONITORING LOOP (monitor.py - FlowMonitor.start())
   ┌─────────────────────────────────────────────────────────┐
   │  while running:                                         │
   │    ┌──────────────────────────────────────────────┐     │
   │    │  discover_executions(shm_dir)                │     │
   │    │  • Scan /dev/shm/ for flow_events_* files    │     │
   │    │  • Extract PIDs from filenames               │     │
   │    │  • Return list of PIDs with shared memory    │     │
   │    │                                              │     │
   │    │  Returns: [12345, 12346, ...]                │     │
   │    └──────────────┬───────────────────────────────┘     │
   │                   │                                     │
   │                   ▼                                     │
   │    ┌──────────────────────────────────────────────┐     │
   │    │  For each PID:                               │     │
   │    │    _process_execution(pid) ──────────────────┼─────┼──┐
   │    └──────────────────────────────────────────────┘     │  │
   │                                                         │  │
   │    sleep(poll_interval)  # Default: 100ms               │  │
   └─────────────────────────────────────────────────────────┘  │
                                                                │
   ┌────────────────────────────────────────────────────────────┘
   │
   ▼

3. PROCESS EXECUTION (monitor.py - _process_execution())
   ┌───────────────────────────────────────────────────────┐
   │  parse_execution(pid, shm_dir, ...)                   │
   │  [shm_protocol.py]                                    │
   │  ┌──────────────────────────────────────────────────┐ │
   │  │ A) parse_flow_events()                           │ │
   │  │    • Open /dev/shm/flow_events_{pid}             │ │
   │  │    • mmap file into memory                       │ │
   │  │    • Cast to FlowEventBuffer ctypes structure    │ │
   │  │    • Read header: num_events, capacity           │ │
   │  │    • Read events array (32 bytes each):          │ │
   │  │      - type (SOURCE=1, SINK=2)                   │ │
   │  │      - id (source_id or sink_id)                 │ │
   │  │      - timestamp_ns                              │ │
   │  │      - data_hash (xxHash64)                      │ │
   │  │      - data_size                                 │ │
   │  │    • Return List[ParsedFlowEvent]                │ │
   │  └──────────────────────────────────────────────────┘ │
   │  ┌──────────────────────────────────────────────────┐ │
   │  │ B) parse_coverage_map()                          │ │
   │  │    • Open /dev/shm/df_coverage_{pid}             │ │
   │  │    • Read raw bytes (coverage bitmap)            │ │
   │  │    • Each byte = hit count for intermediate loc  │ │
   │  │    • Return bytes                                │ │
   │  └──────────────────────────────────────────────────┘ │
   │                                                       │
   │  Returns: ParsedExecution(pid, events, coverage)      │
   └────────────┬──────────────────────────────────────────┘
                │
                ▼

4. EVENT CORRELATION (event_processor.py - EventProcessor.process_execution())
   ┌───────────────────────────────────────────────────────┐
   │  A) Separate events by type                           │
   │     • source_events = [e for e in events if SOURCE]   │
   │     • sink_events = [e for e in events if SINK]       │
   └────────────┬──────────────────────────────────────────┘
                │
                ▼
   ┌───────────────────────────────────────────────────────┐
   │  B) Parse coverage map                                │
   │     coverage_hits = {loc_id: count for loc_id, count  │
   │                      in enumerate(coverage_bytes)     │
   │                      if count > 0}                    │
   └────────────┬──────────────────────────────────────────┘
                │
                ▼
   ┌───────────────────────────────────────────────────────┐
   │  C) Correlate flows (_correlate_flows)                │
   │  ┌──────────────────────────────────────────────────┐ │
   │  │ 1. Index events by ID:                           │ │
   │  │    sources_by_id[src_id] = [events...]           │ │
   │  │    sinks_by_id[sink_id] = [events...]            │ │
   │  └──────────────────────────────────────────────────┘ │
   │  ┌──────────────────────────────────────────────────┐ │
   │  │ 2. For each flow definition:                     │ │
   │  │    flow_def = flows[flow_id]                     │ │
   │  │                                                  │ │
   │  │    a) Get candidate events:                      │ │
   │  │       candidate_sources = sources_by_id[src_id]  │ │
   │  │       candidate_sinks = sinks_by_id[sink_id]     │ │
   │  │                                                  │ │
   │  │    b) Check source/sink presence:                │ │
   │  │       if no sources OR no sinks: SKIP            │ │
   │  │                                                  │ │
   │  │    c) Check intermediate coverage:               │ │
   │  │       for loc_id in flow_def.intermediate_ids:   │ │
   │  │         if loc_id NOT in coverage_hits:          │ │
   │  │           SKIP (incomplete flow)                 │ │
   │  │                                                  │ │
   │  │    d) Match source→sink pairs:                   │ │
   │  │       for src_event in candidate_sources:        │ │
   │  │         for sink_event in candidate_sinks:       │ │
   │  │           if src.timestamp < sink.timestamp:     │ │
   │  │             CREATE FlowCompletion:               │ │
   │  │               - flow_id                          │ │
   │  │               - source_event                     │ │
   │  │               - sink_event                       │ │
   │  │               - time_delta_ns                    │ │
   │  │               - intermediate_coverage (SET)      │ │
   │  └──────────────────────────────────────────────────┘ │
   │                                                       │
   │  Returns: ExecutionAnalysis(                          │
   │    pid, events, completed_flows, coverage_hits)       │
   └────────────┬──────────────────────────────────────────┘
                │
                ▼

5. OUTPUT & STATISTICS (monitor.py)
   ┌────────────────────────────────────────────────────────┐
   │  A) Update Statistics                                  │
   │     • Total executions++                               │
   │     • Total flows completed++                          │
   │     • Per-flow statistics                              │
   │     • Timing statistics (min/max/avg)                  │
   └────────────┬───────────────────────────────────────────┘
                │
                ▼
   ┌─────────────────────────────────────────────────────────┐
   │  B) Output Results (_output_analysis)                   │
   │     Format: JSONL (one line per execution)              │
   │     {                                                   │
   │       "timestamp": "2025-11-07T...",                    │
   │       "execution": {                                    │
   │         "pid": 12345,                                   │
   │         "total_events": 6,                              │
   │         "num_sources": 3,                               │
   │         "num_sinks": 3,                                 │
   │         "completed_flows": [                            │
   │           {                                             │
   │             "flow_id": 1,                               │
   │             "source_id": 1,                             │
   │             "sink_id": 1,                               │
   │             "source_hash": "0x...",                     │
   │             "sink_hash": "0x...",                       │
   │             "time_delta_ns": 54321,                     │
   │             "time_delta_us": 54.321,                    │
   │             "intermediate_coverage": [1, 2, 3]          │
   │           }                                             │
   │         ],                                              │
   │         "coverage": {"1": 5, "2": 3, "3": 1}            │
   │       }                                                 │
   │     }                                                   │
   └────────────┬────────────────────────────────────────────┘
                │
                ▼
   ┌────────────────────────────────────────────────────────┐
   │  C) Cleanup (if auto_cleanup=true)                     │
   │     • Delete /dev/shm/flow_events_{pid}                │
   │     • Delete /dev/shm/df_coverage_{pid}                │
   └────────────────────────────────────────────────────────┘

KEY DESIGN DECISIONS:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. NO PID TRACKING: PIDs are reused by OS, so we rely on file
   existence. Once processed and cleaned up, files are gone.

2. COMPLETE FLOWS ONLY: A flow is only reported if:
   - Source is covered at least once (before sink)
   - Sink is covered at least once (after source)
   - ALL intermediate locations are covered

3. MULTIPLE FLOWS PER EXECUTION: We report all completed flows
   in a single execution, not just the first one.

4. DISCOVERY-BASED: Monitor discovers PIDs by scanning /dev/shm
   every poll_interval (default 100ms). No fuzzer cooperation.
```

---

## Communication Protocol

### Shared Memory Regions (Per Execution)

#### Region 1: Flow Events (`/flow_events_<pid>`)

**Simple append-only array** (NOT a ring buffer):

```c
// Event structure (32 bytes)
typedef struct {
  uint32_t type;          // 1=SOURCE, 2=SINK
  uint32_t id;            // source_id or sink_id
  uint64_t timestamp;     // monotonic nanoseconds (for debugging)
  uint64_t data_hash;     // xxHash64 of the data
  uint32_t data_size;     // Original data size
  uint32_t padding;       // Alignment to 8-byte boundary
} FlowEvent;

// Buffer for one execution
typedef struct {
  uint32_t num_events;        // Number of events written
  uint32_t max_events;        // Capacity (e.g., 1024)
  uint64_t padding;           // Alignment
  FlowEvent events[max_events];
} FlowEventBuffer;
```

**Size:** 16 bytes header + (32 bytes × 1024) = **~32 KB per execution**

**Runtime behavior:**
```c
void flow_report_source(void *data, size_t size, int src_id) {
    uint32_t idx = __atomic_fetch_add(&shm->num_events, 1, __ATOMIC_RELAXED);
    if (idx >= shm->max_events) {
        return; // Buffer full, drop event
    }
    
    FlowEvent *event = &shm->events[idx];
    event->type = FLOW_EVENT_SOURCE;
    event->id = src_id;
    event->timestamp = get_monotonic_ns();
    event->data_hash = xxhash64(data, size);
    event->data_size = size;
}
```

**Monitor behavior:**
```python
def parse_flow_events(shm_path: Path) -> List[ParsedFlowEvent]:
    """Parse events from shared memory file."""
    with open(shm_path, 'rb') as f:
        # Read header
        header_bytes = f.read(ctypes.sizeof(FlowEventBuffer))
        header = FlowEventBuffer.from_buffer_copy(header_bytes)
        
        # Read events
        events = []
        for i in range(header.num_events):
            event_bytes = f.read(ctypes.sizeof(FlowEvent))
            event = FlowEvent.from_buffer_copy(event_bytes)
            events.append(ParsedFlowEvent(...))
        
    return events
```

#### Region 2: Coverage Map (`/df_coverage_<pid>`)

```c
typedef struct {
  uint32_t map_size;          // Number of intermediate locations
  uint32_t padding;           // Alignment
  uint8_t coverage[map_size]; // Hit counts (0-255)
} CoverageMap;
```

**Size:** 8 bytes header + variable coverage array (**~10 KB typical**)

Direct mapping of `df_coverage_runtime.c` globals.

### Workflow

1. **Fuzzer starts execution**: New process PID 12345
2. **Runtime creates**: `/flow_events_12345` and `/df_coverage_12345`
3. **Execution runs**: Writes events, updates coverage
4. **Process exits**: Shared memory persists
5. **Monitor discovers**: PID 12345 completed (polling `/dev/shm/`)
6. **Monitor reads**: All events and coverage
7. **Monitor processes**: Correlates flow, checks for new patterns
8. **Monitor cleans up**: Deletes shared memory regions

---

## Enhanced .flowdb Format (v1.1)

**Now includes intermediate IDs per flow:**

```
# FlowManager Serialized Database v1.1
# Format: SOURCE/SINK/INTERMEDIATE,ID,file,line,colStart,colEnd
#         FLOW,flowID,srcID,sinkID,intermediate_ids=[...],description
METADATA,flows=2,sources=2,sinks=2,intermediates=5
SOURCE,1,program.c,7,9,12
SOURCE,2,program.c,15,5,9
SINK,1,program.c,42,5,10
SINK,2,program.c,50,3,7
INTERMEDIATE,1,program.c,10,14,18
INTERMEDIATE,2,program.c,12,8,12
INTERMEDIATE,3,program.c,20,5,9
INTERMEDIATE,4,program.c,22,10,15
INTERMEDIATE,5,program.c,25,7,11
FLOW,1,1,1,[1,2,3],Untrusted input flows to sensitive sink
FLOW,2,2,2,[3,4,5],Another taint flow
```

**Key enhancement:** Monitor can now map `(src_id, sink_id)` → `flow_id` → `expected_intermediates[]`

---

## Data Structures

### Flow Database (Python)

```python
from dataclasses import dataclass
from typing import Dict, List, Optional, Set, Tuple

@dataclass
class Location:
    file: str
    line: int
    col_start: int
    col_end: int
    
@dataclass  
class Flow:
    flow_id: int
    src_id: int
    sink_id: int
    intermediate_ids: List[int]  # From .flowdb FLOW entries
    description: str

class FlowDatabase:
    def __init__(self, flowdb_path: str):
        self.sources: Dict[int, Location] = {}
        self.sinks: Dict[int, Location] = {}
        self.intermediates: Dict[int, Location] = {}
        self.flows: Dict[int, Flow] = {}
        
        # Lookup tables
        self.src_sink_to_flow: Dict[Tuple[int, int], int] = {}
        
        self.load(flowdb_path)
    
    def load(self, path: str):
        """Parse .flowdb file format v1.1"""
        with open(path) as f:
            for line in f:
                line = line.strip()
                if line.startswith('#') or not line:
                    continue
                
                parts = line.split(',')
                if parts[0] == 'SOURCE':
                    self.sources[int(parts[1])] = Location(
                        parts[2], int(parts[3]), int(parts[4]), int(parts[5]))
                elif parts[0] == 'SINK':
                    self.sinks[int(parts[1])] = Location(
                        parts[2], int(parts[3]), int(parts[4]), int(parts[5]))
                elif parts[0] == 'INTERMEDIATE':
                    self.intermediates[int(parts[1])] = Location(
                        parts[2], int(parts[3]), int(parts[4]), int(parts[5]))
                elif parts[0] == 'FLOW':
                    # Parse: FLOW,flowID,srcID,sinkID,[1,2,3],description
                    flow = Flow(
                        int(parts[1]), int(parts[2]), int(parts[3]),
                        self._parse_int_list(parts[4]),
                        ','.join(parts[5:]))
                    self.flows[flow.flow_id] = flow
                    self.src_sink_to_flow[(flow.src_id, flow.sink_id)] = flow.flow_id
    
    def _parse_int_list(self, s: str) -> List[int]:
        """Parse [1,2,3] format"""
        if s.startswith('[') and s.endswith(']'):
            inner = s[1:-1]
            return [int(x) for x in inner.split(',')] if inner else []
        return []
    
    def lookup_flow(self, src_id: int, sink_id: int) -> Optional[int]:
        """Map (src_id, sink_id) to flow_id"""
        return self.src_sink_to_flow.get((src_id, sink_id))
    
    def get_flow_intermediates(self, flow_id: int) -> List[int]:
        """Get expected intermediate IDs for a flow"""
        return self.flows[flow_id].intermediate_ids if flow_id in self.flows else []
```

### Shared Memory Protocol Structures

```python
# shm_protocol.py - ctypes structures matching C runtime

class FlowEvent(ctypes.Structure):
    """Flow event (32 bytes) - matches flow_shm.h"""
    _fields_ = [
        ("type", ctypes.c_uint32),      # 1=SOURCE, 2=SINK
        ("id", ctypes.c_uint32),        # source_id or sink_id
        ("timestamp", ctypes.c_uint64), # nanoseconds
        ("data_hash", ctypes.c_uint64), # xxHash64
        ("data_size", ctypes.c_uint32), # bytes
        ("padding", ctypes.c_uint32),   # alignment
    ]

class FlowEventBuffer(ctypes.Structure):
    """Flow event buffer header - matches flow_shm.h"""
    _fields_ = [
        ("num_events", ctypes.c_uint32),  # events written
        ("max_events", ctypes.c_uint32),  # capacity (1024)
        ("padding", ctypes.c_uint64),     # alignment
    ]

class ParsedFlowEvent(NamedTuple):
    """Parsed event (Pythonic)"""
    type: str  # "SOURCE" or "SINK"
    id: int
    timestamp_ns: int
    data_hash: int
    data_size: int

class ParsedExecution(NamedTuple):
    """Complete execution data"""
    pid: int
    events: List[ParsedFlowEvent]
    coverage: bytes  # raw coverage map
```

### Event Processing Structures

```python
# event_processor.py - correlation results

class FlowCompletion(NamedTuple):
    """A completed flow instance"""
    flow_id: int
    source_event: ParsedFlowEvent
    sink_event: ParsedFlowEvent
    time_delta_ns: int
    intermediate_coverage: Set[int]  # locations hit

@dataclass
class ExecutionAnalysis:
    """Analysis results for one execution"""
    pid: int
    total_events: int
    source_events: List[ParsedFlowEvent]
    sink_events: List[ParsedFlowEvent]
    completed_flows: List[FlowCompletion]
    coverage_hits: Dict[int, int]  # loc_id → hit_count
    
    def to_dict(self) -> dict:
        """Convert to JSON-serializable dict"""
        # ... (see actual implementation)

class Statistics:
    """Aggregate statistics across executions"""
    total_executions: int
    total_events: int
    total_completed_flows: int
    completions_per_flow: Dict[int, int]
    coverage_per_flow: Dict[int, Set[int]]
    min_time_delta_ns: Optional[int]
    max_time_delta_ns: Optional[int]
    total_time_delta_ns: int
```

## Process Discovery

### Polling `/dev/shm/` (Current Implementation)

**Discovery-based approach - simple and reliable:**

```python
from pathlib import Path

def discover_executions(shm_dir: Path, flow_prefix: str = "flow_events_") -> List[int]:
    """
    Discover executions by scanning shared memory directory.
    Simply finds all files matching the prefix pattern.
    """
    pids = []
    
    for shm_file in shm_dir.glob(f"{flow_prefix}*"):
        try:
            pid_str = shm_file.name.replace(flow_prefix, "")
            pid = int(pid_str)
            pids.append(pid)
        except ValueError:
            # Skip non-numeric suffixes
            continue
    
    return sorted(pids)

# Main loop in monitor.py:
while running:
    pids = discover_executions(shm_dir)
    for pid in pids:
        try:
            process_execution(pid)
            if auto_cleanup:
                cleanup_execution(pid)
        except Exception as e:
            logger.error(f"Failed to process {pid}: {e}")
    
    time.sleep(poll_interval)  # Default: 100ms
```

**Key Points:**
- ✅ No PID tracking - PIDs are reused by OS, so tracking is unreliable
- ✅ Discovery-based - find files, process if they exist
- ✅ Once processed and cleaned up, files are deleted (no reprocessing)
- ✅ Works with any fuzzer - no cooperation needed
- ✅ Simple and portable

---

## Output Format

### JSONL (JSON Lines) - One Entry Per Execution

Each line is a complete JSON object with the execution analysis:

```json
{
  "timestamp": "2025-11-07T12:34:56.789Z",
  "execution": {
    "pid": 12345,
    "total_events": 6,
    "num_sources": 3,
    "num_sinks": 3,
    "completed_flows": [
      {
        "flow_id": 1,
        "source_id": 1,
        "sink_id": 1,
        "source_hash": "0x1234567890abcdef",
        "sink_hash": "0xfedcba0987654321",
        "source_size": 128,
        "sink_size": 64,
        "time_delta_ns": 54321,
        "time_delta_us": 54.321,
        "intermediate_coverage": [1, 2, 3]
      }
    ],
    "coverage": {
      "1": 5,
      "2": 3,
      "3": 1
    }
  }
}
```

**Field descriptions:**
- `timestamp`: ISO 8601 UTC timestamp when execution was processed
- `execution.pid`: Process ID
- `execution.total_events`: Total SOURCE + SINK events recorded
- `execution.num_sources`: Number of SOURCE events
- `execution.num_sinks`: Number of SINK events
- `execution.completed_flows`: Array of flows that were fully completed (source + sink + ALL intermediates covered)
  - `flow_id`: Flow definition ID from .flowdb
  - `source_id`/`sink_id`: Location IDs
  - `source_hash`/`sink_hash`: xxHash64 of the data at source/sink
  - `source_size`/`sink_size`: Original data sizes in bytes
  - `time_delta_ns`: Nanoseconds between source and sink events
  - `time_delta_us`: Microseconds between source and sink events
  - `intermediate_coverage`: List of intermediate location IDs that were hit
- `execution.coverage`: Map of location_id → hit_count for all covered intermediate locations

### Statistics Output (Logged Periodically)

The monitor logs human-readable statistics to the configured log output (default: stderr) at regular intervals (default: every 10 seconds). These are NOT written to the JSONL output file, but to the log stream.

Example log output:
```
[2025-11-07 12:35:00] INFO: 
=== Statistics ===
=== Execution Statistics ===
Total executions: 3
Total events: 18
  Sources: 9
  Sinks: 9
Completed flows: 3

Completions per flow:
  Flow 1: 1 completions
  Flow 2: 1 completions
  Flow 3: 1 completions

Timing:
  Min: 54.32 μs
  Max: 74.15 μs
  Avg: 62.19 μs
```

**Logged fields:**
- Total executions processed
- Total events (sources + sinks) observed
- Number of completed flows detected
- Per-flow completion counts
- Timing statistics (min/max/avg time between source→sink in microseconds)
---

## Configuration

### Configuration System

```yaml
# configs/default.yaml - Base configuration
shared_memory:
  shm_dir: "/dev/shm"
  flow_events_prefix: "flow_events_"
  coverage_prefix: "df_coverage_"
  poll_interval: 0.1  # 100ms

flow_database:
  database_path: null  # Required via CLI

output:
  format: "jsonl"
  destination: "-"  # stdout
  buffered: true
  flush_each: false

processing:
  max_executions: null  # Unlimited

logging:
  level: "INFO"
  format: "[%(asctime)s] %(levelname)s: %(message)s"
  destination: null  # stderr

statistics:
  print_interval: 10  # Print every 10 seconds
  print_summary: true

cleanup:
  auto_cleanup: true
  cleanup_on_startup: true
  cleanup_on_exit: false
```

### CLI Usage

```bash
# Basic usage with default config
./flow_monitor.py --flowdb flows.flowdb

# Use development config
./flow_monitor.py --flowdb flows.flowdb -c configs/development.yaml

# Override specific settings via CLI
./flow_monitor.py \
    --flowdb flows.flowdb \
    -c configs/production.yaml \
    --max-executions 1000 \
    --log-level DEBUG \
    --cleanup-on-exit

# Environment variable overrides
export FLOW_MONITOR_LOG_LEVEL=DEBUG
export FLOW_MONITOR_POLL_INTERVAL=0.05
./flow_monitor.py --flowdb flows.flowdb
```

### Configuration Priority

1. **CLI arguments** (highest priority)
2. **Environment variables** (`FLOW_MONITOR_*`)
3. **YAML config file**
4. **Python dataclass defaults** (lowest priority)

## Implementation Structure

```
sense/monitor/
├── README.md               # This file
├── __init__.py            # Package exports
├── flow_monitor.py        # CLI entry point (Click framework)
├── config.py              # Configuration management (YAML + inheritance)
├── monitor.py             # Main FlowMonitor service (polling loop)
├── flow_db.py             # FlowDatabase parser (.flowdb v1.1)
├── event_processor.py     # EventProcessor (correlation engine)
├── shm_protocol.py        # Shared memory parser (ctypes structures)
└── configs/
    ├── default.yaml       # Base configuration
    ├── development.yaml   # Debug mode (verbose, no cleanup)
    └── production.yaml    # Performance mode (file output, cleanup)
```

## Error Handling

1. **Buffer overflow**: Drop events, log warning
2. **Process crashed**: Partial data still readable from shared memory
3. **Missing .flowdb**: Fail fast with clear error
4. **Orphaned shared memory**: Cleanup utility to scan and remove old regions
5. **Hash collisions**: Accept as same data (probability ~10^-19)
6. **Malformed .flowdb**: Skip invalid lines, continue parsing
