#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "support.h"
#include "kernel.cu"

#define MAX_LINE_LENGTH 1000000
#define RADIUS 2

void padMatrix(int* input, int* padded, int n_row, int n_col) {
    int padded_row = n_row + 2 * RADIUS;
    int padded_col = n_col + 2 * RADIUS;
    
    // Initialize padded matrix with zeros
    for (int i = 0; i < padded_row * padded_col; i++) {
        padded[i] = 0;
    }
    
    // Copy original data to center of padded matrix
    for (int i = 0; i < n_row; i++) {
        for (int j = 0; j < n_col; j++) {
            padded[(i + RADIUS) * padded_col + (j + RADIUS)] = input[i * n_col + j];
        }
    }
}

int main(int argc, char* argv[]) {
    if (argc != 6) {
        printf("USE LIKE THIS: convolution_CUDA n_row n_col input.csv results.csv time.csv\n");
        return EXIT_FAILURE;
    }

    int n_row = atoi(argv[1]);
    int n_col = atoi(argv[2]);
    char* input_filename = argv[3];
    char* results_filename = argv[4];
    char* time_filename = argv[5];

    FILE* inputFile = fopen(input_filename, "r");
    if (inputFile == NULL) {
        FATAL("Could not open file %s", input_filename);
    }

    int* inputMatrix_h = (int*)malloc(n_row * n_col * sizeof(int));
    if (inputMatrix_h == NULL) {
        FATAL("Failed to allocate memory for inputMatrix_h");
    }
    
    // read the data from the file
    int row_count = 0;
    char* line = (char*)malloc(MAX_LINE_LENGTH * sizeof(char));
    while (fgets(line, MAX_LINE_LENGTH, inputFile)) {
        char *token;
        const char s[2] = ",";
        token = strtok(line, s);
        int i_col = 0;
        while (token != NULL && i_col < n_col) {
            inputMatrix_h[row_count * n_col + i_col] = strtol(token, NULL, 10);
            i_col++;
            token = strtok(NULL, s);
        }
        row_count++;
        if (row_count >= n_row) break;
    }
    fclose(inputFile);
    free(line);

    // Padding
    int padded_row = n_row + 2 * RADIUS;
    int padded_col = n_col + 2 * RADIUS;
    int* paddedMatrix_h = (int*)malloc(padded_row * padded_col * sizeof(int));
    if (paddedMatrix_h == NULL) {
        FATAL("Failed to allocate memory for paddedMatrix_h");
    }
    padMatrix(inputMatrix_h, paddedMatrix_h, n_row, n_col);

    // Initialize filter
    int* filterMatrix_h = (int*)malloc(5 * 5 * sizeof(int));
    memset(filterMatrix_h, 0, 5 * 5 * sizeof(int));
    filterMatrix_h[0*5+0] = 1;
    filterMatrix_h[1*5+1] = 1;
    filterMatrix_h[2*5+2] = 1;
    filterMatrix_h[3*5+3] = 1;
    filterMatrix_h[4*5+4] = 1;
    filterMatrix_h[4*5+0] = 1;
    filterMatrix_h[3*5+1] = 1;
    filterMatrix_h[1*5+3] = 1;
    filterMatrix_h[0*5+4] = 1;

    // Allocate device memory
    int *paddedMatrix_d, *filterMatrix_d, *outputMatrix_d;
    cudaMalloc((void**)&paddedMatrix_d, padded_row * padded_col * sizeof(int));
    cudaMalloc((void**)&filterMatrix_d, 5 * 5 * sizeof(int));
    cudaMalloc((void**)&outputMatrix_d, n_row * n_col * sizeof(int));

    // Transfer to device
    cudaMemcpy(paddedMatrix_d, paddedMatrix_h, padded_row * padded_col * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(filterMatrix_d, filterMatrix_h, 5 * 5 * sizeof(int), cudaMemcpyHostToDevice);

    // Kernel launch configuration
    dim3 dimBlock(BLOCK_SIZE, BLOCK_SIZE);
    dim3 dimGrid((n_col + BLOCK_SIZE - 1) / BLOCK_SIZE, (n_row + BLOCK_SIZE - 1) / BLOCK_SIZE);

    Timer timer;
    startTime(&timer);

    convolution_kernel<<<dimGrid, dimBlock>>>(paddedMatrix_d, filterMatrix_d, outputMatrix_d, n_row, n_col);
    cudaDeviceSynchronize();

    stopTime(&timer);

    // Copy back
    int* outputMatrix_h = (int*)malloc(n_row * n_col * sizeof(int));
    cudaMemcpy(outputMatrix_h, outputMatrix_d, n_row * n_col * sizeof(int), cudaMemcpyDeviceToHost);

    // Save results
    FILE* resultsFile = fopen(results_filename, "w");
    for (int i = 0; i < n_row; i++) {
        for (int j = 0; j < n_col; j++) {
            fprintf(resultsFile, "%d", outputMatrix_h[i * n_col + j]);
            if (j != n_col - 1) fprintf(resultsFile, ",");
            else if (i < n_row - 1) fprintf(resultsFile, "\n");
        }
    }
    fclose(resultsFile);

    // Save time
    FILE* timeFile = fopen(time_filename, "w");
    fprintf(timeFile, "%.20f", elapsedTime(timer));
    fclose(timeFile);

    // Free memory
    free(inputMatrix_h);
    free(paddedMatrix_h);
    free(filterMatrix_h);
    free(outputMatrix_h);
    cudaFree(paddedMatrix_d);
    cudaFree(filterMatrix_d);
    cudaFree(outputMatrix_d);

    return 0;
}
