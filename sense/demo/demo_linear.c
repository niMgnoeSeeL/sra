#include <stdio.h>

// Function with HIGH interference - linear in first argument
double linear_func(int a, double x) {
    // Every different value of 'a' produces a different output
    return a * x + 1.0;
}

int main() {
    double result = linear_func(10, 3.14);
    printf("linear_func(10, 3.14) = %.6f\n", result);
    return 0;
}