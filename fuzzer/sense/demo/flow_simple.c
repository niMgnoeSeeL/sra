#include <math.h>
#include <stdio.h>
#include <stdlib.h>

int main() {
  char buf[16];
  fgets(buf, sizeof(buf), stdin);
  double x = atof(buf);
  log(x);
  printf("%s", buf);
  return 0;
}
