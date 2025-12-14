// read_tracker.h
// Core read tracking logic for DynamoRIO marker-based instrumentation

#ifndef READ_TRACKER_H
#define READ_TRACKER_H

#include "dr_api.h"
#include <stddef.h>
#include <stdint.h>

/* --- Read tracker state --- */

typedef struct {
  bool active;            // Is tracking currently active?
  uint32_t sink_id;       // Current sink ID
  app_pc region_base;     // Base address of tracked allocation
  size_t region_size;     // Size of tracked allocation
  app_pc ptr_offset_addr; // Original ptr passed (may be base + offset)
  size_t ptr_offset;      // Offset from base (ptr - base)
  byte *read_mask;        // Byte-level read tracking (for full allocation)
  /* debug counters */
  uint64_t memread_calls;
  uint64_t memread_hits;
} read_tracker_t;

/* --- Read tracker API --- */

/**
 * Set the TLS field index for tracker access.
 * Must be called once during client initialization before using tracker
 * functions.
 * @param idx TLS field index registered with drmgr
 */
void read_tracker_set_tls_index(int idx);

/**
 * Initialize a read tracker instance.
 * Call this once per thread during thread initialization.
 * @param tracker Tracker instance to initialize
 */
void read_tracker_init(read_tracker_t *tracker);

/**
 * Clean up a read tracker instance.
 * Call this during thread exit to free any allocated resources.
 * @param tracker Tracker instance to clean up
 */
void read_tracker_cleanup(read_tracker_t *tracker);

/**
 * Start tracking reads for a heap allocation.
 * Wrapper function for __dr_start_tracking_sink marker.
 * Compatible with drwrap pre-callback signature.
 * @param wrapcxt DynamoRIO wrap context
 * @param user_data User data pointer (unused)
 */
void pre_start_tracking_sink(void *wrapcxt, void **user_data);

/**
 * Prepare to end tracking (pre-callback).
 * Wrapper function for __dr_end_tracking_sink marker (pre-phase).
 * Compatible with drwrap pre-callback signature.
 * @param wrapcxt DynamoRIO wrap context
 * @param user_data User data pointer (stores sink_id for post-callback)
 */
void pre_end_tracking_sink(void *wrapcxt, void **user_data);

/**
 * Finish tracking and compute results (post-callback).
 * Wrapper function for __dr_end_tracking_sink marker (post-phase).
 * Sets the return value to the max distance from the original pointer.
 * Compatible with drwrap post-callback signature.
 * @param wrapcxt DynamoRIO wrap context
 * @param user_data User data from pre-callback (sink_id)
 */
void post_end_tracking_sink(void *wrapcxt, void *user_data);

/**
 * Wrap sink marker functions in the given module (if present).
 * @param info Module information from event_module_load
 * @param module_name Name of the module (for logging)
 */
void wrap_sink_markers(const module_data_t *info, const char *module_name);

/**
 * Record a memory read operation.
 * Analysis callback invoked by instrumentation for each memory read.
 * Call this from your instrumentation code (clean call or inline).
 * @param addr Address being read
 * @param size Number of bytes being read
 */
void on_mem_read(app_pc addr, uint size);

/**
 * Insert read instrumentation for a single instruction (naive approach).
 * Inserts clean calls to on_mem_read for each memory read operand.
 * This function can be called from a client's event_app_instruction callback.
 * 
 * @param drcontext DynamoRIO context
 * @param bb Basic block instrlist
 * @param instr Instruction to instrument
 * @return true if instrumentation was inserted, false otherwise
 */
bool read_instrument_mem_access_naive(void *drcontext, instrlist_t *bb,
                                       instr_t *instr);

/* --- TLS getter ---*/
read_tracker_t *get_read_tracker_thread_data(void *drcontext);

#endif /* READ_TRACKER_H */
