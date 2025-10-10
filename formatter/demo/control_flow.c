#include <stdio.h>

int main() {
    int x = 5;
    
    // Single-line if statement
    if (x > 0) printf("positive\n");
    
    // Single-line if-else
    if (x > 10) printf("big\n"); else printf("small\n");
    
    // Single-line while loop
    while (x > 0) x--;
    
    // Do-while loop
    do x++; while (x < 3);
    
    // Nested single-line constructs
    if (x > 0) while (x < 10) x++;
    
    return 0;
}