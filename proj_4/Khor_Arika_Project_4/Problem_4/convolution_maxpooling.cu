#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h> // For INT_MIN
#include "../common/support.h"

#define MAX_LINE_LENGTH 1000000

// Kernel 1: Performs 2D tiled convolution
__global__ void convolution_kernel(int* paddedInput, int* filter, int* output, int n_row, int n_col, int radius) {
    extern __shared__ int s_data[];
    
    int filter_dim = 2 * radius + 1;
    int* filter_s = s_data;
    int* tile_s = &s_data[filter_dim * filter_dim];

    int tx = threadIdx.x;
    int ty = threadIdx.y;
    int row = blockIdx.y * blockDim.y + ty;
    int col = blockIdx.x * blockDim.x + tx;

    // Load filter into shared memory collaboratively
    int filter_size = filter_dim * filter_dim;
    for (int i = ty * blockDim.x + tx; i < filter_size; i += blockDim.x * blockDim.y) {
        filter_s[i] = filter[i];
    }

    // Padded input dimensions
    int padded_col = n_col + 2 * radius;
    int tile_dim = blockDim.x + 2 * radius;

    // Load tile into shared memory (including halo)
    for (int i = ty; i < tile_dim; i += blockDim.y) {
        for (int j = tx; j < tile_dim; j += blockDim.x) {
            int global_row = blockIdx.y * blockDim.y + i;
            int global_col = blockIdx.x * blockDim.x + j;
            
            if (global_row < n_row + 2 * radius && global_col < n_col + 2 * radius) {
                tile_s[i * tile_dim + j] = paddedInput[global_row * padded_col + global_col];
            } else {
                tile_s[i * tile_dim + j] = 0;
            }
        }
    }

    __syncthreads();

    // Compute convolution for the output pixel
    if (row < n_row && col < n_col) {
        int sum = 0;
        for (int i = 0; i < filter_dim; i++) {
            for (int j = 0; j < filter_dim; j++) {
                sum += tile_s[(ty + i) * tile_dim + (tx + j)] * filter_s[i * filter_dim + j];
            }
        }
        output[row * n_col + col] = sum;
    }
}

// Kernel 2: Performs max pooling on the convolved image
__global__ void maxpooling_kernel(int* convolved_input, int* output, int n_row, int n_col, int radius) {
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    if (row < n_row && col < n_col) {
        int max_val = INT_MIN;
        for (int i = -radius; i <= radius; i++) {
            for (int j = -radius; j <= radius; j++) {
                int cur_row = row + i;
                int cur_col = col + j;

                if (cur_row >= 0 && cur_row < n_row && cur_col >= 0 && cur_col < n_col) {
                    int val = convolved_input[cur_row * n_col + cur_col];
                    if (val > max_val) {
                        max_val = val;
                    }
                }
            }
        }
        output[row * n_col + col] = max_val;
    }
}

// Host-side function for padding the input matrix
void padMatrix(int* input, int* padded, int n_row, int n_col, int radius) {
    int padded_row = n_row + 2 * radius;
    int padded_col = n_col + 2 * radius;
    
    for (int i = 0; i < padded_row * padded_col; i++) {
        padded[i] = 0;
    }
    
    for (int i = 0; i < n_row; i++) {
        for (int j = 0; j < n_col; j++) {
            padded[(i + radius) * padded_col + (j + radius)] = input[i * n_col + j];
        }
    }
}

int main(int argc, char* argv[]) {
    if (argc < 6 || argc > 8) {
        printf("USE LIKE THIS: convolution_maxpooling_CUDA n_row n_col input.csv results.csv time.csv [BLOCK_SIZE] [RADIUS]\n");
        return EXIT_FAILURE;
    }

    int n_row = atoi(argv[1]);
    int n_col = atoi(argv[2]);
    char* input_filename = argv[3];
    char* results_filename = argv[4];
    char* time_filename = argv[5];

    int block_size = 16;
    if (argc >= 7) {
        block_size = atoi(argv[6]);
    }

    int radius = 2;
    if (argc >= 8) {
        radius = atoi(argv[7]);
    }

    FILE* inputFile = fopen(input_filename, "r");
    if (inputFile == NULL) {
        FATAL("Could not open file %s", input_filename);
    }

    int* inputMatrix_h = (int*)malloc(n_row * n_col * sizeof(int));
    if (inputMatrix_h == NULL) {
        FATAL("Failed to allocate memory for inputMatrix_h");
    }
    
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
        if (row_count >= n_row) break;
    }
    fclose(inputFile);
    free(line);

    int padded_row = n_row + 2 * radius;
    int padded_col = n_col + 2 * radius;
    int* paddedMatrix_h = (int*)malloc(padded_row * padded_col * sizeof(int));
    if (paddedMatrix_h == NULL) {
        FATAL("Failed to allocate memory for paddedMatrix_h");
    }
    padMatrix(inputMatrix_h, paddedMatrix_h, n_row, n_col, radius);

    int filter_dim = 2 * radius + 1;
    int* filterMatrix_h = (int*)malloc(filter_dim * filter_dim * sizeof(int));
    memset(filterMatrix_h, 0, filter_dim * filter_dim * sizeof(int));
    
    if (radius == 2) {
        filterMatrix_h[0*5+0] = 1; filterMatrix_h[1*5+1] = 1; filterMatrix_h[2*5+2] = 1;
        filterMatrix_h[3*5+3] = 1; filterMatrix_h[4*5+4] = 1; filterMatrix_h[4*5+0] = 1;
        filterMatrix_h[3*5+1] = 1; filterMatrix_h[1*5+3] = 1; filterMatrix_h[0*5+4] = 1;
    } else {
        filterMatrix_h[radius * filter_dim + radius] = 1;
    }

    int *paddedMatrix_d, *filterMatrix_d, *convolvedMatrix_d, *outputMatrix_d;
    gpuErrchk(cudaMalloc((void**)&paddedMatrix_d, padded_row * padded_col * sizeof(int)));
    gpuErrchk(cudaMalloc((void**)&filterMatrix_d, filter_dim * filter_dim * sizeof(int)));
    gpuErrchk(cudaMalloc((void**)&convolvedMatrix_d, n_row * n_col * sizeof(int)));
    gpuErrchk(cudaMalloc((void**)&outputMatrix_d, n_row * n_col * sizeof(int)));

    gpuErrchk(cudaMemcpy(paddedMatrix_d, paddedMatrix_h, padded_row * padded_col * sizeof(int), cudaMemcpyHostToDevice));
    gpuErrchk(cudaMemcpy(filterMatrix_d, filterMatrix_h, filter_dim * filter_dim * sizeof(int), cudaMemcpyHostToDevice));

    dim3 dimBlock(block_size, block_size);
    dim3 dimGrid((n_col + block_size - 1) / block_size, (n_row + block_size - 1) / block_size);

    int tile_dim = block_size + 2 * radius;
    size_t shared_mem_size = sizeof(int) * (tile_dim * tile_dim + filter_dim * filter_dim);

    Timer timer;
    startTime(&timer);

    convolution_kernel<<<dimGrid, dimBlock, shared_mem_size>>>(paddedMatrix_d, filterMatrix_d, convolvedMatrix_d, n_row, n_col, radius);
    gpuErrchk(cudaDeviceSynchronize());

    maxpooling_kernel<<<dimGrid, dimBlock>>>(convolvedMatrix_d, outputMatrix_d, n_row, n_col, radius);
    gpuErrchk(cudaDeviceSynchronize());

    stopTime(&timer);

    int* outputMatrix_h = (int*)malloc(n_row * n_col * sizeof(int));
    gpuErrchk(cudaMemcpy(outputMatrix_h, outputMatrix_d, n_row * n_col * sizeof(int), cudaMemcpyDeviceToHost));

    FILE* resultsFile = fopen(results_filename, "w");
    for (int i = 0; i < n_row; i++) {
        for (int j = 0; j < n_col; j++) {
            fprintf(resultsFile, "%d", outputMatrix_h[i * n_col + j]);
            if (j != n_col - 1) fprintf(resultsFile, ",");
        }
        fprintf(resultsFile, "\n");
    }
    fclose(resultsFile);

    FILE* timeFile = fopen(time_filename, "w");
    fprintf(timeFile, "%.20f", elapsedTime(timer));
    fclose(timeFile);

    free(inputMatrix_h);
    free(paddedMatrix_h);
    free(filterMatrix_h);
    free(outputMatrix_h);
    gpuErrchk(cudaFree(paddedMatrix_d));
    gpuErrchk(cudaFree(filterMatrix_d));
    gpuErrchk(cudaFree(convolvedMatrix_d));
    gpuErrchk(cudaFree(outputMatrix_d));

    return 0;
}
