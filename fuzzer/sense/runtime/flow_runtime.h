#pragma once
#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

// Flow tracking runtime - monitors taint sources and sinks
// Communicates with external monitoring service via shared memory or IPC

// Initialize flow tracking runtime
// Call this once at program startup (optional - auto-initialized on first use)
void flow_init(void);

// Cleanup flow tracking runtime
// Call this at program exit to flush any pending data
void flow_shutdown(void);

// Report a taint source event
// Called when data enters the program from an untrusted source
// Parameters:
//   data: pointer to the tainted data
//   size: size of the tainted data in bytes
//   src_id: unique source ID from SARIF analysis
void flow_report_source(void *data, size_t size, int src_id);

// Report a taint sink event
// Called when tainted data reaches a sensitive sink
// Parameters:
//   data: pointer to the data at the sink
//   size: size of the data in bytes
//   sink_id: unique sink ID from SARIF analysis
void flow_report_sink(void *data, size_t size, int sink_id);

// Compatibility aliases for LLVM pass (maintains existing function names)
void sample_report_source(void *data, int size, int src_id);
void sample_report_sink(void *data, int size, int sink_id);

#ifdef __cplusplus
}
#endif
