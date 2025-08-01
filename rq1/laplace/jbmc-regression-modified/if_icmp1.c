#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#define pass (void)0

int f(int i, int j) {
    if (i == j) {
      return 1;
    }
    return 0;
}

int main(int argc, char *argv[])
{
    int cnt = 0, reach = 0, i;
    float freq, lap;

    srand(atoi(argv[1]));

    while (cnt < 2000000)
    {
        cnt++;
        i = rand() - (rand() % 2 ? -1 << 31 : 0);
        if (i + 1 < 0)
        continue;
        reach += f(i, i + 1);
    }
    freq = (float)reach / cnt;
    lap = (float)(reach + 2) / (cnt + 4);
    printf("cnt:%d reach:%d freq:%e lap:%e\n", cnt, reach, freq, lap);
    return 0;
}