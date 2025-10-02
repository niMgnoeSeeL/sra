#include "mut_runtime.h"
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>

// Default values
#define DEFAULT_SEED 0x9E3779B97F4A7C15ull
#define DEFAULT_BUDGET -1  // -1 means unlimited mutations

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

void mut_seed(uint64_t s) { g_state = s ? s : DEFAULT_SEED; }
void mut_set_budget(int n) { g_budget = n; }

static void init_from_env(void) {
  if (g_initialized) return;
  g_initialized = 1;
  
  // Set defaults first
  g_state = DEFAULT_SEED;
  g_budget = DEFAULT_BUDGET;
  
  // Override with environment variables if they exist
  const char *seed_str = getenv("MUT_SEED");
  if (seed_str && *seed_str) {  // Check for non-empty string
    uint64_t seed = strtoull(seed_str, NULL, 0);
    if (seed != 0 || seed_str[0] == '0') {  // Handle explicit zero
      g_state = seed;
    }
  }
  
  const char *budget_str = getenv("MUT_BUDGET");
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

int mut_int(int x) {
  if (!budget_ok()) return x;
  // Small jitter in {-1, 0, +1}
  int delta = (int)((xorshift64star() % 3ull) - 1ull);
  return x + delta;
}

double mut_double(double x) {
  if (!budget_ok()) return x;
  // Small relative jitter in about ±1e-3
  uint64_t r = xorshift64star();
  double u = (double)(r & ((1ull<<20)-1)) / (double)(1ull<<20); // [0,1)
  double eps = (u - 0.5) * 2.0e-3; // ~[-1e-3, +1e-3]
  return x + x * eps;
}
