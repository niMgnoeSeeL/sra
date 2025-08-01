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
        if (z < 0)
            continue;
        int y = 3;
        int r = x + z;
        x = z - y;
        z = r;
        if (z < x)
            pass;
        else
            pass;
        if (x < r) // z0양수, x1 = z0 - 3 < x0 + z0 = r -- 유의미한 변화
            pass;
        else
        {
            pass;
            reach++;
        }
    }
}