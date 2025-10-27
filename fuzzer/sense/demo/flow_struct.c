#include <stdio.h>
#include <unistd.h>

struct Student {
  int id;
  int age;
  char name[32];
};

int main() {
  struct Student s;

  // Taint source: read directly into age field
  read(STDIN_FILENO, &s.age, sizeof(s.age)); // line 14: only s.age is tainted

  printf("Student age: %d\n", s.age * 2);

  return 0;
}
