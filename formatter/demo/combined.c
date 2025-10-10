#include <stdio.h>

int test_combined() {
    int result = 0;
    
    for (int i = 0; i < 10 && i > -5; i++) {
        int temp = (i > 5) ? i * 2 : i + 1;
        if (temp > 0 && temp < 20) {
            result += temp;
        }
    }
    
    return result;
}