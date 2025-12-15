#include <stdio.h>
#include <stdlib.h>

char *taint_source(char *name) {
  // introduce the taint
  return getenv(name);
}

int main() {
  // Get environment variable
  char *var_name = "HOME";
  char *value = taint_source(var_name);
  if (value) {
    printf("Value of %s: %s\n", var_name, value);
  } else {
    printf("%s is not set.\n", var_name);
  }
  return 0;
}