#include "sample_runtime.h"
#include <limits.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <sys/random.h>
#include <time.h>
#include <unistd.h>

// Default values
#define DEFAULT_BUDGET -1   // -1 means unlimited samples
#define MAX_CSTR (1u << 20) // 1 MiB cap for C-string lengths

static uint64_t g_state = 0;
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

static size_t clamp_cstr_len(const char *s) {
  if (s == NULL)
    return 0;
  return strnlen(s, MAX_CSTR);
}

void sample_seed(uint64_t s) { g_state = s; }
void sample_set_budget(int n) { g_budget = n; }

static void init_from_env(void) {
  // One-time initialization from environment variables
  if (g_initialized)
    return;
  g_initialized = 1;

  // Initialize budget (default: unlimited)
  g_budget = DEFAULT_BUDGET;
  const char *budget_str = getenv("SAMPLE_BUDGET");
  if (budget_str && *budget_str) {
    g_budget = atoi(budget_str);
  }

  // Initialize seed: use SAMPLE_SEED if set, otherwise use random entropy
  const char *seed_str = getenv("SAMPLE_SEED");
  if (seed_str && *seed_str) {
    // User provided explicit seed
    uint64_t seed = strtoull(seed_str, NULL, 0);
    if (seed != 0 || seed_str[0] == '0') {
      g_state = seed;
    }
  } else {
    // No explicit seed: use random entropy
    uint64_t newseed;

    // High-quality entropy if available
    if (getrandom(&newseed, sizeof(newseed), GRND_NONBLOCK) ==
        sizeof(newseed)) {
      g_state = newseed;
    } else {
      // Fallback entropy: rdtsc + time-based mixing
      unsigned long t = 0;
#ifdef __x86_64__
      t = __builtin_ia32_rdtsc();
#else
      t = (unsigned long)clock();
#endif
      uint64_t fallback =
          ((uint64_t)t << 32) ^ (uint64_t)time(NULL) ^ (uint64_t)getpid();

      g_state = fallback;
    }
  }
}

static int budget_ok(void) {
  init_from_env(); // Initialize on first use
  if (g_budget < 0)
    return 1;
  if (g_budget == 0)
    return 0;
  --g_budget;
  return 1;
}

int sample_int(int original) {
  if (!budget_ok())
    return original; // Return original when budget exhausted

  // Generate uniform int32 using full 64-bit random value
  uint64_t r = xorshift64star();

  // Use upper 32 bits for better distribution
  uint32_t u32 = (uint32_t)(r >> 32);

  // Convert to signed int32 (covers full range including negative)
  return (int)u32;
}

double sample_double(double original) {
  if (!budget_ok())
    return original; // Return original when budget exhausted

  // Generate uniform double in [0.0, 1.0) using high-quality method
  uint64_t r = xorshift64star();

  // Use 53 bits of precision (IEEE 754 double mantissa)
  uint64_t mantissa = r >> 11; // Take upper 53 bits

  // Convert to [0.0, 1.0) range
  return (double)mantissa / (double)(1ULL << 53);
}

void sample_bytes(void *data, int size) {
  if (!budget_ok())
    return;

  if (data == NULL)
    return;

  if (size == -1) {
    size = (int)clamp_cstr_len((const char *)data);
  }

  if (size <= 0)
    return;

  unsigned char *bytes = (unsigned char *)data;

  // Mutate each byte with random data
  for (int i = 0; i < size; i++) {
    uint64_t r = xorshift64star();
    bytes[i] = (unsigned char)(r & 0xFF);
  }
}