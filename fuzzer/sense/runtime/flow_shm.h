//===----------------------------------------------------------------------===//
// flow_shm.h - Shared memory protocol for flow event tracking
//===----------------------------------------------------------------------===//
//
// This header defines the shared memory structures used for communication
// between the instrumented program and the monitor service.
//
// Two shared memory regions per execution:
//   1. /flow_events_<pid> - Flow source/sink events
//   2. /df_coverage_<pid> - Coverage map (defined in df_coverage_runtime.h)
//
//===----------------------------------------------------------------------===//

#ifndef FLOW_SHM_H
#define FLOW_SHM_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

// Event types
#define FLOW_EVENT_SOURCE 1
#define FLOW_EVENT_SINK 2

// Default buffer capacity (1024 events = ~32 KB)
#define FLOW_EVENT_MAX_EVENTS 1024

// Flow event structure (32 bytes)
typedef struct {
  uint32_t type;      // FLOW_EVENT_SOURCE or FLOW_EVENT_SINK
  uint32_t id;        // source_id or sink_id
  uint64_t timestamp; // monotonic nanoseconds (for debugging)
  uint64_t data_hash; // xxHash64 of the data
  uint32_t data_size; // Original data size in bytes
  uint32_t padding;   // Alignment to 8-byte boundary
} FlowEvent;

// Shared memory buffer for flow events (one per execution)
typedef struct {
  uint32_t num_events; // Number of events written (atomic)
  uint32_t max_events; // Capacity (typically 1024)
  uint32_t completed;  // Set to 1 when program exits (atomic)
  uint32_t padding;    // Alignment
  FlowEvent events[];  // Flexible array member
} FlowEventBuffer;

// Calculate total size of flow event buffer
static inline size_t flow_event_buffer_size(uint32_t max_events) {
  return sizeof(FlowEventBuffer) + (sizeof(FlowEvent) * max_events);
}

#ifdef __cplusplus
}
#endif

#endif // FLOW_SHM_H
