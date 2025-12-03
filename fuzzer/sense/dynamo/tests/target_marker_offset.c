// target_marker_offset.c
// Test with ptr offset from base address
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

// Marker functions (empty stubs - DR client wraps these)
void __dr_start_tracking_sink(uint32_t sink_id, void *ptr) {
  // Empty stub - DynamoRIO wraps this
}

size_t __dr_end_tracking_sink(uint32_t sink_id) {
  // Empty stub - DynamoRIO wraps this
  return 0;
}

// Sink function that reads from buffer
void taint_sink(const uint8_t *buf, size_t len) {
  size_t sum = 0;
  for (size_t i = 0; i < len; i += 2) { // read every other byte
    sum += buf[i];
  }
  if (sum % 100 == 0) {
    fprintf(stderr, "[taint_sink] sum=%zu\n", sum);
  }
}

int main(void) {
  fprintf(stderr, "[main] Testing with ptr offset from base...\n");

  // Test 1: ptr == base (offset = 0)
  {
    uint8_t *base = malloc(256);
    for (size_t i = 0; i < 256; i++) {
      base[i] = (uint8_t)i;
    }

    uint8_t *ptr = base; // No offset
    size_t len = 100;

    fprintf(stderr, "\n[Test 1] ptr == base, len=%zu\n", len);
    __dr_start_tracking_sink(1, (void *)ptr);
    taint_sink(ptr, len);
    size_t max_read = __dr_end_tracking_sink(1);
    fprintf(stderr, "[Test 1] Returned max_read = %zu\n", max_read);

    free(base);
  }

  // Test 2: ptr with offset (ptr = base + 50)
  {
    uint8_t *base = malloc(256);
    for (size_t i = 0; i < 256; i++) {
      base[i] = (uint8_t)i;
    }

    uint8_t *ptr = base + 50; // Offset = 50
    size_t len = 100;

    fprintf(stderr, "\n[Test 2] ptr = base + 50, len=%zu\n", len);
    fprintf(stderr, "[Test 2] base=%p, ptr=%p, offset=%ld\n", base, ptr,
            (long)(ptr - base));
    __dr_start_tracking_sink(2, (void *)ptr);
    taint_sink(ptr, len);
    size_t max_read = __dr_end_tracking_sink(2);
    fprintf(stderr, "[Test 2] Returned max_read = %zu\n", max_read);

    free(base);
  }

  // Test 3: Large offset (ptr = base + 200)
  {
    uint8_t *base = malloc(1024);
    for (size_t i = 0; i < 1024; i++) {
      base[i] = (uint8_t)i;
    }

    uint8_t *ptr = base + 200; // Offset = 200
    size_t len = 50;

    fprintf(stderr, "\n[Test 3] ptr = base + 200, len=%zu\n", len);
    fprintf(stderr, "[Test 3] base=%p, ptr=%p, offset=%ld\n", base, ptr,
            (long)(ptr - base));
    __dr_start_tracking_sink(3, (void *)ptr);
    taint_sink(ptr, len);
    size_t max_read = __dr_end_tracking_sink(3);
    fprintf(stderr, "[Test 3] Returned max_read = %zu\n", max_read);

    free(base);
  }

  fprintf(stderr, "\n[main] All tests completed\n");
  return 0;
}
