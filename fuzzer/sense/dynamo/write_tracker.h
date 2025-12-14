// write_tracker.h
// Core write tracking logic extracted for reuse

#ifndef WRITE_TRACKER_H
#define WRITE_TRACKER_H

#include "dr_api.h"
#include <stddef.h>
#include <stdint.h>

/* --- Per-thread write tracking state --- */

typedef struct {
  bool active;            // Is tracking currently active?
  uint32_t src_id;        // Current source ID
  app_pc region_base;     // Base address of tracked allocation
  size_t region_size;     // Size of tracked allocation
  app_pc ptr_offset_addr; // Original ptr passed (may be base + offset)
  size_t ptr_offset;      // Offset from base (ptr - base)
  byte *write_mask;       // Byte-level write tracking (for full allocation)
  /* debug counters */
  uint64_t memwrite_calls;
  uint64_t memwrite_hits;
} write_tracker_t;

/* --- Module configuration --- */

// Set the TLS index for this module (called once during client init)
void write_tracker_set_tls_index(int tls_idx);

/* --- Per-thread lifecycle --- */

// Initialize write tracker state (called per-thread)
void write_tracker_init(write_tracker_t *tdata);

// Clean up write tracker resources (called per-thread)
void write_tracker_cleanup(write_tracker_t *tdata);

/* --- Marker function wrappers --- */

// Called before __dr_start_tracking_src
void pre_start_tracking_src(void *wrapcxt, void **user_data);

// Called before __dr_end_tracking_src
void pre_end_tracking_src(void *wrapcxt, void **user_data);

// Called after __dr_end_tracking_src (sets return value)
void post_end_tracking_src(void *wrapcxt, void *user_data);

// Called to wrap src marker functions in a module
void wrap_src_markers(const module_data_t *info, const char *module_name);

/* --- Memory write callback --- */

// Called for each memory write when tracking is active
void on_mem_write(app_pc addr, uint size);

/**
 * Insert write instrumentation for a single instruction (naive approach).
 * Inserts clean calls to on_mem_write for each memory write operand.
 * This function can be called from a client's event_app_instruction callback.
 *
 * @param drcontext DynamoRIO context
 * @param bb Basic block instrlist
 * @param instr Instruction to instrument
 * @return true if instrumentation was inserted, false otherwise
 */
bool write_instrument_mem_access_naive(void *drcontext, instrlist_t *bb,
                                       instr_t *instr);

/* --- TLS getter ---*/
write_tracker_t *get_write_tracker_thread_data(void *drcontext);

#endif // WRITE_TRACKER_H
