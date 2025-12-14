// track_rw_marker.c
// Combined DynamoRIO client tracking both reads and writes using marker
// functions Supports: multi-threading, nested markers, selective
// instrumentation

#include "dr_api.h"
#include "dr_modules.h"
#include "drmgr.h"
#include "drsyms.h"
#include "drutil.h"
#include "drwrap.h"

#include "marker_common.h"
#include "read_tracker.h"
#include "write_tracker.h"

#include <stddef.h>
#include <stdint.h>
#include <string.h>

/* Select instrumentation mode: naive only for now */
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

/* --- Per-thread combined state --- */

typedef struct {
  read_tracker_t read;
  write_tracker_t write;
} rw_tracker_t;

static int tls_idx = -1; // TLS slot index

/* --- Per-thread state helper --- */

static rw_tracker_t *get_rw_tracker_thread_data(void *drcontext) {
  return (rw_tracker_t *)drmgr_get_tls_field(drcontext, tls_idx);
}

/*
 * track_rw_marker: combined read/write instrumentation
 * -----------------------------------------------------
 *
 * This client tracks BOTH memory reads and writes using the naive approach.
 * We delegate to read_instrument_mem_access_naive and
 * write_instrument_mem_access_naive from the tracker modules to avoid code
 * duplication.
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

  // Insert read instrumentation (if instruction reads memory)
  read_instrument_mem_access_naive(drcontext, bb, instr);

  // Insert write instrumentation (if instruction writes memory)
  write_instrument_mem_access_naive(drcontext, bb, instr);

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

  /* Wrap both sink and source markers */
  wrap_sink_markers(info, name);
  wrap_src_markers(info, name);
}

/* --- Thread init/exit --- */

static void event_thread_init(void *drcontext) {
  rw_tracker_t *tdata = dr_thread_alloc(drcontext, sizeof(rw_tracker_t));

  // Initialize both trackers
  read_tracker_init(&tdata->read);
  write_tracker_init(&tdata->write);

  drmgr_set_tls_field(drcontext, tls_idx, tdata);

  dr_fprintf(STDERR, "[DR] Thread %d initialized\n",
             dr_get_thread_id(drcontext));
}

static void event_thread_exit(void *drcontext) {
  rw_tracker_t *tdata = get_rw_tracker_thread_data(drcontext);

  if (tdata != NULL) {
    // Clean up both trackers
    read_tracker_cleanup(&tdata->read);
    write_tracker_cleanup(&tdata->write);
    dr_thread_free(drcontext, tdata, sizeof(rw_tracker_t));
  }

  dr_fprintf(STDERR, "[DR] Thread %d exiting\n", dr_get_thread_id(drcontext));
}

/* --- Client init/exit --- */

DR_EXPORT void dr_client_main(client_id_t id, int argc, const char *argv[]) {
  dr_set_client_name("track_rw_marker", "https://example.com");

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

  // Tell both trackers which TLS index to use
  read_tracker_set_tls_index(tls_idx);
  write_tracker_set_tls_index(tls_idx);

  // Register events
  dr_register_exit_event(event_exit);
  drmgr_register_thread_init_event(event_thread_init);
  drmgr_register_thread_exit_event(event_thread_exit);
  drmgr_register_module_load_event(event_module_load);
  drmgr_register_bb_instrumentation_event(NULL, event_app_instruction, NULL);

  dr_fprintf(STDERR, "== track_rw_marker loaded ==\n");
  dr_fprintf(STDERR, "Client DLL used  = %s\n", dr_get_client_path(id));
  dr_fprintf(STDERR, "PID              = %u (0x%x)\n", dr_get_process_id(),
             dr_get_process_id());
  dr_fprintf(STDERR, "Processname      = %s\n", dr_get_application_name());
  dr_fprintf(STDERR, "TLS idx          = %d\n", tls_idx);
}

static void event_exit(void) {
  dr_fprintf(STDERR, "== track_rw_marker exiting ==\n");

  // Clean up
  alloc_exit();
  skipmod_exit();
  drmgr_unregister_tls_field(tls_idx);

  drsym_exit();
  drmgr_exit();
  drwrap_exit();
  drutil_exit();
}
