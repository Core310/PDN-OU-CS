#ifndef __KERNEL_H__
#define __KERNEL_H__

#define BLOCK_SIZE 16
#define RADIUS 2

__global__ void convolution_kernel(int* paddedInput, int* filter, int* output, int n_row, int n_col) {
    __shared__ int filter_s[25];
    __shared__ int tile_s[BLOCK_SIZE + 2 * RADIUS][BLOCK_SIZE + 2 * RADIUS];

    int tx = threadIdx.x;
    int ty = threadIdx.y;
    int row = blockIdx.y * BLOCK_SIZE + ty;
    int col = blockIdx.x * BLOCK_SIZE + tx;

    // Load filter into shared memory
    if (ty < 5 && tx < 5) {
        filter_s[ty * 5 + tx] = filter[ty * 5 + tx];
    }

    // Padded input dimensions
    int padded_col = n_col + 2 * RADIUS;

    // Load tile into shared memory (including halo)
    // Each thread in the block loads one or more elements to cover the (BLOCK_SIZE + 2*RADIUS)^2 tile.
    for (int i = ty; i < BLOCK_SIZE + 2 * RADIUS; i += BLOCK_SIZE) {
        for (int j = tx; j < BLOCK_SIZE + 2 * RADIUS; j += BLOCK_SIZE) {
            int global_row = blockIdx.y * BLOCK_SIZE + i;
            int global_col = blockIdx.x * BLOCK_SIZE + j;
            
            // Check bounds for paddedInput (important if n_row/n_col aren't multiples of BLOCK_SIZE)
            if (global_row < n_row + 2 * RADIUS && global_col < n_col + 2 * RADIUS) {
                tile_s[i][j] = paddedInput[global_row * padded_col + global_col];
            } else {
                tile_s[i][j] = 0;
            }
        }
    }

    __syncthreads();

    // Compute convolution for the output pixel
    if (row < n_row && col < n_col) {
        int sum = 0;
        for (int i = 0; i < 5; i++) {
            for (int j = 0; j < 5; j++) {
                sum += tile_s[ty + i][tx + j] * filter_s[i * 5 + j];
            }
        }
        output[row * n_col + col] = sum;
    }
}

#endif
