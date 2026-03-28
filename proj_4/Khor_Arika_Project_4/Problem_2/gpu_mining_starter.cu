#include <cuda_runtime_api.h>
#include <curand_kernel.h>
#include <driver_types.h>
#include <curand.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <time.h>
#include <cstdio>
#include <cuda.h>

#include "../common/support.h"
#include "hash_kernel.cu"
#include "nonce_kernel.cu"
#include "reduction_kernel.h"

// to activate debug statements
#define DEBUG 1

// program constants
#define BLOCK_SIZE 1024
#define SEED       123

// solution constants
#define MAX     123123123
#define TARGET  20

// functions used
unsigned int generate_hash(unsigned int nonce, unsigned int index, unsigned int* transactions, unsigned int n_transactions);
void read_file(char* file, unsigned int* transactions, unsigned int n_transactions);


/* Main ------------------ //
*   This is the main program.
*/
int main(int argc, char* argv[]) {

    // Catch console errors
    if (argc < 6 || argc > 7) {
        printf("USE LIKE THIS: gpu_mining transactions.csv n_transactions trials out.csv time.csv [BLOCK_SIZE]\n");
        return EXIT_FAILURE;
    }

    // Block size configuration
    unsigned int block_size = 1024;
    if (argc == 7) {
        block_size = strtoul(argv[6], NULL, 10);
    }


    // Output files
    FILE* output_file = fopen(argv[4], "w");
    FILE* time_file   = fopen(argv[5], "w");

    // Read in the transactions
    unsigned int n_transactions = strtoul(argv[2], NULL, 10);
    unsigned int* transactions = (unsigned int*)calloc(n_transactions, sizeof(unsigned int));
    read_file(argv[1], transactions, n_transactions);

    // get the number of trials
    unsigned int trials = strtoul(argv[3], NULL, 10);


    // -------- Start Mining ------------------------------------------------------- //
    // ----------------------------------------------------------------------------- //
    
    // Set timer and cuda error return
    Timer timer;
    startTime(&timer);

    // To use with kernels
    int num_blocks = ceil((float)trials / (float)block_size);
    dim3 dimGrid(num_blocks, 1, 1);
    dim3 dimBlock(block_size, 1, 1);


    // ------ Step 1: generate the nonce values ------ //

    // Allocate the nonce device memory
    unsigned int* device_nonce_array;
    gpuErrchk(cudaMalloc((void**)&device_nonce_array, trials * sizeof(unsigned int)));

    // Launch the nonce kernel
    nonce_kernel <<< dimGrid, dimBlock >>> (
        device_nonce_array, // put nonces into here
        trials,             // size of array
        MAX,                // to mod with
        SEED                // random seed
        );
    gpuErrchk(cudaDeviceSynchronize());


    // ------ Step 2: Generate the hash values ------ //

    // Allocate memory for device hash array
    unsigned int* device_hash_array;
    gpuErrchk(cudaMalloc((void**)&device_hash_array, trials * sizeof(unsigned int)));

    // Allocate memory and copy transactions to device
    unsigned int* device_transactions;
    gpuErrchk(cudaMalloc((void**)&device_transactions, n_transactions * sizeof(unsigned int)));
    gpuErrchk(cudaMemcpy(device_transactions, transactions, n_transactions * sizeof(unsigned int), cudaMemcpyHostToDevice));

    // Launch the hash kernel
    generate_hash_kernel <<< dimGrid, dimBlock >>> (
        device_hash_array,
        device_nonce_array,
        trials,
        device_transactions,
        n_transactions,
        MAX
    );
    gpuErrchk(cudaDeviceSynchronize());

    // Free memory
    free(transactions);
    gpuErrchk(cudaFree(device_transactions));

    // ------ Step 3: Find the nonce with the minimum hash value ------ //

    // Allocate memory for reduction output
    unsigned long long *d_min_result;
    gpuErrchk(cudaMalloc((void**)&d_min_result, sizeof(unsigned long long)));

    // Initialize global minimum on device
    unsigned long long h_initial_min = ((unsigned long long)MAX << 32) | 0xFFFFFFFFULL;
    gpuErrchk(cudaMemcpy(d_min_result, &h_initial_min, sizeof(unsigned long long), cudaMemcpyHostToDevice));

    // Launch the reduction kernel
    reduction_kernel <<< dimGrid, dimBlock, 2 * dimBlock.x * sizeof(unsigned int) >>> (
        device_hash_array,
        device_nonce_array,
        trials,
        d_min_result
    );
    gpuErrchk(cudaDeviceSynchronize());

    // Copy final result back to host
    unsigned long long h_final_result;
    gpuErrchk(cudaMemcpy(&h_final_result, d_min_result, sizeof(unsigned long long), cudaMemcpyDeviceToHost));

    // Unpack final results
    unsigned int min_hash = (unsigned int)(h_final_result >> 32);
    unsigned int min_nonce = (unsigned int)(h_final_result & 0xFFFFFFFFULL);

    // Free memory
    gpuErrchk(cudaFree(device_nonce_array));
    gpuErrchk(cudaFree(device_hash_array));
    gpuErrchk(cudaFree(d_min_result));

    stopTime(&timer);
    // ----------------------------------------------------------------------------- //
    // -------- Finish Mining ------------------------------------------------------ //


    // Get if suceeded
    char* res = (char*)malloc(8 * sizeof(char));
    if (min_hash < TARGET)  res = (char*)"Success!";
    else                    res = (char*)"Failure.";

    // Show results in console
    if (DEBUG) 
        printf("%s\n   Min hash:  %u\n   Min nonce: %u\n   %f seconds\n",
            res,
            min_hash,
            min_nonce,
            elapsedTime(timer)
        );

    // Print results
    fprintf(output_file, "%s\n%u\n%u\n", res, min_hash, min_nonce);
    fprintf(time_file, "%f\n", elapsedTime(timer));

    // Cleanup
    fclose(time_file);
    fclose(output_file);

    return 0;
} // End Main -------------------------------------------- //






/* Read File -------------------- //
*   Reads in a file of transactions. 
*/
void read_file(char* file, unsigned int* transactions, unsigned int n_transactions) {

    // open file
    FILE* trans_file = fopen(file, "r");
    if (!trans_file) {
        fprintf(stderr, "ERROR: could not read the transaction file.\n");
        exit(-1);
    }


    // read items
    char line[100] = { 0 };
    for (int i = 0; i < n_transactions && fgets(line, 100, trans_file); ++i) {
        char* p;
        transactions[i] = strtof(line, &p);
    }

    fclose(trans_file);

} // End Read File ------------- //
