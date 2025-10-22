#include <stdio.h>

// Function with MEDIUM interference - modulo operation
int modulo_func(int a, int b) {
    // Many values of 'a' can produce the same output due to modulo
    // Interference depends on the modulo value
    return (a % 100) + b;  // Only last 2 digits of 'a' matter
}

int main() {
    int result = modulo_func(12345, 10);
    printf("modulo_func(12345, 10) = %d\n", result);
    return 0;
}