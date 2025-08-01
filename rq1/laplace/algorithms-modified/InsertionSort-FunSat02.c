#include <stdio.h>
#include <time.h>
#include <math.h>
#include <stdlib.h>
#include <stdbool.h>
#define pass (void)0

void sort(int *a)
{
    int N = sizeof(a) / sizeof(a[0]);
    for (int i = 1; i < N; i++)
    { // N branches
        int j = i - 1;
        int x = a[i];
        // First branch (j >= 0):  2 + 3 + ... + N = N(N+1)/2 - 1 branches
        // Second branch (a[j] > x):  1 + 2 + ... + N-1 = (N-1)N/2 branches
        while ((j >= 0) && (a[j] > x))
        {
            a[j + 1] = a[j];
            j--;
        }
        a[j + 1] = x;
    }
}

int test(int N, int i1, int i2)
{
    if (N <= 0)
        return 0;

    int *a;
    a = (int *)malloc(N * sizeof(int));
    for (int i = 0; i < N; i++)
    {
        a[i] = N - i;
    }

    sort(a);

    free(a);
    if (0 > i1 || i2 >= N)
        return 0;
    if (i1 >= i2)
        return 0;
    // assert (a[i1] <= a[i2]);
    return 1;
}

int main(int argc, char *argv[])
{
    int cnt = 0, reach = 0, N, i1, i2;
    float low, high;
    low = atof(argv[2]);
    high = atof(argv[3]);
    int success_cnt = 0;
    float freq, lap;

    srand(atoi(argv[1]));

    int *cnt_arr, *reach_arr;
    cnt_arr = (int *)malloc(sizeof(int) * 2000000);
    reach_arr = (int *)malloc(sizeof(int) * 2000000);

    while (cnt < 2000000)
    {
        cnt_arr[cnt] = cnt;
        reach_arr[cnt] = reach;
        freq = (float)reach / cnt;
        lap = (float)(reach + 2) / (cnt + 4);
        printf("%d %d %f %f", cnt_arr[cnt], reach_arr[cnt], freq, lap);
        fflush(stdout);
        if (low <= lap && lap <= high)
        {
            success_cnt++;
            printf(" SUCCESS");
        }
        else
            success_cnt = 0;
        printf("\n");
        if (success_cnt == 10)
            break;
        cnt++;
        N = rand() - (rand() % 2 ? -1 << 31 : 0);
        i1 = rand() - (rand() % 2 ? -1 << 31 : 0);
        i2 = rand() - (rand() % 2 ? -1 << 31 : 0);
        reach += test(N, i1, i2);
    }
    return 0;
}