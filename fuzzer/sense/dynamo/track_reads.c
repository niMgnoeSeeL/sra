// track_reads.c
#include "dr_api.h"
#include "drmgr.h"
#include "drsyms.h"
#include "drutil.h"
#include "drwrap.h"
#include <string.h>

static void event_exit(void);
static void event_module_load(void *drcontext, const module_data_t *info,
                              bool loaded);
static dr_emit_flags_t event_app_instruction(void *drcontext, void *tag,
                                             instrlist_t *bb, instr_t *instr,
                                             bool for_trace, bool translating,
                                             void *user_data);

/* --- Global state (demo: single thread, single region) --- */

static bool g_sink_active = false;
static app_pc g_region_base = NULL;
static size_t g_region_size = 0;
static byte *g_read_mask = NULL;

/* For allocation tracking: super simple map of heap region (base,size) */
typedef struct alloc_rec_t {
  app_pc base;
  size_t size;
} alloc_rec_t;

#define MAX_ALLOCS 1024
static alloc_rec_t g_allocs[MAX_ALLOCS];
static int g_alloc_count = 0;

/* --- Utility: track malloc --- */

static void record_alloc(app_pc base, size_t size) {
  if (base == NULL)
    return;
  // Track all allocations, including malloc(0) which can return a valid pointer
  if (g_alloc_count < MAX_ALLOCS) {
    g_allocs[g_alloc_count].base = base;
    g_allocs[g_alloc_count].size = size;
    g_alloc_count++;
  }
}

static void remove_alloc(app_pc base) {
  for (int i = 0; i < g_alloc_count; ++i) {
    if (g_allocs[i].base == base) {
      g_allocs[i] = g_allocs[g_alloc_count - 1];
      g_alloc_count--;
      return;
    }
  }
}

static bool find_alloc_containing(app_pc ptr, app_pc *base_out,
                                  size_t *size_out) {
  for (int i = 0; i < g_alloc_count; ++i) {
    app_pc b = g_allocs[i].base;
    size_t s = g_allocs[i].size;
    if (ptr >= b && ptr < b + s) {
      if (base_out)
        *base_out = b;
      if (size_out)
        *size_out = s;
      return true;
    }
  }
  return false;
}

/* --- Wrappers for malloc/free --- */

static void pre_malloc(void *wrapcxt, void **user_data) {
  // Save the size argument in user_data for post_malloc
  size_t size = (size_t)drwrap_get_arg(wrapcxt, 0);
  *user_data = (void *)size;
}

static void post_malloc(void *wrapcxt, void *user_data) {
  void *ret = drwrap_get_retval(wrapcxt);
  size_t n = (size_t)user_data; // Get size from user_data saved in pre_malloc
  record_alloc((app_pc)ret, n);
  dr_fprintf(STDERR, "[DR] malloc(%zu) = %p\n", n, ret);
}

static void pre_free(void *wrapcxt, void **user_data) {
  void *ptr = drwrap_get_arg(wrapcxt, 0);
  remove_alloc((app_pc)ptr);
  dr_fprintf(STDERR, "[DR] free(%p)\n", ptr);
  *user_data = NULL;
}

/* --- Wrappers for taint_sink --- */

static void pre_taint_sink(void *wrapcxt, void **user_data) {
  const byte *buf = (const byte *)drwrap_get_arg(wrapcxt, 0);
  size_t len = (size_t)drwrap_get_arg(wrapcxt, 1);

  dr_fprintf(STDERR, "[DR] taint_sink entered: buf=%p len=%zu\n", buf, len);

  app_pc base = NULL;
  size_t size = 0;
  if (!find_alloc_containing((app_pc)buf, &base, &size)) {
    dr_fprintf(STDERR, "[DR] WARNING: buf not in tracked heap, skipping\n");
    g_sink_active = false;
    *user_data = NULL;
    return;
  }

  // For demo, we will treat the whole allocation as the region of interest.
  g_region_base = base;
  g_region_size = size;

  g_read_mask = dr_global_alloc(g_region_size);
  memset(g_read_mask, 0, g_region_size);

  g_sink_active = true;
  *user_data = NULL; // unused
}

static void post_taint_sink(void *wrapcxt, void *user_data) {
  if (!g_sink_active)
    return;

  size_t bytes_read = 0;
  size_t first = g_region_size, last = 0;

  for (size_t i = 0; i < g_region_size; ++i) {
    if (g_read_mask[i]) {
      bytes_read++;
      if (i < first)
        first = i;
      if (i > last)
        last = i;
    }
  }

  dr_fprintf(
      STDERR,
      "[DR] taint_sink read %zu bytes in region [%p .. %p) (alloc size=%zu)\n",
      bytes_read, g_region_base, g_region_base + g_region_size, g_region_size);

  if (bytes_read > 0) {
    dr_fprintf(STDERR, "[DR]   first offset=%zu, last offset=%zu\n", first,
               last);
  }

  dr_global_free(g_read_mask, g_region_size);
  g_read_mask = NULL;
  g_sink_active = false;
  g_region_base = NULL;
  g_region_size = 0;
}

/* --- Memory read callback --- */

static void on_mem_read(app_pc addr, uint size) {
  if (!g_sink_active || g_read_mask == NULL)
    return;

  app_pc start = addr;
  app_pc end = addr + size;

  app_pc reg_start = g_region_base;
  app_pc reg_end = g_region_base + g_region_size;

  if (end <= reg_start || start >= reg_end)
    return; // no overlap

  // Calculate the overlapping range within our tracked region
  size_t off_start = (size_t)(start < reg_start ? 0 : start - reg_start);
  size_t off_end = (size_t)(end > reg_end ? g_region_size : end - reg_start);

  for (size_t i = off_start; i < off_end; ++i) {
    g_read_mask[i] = 1;
  }
}

/* --- Instrumentation --- */

/* Track which functions we want to instrument */
static app_pc g_taint_sink_start = NULL;
static app_pc g_taint_sink_end = NULL;

static dr_emit_flags_t event_app_instruction(void *drcontext, void *tag,
                                             instrlist_t *bb, instr_t *instr,
                                             bool for_trace, bool translating,
                                             void *user_data) {
  if (!instr_reads_memory(instr))
    return DR_EMIT_DEFAULT;
  
  /* SELECTIVE INSTRUMENTATION: Only instrument if we're inside taint_sink */
  if (!g_sink_active)
    return DR_EMIT_DEFAULT;
  
  /* Check if this instruction is within the taint_sink function bounds */
  app_pc pc = instr_get_app_pc(instr);
  if (g_taint_sink_start != NULL && g_taint_sink_end != NULL) {
    if (pc < g_taint_sink_start || pc >= g_taint_sink_end) {
      /* This instruction is outside taint_sink, skip instrumentation */
      return DR_EMIT_DEFAULT;
    }
  }

  dr_fprintf(STDERR, "[DR] Instrumenting instruction at %p (inside taint_sink)\n", pc);

  // For each memory read operand, insert code to compute its address and call
  // on_mem_read(addr, size)
  int num_srcs = instr_num_srcs(instr);
  for (int i = 0; i < num_srcs; ++i) {
    opnd_t src = instr_get_src(instr, i);
    if (!opnd_is_memory_reference(src))
      continue;

    // Use drutil to compute the effective address into a scratch reg
    reg_id_t reg = DR_REG_XCX; // arbitrary scratch
    dr_save_reg(drcontext, bb, instr, reg, SPILL_SLOT_1);
    drutil_insert_get_mem_addr(drcontext, bb, instr, src, reg, SPILL_SLOT_2);

    // Insert clean call: on_mem_read(addr, size)
    uint mem_size = opnd_size_in_bytes(opnd_get_size(src));
    dr_insert_clean_call(drcontext, bb, instr, (void *)on_mem_read, false, 2,
                         opnd_create_reg(reg),         /* arg 0: address */
                         OPND_CREATE_INT32(mem_size)); /* arg 1: size */

    dr_restore_reg(drcontext, bb, instr, reg, SPILL_SLOT_1);
  }

  return DR_EMIT_DEFAULT;
}

/* --- Module load: wrap malloc/free and taint_sink by name --- */

static void event_module_load(void *drcontext, const module_data_t *info,
                              bool loaded) {
  const char *name = dr_module_preferred_name(info);
  dr_fprintf(STDERR, "[DR] module loaded: %s\n", name);

  app_pc f;

  /* Wrap malloc */
  f = (app_pc)dr_get_proc_address(info->handle, "malloc");
  if (f != NULL) {
    if (!drwrap_wrap_ex(f, pre_malloc, post_malloc, NULL /*wrap_data*/,
                        0 /*flags*/)) {
      dr_fprintf(STDERR, "[DR] failed to wrap malloc in %s\n", name);
    } else {
      dr_fprintf(STDERR, "[DR] wrapped malloc in %s\n", name);
    }
  }

  /* Wrap free */
  f = (app_pc)dr_get_proc_address(info->handle, "free");
  if (f != NULL) {
    if (!drwrap_wrap_ex(f, pre_free, NULL, NULL /*wrap_data*/, 0 /*flags*/)) {
      dr_fprintf(STDERR, "[DR] failed to wrap free in %s\n", name);
    } else {
      dr_fprintf(STDERR, "[DR] wrapped free in %s\n", name);
    }
  }

  /* Wrap our sink function taint_sink (in the main module "target") */
  /* First try exported symbols */
  f = (app_pc)dr_get_proc_address(info->handle, "taint_sink");

  /* If not exported, try looking up via debug symbols */
  if (f == NULL) {
    drsym_error_t symres;
    drsym_info_t sym_info;
    sym_info.struct_size = sizeof(sym_info);
    sym_info.name = "taint_sink";
    sym_info.name_size = strlen("taint_sink");

    symres = drsym_lookup_symbol(info->full_path, "taint_sink", (size_t *)&f,
                                 DRSYM_DEFAULT_FLAGS);
    if (symres == DRSYM_SUCCESS) {
      /* drsym_lookup_symbol returns offset from module base, convert to address
       */
      f = info->start + (size_t)f;
      dr_fprintf(STDERR, "[DR] found taint_sink via debug symbols at %p\n", f);
    }
  }

  if (f != NULL) {
    /* Save the function boundaries for selective instrumentation */
    g_taint_sink_start = f;
    
    /* Get exact function size using drsym_lookup_address */
    drsym_error_t symres;
    drsym_info_t sym_info;
    char name_buf[256];
    
    sym_info.struct_size = sizeof(sym_info);
    sym_info.name = name_buf;
    sym_info.name_size = sizeof(name_buf);
    sym_info.file = NULL;
    sym_info.file_size = 0;
    
    size_t offset = (size_t)(f - info->start);
    symres = drsym_lookup_address(info->full_path, offset, &sym_info, DRSYM_DEFAULT_FLAGS);
    
    if (symres == DRSYM_SUCCESS && sym_info.end_offs > sym_info.start_offs) {
      size_t func_size = sym_info.end_offs - sym_info.start_offs;
      g_taint_sink_end = info->start + sym_info.end_offs;
      dr_fprintf(STDERR, "[DR] taint_sink exact bounds: [%p .. %p) size=%zu bytes\n",
                 g_taint_sink_start, g_taint_sink_end, func_size);
    } else {
      /* Fallback: conservative estimate */
      g_taint_sink_end = f + 4096;
      dr_fprintf(STDERR, "[DR] taint_sink bounds (estimated): [%p .. %p)\n",
                 g_taint_sink_start, g_taint_sink_end);
    }
    
    if (!drwrap_wrap_ex(f, pre_taint_sink, post_taint_sink, NULL /*wrap_data*/,
                        0 /*flags*/)) {
      dr_fprintf(STDERR, "[DR] failed to wrap taint_sink in %s\n", name);
    } else {
      dr_fprintf(STDERR, "[DR] successfully wrapped taint_sink in %s\n", name);
    }
  }
}

/* --- Client init/exit --- */

DR_EXPORT void dr_client_main(client_id_t id, int argc, const char *argv[]) {
  dr_set_client_name("track_reads", "https://example.com");

  drmgr_init();
  drwrap_init();
  drutil_init();
  drsym_init(0);

  dr_register_exit_event(event_exit);
  drmgr_register_module_load_event(event_module_load);
  drmgr_register_bb_instrumentation_event(NULL, event_app_instruction, NULL);

  //   dr_log(NULL, LOG_ALL, 1, "track_reads client initialized\n");
  dr_fprintf(STDERR, "== track_reads loaded ==\n");
  dr_fprintf(STDERR, "Client DLL used  = %s\n", dr_get_client_path(id));
  dr_fprintf(STDERR, "PID              = %u (0x%x)\n", dr_get_process_id(),
             dr_get_process_id());
  dr_fprintf(STDERR, "Processname      = %s\n", dr_get_application_name());
}

static void event_exit(void) {
  dr_fprintf(STDERR, "== track_reads exiting ==\n");
  drsym_exit();
  drmgr_exit();
  drwrap_exit();
  drutil_exit();
}
