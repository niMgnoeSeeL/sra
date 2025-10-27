#include <stdio.h>
#include <unistd.h>

int main() {
  char matrix[4][16]; // 4 rows, 16 columns each

  // Taint source: read into second row only
  read(STDIN_FILENO, matrix[1], 16); // line 8: only matrix[1] is tainted

  printf("Row 1: %s\n", matrix[1]);

  return 0;
}
