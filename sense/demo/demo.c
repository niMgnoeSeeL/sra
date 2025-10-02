#include <stdio.h>
#include "mut_runtime.h"  // so we can seed/budget from user code if we want

// target function
double f(int a, double x) {
  // mutate an arg
  return a * x + 1.0;
  // print the return value
}

int main() {
  // Optional: seed/budget from the program side
  double out = f(10, 3.14);
  printf("f(10, 3.14) = %.6f\n", out);
  return 0;
}
