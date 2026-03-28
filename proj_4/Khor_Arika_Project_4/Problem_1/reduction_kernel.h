#ifndef REDUCTION_KERNEL_H
#define REDUCTION_KERNEL_H

extern __global__ void reduction_kernel(unsigned int *d_hashes, unsigned int *d_nonces, int num_elements, unsigned int *d_min_hash, unsigned int *d_min_nonce);

#endif // REDUCTION_KERNEL_H
