#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#define pass (void)0

int main(int argc, char *argv[])
{
    int cnt = 0, reach = 0, i, j;
    float freq, lap;

    srand(atoi(argv[1]));

    while (cnt < 2000000)
    {
        cnt++;
        i = rand() - (rand() % 2 ? -1 << 31 : 0);
        switch (i)
        {
        case 1:
            j = 2;
            break;
        case 10:
            j = 11;
            break;
        case 100:
            j = 101;
            break;
        case 1000:
            j = 1001;
            break;
        case 10000:
            j = 10001;
            break;
        case 100000:
            j = 100001;
            break;
        default:
            j = -1;
        }

        if (i == 1 || i == 10 || i == 100 || i == 1000 || i == 10000 || i == 100000)
            reach++;
    }
    freq = (float)reach / cnt;
    lap = (float)(reach + 2) / (cnt + 4);
    printf("cnt:%d reach:%d freq:%e lap:%e\n", cnt, reach, freq, lap);
    return 0;
}