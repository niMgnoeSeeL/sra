// Comprehensive test combining all new patterns
#include <stdio.h>
#include <vector>
#include <iostream>
#include <stdexcept>

int main() {
    int x = 2;
    std::vector<int> numbers = {1, 2, 3};
    
    // Combined constructs that should all be broken
    switch (x) { case 1: for (auto n : numbers) { printf("%d ", n); } break; case 2: try { throw std::runtime_error("test"); } catch (...) { printf("caught\n"); } break; default: goto cleanup; }
    
    // Complex nesting
    for (auto num : numbers) { switch (num) { case 1: try { printf("One\n"); } catch (...) { goto error; } break; case 2: printf("Two\n"); break; default: break; } }
    
    goto end;
    
    error: printf("Error occurred\n");
    cleanup: printf("Cleanup\n");
    end: printf("Program end\n");
    
    return 0;
}