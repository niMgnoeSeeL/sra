//===----------------------------------------------------------------------===//
// df_coverage_runtime.c - Dataflow coverage tracking runtime implementation
//===----------------------------------------------------------------------===//

#include "df_coverage_runtime.h"
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

// Global coverage map (allocated in shared memory)
uint8_t *__df_coverage_map = NULL;
uint32_t __df_coverage_map_size __attribute__((weak)) = 0;

// Shared memory state
static int g_shm_fd = -1;
static char g_shm_name[256];

// Initialize coverage map in shared memory
void df_coverage_init(void) {
  if (__df_coverage_map) {
    return; // Already initialized
  }

  if (__df_coverage_map_size == 0) {
    fprintf(stderr,
            "[df-coverage] WARNING: Map size is 0, using default size 1024\n");
    __df_coverage_map_size = 1024;
  }

  // Create shared memory region: /df_coverage_<pid>
  snprintf(g_shm_name, sizeof(g_shm_name), "/df_coverage_%d", getpid());

  g_shm_fd = shm_open(g_shm_name, O_CREAT | O_RDWR, 0600);
  if (g_shm_fd < 0) {
    perror("[df-coverage] ERROR: shm_open failed");
    exit(1);
  }

  // Resize shared memory
  if (ftruncate(g_shm_fd, __df_coverage_map_size) < 0) {
    perror("[df-coverage] ERROR: ftruncate failed");
    close(g_shm_fd);
    shm_unlink(g_shm_name);
    exit(1);
  }

  // Map shared memory
  __df_coverage_map =
      (uint8_t *)mmap(NULL, __df_coverage_map_size, PROT_READ | PROT_WRITE,
                      MAP_SHARED, g_shm_fd, 0);
  if (__df_coverage_map == MAP_FAILED) {
    perror("[df-coverage] ERROR: mmap failed");
    close(g_shm_fd);
    shm_unlink(g_shm_name);
    exit(1);
  }

  // Zero the map
  memset(__df_coverage_map, 0, __df_coverage_map_size);

  fprintf(stderr,
          "[df-coverage] Initialized coverage map with %u locations in shared "
          "memory %s\n",
          __df_coverage_map_size, g_shm_name);
}

// Record that a location was hit
void df_coverage_hit(uint32_t loc_id) {
  if (!__df_coverage_map) {
    df_coverage_init();
  }

  if (loc_id >= __df_coverage_map_size) {
    fprintf(stderr,
            "[df-coverage] WARNING: Location ID %u out of bounds (max: %u)\n",
            loc_id, __df_coverage_map_size - 1);
    return;
  }

  // Increment hit count (saturating at 255)
  if (__df_coverage_map[loc_id] < 255) {
    __df_coverage_map[loc_id]++;
  }
}

// Print coverage summary (commented out - not needed for now)
// Fuzzer will query the map directly
/*
void df_coverage_print_summary(void) {
  if (!__df_coverage_map) {
    fprintf(stderr, "[df-coverage] Coverage map not initialized\n");
    return;
  }

  uint32_t total_locations = __df_coverage_map_size;
  uint32_t hit_locations = 0;
  uint64_t total_hits = 0;

  for (uint32_t i = 0; i < total_locations; i++) {
    if (__df_coverage_map[i] > 0) {
      hit_locations++;
      total_hits += __df_coverage_map[i];
    }
  }

  fprintf(stderr, "\n=== Dataflow Coverage Summary ===\n");
  fprintf(stderr, "Total locations: %u\n", total_locations);
  fprintf(stderr, "Hit locations: %u (%.2f%%)\n", hit_locations,
          total_locations > 0 ? (100.0 * hit_locations / total_locations)
                              : 0.0);
  fprintf(stderr, "Total hits: %lu\n", total_hits);
  fprintf(stderr, "=================================\n\n");

  // Print detailed hit counts
  fprintf(stderr, "Location hit counts:\n");
  for (uint32_t i = 0; i < total_locations; i++) {
    if (__df_coverage_map[i] > 0) {
      fprintf(stderr, "  LOC_%u: %u hits\n", i, __df_coverage_map[i]);
    }
  }
}
*/

// Get coverage count for a specific location (for future fuzzer integration)
/*
uint8_t df_coverage_get_count(uint32_t loc_id) {
  if (!__df_coverage_map || loc_id >= __df_coverage_map_size) {
    return 0;
  }
  return __df_coverage_map[loc_id];
}
*/

// Reset coverage map (for future fuzzer integration)
/*
void df_coverage_reset(void) {
  if (__df_coverage_map) {
    memset(__df_coverage_map, 0, __df_coverage_map_size);
    fprintf(stderr, "[df-coverage] Coverage map reset\n");
  }
}
*/

__attribute__((destructor)) static void df_coverage_exit_handler(void) {
  if (__df_coverage_map && __df_coverage_map != MAP_FAILED) {
    // Unmap shared memory
    munmap(__df_coverage_map, __df_coverage_map_size);
    __df_coverage_map = NULL;
  }

  if (g_shm_fd >= 0) {
    close(g_shm_fd);
    g_shm_fd = -1;
  }

  // Note: We do NOT unlink the shared memory here!
  // The monitor service needs to read it after the process exits.
  // The monitor will unlink it after processing.
}
