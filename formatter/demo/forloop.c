#include <stdio.h>

int main() {
    for (int i = 0; i < 10; i++) {
        printf("i = %d\n", i);
    }
    
    for (int j = 0; j < 5 && j > -1; j += 2) {
        if (j == 2) break;
    }
    
    int k;
    for (k = 1; k <= 100; k *= 2) {
        // do something
    }
    
    return 0;
}