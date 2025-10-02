#include <stdio.h>

// Function with LOW interference - sign function
int sign_func(int a, int b) {
    // Only the sign of 'a' matters, not its magnitude
    // So roughly half the int32 values give same output
    if (a > 0) return b + 1;
    else if (a < 0) return b - 1;
    else return b;  // a == 0
}

int main() {
    int result = sign_func(12345, 10);
    printf("sign_func(12345, 10) = %d\n", result);
    return 0;
}