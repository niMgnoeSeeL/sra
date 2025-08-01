#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#define pass (void)0

int testOrig(int a, int b)
{
    if (a > b)
    {
        pass;
    }
    else if (a == b)
    {
        return 1; // arg == arg + 1 -- 유의미한 변화
        pass;
    }
    else
        pass;
    return 0;
}

int main(int argc, char *argv[])
{
    int cnt = 0, reach = 0, arg;
    float freq, lap;

    srand(atoi(argv[1]));

    while (cnt < 2000000)
    {
        cnt++;
        arg = rand() - (rand() % 2 ? -1 << 31 : 0);
        if (arg >= 2147483647)
            continue;
        reach += testOrig(arg, arg + 1);
    }

    freq = (float)reach / cnt;
    lap = (float)(reach + 2) / (cnt + 4);
    printf("cnt:%d reach:%d freq:%e lap:%e\n", cnt, reach, freq, lap);
    return 0;
}