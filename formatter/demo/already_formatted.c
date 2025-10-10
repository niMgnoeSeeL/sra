#include <stdio.h>

int test_already_formatted() {
    int x = 5;
    
    // Already properly formatted if-else
    if (x > 0)
        printf("positive\n");
    else
        printf("not positive\n");
    
    // Already properly formatted while
    while (x > 0)
        x--;
    
    // Already properly formatted for loop
    for (int i = 0
         ; i < 10
         ; i++)
        printf("i = %d\n", i);
    
    return 0;
}