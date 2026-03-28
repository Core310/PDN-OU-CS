#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h> // For INT_MIN
#include "support.h"

#define MAX_LINE_LENGTH 1000000
#define RADIUS 2 // For a 5x5 filter, RADIUS is 2
#define BLOCK_SIZE 16 // Example BLOCK_SIZE

// Kernel 1: Performs 2D tiled convolution
__global__ void convolution_kernel(int* paddedInput, int* filter, int* output, int n_row, int n_col) {
    __shared__ int filter_s[25]; // 5x5 filter
    // Shared memory for input tile + halo. Size: (BLOCK_SIZE + 2*RADIUS) x (BLOCK_SIZE + 2*RADIUS)
    __shared__ int tile_s[BLOCK_SIZE + 2 * RADIUS][BLOCK_SIZE + 2 * RADIUS]; 

    int tx = threadIdx.x;
    int ty = threadIdx.y;
    int row = blockIdx.y * BLOCK_SIZE + ty; // Global row for output
    int col = blockIdx.x * BLOCK_SIZE + tx; // Global col for output

    // Load filter into shared memory collaboratively
    // Only ty < 5 and tx < 5 threads will load the filter. __syncthreads() ensures all threads wait.
    if (ty < 5 && tx < 5) {
        filter_s[ty * 5 + tx] = filter[ty * 5 + tx];
    }
    __syncthreads(); // Ensure filter is fully loaded before use

    // Padded input dimensions (from host-side padding)
    int padded_num_cols = n_col + 2 * RADIUS;

    // Calculate effective global coordinates for the tile's top-left corner (including halo)
    int global_load_row_start = blockIdx.y * BLOCK_SIZE - RADIUS;
    int global_load_col_start = blockIdx.x * BLOCK_SIZE - RADIUS;

    // Load tile into shared memory (including halo)
    // Each thread loads multiple elements if (BLOCK_SIZE + 2 * RADIUS) > blockDim.y/x
    // This loop structure distributes loading across threads in the block
    for (int r = ty; r < BLOCK_SIZE + 2 * RADIUS; r += blockDim.y) {
        for (int c = tx; c < BLOCK_SIZE + 2 * RADIUS; c += blockDim.x) {
            int global_r = global_load_row_start + r;
            int global_c = global_load_col_start + c;

            // Check if global read is within padded input bounds
            if (global_r >= 0 && global_r < n_row + 2 * RADIUS &&
                global_c >= 0 && global_c < n_col + 2 * RADIUS) {
                tile_s[r][c] = paddedInput[global_r * padded_num_cols + global_c];
            } else {
                tile_s[r][c] = 0; // Padding with zeros for out-of-bounds reads
            }
        }
    }
    __syncthreads(); // Ensure tile is fully loaded before convolution

    // Compute convolution for the output pixel
    if (row < n_row && col < n_col) { // Check if current thread is within actual output image bounds
        int sum = 0;
        // Loop over the 5x5 filter (from -RADIUS to RADIUS)
        for (int blurRow = -RADIUS; blurRow <= RADIUS; ++blurRow) {
            for (int blurCol = -RADIUS; blurCol <= RADIUS; ++blurCol) {
                // Corresponding filter index (0 to 4)
                int filter_idx_r = blurRow + RADIUS;
                int filter_idx_c = blurCol + RADIUS;
                
                // Corresponding tile_s index relative to thread's output pixel (ty, tx)
                // ty/tx is the relative thread index in the BLOCK_SIZE x BLOCK_SIZE central part of tile_s
                int tile_idx_r = ty + RADIUS + blurRow;
                int tile_idx_c = tx + RADIUS + blurCol;
                
                sum += tile_s[tile_idx_r][tile_idx_c] * filter_s[filter_idx_r * 5 + filter_idx_c];
            }
        }
        output[row * n_col + col] = sum; // Write result to global memory
    }
}

// Kernel 2: Performs 5x5 max pooling on the convolved image (in global memory)
__global__ void maxpooling_kernel(int* convolved_input, int* output, int n_row, int n_col) {
    int row = blockIdx.y * blockDim.y + threadIdx.y; // Global row for output
    int col = blockIdx.x * blockDim.x + threadIdx.x; // Global col for output

    if (row < n_row && col < n_col) { // Check if current thread is within actual output image bounds
        int max_val = INT_MIN; // Initialize with smallest possible integer for robustness
        // Loop over the 5x5 window (from -RADIUS to RADIUS) for max pooling
        for (int i = -RADIUS; i <= RADIUS; i++) {
            for (int j = -RADIUS; j <= RADIUS; j++) {
                int cur_row = row + i; // Global row in convolved_input
                int cur_col = col + j; // Global col in convolved_input

                // Check bounds within the convolved_input image
                if (cur_row >= 0 && cur_row < n_row && cur_col >= 0 && cur_col < n_col) {
                    int val = convolved_input[cur_row * n_col + cur_col];
                    if (val > max_val) {
                        max_val = val;
                    }
                }
            }
        }
        output[row * n_col + col] = max_val; // Write result to global memory
    }
}

// Host-side function for padding the input matrix
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
    // Check command line arguments
    if (argc != 6) {
        printf("USE LIKE THIS: convolution_CUDA n_row n_col input.csv results.csv time.csv");
        fputc('
', stdout); // Print newline explicitly
        return EXIT_FAILURE;
    }

    // Parse command line arguments
    int n_row = atoi(argv[1]);
    int n_col = atoi(argv[2]);
    char* input_filename = argv[3];
    char* results_filename = argv[4];
    char* time_filename = argv[5];

    // Open input file
    FILE* inputFile = fopen(input_filename, "r");
    if (inputFile == NULL) {
        FATAL("Could not open file %s", input_filename);
    }

    // Allocate host memory for input matrix
    int* inputMatrix_h = (int*)malloc(n_row * n_col * sizeof(int));
    if (inputMatrix_h == NULL) {
        FATAL("Failed to allocate memory for inputMatrix_h");
    }
    
    // Read data from the input CSV file
    int row_count = 0;
    char* line = (char*)malloc(MAX_LINE_LENGTH * sizeof(char));
    while (fgets(line, MAX_LINE_LENGTH, inputFile)) {
        char *token = strtok(line, ",");
        int i_col = 0;
        while (token != NULL && i_col < n_col) {
            inputMatrix_h[row_count * n_col + i_col] = strtol(token, NULL, 10);
            token = strtok(NULL, ",");
            i_col++;
        }
        row_count++;
        if (row_count >= n_row) break; // Stop if we've read enough rows
    }
    fclose(inputFile);
    free(line);

    // Perform host-side padding
    int padded_row = n_row + 2 * RADIUS;
    int padded_col = n_col + 2 * RADIUS;
    int* paddedMatrix_h = (int*)malloc(padded_row * padded_col * sizeof(int));
    if (paddedMatrix_h == NULL) {
        FATAL("Failed to allocate memory for paddedMatrix_h");
    }
    padMatrix(inputMatrix_h, paddedMatrix_h, n_row, n_col);

    // Initialize filter matrix on host
    int* filterMatrix_h = (int*)malloc(5 * 5 * sizeof(int));
    memset(filterMatrix_h, 0, 5 * 5 * sizeof(int));
    // Example 5x5 filter (diagonal 'X' shape, similar to serial example)
    filterMatrix_h[0*5+0] = 1; filterMatrix_h[1*5+1] = 1; filterMatrix_h[2*5+2] = 1;
    filterMatrix_h[3*5+3] = 1; filterMatrix_h[4*5+4] = 1; filterMatrix_h[4*5+0] = 1;
    filterMatrix_h[3*5+1] = 1; filterMatrix_h[1*5+3] = 1; filterMatrix_h[0*5+4] = 1;

    // Allocate device memory
    int *paddedMatrix_d, *filterMatrix_d, *convolvedMatrix_d, *outputMatrix_d;
    cudaMalloc((void**)&paddedMatrix_d, padded_row * padded_col * sizeof(int));
    cudaMalloc((void**)&filterMatrix_d, 5 * 5 * sizeof(int));
    cudaMalloc((void**)&convolvedMatrix_d, n_row * n_col * sizeof(int)); // Intermediate convolved output
    cudaMalloc((void**)&outputMatrix_d, n_row * n_col * sizeof(int));     // Final max-pooled output

    // Transfer host data to device
    cudaMemcpy(paddedMatrix_d, paddedMatrix_h, padded_row * padded_col * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(filterMatrix_d, filterMatrix_h, 5 * 5 * sizeof(int), cudaMemcpyHostToDevice);

    // Kernel launch configuration
    dim3 dimBlock(BLOCK_SIZE, BLOCK_SIZE); // Threads per block (e.g., 16x16)
    // Grid size such that each thread in a BLOCK_SIZE x BLOCK_SIZE block processes one output pixel
    dim3 dimGrid((n_col + BLOCK_SIZE - 1) / BLOCK_SIZE, (n_row + BLOCK_SIZE - 1) / BLOCK_SIZE);

    Timer timer;
    startTime(&timer);

    // Launch Kernel 1: Convolution
    // Output of convolution goes to convolvedMatrix_d
    convolution_kernel<<<dimGrid, dimBlock, sizeof(int) * (BLOCK_SIZE + 2*RADIUS) * (BLOCK_SIZE + 2*RADIUS) + sizeof(int) * 25 >>>(
        paddedMatrix_d, filterMatrix_d, convolvedMatrix_d, n_row, n_col);
    cudaDeviceSynchronize();

    // Launch Kernel 2: Max-Pooling
    // Input is convolvedMatrix_d, output goes to outputMatrix_d
    maxpooling_kernel<<<dimGrid, dimBlock>>>(convolvedMatrix_d, outputMatrix_d, n_row, n_col);
    cudaDeviceSynchronize();

    stopTime(&timer);

    // Copy back final max-pooled result from device to host
    int* outputMatrix_h = (int*)malloc(n_row * n_col * sizeof(int));
    if (outputMatrix_h == NULL) {
        FATAL("Failed to allocate memory for outputMatrix_h for results");
    }
    cudaMemcpy(outputMatrix_h, outputMatrix_d, n_row * n_col * sizeof(int), cudaMemcpyDeviceToHost);

    // Save results to CSV file
    FILE* resultsFile = fopen(results_filename, "w");
    if (resultsFile == NULL) {
        FATAL("Could not open results file %s", results_filename);
    }
    for (int i = 0; i < n_row; i++) {
        for (int j = 0; j < n_col; j++) {
            char buffer[32]; // Sufficient for an int
            sprintf(buffer, "%d", outputMatrix_h[i * n_col + j]);
            fputs(buffer, resultsFile);
            if (j != n_col - 1) fputs(",", resultsFile);
        }
        fputc('
', resultsFile); // Explicitly print newline
    }
    fclose(resultsFile);

    // Save time to file
    FILE* timeFile = fopen(time_filename, "w");
    if (timeFile == NULL) {
        FATAL("Could not open time file %s", time_filename);
    }
    char time_buffer[64];
    sprintf(time_buffer, "%.20f", elapsedTime(timer));
    fputs(time_buffer, timeFile);
    fputc('
', timeFile); // Explicitly print newline
    fclose(timeFile);

    // Free all allocated memory
    free(inputMatrix_h);
    free(paddedMatrix_h);
    free(filterMatrix_h);
    free(outputMatrix_h);
    cudaFree(paddedMatrix_d);
    cudaFree(filterMatrix_d);
    cudaFree(convolvedMatrix_d);
    cudaFree(outputMatrix_d);

    return 0;
}
