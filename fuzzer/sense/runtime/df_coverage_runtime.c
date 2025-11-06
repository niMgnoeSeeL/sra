//===----------------------------------------------------------------------===//
// df_coverage_runtime.c - Dataflow coverage tracking runtime implementation
//===----------------------------------------------------------------------===//

#include "df_coverage_runtime.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Global coverage map (allocated at runtime)
uint8_t *__df_coverage_map = NULL;
uint32_t __df_coverage_map_size = 0;

// Initialize coverage map
void df_coverage_init(void) {
  if (__df_coverage_map) {
    return; // Already initialized
  }

  if (__df_coverage_map_size == 0) {
    fprintf(stderr,
            "[df-coverage] WARNING: Map size is 0, using default size 1024\n");
    __df_coverage_map_size = 1024;
  }

  __df_coverage_map =
      (uint8_t *)calloc(__df_coverage_map_size, sizeof(uint8_t));
  if (!__df_coverage_map) {
    fprintf(stderr, "[df-coverage] ERROR: Failed to allocate coverage map\n");
    exit(1);
  }

  fprintf(stderr, "[df-coverage] Initialized coverage map with %u locations\n",
          __df_coverage_map_size);
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
  if (__df_coverage_map) {
    // df_coverage_print_summary();
    free(__df_coverage_map);
    __df_coverage_map = NULL;
  }
}
