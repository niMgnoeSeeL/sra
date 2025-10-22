#include <stdio.h>

// Function with COLLISION-BASED interference - hash-like function
int hash_func(int a, int b) {
    // Simple hash function that can have collisions
    // Some different values of 'a' will produce same hash
    unsigned int hash = (unsigned int)a;
    hash = hash * 2654435761U;  // Knuth's multiplicative hash
    return (int)(hash % 1000) + b;  // Take last 3 digits
}

int main() {
    int result = hash_func(12345, 10);
    printf("hash_func(12345, 10) = %d\n", result);
    return 0;
}