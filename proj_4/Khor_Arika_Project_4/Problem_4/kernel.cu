#ifndef __KERNEL_H__
#define __KERNEL_H__

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

#endif
