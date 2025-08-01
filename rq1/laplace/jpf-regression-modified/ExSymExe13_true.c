#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#define pass (void)0

int main(int argc, char *argv[])
{
    int cnt = 0, reach = 0, x, z;
    float freq, lap;

    srand(atoi(argv[1]));

    while (cnt < 2000000)
    {
        cnt++;
        x = rand() - (rand() % 2 ? -1 << 31 : 0);
        z = rand() - (rand() % 2 ? -1 << 31 : 0);
        if (z < 0)
            continue;
        pass;
        int y = 3;
        int r = x + z;
        z = x - y - 4;
        if (r < 99)
            pass;
        else
            pass;
        if (x < z)
        { // x0 < x0 - 7 = z1 -- 유의미한 변화, dup 아닌가?
            pass;
            reach++;
        }
        else
            pass;

        // assert false;
    }
    freq = (float)reach / cnt;
    lap = (float)(reach + 2) / (cnt + 4);
    printf("cnt:%d reach:%d freq:%e lap:%e\n", cnt, reach, freq, lap);
    return 0;
}