#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#define pass (void)0

int method_a(int x, int y)
{

    if (x > 10)

        return x;

    if (y > 10)

        return y;

    return 0;
}

int method_b(int z)
{

    if (z > 10)
        return z++;
    else
        return z--;
}

int main(int argc, char *argv[])
{
    int cnt = 0, reach = 0, x, y;
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
        y = rand() - (rand() % 2 ? -1 << 31 : 0);
        int v = method_a(x, y);

        if (v > 0)
        {

            pass;

            int tmp = method_b(x); // orig method_b(x)

            if (tmp == x) // added

                pass;
        }
        else
            reach++; // 둘 다 10보다 크지 않을 때 도달 -- 유의미한 변화
    }
}