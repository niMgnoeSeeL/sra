// target_marker.c
// Demo target using marker functions for DR integration
#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define MAX_BUF 1024
#define NUM_ITERATIONS 50 // Reduced per thread
#define NUM_THREADS 2

// Marker functions (empty stubs - DR client wraps these)
void __dr_start_tracking_src(uint32_t sink_id, void *ptr) {
  // Empty stub - DynamoRIO wraps this
  // Note: len removed - DR does dynamic allocation lookup
}

size_t __dr_end_tracking_src(uint32_t sink_id) {
  // Empty stub - DynamoRIO wraps this
  // Returns: max distance write from ptr offset
  return 0;
}

// This is our "taint source" function - now wrapped with markers
// SOURCE ID 42: SSL_read-like function
void taint_src(uint8_t *buf, size_t len) {
  size_t sum = 0;
  // Simulate some non-trivial writing pattern
  for (size_t i = 0; i < len; i += 2) { // write every other byte
    buf[i] = (uint8_t)(i % 256);
    sum += buf[i];
  }

  // Prevent the compiler from optimizing the loop away
  if (sum % 100 == 0) {
    fprintf(stderr, "[taint_src] sum=%zu\n", sum);
  }
}

// Thread worker function
void *worker_thread(void *arg) {
  int thread_id = *(int *)arg;

  fprintf(stderr, "[Thread %d] Starting %d iterations...\n", thread_id,
          NUM_ITERATIONS);

  for (int iter = 0; iter < NUM_ITERATIONS; iter++) {
    // Allocate a fresh buffer for each iteration
    uint8_t *buf = malloc(MAX_BUF);
    if (!buf) {
      perror("malloc");
      return NULL;
    }

    // Fill buffer with pseudo-random data
    for (size_t i = 0; i < MAX_BUF; i++) {
      buf[i] = (uint8_t)((thread_id * 7 + iter * 13 + i * 17) % 256);
    }

    // Vary the length for each iteration
    size_t len = 100 + (iter % 200);

    // STATIC SINK_ID: All threads use the same sink_id=42 for this sink
    uint32_t sink_id = 42;

    // Start tracking (marker inserted by LLVM pass or manually)
    __dr_start_tracking_src(sink_id, (void *)buf);
    taint_src(buf, len);
    // End tracking - returns max distance write from buf
    size_t max_write = __dr_end_tracking_src(sink_id);

    if (max_write > 0) {
      fprintf(stderr, "[Thread %d iter %d] Max write distance: %zu bytes\n",
              thread_id, iter, max_write);
    }

    free(buf);
  }

  fprintf(stderr, "[Thread %d] Completed %d iterations\n", thread_id,
          NUM_ITERATIONS);
  return NULL;
}

int main(void) {
  fprintf(stderr, "[main] Running %d threads with %d iterations each...\n",
          NUM_THREADS, NUM_ITERATIONS);

  pthread_t threads[NUM_THREADS];
  int thread_ids[NUM_THREADS];

  // Create threads
  for (int i = 0; i < NUM_THREADS; i++) {
    thread_ids[i] = i;
    if (pthread_create(&threads[i], NULL, worker_thread, &thread_ids[i]) != 0) {
      perror("pthread_create");
      return 1;
    }
  }

  // Join threads
  for (int i = 0; i < NUM_THREADS; i++) {
    pthread_join(threads[i], NULL);
  }

  fprintf(stderr, "[main] All threads completed\n");
  return 0;
}
