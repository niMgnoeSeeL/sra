// write_tracker.c
// Core write tracking logic implementation

#include "write_tracker.h"
#include "drmgr.h"
#include "drsyms.h"
#include "drutil.h"
#include "drwrap.h"
#include "marker_common.h"
#include <string.h>

/* --- Module-level state --- */

static int g_tls_idx = -1; // TLS slot index (set by client)

/* --- Write tracker API implementation --- */

void write_tracker_set_tls_index(int tls_idx) { g_tls_idx = tls_idx; }

/* --- Per-thread lifecycle --- */

void write_tracker_init(write_tracker_t *tdata) {
  memset(tdata, 0, sizeof(write_tracker_t));
}

void write_tracker_cleanup(write_tracker_t *tdata) {
  // Clean up if tracking is still active
  if (tdata->active && tdata->write_mask != NULL) {
    dr_global_free(tdata->write_mask, tdata->region_size);
    tdata->write_mask = NULL;
  }
}

/* --- Marker function wrappers --- */

void pre_start_tracking_src(void *wrapcxt, void **user_data) {
  void *drcontext = drwrap_get_drcontext(wrapcxt);
  write_tracker_t *tdata = get_write_tracker_thread_data(drcontext);

  if (tdata == NULL) {
    dr_fprintf(STDERR, "[DR] ERROR: NULL thread data in start_tracking\n");
    return;
  }

  if (tdata->active) {
    dr_fprintf(STDERR,
               "[DR] WARNING: start_tracking called while already active\n");
    return;
  }

  // Extract arguments: src_id, ptr (no len - we do dynamic lookup)
  uint32_t src_id = (uint32_t)(size_t)drwrap_get_arg(wrapcxt, 0);
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
             "[DR] Start tracking src=%u ptr=%p (base=%p, offset=%zu, "
             "alloc_size=%zu)\n",
             src_id, ptr, base, offset, size);

  // Set up tracking state (track full allocation)
  tdata->active = true;
  tdata->src_id = src_id;
  tdata->region_base = base;
  tdata->region_size = size;
  tdata->ptr_offset_addr = (app_pc)ptr;
  tdata->ptr_offset = offset;
  tdata->write_mask = dr_global_alloc(size);
  tdata->memwrite_calls = 0;
  tdata->memwrite_hits = 0;
  memset(tdata->write_mask, 0, size);
}

void pre_end_tracking_src(void *wrapcxt, void **user_data) {
  void *drcontext = drwrap_get_drcontext(wrapcxt);
  write_tracker_t *tdata = get_write_tracker_thread_data(drcontext);

  if (tdata == NULL || !tdata->active) {
    dr_fprintf(STDERR, "[DR] ERROR: end_tracking without matching start\n");
    return;
  }

  uint32_t src_id = (uint32_t)(size_t)drwrap_get_arg(wrapcxt, 0);

  if (tdata->src_id != src_id) {
    dr_fprintf(STDERR,
               "[DR] WARNING: mismatched src_id (expected %u, got %u)\n",
               tdata->src_id, src_id);
  }

  dr_fprintf(STDERR, "[DR] on_mem_write calls=%llu hits=%llu\n",
             tdata->memwrite_calls, tdata->memwrite_hits);

  // Store src_id in user_data for post callback
  *user_data = (void *)(size_t)src_id;
}

void post_end_tracking_src(void *wrapcxt, void *user_data) {
  void *drcontext = drwrap_get_drcontext(wrapcxt);
  write_tracker_t *tdata = get_write_tracker_thread_data(drcontext);

  if (tdata == NULL || !tdata->active) {
    drwrap_set_retval(wrapcxt, (void *)0);
    return;
  }

  uint32_t src_id = (uint32_t)(size_t)user_data;

  // Count bytes written in full allocation
  size_t bytes_write_full = 0;
  size_t first_full = tdata->region_size, last_full = 0;

  // Count bytes written from offset onwards
  size_t bytes_write_from_offset = 0;
  size_t first_from_offset = tdata->region_size, last_from_offset = 0;
  size_t max_distance_from_offset = 0;

  for (size_t i = 0; i < tdata->region_size; ++i) {
    if (tdata->write_mask[i]) {
      bytes_write_full++;
      if (i < first_full)
        first_full = i;
      if (i > last_full)
        last_full = i;

      // Track writes from offset onwards
      if (i >= tdata->ptr_offset) {
        bytes_write_from_offset++;
        if (i < first_from_offset)
          first_from_offset = i;
        if (i > last_from_offset)
          last_from_offset = i;

        // Calculate distance from offset
        size_t distance = i - tdata->ptr_offset + 1;
        if (distance > max_distance_from_offset)
          max_distance_from_offset = distance;
      }
    }
  }

  dr_fprintf(STDERR,
             "[DR] End tracking src_id=%u: write %zu bytes in full allocation "
             "[%p .. %p) (size=%zu)\n",
             src_id, bytes_write_full, tdata->region_base,
             tdata->region_base + tdata->region_size, tdata->region_size);

  if (bytes_write_full > 0) {
    dr_fprintf(STDERR, "[DR]   Full alloc: first offset=%zu, last offset=%zu\n",
               first_full, last_full);
  }

  if (tdata->ptr_offset > 0) {
    dr_fprintf(
        STDERR,
        "[DR]   From ptr offset=%zu: write %zu bytes, max distance=%zu\n",
        tdata->ptr_offset, bytes_write_from_offset, max_distance_from_offset);
  } else {
    dr_fprintf(STDERR, "[DR]   Max distance from ptr: %zu\n",
               max_distance_from_offset);
  }

  // Set return value: max distance from offset (MUST be in post callback!)
  drwrap_set_retval(wrapcxt, (void *)max_distance_from_offset);

  // Free write mask and deactivate
  dr_global_free(tdata->write_mask, tdata->region_size);
  tdata->write_mask = NULL;
  tdata->active = false;
}

void wrap_src_markers(const module_data_t *info, const char *module_name) {
  /* Wrap marker functions: __dr_start_tracking_src */
  // Markers are not exported, lookup via debug symbols
  app_pc f;
  drsym_error_t symres;
  symres = drsym_lookup_symbol(info->full_path, "__dr_start_tracking_src",
                               (size_t *)&f, DRSYM_DEFAULT_FLAGS);
  if (symres == DRSYM_SUCCESS) {
    f = info->start + (size_t)f;
    if (drwrap_wrap_ex(f, pre_start_tracking_src, NULL, NULL, 0)) {
      dr_fprintf(STDERR, "[DR] Wrapped __dr_start_tracking_src at %p in %s\n",
                 f, module_name);
    }
  }

  /* Wrap marker functions: __dr_end_tracking_src */
  // Markers are not exported, lookup via debug symbols
  symres = drsym_lookup_symbol(info->full_path, "__dr_end_tracking_src",
                               (size_t *)&f, DRSYM_DEFAULT_FLAGS);
  if (symres == DRSYM_SUCCESS) {
    f = info->start + (size_t)f;
    // Need post callback to set return value!
    if (drwrap_wrap_ex(f, pre_end_tracking_src, post_end_tracking_src, NULL,
                       0)) {
      dr_fprintf(STDERR, "[DR] Wrapped __dr_end_tracking_src at %p in %s\n", f,
                 module_name);
    }
  }
}

/* --- Memory write callback --- */

void on_mem_write(app_pc addr, uint size) {
  void *drcontext = dr_get_current_drcontext();
  write_tracker_t *tdata = get_write_tracker_thread_data(drcontext);

  if (tdata)
    tdata->memwrite_calls++; // count even if we bail

  if (tdata == NULL || !tdata->active || tdata->write_mask == NULL)
    return;

  app_pc start = addr;
  app_pc end = addr + size;

  app_pc reg_start = tdata->region_base;
  app_pc reg_end = tdata->region_base + tdata->region_size;

  if (end <= reg_start || start >= reg_end)
    return; // no overlap

  tdata->memwrite_hits++; // overlaps tracked region

  // Calculate overlapping range
  size_t off_start = (size_t)(start < reg_start ? 0 : start - reg_start);
  size_t off_end =
      (size_t)(end > reg_end ? tdata->region_size : end - reg_start);

  for (size_t i = off_start; i < off_end; ++i) {
    tdata->write_mask[i] = 1;
  }
}

/* --- TLS getter --- */
write_tracker_t *get_write_tracker_thread_data(void *drcontext) {
  return (write_tracker_t *)drmgr_get_tls_field(drcontext, g_tls_idx);
}

/* --- Instrumentation helper --- */

bool write_instrument_mem_access_naive(void *drcontext, instrlist_t *bb,
                                       instr_t *instr) {
  /* Fast reject: ignore instructions that do not write memory. */
  if (!instr_writes_memory(instr))
    return false;

  /* For each explicit memory-write operand (destination), insert a clean call.
   */
  int num_dsts = instr_num_dsts(instr);
  bool instrumented = false;

  for (int i = 0; i < num_dsts; ++i) {
    opnd_t dst = instr_get_dst(instr, i);
    if (!opnd_is_memory_reference(dst))
      continue;

    /* Compute effective address (EA) into RCX. */
    reg_id_t reg = DR_REG_XCX;
    dr_save_reg(drcontext, bb, instr, reg, SPILL_SLOT_1);
    drutil_insert_get_mem_addr(drcontext, bb, instr, dst, reg, SPILL_SLOT_2);

    /* Insert clean call: on_mem_write(addr, size). */
    uint mem_size = opnd_size_in_bytes(opnd_get_size(dst));
    dr_insert_clean_call(drcontext, bb, instr, (void *)on_mem_write, false, 2,
                         opnd_create_reg(reg), OPND_CREATE_INT32(mem_size));

    /* Restore RCX for the application instruction stream. */
    dr_restore_reg(drcontext, bb, instr, reg, SPILL_SLOT_1);
    instrumented = true;
  }

  return instrumented;
}