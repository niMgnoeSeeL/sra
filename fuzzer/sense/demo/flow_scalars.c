#include <math.h>
#include <stdio.h>
#include <unistd.h>

int main() {
  // Test case 1: int taint source - read() directly into int
  int x;
  read(STDIN_FILENO, &x, sizeof(x)); // x is tainted (line 8)
  log(x);
  printf("int: %d\n", x * 2);

  // Test case 2: double taint source - read() directly into double
  double y;
  read(STDIN_FILENO, &y, sizeof(y)); // y is tainted (line 14)
  log(y);
  printf("double: %.2f\n", y * 2.0);

  // Test case 3: char array taint source - fgets
  char buf[16];
  fgets(buf, sizeof(buf), stdin); // buf is tainted (line 20)
  printf("string: %s", buf);

  return 0;
}
