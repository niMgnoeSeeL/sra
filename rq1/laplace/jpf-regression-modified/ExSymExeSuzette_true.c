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
    float freq, lap;

    srand(atoi(argv[1]));

    while (cnt < 2000000)
    {
        cnt++;
        x = rand() - (rand() % 2 ? -1 << 31 : 0);
        y = rand() - (rand() % 2 ? -1 << 31 : 0);
        if (x < 0 || x > 10)
            continue;

        int v = method_a(x, y);

        if (v > 0)
        {
            pass;

            int tmp = method_b(x); // orig method_b(x)

            if (tmp == x) // added
                pass;
            reach++; // x가 0에서 10 사이 -- 유의미한 변화
        }
    }

    freq = (float)reach / cnt;
    lap = (float)(reach + 2) / (cnt + 4);
    printf("cnt:%d reach:%d freq:%e lap:%e\n", cnt, reach, freq, lap);
    return 0;
}