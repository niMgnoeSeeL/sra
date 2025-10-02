#include "sample_runtime.h"
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <limits.h>

// Default values
#define DEFAULT_SEED 0x1234567890ABCDEFull
#define DEFAULT_BUDGET -1  // -1 means unlimited samples

static uint64_t g_state = DEFAULT_SEED;
static int g_budget = DEFAULT_BUDGET;
static int g_initialized = 0;

static uint64_t xorshift64star(void) {
  uint64_t x = g_state;
  x ^= x >> 12;
  x ^= x << 25;
  x ^= x >> 27;
  g_state = x;
  return x * 0x2545F4914F6CDD1Dull;
}

void sample_seed(uint64_t s) { g_state = s ? s : DEFAULT_SEED; }
void sample_set_budget(int n) { g_budget = n; }

static void init_from_env(void) {
  if (g_initialized) return;
  g_initialized = 1;
  
  // Set defaults first
  g_state = DEFAULT_SEED;
  g_budget = DEFAULT_BUDGET;
  
  // Override with environment variables if they exist
  const char *seed_str = getenv("SAMPLE_SEED");
  if (seed_str && *seed_str) {  // Check for non-empty string
    uint64_t seed = strtoull(seed_str, NULL, 0);
    if (seed != 0 || seed_str[0] == '0') {  // Handle explicit zero
      g_state = seed;
    }
  }
  
  const char *budget_str = getenv("SAMPLE_BUDGET");
  if (budget_str && *budget_str) {  // Check for non-empty string
    g_budget = atoi(budget_str);
  }
}

static int budget_ok(void) {
  init_from_env(); // Initialize on first use
  if (g_budget < 0) return 1;
  if (g_budget == 0) return 0;
  --g_budget; return 1;
}

int sample_int(int original) {
  if (!budget_ok()) return original;  // Return original when budget exhausted
  
  // Generate uniform int32 using full 64-bit random value
  uint64_t r = xorshift64star();
  
  // Use upper 32 bits for better distribution
  uint32_t u32 = (uint32_t)(r >> 32);
  
  // Convert to signed int32 (covers full range including negative)
  return (int)u32;
}

double sample_double(double original) {
  if (!budget_ok()) return original;  // Return original when budget exhausted
  
  // Generate uniform double in [0.0, 1.0) using high-quality method
  uint64_t r = xorshift64star();
  
  // Use 53 bits of precision (IEEE 754 double mantissa)
  uint64_t mantissa = r >> 11;  // Take upper 53 bits
  
  // Convert to [0.0, 1.0) range
  return (double)mantissa / (double)(1ULL << 53);
}