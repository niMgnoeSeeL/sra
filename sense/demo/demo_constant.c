#include <stdio.h>

// Function with ZERO interference - constant function
int constant_func(int a, int b) {
    // This function ignores its arguments completely
    return 42;
}

int main() {
    int result = constant_func(10, 20);
    printf("constant_func(10, 20) = %d\n", result);
    return 0;
}