#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#define pass (void)0

int main(int argc, char *argv[])
{
    int cnt = 0, reach = 0, x, z;
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
        x = rand() - (rand() % 2 ? -1 << 31 : 0);
        z = rand() - (rand() % 2 ? -1 << 31 : 0);
        x = x % 1000;
        z = z % 50;
        x = z++;
        if (z > 0)
            pass;
        else
        {
            reach++;
        }
        if (x > 0)
            pass;
        else
            pass;
    }
    return 0;
}