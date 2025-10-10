// Test file for label statements and goto
#include <stdio.h>

int main() {
    int i = 0;
    
    // Label that should be on its own line
    start: printf("Starting loop\n"); i++;
    
    if (i < 3) goto start;
    
    // Another label with goto
    loop_begin: { int x = i * 2; printf("x = %d\n", x); i++; if (i < 5) goto loop_begin; }
    
    // Label in a switch
    int choice = 2;
    switch (choice) {
        case 1: goto label1;
        case 2: goto label2;
        default: goto end;
    }
    
    label1: printf("Label 1\n"); goto end;
    label2: printf("Label 2\n"); goto end;
    end: printf("End\n");
    
    return 0;
}