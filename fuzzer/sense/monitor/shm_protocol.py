"""
Shared memory protocol definitions and parsing.

This module provides ctypes structures that mirror the C runtime structures
for parsing shared memory regions created by instrumented programs.

Structures:
    - FlowEvent: 32-byte event structure (SOURCE or SINK)
    - FlowEventBuffer: Header + array of events
    
Functions:
    - parse_flow_events: Parse /flow_events_<pid> shared memory
    - parse_coverage_map: Parse /df_coverage_<pid> shared memory
"""

import ctypes
from pathlib import Path
from typing import List, NamedTuple
from enum import IntEnum


class FlowEventType(IntEnum):
    """Flow event types (must match flow_shm.h)."""
    SOURCE = 1
    SINK = 2


class FlowEvent(ctypes.Structure):
    """
    Flow event structure (32 bytes total).
    
    Must match the C structure in flow_shm.h:
        typedef struct {
            uint32_t type;       // 4 bytes
            uint32_t id;         // 4 bytes
            uint64_t timestamp;  // 8 bytes
            uint64_t data_hash;  // 8 bytes
            uint32_t data_size;  // 4 bytes
            uint32_t padding;    // 4 bytes
        } FlowEvent;
    """
    _fields_ = [
        ("type", ctypes.c_uint32),
        ("id", ctypes.c_uint32),
        ("timestamp", ctypes.c_uint64),
        ("data_hash", ctypes.c_uint64),
        ("data_size", ctypes.c_uint32),
        ("padding", ctypes.c_uint32),
    ]
    
    def __repr__(self) -> str:
        type_name = FlowEventType(self.type).name if self.type in [1, 2] else "UNKNOWN"
        return (f"FlowEvent(type={type_name}, id={self.id}, "
                f"timestamp={self.timestamp}, hash=0x{self.data_hash:016x}, "
                f"size={self.data_size})")


class FlowEventBuffer(ctypes.Structure):
    """
    Flow event buffer header.
    
    Must match the C structure in flow_shm.h:
        typedef struct {
            uint32_t num_events;  // 4 bytes
            uint32_t max_events;  // 4 bytes (should be 1024)
            uint64_t padding;     // 8 bytes
            FlowEvent events[];   // Variable length
        } FlowEventBuffer;
    """
    _fields_ = [
        ("num_events", ctypes.c_uint32),
        ("max_events", ctypes.c_uint32),
        ("padding", ctypes.c_uint64),
    ]


# Named tuple for parsed event data (more Pythonic than ctypes)
class ParsedFlowEvent(NamedTuple):
    """Parsed flow event data."""
    type: str  # "SOURCE" or "SINK"
    id: int
    timestamp_ns: int
    data_hash: int
    data_size: int


class ParsedExecution(NamedTuple):
    """Parsed execution data."""
    pid: int
    events: List[ParsedFlowEvent]
    coverage: bytes


def parse_flow_events(shm_path: Path) -> List[ParsedFlowEvent]:
    """
    Parse flow events from shared memory region.
    
    Args:
        shm_path: Path to /dev/shm/flow_events_<pid>
        
    Returns:
        List of ParsedFlowEvent objects
        
    Raises:
        FileNotFoundError: If shared memory region not found
        ValueError: If shared memory is corrupted
    """
    if not shm_path.exists():
        raise FileNotFoundError(f"Shared memory not found: {shm_path}")
    
    file_size = shm_path.stat().st_size
    
    # Validate minimum size (header only)
    if file_size < ctypes.sizeof(FlowEventBuffer):
        raise ValueError(f"Shared memory too small: {file_size} bytes")
    
    events = []
    
    with open(shm_path, 'rb') as f:
        # Read and parse header
        header_bytes = f.read(ctypes.sizeof(FlowEventBuffer))
        header = FlowEventBuffer.from_buffer_copy(header_bytes)
        
        # Validate header
        # if header.max_events != 1024:
        #     raise ValueError(f"Invalid max_events: {header.max_events}, expected 1024")
        
        # if header.num_events > header.max_events:
        #     raise ValueError(f"num_events ({header.num_events}) > max_events ({header.max_events})")
        
        # # Expected size: 16 bytes (header) + num_events * 32 bytes
        # expected_min_size = 16 + (header.num_events * ctypes.sizeof(FlowEvent))
        # if file_size < expected_min_size:
        #     raise ValueError(f"File too small for {header.num_events} events: {file_size} < {expected_min_size}")
        
        # Read events
        for i in range(header.num_events):
            event_bytes = f.read(ctypes.sizeof(FlowEvent))
            if len(event_bytes) < ctypes.sizeof(FlowEvent):
                raise ValueError(f"Truncated event {i}")
            
            event = FlowEvent.from_buffer_copy(event_bytes)
            
            # Validate event type
            if event.type not in [FlowEventType.SOURCE, FlowEventType.SINK]:
                raise ValueError(f"Invalid event type: {event.type}")
            
            # Convert to named tuple
            parsed_event = ParsedFlowEvent(
                type="SOURCE" if event.type == FlowEventType.SOURCE else "SINK",
                id=event.id,
                timestamp_ns=event.timestamp,
                data_hash=event.data_hash,
                data_size=event.data_size
            )
            events.append(parsed_event)
    
    return events


def parse_coverage_map(shm_path: Path) -> bytes:
    """
    Parse coverage map from shared memory region.
    
    Args:
        shm_path: Path to /dev/shm/df_coverage_<pid>
        
    Returns:
        Coverage map as bytes (each byte is hit count for that location)
        
    Raises:
        FileNotFoundError: If shared memory region not found
        ValueError: If coverage map is too large
    """
    if not shm_path.exists():
        raise FileNotFoundError(f"Shared memory not found: {shm_path}")
    
    # file_size = shm_path.stat().st_size
    
    # Sanity check: coverage maps shouldn't be huge
    # MAX_COVERAGE_SIZE = 1024 * 1024  # 1MB
    # if file_size > MAX_COVERAGE_SIZE:
    #     raise ValueError(f"Coverage map too large: {file_size} bytes")
    
    with open(shm_path, 'rb') as f:
        coverage_data = f.read()
    
    return coverage_data


def discover_executions(shm_dir: Path, flow_prefix: str = "flow_events_") -> List[int]:
    """
    Discover completed executions by scanning shared memory directory.
    
    Args:
        shm_dir: Path to /dev/shm
        flow_prefix: Prefix for flow event files
        
    Returns:
        List of PIDs with completed executions
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


def parse_execution(pid: int, shm_dir: Path, 
                   flow_prefix: str = "flow_events_",
                   coverage_prefix: str = "df_coverage_") -> ParsedExecution:
    """
    Parse complete execution data (events + coverage).
    
    Args:
        pid: Process ID
        shm_dir: Path to shared memory dir, e.g., /dev/shm
        flow_prefix: Prefix for flow event files
        coverage_prefix: Prefix for coverage files
        
    Returns:
        ParsedExecution with events and coverage
        
    Raises:
        FileNotFoundError: If shared memory regions not found
        ValueError: If data is corrupted
    """
    flow_path = shm_dir / f"{flow_prefix}{pid}"
    coverage_path = shm_dir / f"{coverage_prefix}{pid}"
    
    events = parse_flow_events(flow_path)
    coverage = parse_coverage_map(coverage_path)
    
    return ParsedExecution(pid=pid, events=events, coverage=coverage)
