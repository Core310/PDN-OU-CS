#ifndef REDUCTION_KERNEL_CU
#define REDUCTION_KERNEL_CU

#include <cuda_runtime.h>
#include <stdio.h>
#include "reduction_kernel.h" // Include the header for declaration

// Define a large value for initialization, assuming unsigned int max is sufficient
#define UINT_MAX_VAL 0xFFFFFFFFU 
#define MAX 123123123 

__global__ void reduction_kernel(unsigned int *d_hashes, unsigned int *d_nonces, int num_elements, unsigned int *d_min_hash, unsigned int *d_min_nonce) {
    extern __shared__ unsigned int s_data[];
    unsigned int *s_hashes = s_data;
    unsigned int *s_nonces = &s_data[blockDim.x];

    int tid = threadIdx.x;
    int i = blockIdx.x * blockDim.x + threadIdx.x;

    if(i < num_elements) {
        s_hashes[tid] = d_hashes[i];
        s_nonces[tid] = d_nonces[i];
    } else {
        s_hashes[tid] = MAX;
        s_nonces[tid] = MAX;
    }

    __syncthreads();

    for (unsigned int s=blockDim.x/2; s>0; s>>=1) {
        if (tid < s) {
            if (s_hashes[tid] > s_hashes[tid+s]) {
                s_hashes[tid] = s_hashes[tid+s];
                s_nonces[tid] = s_nonces[tid+s];
            }
        }
        __syncthreads();
    }

    if (tid == 0) {
        d_min_hash[blockIdx.x] = s_hashes[0];
        d_min_nonce[blockIdx.x] = s_nonces[0];
    }
}

#endif // REDUCTION_KERNEL_CU
