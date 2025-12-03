// target_persist.c
// Persistent version that calls taint_sink multiple times
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_BUF 1024
#define NUM_ITERATIONS 10000

// This is our "taint sink" function.
// We will wrap this by name in DynamoRIO and track which bytes it reads.
void taint_sink(const uint8_t *buf, size_t len) {
  size_t sum = 0;

  // Simulate some non-trivial reading pattern
  for (size_t i = 0; i < len; i += 2) { // read every other byte
    sum += buf[i];
  }

  // Prevent the compiler from optimizing the loop away
  // Only print occasionally to avoid I/O overhead
  if (sum % 100 == 0) {
    fprintf(stderr, "[taint_sink] sum = %zu\n", sum);
  }
}

int main(void) {
  fprintf(stderr, "[main] Running %d iterations...\n", NUM_ITERATIONS);

  for (int iter = 0; iter < NUM_ITERATIONS; iter++) {
    // Allocate a fresh buffer for each iteration
    uint8_t *buf = malloc(MAX_BUF);
    if (!buf) {
      perror("malloc");
      return 1;
    }

    // Fill buffer with pseudo-random data
    for (size_t i = 0; i < MAX_BUF; i++) {
      buf[i] = (uint8_t)((iter * 7 + i * 13) % 256);
    }

    // Vary the length for each iteration
    size_t len = 100 + (iter % 900);

    // Call the sink
    taint_sink(buf, len);

    free(buf);
  }

  fprintf(stderr, "[main] Completed %d iterations\n", NUM_ITERATIONS);
  return 0;
}
