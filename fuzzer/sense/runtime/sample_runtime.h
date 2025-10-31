#pragma once
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

void sample_seed(uint64_t s);
void sample_set_budget(
    int n); // max number of samples allowed per process run; -1 = unlimited
int sample_int(int original); // sample from uniform int32 distribution,
                              // fallback to original
double sample_double(double original);   // sample from uniform [0.0, 1.0)
                                         // distribution, fallback to original
void sample_bytes(void *data, int size); // Mutate arbitrary byte array

#ifdef __cplusplus
}
#endif