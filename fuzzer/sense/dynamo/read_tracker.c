// read_tracker.c
// Core read tracking logic implementation

#include "read_tracker.h"
#include "drmgr.h"
#include "drsyms.h"
#include "drutil.h"
#include "drwrap.h"
#include "marker_common.h"
#include <string.h>

/* --- Module-level TLS index --- */

static int g_tls_idx = -1;

/* --- Read tracker API implementation --- */

void read_tracker_set_tls_index(int idx) { g_tls_idx = idx; }

/* --- Per-thread lifecycle --- */

void read_tracker_init(read_tracker_t *tracker) {
  memset(tracker, 0, sizeof(read_tracker_t));
}

void read_tracker_cleanup(read_tracker_t *tracker) {
  // Clean up if tracking is still active
  if (tracker->active && tracker->read_mask != NULL) {
    dr_global_free(tracker->read_mask, tracker->region_size);
    tracker->read_mask = NULL;
  }
  tracker->active = false;
}

/* --- Marker function wrappers --- */

void pre_start_tracking_sink(void *wrapcxt, void **user_data) {
  void *drcontext = drwrap_get_drcontext(wrapcxt);
  read_tracker_t *tracker =
      (read_tracker_t *)drmgr_get_tls_field(drcontext, g_tls_idx);

  if (tracker == NULL) {
    dr_fprintf(STDERR, "[DR] ERROR: NULL tracker in start_tracking\n");
    return;
  }

  if (tracker->active) {
    dr_fprintf(STDERR,
               "[DR] WARNING: start_tracking called while already active\n");
    return;
  }

  // Extract arguments: sink_id, ptr (no len - we do dynamic lookup)
  uint32_t sink_id = (uint32_t)(size_t)drwrap_get_arg(wrapcxt, 0);
  const byte *ptr = (const byte *)drwrap_get_arg(wrapcxt, 1);

  // Find the allocation containing this pointer (dynamic lookup)
  app_pc base = NULL;
  size_t size = 0;
  if (!find_alloc_containing((app_pc)ptr, &base, &size)) {
    dr_fprintf(STDERR, "[DR] WARNING: ptr not in tracked heap, skipping\n");
    return;
  }

  // Calculate offset from base (ptr may not be base address)
  size_t offset = (size_t)((app_pc)ptr - base);

  dr_fprintf(STDERR,
             "[DR] Start tracking sink_id=%u ptr=%p (base=%p, offset=%zu, "
             "alloc_size=%zu)\n",
             sink_id, ptr, base, offset, size);

  // Set up tracking state (track full allocation)
  tracker->active = true;
  tracker->sink_id = sink_id;
  tracker->region_base = base;
  tracker->region_size = size;
  tracker->ptr_offset_addr = (app_pc)ptr;
  tracker->ptr_offset = offset;
  tracker->read_mask = dr_global_alloc(size);
  tracker->memread_calls = 0;
  tracker->memread_hits = 0;
  memset(tracker->read_mask, 0, size);
}

void pre_end_tracking_sink(void *wrapcxt, void **user_data) {
  void *drcontext = drwrap_get_drcontext(wrapcxt);
  read_tracker_t *tracker =
      (read_tracker_t *)drmgr_get_tls_field(drcontext, g_tls_idx);

  if (tracker == NULL || !tracker->active) {
    dr_fprintf(STDERR, "[DR] ERROR: end_tracking without matching start\n");
    return;
  }

  uint32_t sink_id = (uint32_t)(size_t)drwrap_get_arg(wrapcxt, 0);

  if (tracker->sink_id != sink_id) {
    dr_fprintf(STDERR,
               "[DR] WARNING: mismatched sink_id (expected %u, got %u)\n",
               tracker->sink_id, sink_id);
  }

  dr_fprintf(STDERR, "[DR] on_mem_read calls=%u hits=%u\n",
             tracker->memread_calls, tracker->memread_hits);

  // Store sink_id in user_data for post callback
  *user_data = (void *)(size_t)sink_id;
}

void post_end_tracking_sink(void *wrapcxt, void *user_data) {
  void *drcontext = drwrap_get_drcontext(wrapcxt);
  read_tracker_t *tracker =
      (read_tracker_t *)drmgr_get_tls_field(drcontext, g_tls_idx);

  if (tracker == NULL || !tracker->active) {
    drwrap_set_retval(wrapcxt, (void *)0);
    return;
  }

  uint32_t sink_id = (uint32_t)(size_t)user_data;

  // Count bytes read in full allocation
  size_t bytes_read_full = 0;
  size_t first_full = tracker->region_size, last_full = 0;

  // Count bytes read from offset onwards
  size_t bytes_read_from_offset = 0;
  size_t first_from_offset = tracker->region_size, last_from_offset = 0;
  size_t max_distance_from_offset = 0;

  for (size_t i = 0; i < tracker->region_size; ++i) {
    if (tracker->read_mask[i]) {
      bytes_read_full++;
      if (i < first_full)
        first_full = i;
      if (i > last_full)
        last_full = i;

      // Track reads from offset onwards
      if (i >= tracker->ptr_offset) {
        bytes_read_from_offset++;
        if (i < first_from_offset)
          first_from_offset = i;
        if (i > last_from_offset)
          last_from_offset = i;

        // Calculate distance from offset
        size_t distance = i - tracker->ptr_offset + 1;
        if (distance > max_distance_from_offset)
          max_distance_from_offset = distance;
      }
    }
  }

  dr_fprintf(STDERR,
             "[DR] End tracking sink_id=%u: read %zu bytes in full allocation "
             "[%p .. %p) (size=%zu)\n",
             sink_id, bytes_read_full, tracker->region_base,
             tracker->region_base + tracker->region_size, tracker->region_size);

  if (bytes_read_full > 0) {
    dr_fprintf(STDERR, "[DR]   Full alloc: first offset=%zu, last offset=%zu\n",
               first_full, last_full);
  }

  if (tracker->ptr_offset > 0) {
    dr_fprintf(STDERR,
               "[DR]   From ptr offset=%zu: read %zu bytes, max distance=%zu\n",
               tracker->ptr_offset, bytes_read_from_offset,
               max_distance_from_offset);
  } else {
    dr_fprintf(STDERR, "[DR]   Max distance from ptr: %zu\n",
               max_distance_from_offset);
  }

  // Set return value: max distance from offset (MUST be in post callback!)
  drwrap_set_retval(wrapcxt, (void *)max_distance_from_offset);

  // Free read mask and deactivate
  dr_global_free(tracker->read_mask, tracker->region_size);
  tracker->read_mask = NULL;
  tracker->active = false;
}

void wrap_sink_markers(const module_data_t *info, const char *module_name) {
  /* Wrap marker functions: __dr_start_tracking_sink */
  // Markers are not exported, lookup via debug symbols
  drsym_error_t symres;
  app_pc f;
  symres = drsym_lookup_symbol(info->full_path, "__dr_start_tracking_sink",
                               (size_t *)&f, DRSYM_DEFAULT_FLAGS);
  if (symres == DRSYM_SUCCESS) {
    f = info->start + (size_t)f;
    if (drwrap_wrap_ex(f, pre_start_tracking_sink, NULL, NULL, 0)) {
      dr_fprintf(STDERR, "[DR] Wrapped __dr_start_tracking_sink at %p in %s\n",
                 f, module_name);
    }
  }

  /* Wrap marker functions: __dr_end_tracking_sink */
  // Markers are not exported, lookup via debug symbols
  symres = drsym_lookup_symbol(info->full_path, "__dr_end_tracking_sink",
                               (size_t *)&f, DRSYM_DEFAULT_FLAGS);
  if (symres == DRSYM_SUCCESS) {
    f = info->start + (size_t)f;
    // Need post callback to set return value!
    if (drwrap_wrap_ex(f, pre_end_tracking_sink, post_end_tracking_sink, NULL,
                       0)) {
      dr_fprintf(STDERR, "[DR] Wrapped __dr_end_tracking_sink at %p in %s\n", f,
                 module_name);
    }
  }
}

/* --- Memory read callback --- */

void on_mem_read(app_pc addr, uint size) {
  void *drcontext = dr_get_current_drcontext();
  read_tracker_t *tracker =
      (read_tracker_t *)drmgr_get_tls_field(drcontext, g_tls_idx);

  if (tracker)
    tracker->memread_calls++; // count even if we bail

  if (tracker == NULL || !tracker->active || tracker->read_mask == NULL)
    return;

  app_pc start = addr;
  app_pc end = addr + size;

  app_pc reg_start = tracker->region_base;
  app_pc reg_end = tracker->region_base + tracker->region_size;

  if (end <= reg_start || start >= reg_end)
    return; // no overlap

  tracker->memread_hits++; // overlaps tracked region

  // Calculate overlapping range
  size_t off_start = (size_t)(start < reg_start ? 0 : start - reg_start);
  size_t off_end =
      (size_t)(end > reg_end ? tracker->region_size : end - reg_start);

  for (size_t i = off_start; i < off_end; ++i) {
    tracker->read_mask[i] = 1;
  }
}

/* --- TLS getter --- */
read_tracker_t *get_read_tracker_thread_data(void *drcontext) {
  return (read_tracker_t *)drmgr_get_tls_field(drcontext, g_tls_idx);
}

/* --- Instrumentation helper --- */

bool read_instrument_mem_access_naive(void *drcontext, instrlist_t *bb,
                                      instr_t *instr) {
  /* Fast reject: ignore instructions that do not read memory. */
  if (!instr_reads_memory(instr))
    return false;

  /* For each explicit memory-read operand, insert a clean call. */
  int num_srcs = instr_num_srcs(instr);
  bool instrumented = false;

  for (int i = 0; i < num_srcs; ++i) {
    opnd_t src = instr_get_src(instr, i);
    if (!opnd_is_memory_reference(src))
      continue;

    /* Compute effective address (EA) into RCX. */
    reg_id_t reg = DR_REG_XCX;
    dr_save_reg(drcontext, bb, instr, reg, SPILL_SLOT_1);
    drutil_insert_get_mem_addr(drcontext, bb, instr, src, reg, SPILL_SLOT_2);

    /* Insert clean call: on_mem_read(addr, size). */
    uint mem_size = opnd_size_in_bytes(opnd_get_size(src));
    dr_insert_clean_call(drcontext, bb, instr, (void *)on_mem_read, false, 2,
                         opnd_create_reg(reg), OPND_CREATE_INT32(mem_size));

    /* Restore RCX for the application instruction stream. */
    dr_restore_reg(drcontext, bb, instr, reg, SPILL_SLOT_1);
    instrumented = true;
  }

  return instrumented;
}