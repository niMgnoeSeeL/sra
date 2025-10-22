#pragma once
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

void     mut_seed(uint64_t s);
void     mut_set_budget(int n);   // max number of mutations allowed per process run; -1 = unlimited
int      mut_int(int x);
double   mut_double(double x);

#ifdef __cplusplus
}
#endif
