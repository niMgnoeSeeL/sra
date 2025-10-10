// Test file for switch, case, and default statement formatting
#include <stdio.h>

int main() {
    int x = 2;
    
    // Switch statement that should be broken to separate lines
    switch (x) { case 1: printf("One"); break; case 2: printf("Two"); break; default: printf("Other"); break; }
    
    // Nested switch
    switch (x) {
        case 1: { int y = 3; switch (y) { case 3: printf("Nested"); break; default: break; } } break;
        case 2: printf("Two"); break;
        default: printf("Default"); break;
    }
    
    return 0;
}