#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#define pass (void)0

int main(int argc, char *argv[])
{
    int cnt = 0, reach = 0, x, z, r;
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
        r = rand() - (rand() % 2 ? -1 << 31 : 0);
        if (x < 0)
            continue;
        x = x % 3; // [0, 2]
        if (z < 0)
            continue;
        z = z % 9; // [0, 8]
        // printf("x:%d, z:%d\n", x, z);
        int y = 3;
        r = x + z; // [0, 10]
        x = z - y; // [-3, 5]
        z = r; // [0, 10]
        if (z >= x) // 복잡하네 -- 유의미한 변화
            pass;
        else
            pass;
        // printf("x:%d, r:%d\n", x, r);
        if (x >= r) // x [-3, 5] >= [0, 10] r
        {
            pass;
        }
        else // x [-3, 5] < [0, 10] r
        {
            reach++;
            pass;
        }
    }
}