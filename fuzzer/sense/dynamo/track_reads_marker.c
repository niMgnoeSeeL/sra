// track_reads_marker.c
// Production DynamoRIO client using marker functions for LLVM pass integration
// Supports: multi-threading, nested sinks, selective instrumentation

#include "dr_api.h"
#include "dr_modules.h"
#include "drmgr.h"
#include "drsyms.h"
#include "drutil.h"
#include "drwrap.h"

#include "marker_common.h"
#include "read_tracker.h"

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

static int tls_idx = -1; // TLS slot index

/*
 * track_reads_marker (old implementation): always-instrument memory reads
 * ----------------------------------------------------------------------
 *
 * What this version does
 *   This instrumentation callback runs while DynamoRIO is translating
 *   application code into the code cache. For each instruction that *reads
 *   memory*, we insert a clean call to `on_mem_read(addr, size)` for each
 *   explicit memory-reference source operand.
 *
 * How it works
 *   - DynamoRIO calls this function once per instruction while building a
 *     basic block in the code cache.
 *   - If `instr_reads_memory(instr)` is false, we do nothing.
 *   - Otherwise, we iterate over all source operands and for each memory
 *     reference operand:
 *       1) compute its effective address (EA)
 *       2) call `on_mem_read(EA, mem_size)`
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

  // Skip instrumentation for certain modules
  if (pc && pc_in_skip_module(pc))
    return DR_EMIT_DEFAULT;

  // Delegate to read_tracker instrumentation helper
  read_instrument_mem_access_naive(drcontext, bb, instr);

  return DR_EMIT_DEFAULT;
}

/*
 * track_reads_marker: selective, runtime-gated memory-read instrumentation
 * -----------------------------------------------------------------------
 *
 * Goal
 *   Track which bytes of a heap allocation are *read* between two marker calls
 *   (__dr_start_tracking_sink / __dr_end_tracking_sink), with near-zero
 * overhead outside the marked region.
 *
 * Key idea (robust + fast)
 *   We always *translate* every app instruction as DynamoRIO sees it, but we
 *   do NOT always execute expensive instrumentation. Instead, for any app
 *   instruction that reads memory, we insert a small inline guard in the code
 *   cache that checks thread-local state:
 *
 *       if (!tdata->active)  => skip instrumentation (fast path)
 *       else                 => compute EA + call on_mem_read (slow path)
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
 *     as the effective address (EA) when calling on_mem_read.
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
   * Meta instructions may read memory (e.g., TLS loads), and instrumenting them
   * can create recursion and crashes.
   */
  if (instr_is_meta(instr))
    return DR_EMIT_DEFAULT;

  /* Only consider instructions that read memory at all. */
  if (!instr_reads_memory(instr))
    return DR_EMIT_DEFAULT;

  /* Register plan:
   *   - RDX: TLS per-thread data pointer.
   *   - RCX: active flag (ECX) for JECXZ; used only for the guard.
   *   - R8 : scratch register used by drutil_insert_get_mem_addr.
   *   - RAX: dedicated EA register
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
          OPND_CREATE_MEM8(reg_tdata, offsetof(read_tracker_t, active))));

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

  /* Slow path: for each explicit memory-reference source operand, compute the
   * effective address (EA) and invoke on_mem_read(EA, size).
   */
  instrlist_meta_preinsert(bb, instr, slow_label);

  int num_srcs = instr_num_srcs(instr);
  for (int i = 0; i < num_srcs; ++i) {
    opnd_t src = instr_get_src(instr, i);
    if (!opnd_is_memory_reference(src))
      continue;

    /* Compute EA into the dedicated reg_ea.
     * drutil needs a separate scratch register: we use R8.
     */
    drutil_insert_get_mem_addr(drcontext, bb, instr, src, reg_ea, reg_scratch);

    uint mem_size = opnd_size_in_bytes(opnd_get_size(src));

    /* Clean call to analysis routine: on_mem_read(addr, size).
     * This is the expensive part we avoid when inactive.
     */
    dr_insert_clean_call_ex(drcontext, bb, instr, (void *)on_mem_read,
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
  add_module_to_skip_list(info);

  dr_fprintf(STDERR, "[DR] Module loaded: %s at %p - %p\n", name, info->start,
             info->end);

  /* Wrap malloc and free */
  wrap_heap_functions(info);

  /* Wrap sink markers */
  wrap_sink_markers(info, name);
}

/* --- Thread init/exit --- */

static void event_thread_init(void *drcontext) {
  read_tracker_t *tdata = dr_thread_alloc(drcontext, sizeof(read_tracker_t));
  read_tracker_init(tdata);
  drmgr_set_tls_field(drcontext, tls_idx, tdata);

  dr_fprintf(STDERR, "[DR] Thread %d initialized\n",
             dr_get_thread_id(drcontext));
}

static void event_thread_exit(void *drcontext) {
  read_tracker_t *tdata = get_read_tracker_thread_data(drcontext);

  if (tdata != NULL) {
    // Clean up tracker resources
    read_tracker_cleanup(tdata);
    dr_thread_free(drcontext, tdata, sizeof(read_tracker_t));
  }

  dr_fprintf(STDERR, "[DR] Thread %d exiting\n", dr_get_thread_id(drcontext));
}

/* --- Client init/exit --- */

DR_EXPORT void dr_client_main(client_id_t id, int argc, const char *argv[]) {
  dr_set_client_name("track_reads_marker", "https://example.com");

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

  // Initialize shared subsystems
  alloc_init();
  skipmod_init();

  // Tell read_tracker which TLS index to use
  read_tracker_set_tls_index(tls_idx);

  // Register events
  dr_register_exit_event(event_exit);
  drmgr_register_thread_init_event(event_thread_init);
  drmgr_register_thread_exit_event(event_thread_exit);
  drmgr_register_module_load_event(event_module_load);
  drmgr_register_bb_instrumentation_event(NULL, event_app_instruction, NULL);

  dr_fprintf(STDERR, "== track_reads_marker loaded ==\n");
  dr_fprintf(STDERR, "Client DLL used  = %s\n", dr_get_client_path(id));
  dr_fprintf(STDERR, "PID              = %u (0x%x)\n", dr_get_process_id(),
             dr_get_process_id());
  dr_fprintf(STDERR, "Processname      = %s\n", dr_get_application_name());
  dr_fprintf(STDERR, "TLS idx          = %d\n", tls_idx);
}

static void event_exit(void) {
  dr_fprintf(STDERR, "== track_reads_marker exiting ==\n");

  // Clean up
  alloc_exit();
  skipmod_exit();
  drmgr_unregister_tls_field(tls_idx);

  drsym_exit();
  drmgr_exit();
  drwrap_exit();
  drutil_exit();
}
