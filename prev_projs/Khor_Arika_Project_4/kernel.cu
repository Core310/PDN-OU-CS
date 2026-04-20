#include <cuda_runtime.h>
__global__
void kernel(int* input, int* output, int* filter, int n_row, int n_col){
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    int row = blockIdx.y * blockDim.y + threadIdx.y;

    const int blur_size = 2;

    if (row < n_row && col < n_col){
        int res = 0;

        for (int i = -blur_size; i <= blur_size; ++i){
            for(int j= -blur_size; j <= blur_size; ++j){
                int currRow = row + i;
                int currCol = col + j;
                if (currRow >= 0 && currRow < n_row && currCol >= 0 && currCol < n_col){
                    int filterRow = i + blur_size;
                    int filterCol = j + blur_size;

                    res += input[currRow * n_col + currCol] * filter[filterRow * 5 + filterCol];
                }
            }
        }
        output[row * n_col + col] = res;
    }
}