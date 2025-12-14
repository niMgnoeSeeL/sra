// marker_common.h
// Shared utilities for DynamoRIO marker-based tracking clients

#ifndef MARKER_COMMON_H
#define MARKER_COMMON_H

#include "dr_api.h"
#include "drwrap.h"
#include <stddef.h>

/* --- Allocation tracking types --- */

typedef struct alloc_rec_t {
  app_pc base;
  size_t size;
} alloc_rec_t;

/* --- Allocation tracking API --- */

/**
 * Initialize allocation tracking subsystem.
 * Must be called once during client initialization.
 */
void alloc_init(void);

/**
 * Clean up allocation tracking subsystem.
 * Called during client exit.
 */
void alloc_exit(void);

/**
 * Record a heap allocation (thread-safe).
 * @param base Base address of the allocation
 * @param size Size of the allocation in bytes
 */
void record_alloc(app_pc base, size_t size);

/**
 * Remove a heap allocation from tracking (thread-safe).
 * @param base Base address of the allocation to remove
 */
void remove_alloc(app_pc base);

/**
 * Find the allocation containing a given pointer (thread-safe).
 * @param ptr Pointer to search for
 * @param base_out [out] Base address of containing allocation (can be NULL)
 * @param size_out [out] Size of containing allocation (can be NULL)
 * @return true if ptr is within a tracked allocation, false otherwise
 */
bool find_alloc_containing(app_pc ptr, app_pc *base_out, size_t *size_out);

/* --- Skip-module list types --- */

typedef struct {
  app_pc start;
  app_pc end;
} mod_range_t;

/* --- Skip-module list API --- */

/**
 * Initialize skip-module subsystem.
 * Must be called once during client initialization.
 */
void skipmod_init(void);

/**
 * Clean up skip-module subsystem.
 * Called during client exit.
 */
void skipmod_exit(void);

/**
 * Check if a program counter is within a skip-module (thread-safe).
 * @param pc Program counter to check
 * @return true if pc is within a blacklisted module, false otherwise
 */
bool pc_in_skip_module(app_pc pc);

/**
 * Add common system modules to the skip list.
 * Blacklists: ld-linux, linux-vdso, libc.so, libdynamorio.so
 * @param info Module information from event_module_load
 */
void add_module_to_skip_list(const module_data_t *info);

/* --- Wrappers for malloc/free --- */

void pre_malloc(void *wrapcxt, void **user_data);

void post_malloc(void *wrapcxt, void *user_data);

void pre_free(void *wrapcxt, void **user_data);

/**
 * Wrap malloc and free in the given module (if present).
 * @param info Module information from event_module_load
 */
void wrap_heap_functions(const module_data_t *info);

#endif /* MARKER_COMMON_H */
