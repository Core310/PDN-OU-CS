#include <stdio.h>
#include <stdlib.h>
#include "support.h"
#include "nonce_kernel.cu"
#include "hash_kernel.cu"

/*
 * Logic derived from project instructions MUST include a comment quoting the exact wording and page number from Project_3_Instructions.pdf.
 *
 * "Please change the CUDA program to gpu_mining_problem1.cu which performs Step 1 and Step 2 on the GPU and Step 3 on the CPU." (Page 5)
 */

int main(int argc, char **argv) {
    if (argc != 6) {
        printf("Usage: %s <transactions.csv> <n_transactions> <trials> <out.csv> <time.csv>
", argv[0]);
        return 1;
    }

    char *transactions_csv = argv[1];
    int n_transactions = atoi(argv[2]);
    int trials = atoi(argv[3]);
    char *out_csv = argv[4];
    char *time_csv = argv[5];

    unsigned int *transactions = (unsigned int *)malloc(n_transactions * sizeof(unsigned int));
    unsigned int *nonces = (unsigned int *)malloc(trials * sizeof(unsigned int));
    unsigned int *hashes = (unsigned int *)malloc(trials * sizeof(unsigned int));

    // Read transactions from file
    FILE *fp = fopen(transactions_csv, "r");
    for (int i = 0; i < n_transactions; i++) {
        fscanf(fp, "%u", &transactions[i]);
    }
    fclose(fp);

    unsigned int *d_transactions, *d_nonces, *d_hashes;

    cudaMalloc(&d_transactions, n_transactions * sizeof(unsigned int));
    cudaMalloc(&d_nonces, trials * sizeof(unsigned int));
    cudaMalloc(&d_hashes, trials * sizeof(unsigned int));

    cudaMemcpy(d_transactions, transactions, n_transactions * sizeof(unsigned int), cudaMemcpyHostToDevice);

    int threadsPerBlock = 256;
    int blocksPerGrid = (trials + threadsPerBlock - 1) / threadsPerBlock;

    // Step 1: Generate nonces on the GPU
    nonce_kernel<<<blocksPerGrid, threadsPerBlock>>>(d_nonces, trials);

    // Step 2: Generate hash values on the GPU
    hash_kernel<<<blocksPerGrid, threadsPerBlock>>>(d_nonces, d_transactions, d_hashes, n_transactions, trials);

    cudaMemcpy(nonces, d_nonces, trials * sizeof(unsigned int), cudaMemcpyDeviceToHost);
    cudaMemcpy(hashes, d_hashes, trials * sizeof(unsigned int), cudaMemcpyDeviceToHost);

    // Step 3: Find the nonce with the minimum hash value on the CPU
    unsigned int min_hash = -1;
    unsigned int min_nonce = -1;

    for (int i = 0; i < trials; i++) {
        if (hashes[i] < min_hash) {
            min_hash = hashes[i];
            min_nonce = nonces[i];
        }
    }
    
    // Save the results
    fp = fopen(out_csv, "w");
    fprintf(fp, "%u,%u", min_hash, min_nonce);
    fclose(fp);

    cudaFree(d_transactions);
    cudaFree(d_nonces);
    cudaFree(d_hashes);
    free(transactions);
    free(nonces);
    free(hashes);

    return 0;
}
