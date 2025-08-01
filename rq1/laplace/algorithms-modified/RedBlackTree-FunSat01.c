#include <stdio.h>
#include <time.h>
#include <math.h>
#include <stdlib.h>
#include <stdbool.h>
#define pass (void)0


int test(int N, int n)
{
    if (N <= 0)
        return 0;

    // RedBlackTree tree = new RedBlackTree();

    // for (int i = 0; i < N; i++)
    //   tree.treeInsert(new RedBlackTreeNode(i));

    int data = n;
    if (data < 0 || data >= N)
        return 0;
    // RedBlackTreeNode node = tree.treeSearch(tree.root(), data);
    // assert (node != null);
    // System.out.println("here i am");
    return 1;
}

int main(int argc, char *argv[]) {
    int cnt = 0, reach = 0, N, n;
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
        n = rand() - (rand() % 2 ? -1 << 31 : 0);
        reach += test(N, n);
    }
    return 0;
}