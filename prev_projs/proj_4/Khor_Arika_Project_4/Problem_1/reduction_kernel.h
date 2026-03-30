#ifndef REDUCTION_KERNEL_H
#define REDUCTION_KERNEL_H

extern __global__ void reduction_kernel(unsigned int *d_hashes, unsigned int *d_nonces, int num_elements, unsigned long long *d_min_result);

#endif // REDUCTION_KERNEL_H
