// target.c
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define MAX_BUF 1024

// This is our "taint sink" function.
// We will wrap this by name in DynamoRIO and track which bytes it reads.
void taint_sink(const uint8_t *buf, size_t len) {
  size_t sum = 0;

  // Simulate some non-trivial reading pattern
  for (size_t i = 0; i < len; i += 2) { // read every other byte
    sum += buf[i];
  }

  // Prevent the compiler from optimizing the loop away
  fprintf(stderr, "[taint_sink] sum = %zu\n", sum);
}

int main(void) {
  uint8_t *buf = malloc(MAX_BUF);
  if (!buf) {
    perror("malloc");
    return 1;
  }

  // Read up to MAX_BUF bytes from stdin
  size_t n = fread(buf, 1, MAX_BUF, stdin);
  if (n < 0) {
    perror("read");
    free(buf);
    return 1;
  }

  fprintf(stderr, "[main] read %zd bytes\n", n);

  // Call the sink
  taint_sink(buf, (size_t)n);

  free(buf);
  return 0;
}
