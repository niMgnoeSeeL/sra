//===----------------------------------------------------------------------===//
// df_coverage_runtime.h - Dataflow coverage tracking runtime
//===----------------------------------------------------------------------===//

#ifndef DF_COVERAGE_RUNTIME_H
#define DF_COVERAGE_RUNTIME_H

#include <stdint.h>
#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif

// Shared memory header for coverage map
typedef struct {
  uint32_t map_size;  // Number of coverage locations
  uint32_t completed; // Set to 1 when program exits (atomic)
  uint8_t map[];      // Coverage map (flexible array)
} DFCoverageBuffer;

// Global coverage map (dynamically sized based on number of locations)
extern uint8_t *__df_coverage_map;
extern uint32_t __df_coverage_map_size;

// Initialize coverage map
void df_coverage_init(void);

// Record that a location was hit
void df_coverage_hit(uint32_t loc_id);

// Functions for future fuzzer integration (commented out for now)
// Fuzzer will access __df_coverage_map directly

/*
// Print coverage summary
void df_coverage_print_summary(void);

// Get coverage count for a specific location
uint8_t df_coverage_get_count(uint32_t loc_id);

// Reset coverage map
void df_coverage_reset(void);
*/

#ifdef __cplusplus
}
#endif

#endif // DF_COVERAGE_RUNTIME_H
