// track_writes_marker.c
// Production DynamoRIO client using marker functions for LLVM pass integration
// Supports: multi-threading, nested sinks, selective instrumentation

#include "dr_api.h"
#include "dr_modules.h"
#include "drmgr.h"
#include "drsyms.h"
#include "drutil.h"
#include "drwrap.h"
#include <stddef.h>
#include <stdint.h>
#include <string.h>

/* Select instrumentation mode: naive or inline_guard */
// #define event_app_instruction event_app_instruction_inline_guard
#define event_app_instruction event_app_instruction_naive

/* --- Forward declarations --- */
static void event_exit(void);
static void event_thread_init(void *drcontext);
static void event_thread_exit(void *drcontext);
static void event_module_load(void *drcontext, const module_data_t *info,
                              bool loaded);
static dr_emit_flags_t
event_app_instruction_naive(void *drcontext, void *tag, instrlist_t *bb,
                            instr_t *instr, bool for_trace, bool translating,
                            void *user_data);
static dr_emit_flags_t
event_app_instruction_inline_guard(void *drcontext, void *tag, instrlist_t *bb,
                                   instr_t *instr, bool for_trace,
                                   bool translating, void *user_data);

/* --- Per-thread state --- */

typedef struct {
  bool active;            // Is tracking currently active?
  uint32_t src_id;        // Current sink ID
  app_pc region_base;     // Base address of tracked allocation
  size_t region_size;     // Size of tracked allocation
  app_pc ptr_offset_addr; // Original ptr passed (may be base + offset)
  size_t ptr_offset;      // Offset from base (ptr - base)
  byte *write_mask;       // Byte-level write tracking (for full allocation)
  /* debug counters */
  uint64_t memwrite_calls;
  uint64_t memwrite_hits;
} per_thread_data_t;

static int tls_idx = -1; // TLS slot index

/* --- Global allocation tracking --- */

typedef struct alloc_rec_t {
  app_pc base;
  size_t size;
} alloc_rec_t;

#define MAX_ALLOCS 4096
static alloc_rec_t g_allocs[MAX_ALLOCS];
static int g_alloc_count = 0;
static void *g_alloc_lock; // Mutex for thread-safe allocation tracking

/* --- Marker function addresses --- */
static app_pc g_start_marker_addr = NULL;
static app_pc g_end_marker_addr = NULL;

/* Module black-list for instrumentation */
typedef struct {
  app_pc start, end;
} mod_range_t;

static mod_range_t g_skip_mods[256];
static int g_skip_mods_n = 0;
static void *g_skip_mods_lock;

static bool pc_in_skip_module(app_pc pc) {
  bool hit = false;
  dr_mutex_lock(g_skip_mods_lock);
  for (int i = 0; i < g_skip_mods_n; i++) {
    if (pc >= g_skip_mods[i].start && pc < g_skip_mods[i].end) {
      hit = true;
      break;
    }
  }
  dr_mutex_unlock(g_skip_mods_lock);
  return hit;
}

/* --- Allocation tracking (thread-safe) --- */

static void record_alloc(app_pc base, size_t size) {
  if (base == NULL)
    return;

  dr_mutex_lock(g_alloc_lock);
  if (g_alloc_count < MAX_ALLOCS) {
    g_allocs[g_alloc_count].base = base;
    g_allocs[g_alloc_count].size = size;
    g_alloc_count++;
  }
  dr_mutex_unlock(g_alloc_lock);
}

static void remove_alloc(app_pc base) {
  dr_mutex_lock(g_alloc_lock);
  for (int i = 0; i < g_alloc_count; ++i) {
    if (g_allocs[i].base == base) {
      g_allocs[i] = g_allocs[g_alloc_count - 1];
      g_alloc_count--;
      break;
    }
  }
  dr_mutex_unlock(g_alloc_lock);
}

static bool find_alloc_containing(app_pc ptr, app_pc *base_out,
                                  size_t *size_out) {
  bool found = false;

  dr_mutex_lock(g_alloc_lock);
  for (int i = 0; i < g_alloc_count; ++i) {
    app_pc b = g_allocs[i].base;
    size_t s = g_allocs[i].size;
    if (ptr >= b && ptr < b + s) {
      if (base_out)
        *base_out = b;
      if (size_out)
        *size_out = s;
      found = true;
      break;
    }
  }
  dr_mutex_unlock(g_alloc_lock);

  return found;
}

/* --- Per-thread state helpers --- */

static per_thread_data_t *get_thread_data(void *drcontext) {
  return (per_thread_data_t *)drmgr_get_tls_field(drcontext, tls_idx);
}

/* --- Wrappers for malloc/free --- */

static void pre_malloc(void *wrapcxt, void **user_data) {
  size_t size = (size_t)drwrap_get_arg(wrapcxt, 0);
  *user_data = (void *)size;
}

static void post_malloc(void *wrapcxt, void *user_data) {
  void *ret = drwrap_get_retval(wrapcxt);
  size_t n = (size_t)user_data;
  record_alloc((app_pc)ret, n);
}

static void pre_free(void *wrapcxt, void **user_data) {
  void *ptr = drwrap_get_arg(wrapcxt, 0);
  remove_alloc((app_pc)ptr);
}

/* --- Wrappers for marker functions --- */

static void pre_start_tracking_src(void *wrapcxt, void **user_data) {
  void *drcontext = drwrap_get_drcontext(wrapcxt);
  per_thread_data_t *tdata = get_thread_data(drcontext);

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

static void pre_end_tracking_src(void *wrapcxt, void **user_data) {
  void *drcontext = drwrap_get_drcontext(wrapcxt);
  per_thread_data_t *tdata = get_thread_data(drcontext);

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

  dr_fprintf(STDERR, "[DR] on_mem_write calls=%u hits=%u\n",
             tdata->memwrite_calls, tdata->memwrite_hits);

  // Store src_id in user_data for post callback
  *user_data = (void *)(size_t)src_id;
}

static void post_end_tracking_src(void *wrapcxt, void *user_data) {
  void *drcontext = drwrap_get_drcontext(wrapcxt);
  per_thread_data_t *tdata = get_thread_data(drcontext);

  if (tdata == NULL || !tdata->active) {
    drwrap_set_retval(wrapcxt, (void *)0);
    return;
  }

  uint32_t src_id = (uint32_t)(size_t)user_data;

  // Count bytes write in full allocation
  size_t bytes_write_full = 0;
  size_t first_full = tdata->region_size, last_full = 0;

  // Count bytes write from offset onwards
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

      // Track reads from offset onwards
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

/* --- Memory write callback --- */

static void on_mem_write(app_pc addr, uint size) {
  void *drcontext = dr_get_current_drcontext();
  per_thread_data_t *tdata = get_thread_data(drcontext);

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

  /* Debugging: occasionally print the computed offsets to verify mapping
   * between EA and tracked allocation. Print the first few hits and then
   * every 50th hit to keep output manageable.
   */
  if (tdata->memwrite_hits <= 5 || (tdata->memwrite_hits % 50) == 0) {
    dr_fprintf(STDERR,
               "[DR] on_mem_write: addr=%p size=%u region=[%p..%p) "
               "off_start=%zu off_end=%zu memwrite_hits=%llu\n",
               (void *)addr, size, (void *)reg_start, (void *)reg_end,
               off_start, off_end, (unsigned long long)tdata->memwrite_hits);
  }

  for (size_t i = off_start; i < off_end; ++i) {
    tdata->write_mask[i] = 1;
  }
}

/*
 * track_writes_marker (old implementation): always-instrument memory writes
 * ----------------------------------------------------------------------
 *
 * What this version does
 *   This instrumentation callback runs while DynamoRIO is translating
 *   application code into the code cache. For each instruction that *writes
 *   memory*, we insert a clean call to `on_mem_write(addr, size)` for each
 *   explicit memory-reference source operand.
 *
 * How it works
 *   - DynamoRIO calls this function once per instruction while building a
 *     basic block in the code cache.
 *   - If `instr_writes_memory(instr)` is false, we do nothing.
 *   - Otherwise, we iterate over all source operands and for each memory
 *     reference operand:
 *       1) compute its effective address (EA)
 *       2) call `on_mem_write(EA, mem_size)`
 *
 * Register usage and state preservation
 *   - We use RCX (DR_REG_XCX) as the temporary register to hold the computed
 * EA.
 *   - We save/restore RCX around each operand’s EA computation + clean call
 *     sequence using a DynamoRIO spill slot (SPILL_SLOT_1).
 *
 * translation-time gating (commented)
 *   The commented-out `tdata->active` gate is a translation-time filter:
 *     - If enabled, only basic blocks translated while `tdata->active==true`
 *       would receive instrumentation.
 *     - This is fast when inactive, but it is FRAGILE if the same cached
 *       translation is later executed under different `active` state (e.g.,
 *       due to caching, warm-up, or cross-thread reuse depending on mode).
 */

/* --- Instrumentation --- */
static dr_emit_flags_t
event_app_instruction_naive(void *drcontext, void *tag, instrlist_t *bb,
                            instr_t *instr, bool for_trace, bool translating,
                            void *user_data) {
  app_pc pc = instr_get_app_pc(instr);
  app_pc bbpc = instr_get_app_pc(instrlist_first(bb));

  // Skip instrumentation for certain modules
  if (pc && pc_in_skip_module(pc))
    return DR_EMIT_DEFAULT;

  /* Fast reject: ignore instructions that do not write memory. */
  if (!instr_writes_memory(instr)) {
    // dr_fprintf(STDERR, "[TRANSLATE] PC=%p BB=%p\n", pc, bbpc);
    return DR_EMIT_DEFAULT;
  }

  /* Per-thread state is available here, but note: checking `active` here would
   * be a translation-time gate (not a runtime guard).
   */
  per_thread_data_t *tdata = get_thread_data(drcontext);

  /* Debug: log translation of memory-writing instructions and observed state.
   */
  // ADD THIS: Log every time we translate
  // dr_fprintf(STDERR, "[TRANSLATE] PC=%p BB=%p active=%d\n", pc, bbpc,
  //            tdata ? tdata->active : -1);

  /* translation-time gating (commented out for warning)
    THIS IS FRAGILE, do not use it
   */
  //   if (tdata == NULL || !tdata->active)
  //     return DR_EMIT_DEFAULT;

  /* For each explicit memory-write operand (destination), insert a clean call.
   */
  int num_dsts = instr_num_dsts(instr);
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
  }

  return DR_EMIT_DEFAULT;
}

/*
 * track_writes_marker: selective, runtime-gated memory-write instrumentation
 * -----------------------------------------------------------------------
 *
 * Goal
 *   Track which bytes of a heap allocation are *written* between two marker
 * calls
 *   (__dr_start_tracking_src / __dr_end_tracking_src), with near-zero
 * overhead outside the marked region.
 *
 * Key idea (robust + fast)
 *   We always *translate* every app instruction as DynamoRIO sees it, but we
 *   do NOT always execute expensive instrumentation. Instead, for any app
 *   instruction that reads memory, we insert a small inline guard in the code
 *   cache that checks thread-local state:
 *
 *       if (!tdata->active)  => skip instrumentation (fast path)
 *       else                 => compute EA + call on_mem_write (slow path)
 *
 * Why we use JECXZ (and a trampoline)
 *   JECXZ is a short jump, so we route it through a nearby "inactive_stub"
 *   and then do long jumps to reach the common epilogue label. This avoids
 *   displacement-range issues when the slow path is large.
 *
 * Safety: never instrument DR meta-instructions
 *   DynamoRIO and client helpers insert meta-instructions (TLS reads, spills,
 *   etc.). Instrumenting meta can lead to recursion and internal crashes.
 *   We skip meta instructions entirely (instr_is_meta(instr) check).
 *
 * Registers and spill slots
 *   - RDX (reg_tdata): initially holds per-thread data pointer from TLS; reused
 *     as the effective address (EA) when calling on_mem_write.
 *   - RCX (reg_active): holds the active flag in ECX (required for JECXZ).
 *   - R8  (reg_scratch): scratch register required by
 * drutil_insert_get_mem_addr.
 *
 *   We save/restore these registers using DR spill slots so that the
 * application state is preserved on both the fast path and slow path.
 */

/* --- Instrumentation --- */
static dr_emit_flags_t
event_app_instruction_inline_guard(void *drcontext, void *tag, instrlist_t *bb,
                                   instr_t *instr, bool for_trace,
                                   bool translating, void *user_data) {
  /* Never instrument meta instructions inserted by DynamoRIO or other helpers.
   * Meta instructions may write memory (e.g., TLS loads), and instrumenting
   * them can create recursion and crashes.
   */
  if (instr_is_meta(instr))
    return DR_EMIT_DEFAULT;

  /* Only consider instructions that write memory at all. */
  if (!instr_writes_memory(instr))
    return DR_EMIT_DEFAULT;

  /* Register plan:
   *   - RDX: TLS per-thread data pointer.
   *   - RCX: active flag (ECX) for JECXZ; used only for the guard.
   *   - R8 : scratch register used by drutil_insert_get_mem_addr.
   *   - RAX: dedicated EA register.
   */
  const reg_id_t reg_tdata = DR_REG_XDX;
  const reg_id_t reg_active = DR_REG_XCX;
  const reg_id_t reg_scratch = DR_REG_R8;
  const reg_id_t reg_ea = DR_REG_XAX;

  /* Control-flow labels in the code cache:
   *   inactive_stub: near target for JECXZ (short jump)
   *   slow_label   : start of slow path (EA + clean calls)
   *   epilogue     : common restore point
   */
  instr_t *inactive_stub = INSTR_CREATE_label(drcontext);
  instr_t *slow_label = INSTR_CREATE_label(drcontext);
  instr_t *epilogue = INSTR_CREATE_label(drcontext);
  instr_set_meta(inactive_stub);
  instr_set_meta(slow_label);
  instr_set_meta(epilogue);

  /* Preserve application registers that we will clobber in the inserted code.
   * These restores are executed on both fast and slow paths.
   */
  dr_save_reg(drcontext, bb, instr, reg_tdata, SPILL_SLOT_1);
  dr_save_reg(drcontext, bb, instr, reg_active, SPILL_SLOT_2);
  dr_save_reg(drcontext, bb, instr, reg_scratch, SPILL_SLOT_3);
  dr_save_reg(drcontext, bb, instr, reg_ea, SPILL_SLOT_4);

  /* Load per-thread state pointer from drmgr TLS into RDX. */
  drmgr_insert_read_tls_field(drcontext, tls_idx, bb, instr, reg_tdata);

  /* Inline guard: load tdata->active into ECX and branch if inactive.
   * JECXZ does not clobber EFLAGS, which avoids expensive/fragile flag save.
   */
  instrlist_meta_preinsert(
      bb, instr,
      INSTR_CREATE_movzx(
          drcontext, opnd_create_reg(DR_REG_ECX),
          OPND_CREATE_MEM8(reg_tdata, offsetof(per_thread_data_t, active))));

  /* Fast path if inactive:
   *   ECX == 0  => JECXZ to inactive_stub (short jump).
   */
  instrlist_meta_preinsert(
      bb, instr,
      INSTR_CREATE_jecxz(drcontext, opnd_create_instr(inactive_stub)));

  /* Otherwise, unconditionally jump into the slow path (short jump). */
  instrlist_meta_preinsert(
      bb, instr, INSTR_CREATE_jmp(drcontext, opnd_create_instr(slow_label)));

  /* Inactive stub: route control to the shared epilogue (long jump). */
  instrlist_meta_preinsert(bb, instr, inactive_stub);
  instrlist_meta_preinsert(
      bb, instr, INSTR_CREATE_jmp(drcontext, opnd_create_instr(epilogue)));

  /* Slow path: for each explicit memory-reference destination operand, compute
   * the effective address (EA) and invoke on_mem_write(EA, size).
   */
  instrlist_meta_preinsert(bb, instr, slow_label);

  int num_dsts = instr_num_dsts(instr);
  for (int i = 0; i < num_dsts; ++i) {
    opnd_t dst = instr_get_dst(instr, i);
    if (!opnd_is_memory_reference(dst))
      continue;

    /* Compute EA into the dedicated reg_ea.
     * drutil needs a separate scratch register: we use R8.
     */
    drutil_insert_get_mem_addr(drcontext, bb, instr, dst, reg_ea, reg_scratch);

    uint mem_size = opnd_size_in_bytes(opnd_get_size(dst));

    /* Clean call to analysis routine: on_mem_write(addr, size).
     * This is the expensive part we avoid when inactive.
     */
    dr_insert_clean_call_ex(drcontext, bb, instr, (void *)on_mem_write,
                            false /* no fp save */, 2, opnd_create_reg(reg_ea),
                            OPND_CREATE_INT32(mem_size));
  }

  /* Common epilogue: restore registers for both paths and continue execution.
   */
  instrlist_meta_preinsert(bb, instr, epilogue);

  /* Restore in reverse order of saves. */
  dr_restore_reg(drcontext, bb, instr, reg_ea, SPILL_SLOT_4);
  dr_restore_reg(drcontext, bb, instr, reg_scratch, SPILL_SLOT_3);
  dr_restore_reg(drcontext, bb, instr, reg_active, SPILL_SLOT_2);
  dr_restore_reg(drcontext, bb, instr, reg_tdata, SPILL_SLOT_1);

  return DR_EMIT_DEFAULT;
}

/* --- Module load event --- */

static void event_module_load(void *drcontext, const module_data_t *info,
                              bool loaded) {
  const char *name = dr_module_preferred_name(info);

  /* Add certain modules to the skip instrumentation black-list */
  if (name && (strstr(name, "ld-linux") || strstr(name, "linux-vdso") ||
               strstr(name, "libc.so") || strstr(name, "libdynamorio.so"))) {
    dr_mutex_lock(g_skip_mods_lock);
    if (g_skip_mods_n < (int)(sizeof(g_skip_mods) / sizeof(g_skip_mods[0]))) {
      g_skip_mods[g_skip_mods_n].start = info->start;
      g_skip_mods[g_skip_mods_n].end = info->end;
      g_skip_mods_n++;
    }
    dr_mutex_unlock(g_skip_mods_lock);
  }

  dr_fprintf(STDERR, "[DR] Module loaded: %s at %p - %p\n", name, info->start,
             info->end);

  app_pc f;

  /* Wrap malloc */
  f = (app_pc)dr_get_proc_address(info->handle, "malloc");
  if (f != NULL) {
    drwrap_wrap_ex(f, pre_malloc, post_malloc, NULL, 0);
  }

  /* Wrap free */
  f = (app_pc)dr_get_proc_address(info->handle, "free");
  if (f != NULL) {
    drwrap_wrap_ex(f, pre_free, NULL, NULL, 0);
  }

  /* Wrap marker functions: __dr_start_tracking_src */
  // Markers are not exported, lookup via debug symbols
  drsym_error_t symres;
  symres = drsym_lookup_symbol(info->full_path, "__dr_start_tracking_src",
                               (size_t *)&f, DRSYM_DEFAULT_FLAGS);
  if (symres == DRSYM_SUCCESS) {
    f = info->start + (size_t)f;
    g_start_marker_addr = f;
    if (drwrap_wrap_ex(f, pre_start_tracking_src, NULL, NULL, 0)) {
      dr_fprintf(STDERR, "[DR] Wrapped __dr_start_tracking_sink at %p in %s\n",
                 f, name);
    }
  }

  /* Wrap marker functions: __dr_end_tracking_src */
  // Markers are not exported, lookup via debug symbols
  symres = drsym_lookup_symbol(info->full_path, "__dr_end_tracking_src",
                               (size_t *)&f, DRSYM_DEFAULT_FLAGS);
  if (symres == DRSYM_SUCCESS) {
    f = info->start + (size_t)f;
    g_end_marker_addr = f;
    // Need post callback to set return value!
    if (drwrap_wrap_ex(f, pre_end_tracking_src, post_end_tracking_src, NULL,
                       0)) {
      dr_fprintf(STDERR, "[DR] Wrapped __dr_end_tracking_sink at %p in %s\n", f,
                 name);
    }
  }
}

/* --- Thread init/exit --- */

static void event_thread_init(void *drcontext) {
  per_thread_data_t *tdata =
      dr_thread_alloc(drcontext, sizeof(per_thread_data_t));
  memset(tdata, 0, sizeof(per_thread_data_t));
  drmgr_set_tls_field(drcontext, tls_idx, tdata);

  dr_fprintf(STDERR, "[DR] Thread %d initialized\n",
             dr_get_thread_id(drcontext));
}

static void event_thread_exit(void *drcontext) {
  per_thread_data_t *tdata = get_thread_data(drcontext);

  if (tdata != NULL) {
    // Clean up if tracking is still active
    if (tdata->active && tdata->write_mask != NULL) {
      dr_global_free(tdata->write_mask, tdata->region_size);
    }

    dr_thread_free(drcontext, tdata, sizeof(per_thread_data_t));
  }

  dr_fprintf(STDERR, "[DR] Thread %d exiting\n", dr_get_thread_id(drcontext));
}

/* --- Client init/exit --- */

DR_EXPORT void dr_client_main(client_id_t id, int argc, const char *argv[]) {
  dr_set_client_name("track_write_marker", "https://example.com");

  drmgr_init();
  drwrap_init();
  drutil_init();
  drsym_init(0);

  // Register TLS field for per-thread data
  tls_idx = drmgr_register_tls_field();
  if (tls_idx == -1) {
    dr_fprintf(STDERR, "[DR] ERROR: failed to register TLS field\n");
    return;
  }

  // Create mutex for allocation tracking
  g_alloc_lock = dr_mutex_create();

  // Create mutex for skip module list
  g_skip_mods_lock = dr_mutex_create();

  // Register events
  dr_register_exit_event(event_exit);
  drmgr_register_thread_init_event(event_thread_init);
  drmgr_register_thread_exit_event(event_thread_exit);
  drmgr_register_module_load_event(event_module_load);
  drmgr_register_bb_instrumentation_event(NULL, event_app_instruction, NULL);

  dr_fprintf(STDERR, "== track_write_marker loaded ==\n");
  dr_fprintf(STDERR, "Client DLL used  = %s\n", dr_get_client_path(id));
  dr_fprintf(STDERR, "PID              = %u (0x%x)\n", dr_get_process_id(),
             dr_get_process_id());
  dr_fprintf(STDERR, "Processname      = %s\n", dr_get_application_name());
  dr_fprintf(STDERR, "TLS idx          = %d\n", tls_idx);
}

static void event_exit(void) {
  dr_fprintf(STDERR, "== track_write_marker exiting ==\n");

  // Clean up
  dr_mutex_destroy(g_alloc_lock);
  drmgr_unregister_tls_field(tls_idx);

  drsym_exit();
  drmgr_exit();
  drwrap_exit();
  drutil_exit();
}
