
#include "support.h"

/*
 * Logic derived from project instructions MUST include a comment quoting the exact wording and page number from Project_3_Instructions.pdf.
 *
 * "In the Problem 1, please write a kernel function called hash_kernel.cu to generate the hash value array on the GPU." (Page 5)
 */

__global__ void hash_kernel(unsigned int *nonce_array, unsigned int *transaction_array, unsigned int *hash_array, int n_transactions, int trials) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;

    if (idx < trials) {
        unsigned int nonce = nonce_array[idx];
        unsigned int hash = 0;

        for (int i = 0; i < n_transactions; i++) {
            hash += transaction_array[i] * nonce;
        }

        hash_array[idx] = hash % 10000;
    }
}
