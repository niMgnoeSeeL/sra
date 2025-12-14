// marker_common.c
// Shared utilities for DynamoRIO marker-based tracking clients

#include "marker_common.h"
#include "dr_api.h"
#include <string.h>

/* --- Allocation tracking (thread-safe) --- */

#define MARKER_MAX_ALLOCS 4096
static alloc_rec_t g_allocs[MARKER_MAX_ALLOCS];
static int g_alloc_count = 0;
static void *g_alloc_lock = NULL;

void alloc_init(void) {
  g_alloc_count = 0;
  g_alloc_lock = dr_mutex_create();
}

void alloc_exit(void) {
  dr_mutex_destroy(g_alloc_lock);
  g_alloc_lock = NULL;
}

void record_alloc(app_pc base, size_t size) {
  if (base == NULL)
    return;

  dr_mutex_lock(g_alloc_lock);
  if (g_alloc_count < MARKER_MAX_ALLOCS) {
    g_allocs[g_alloc_count].base = base;
    g_allocs[g_alloc_count].size = size;
    g_alloc_count++;
  }
  dr_mutex_unlock(g_alloc_lock);
}

void remove_alloc(app_pc base) {
  dr_mutex_lock(g_alloc_lock);
  for (int i = 0; i < g_alloc_count; ++i) {
    if (g_allocs[i].base == base) {
      // Swap with last element
      g_allocs[i] = g_allocs[g_alloc_count - 1];
      g_alloc_count--;
      break;
    }
  }
  dr_mutex_unlock(g_alloc_lock);
}

bool find_alloc_containing(app_pc ptr, app_pc *base_out, size_t *size_out) {
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

/* --- Skip-module list implementation --- */

#define MAX_SKIP_MODS 256

static mod_range_t g_skip_mods[MAX_SKIP_MODS];
static int g_skip_mods_n = 0;
static void *g_skip_mods_lock = NULL;

void skipmod_init(void) {
  g_skip_mods_n = 0;
  g_skip_mods_lock = dr_mutex_create();
}

void skipmod_exit(void) {
  if (g_skip_mods_lock != NULL) {
    dr_mutex_destroy(g_skip_mods_lock);
    g_skip_mods_lock = NULL;
  }
}

bool pc_in_skip_module(app_pc pc) {
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

void add_module_to_skip_list(const module_data_t *info) {
  const char *name = dr_module_preferred_name(info);

  /* Add certain modules to the skip instrumentation black-list */
  if (name && (strstr(name, "ld-linux") || strstr(name, "linux-vdso") ||
               strstr(name, "libc.so") || strstr(name, "libdynamorio.so"))) {
    dr_mutex_lock(g_skip_mods_lock);
    if (g_skip_mods_n < MAX_SKIP_MODS) {
      g_skip_mods[g_skip_mods_n].start = info->start;
      g_skip_mods[g_skip_mods_n].end = info->end;
      g_skip_mods_n++;
    }
    dr_mutex_unlock(g_skip_mods_lock);
  }
}

/* --- Wrappers for malloc/free --- */

void pre_malloc(void *wrapcxt, void **user_data) {
  size_t size = (size_t)drwrap_get_arg(wrapcxt, 0);
  *user_data = (void *)size;
}

void post_malloc(void *wrapcxt, void *user_data) {
  void *ret = drwrap_get_retval(wrapcxt);
  size_t n = (size_t)user_data;
  record_alloc((app_pc)ret, n);
}

void pre_free(void *wrapcxt, void **user_data) {
  void *ptr = drwrap_get_arg(wrapcxt, 0);
  remove_alloc((app_pc)ptr);
}

void wrap_heap_functions(const module_data_t *info) {
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
}