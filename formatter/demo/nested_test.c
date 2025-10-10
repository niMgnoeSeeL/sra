#include <stdio.h>

int test_nested() {
    int x = 5, y = 10;
    
    if (x > 0) if (y > 5) printf("nested\n"); else printf("inner else\n");
    
    if (x > 0) printf("first\n"); else if (y > 5) printf("else if\n"); else printf("final else\n");
    
    return 0;
}