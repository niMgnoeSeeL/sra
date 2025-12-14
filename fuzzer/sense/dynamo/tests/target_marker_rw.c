// target_marker_rw.c
// Demo target using BOTH source and sink marker functions for DR integration
#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_BUF 1024
#define NUM_ITERATIONS 50
#define NUM_THREADS 2

// Sink marker functions (empty stubs - DR client wraps these)
void __dr_start_tracking_sink(uint32_t sink_id, void *ptr) {
  // Empty stub - DynamoRIO wraps this
}

size_t __dr_end_tracking_sink(uint32_t sink_id) {
  // Empty stub - DynamoRIO wraps this
  return 0;
}

// Source marker functions (empty stubs - DR client wraps these)
void __dr_start_tracking_src(uint32_t src_id, void *ptr) {
  // Empty stub - DynamoRIO wraps this
}

size_t __dr_end_tracking_src(uint32_t src_id) {
  // Empty stub - DynamoRIO wraps this
  return 0;
}

// Taint source: writes to buffer (simulates SSL_read)
void taint_source(uint8_t *buf, size_t len) {
  for (size_t i = 0; i < len; i += 2) {
    buf[i] = (uint8_t)(i % 256);
  }
}

// Taint sink: reads from buffer (simulates SSL_write)
void taint_sink(const uint8_t *buf, size_t len) {
  size_t sum = 0;
  for (size_t i = 0; i < len; i += 2) {
    sum += buf[i];
  }

  // Prevent optimization
  if (sum % 1000 == 0) {
    fprintf(stderr, "[taint_sink] sum=%zu\n", sum);
  }
}

// Data transformation: both reads and writes
void process_buffer(uint8_t *buf, size_t len) {
  for (size_t i = 0; i < len / 2; i++) {
    // Read from first half, write to second half
    buf[len / 2 + i] = buf[i] ^ 0xFF;
  }
}

// Thread worker function
void *worker_thread(void *arg) {
  int thread_id = *(int *)arg;

  fprintf(stderr, "[Thread %d] Starting %d iterations...\n", thread_id,
          NUM_ITERATIONS);

  for (int iter = 0; iter < NUM_ITERATIONS; iter++) {
    // Allocate buffers
    uint8_t *src_buf = malloc(MAX_BUF);
    uint8_t *dst_buf = malloc(MAX_BUF);
    if (!src_buf || !dst_buf) {
      perror("malloc");
      return NULL;
    }

    // Initialize buffers
    memset(src_buf, 0, MAX_BUF);
    memset(dst_buf, 0, MAX_BUF);

    size_t len = 100 + (iter % 200);

    // === SOURCE TRACKING (ID 100): Track writes ===
    __dr_start_tracking_src(100, (void *)src_buf);
    taint_source(src_buf, len);
    size_t max_write = __dr_end_tracking_src(100);

    if (max_write > 0 && iter % 10 == 0) {
      fprintf(stderr, "[Thread %d iter %d] Source max write: %zu bytes\n",
              thread_id, iter, max_write);
    }

    // === PROCESSING: Both read and write ===
    // Not wrapping this for now.
    process_buffer(src_buf, len);

    // Copy data (simulating network buffer flow)
    memcpy(dst_buf, src_buf, len);

    // === SINK TRACKING (ID 200): Track reads ===
    __dr_start_tracking_sink(200, (void *)dst_buf);
    taint_sink(dst_buf, len);
    size_t max_read = __dr_end_tracking_sink(200);

    if (max_read > 0 && iter % 10 == 0) {
      fprintf(stderr, "[Thread %d iter %d] Sink max read: %zu bytes\n",
              thread_id, iter, max_read);
    }

    free(src_buf);
    free(dst_buf);
  }

  fprintf(stderr, "[Thread %d] Completed %d iterations\n", thread_id,
          NUM_ITERATIONS);
  return NULL;
}

int main(void) {
  fprintf(stderr, "[main] Running %d threads with %d iterations each...\n",
          NUM_THREADS, NUM_ITERATIONS);
  fprintf(stderr, "[main] Testing BOTH source (writes) and sink (reads) "
                  "tracking\n");

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
