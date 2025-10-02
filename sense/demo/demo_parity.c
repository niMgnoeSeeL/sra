#include <stdio.h>

int parity_func(int a, int b) {
    // Only the parity (even/odd) of 'a' matters
    return (a % 2) + b; 
}

int main() {
    int result = parity_func(12345, 10);
    printf("parity_func(12345, 10) = %d\n", result);
    return 0;
}