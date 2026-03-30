
#include <gtest/gtest.h>
#include <cuda_runtime.h>
#include <vector>
#include <algorithm>
#include <string.h>

#include "../common/support.h"
#include "../Problem_3/kernel.cu"

// Helper function to pad matrix (taking radius)
void host_padMatrix(const std::vector<int>& input, std::vector<int>& padded, int n_row, int n_col, int radius) {
    int padded_row = n_row + 2 * radius;
    int padded_col = n_col + 2 * radius;
    std::fill(padded.begin(), padded.end(), 0);
    for (int i = 0; i < n_row; i++) {
        for (int j = 0; j < n_col; j++) {
            padded[(i + radius) * padded_col + (j + radius)] = input[i * n_col + j];
        }
    }
}

// Helper function for host-side serial convolution (taking radius)
void host_convolution(const std::vector<int>& padded, const std::vector<int>& filter, std::vector<int>& output, int n_row, int n_col, int radius) {
    int padded_col = n_col + 2 * radius;
    int filter_dim = 2 * radius + 1;
    for (int i = 0; i < n_row; i++) {
        for (int j = 0; j < n_col; j++) {
            int sum = 0;
            for (int r = -radius; r <= radius; r++) {
                for (int c = -radius; c <= radius; c++) {
                    int val = padded[(i + radius + r) * padded_col + (j + radius + c)];
                    int f_val = filter[(r + radius) * filter_dim + (c + radius)];
                    sum += val * f_val;
                }
            }
            output[i * n_col + j] = sum;
        }
    }
}

class ConvolutionTest : public ::testing::Test {
protected:
    void RunTest(int n_row, int n_col, int block_size = 16, int radius = 2) {
        int num_elements = n_row * n_col;
        std::vector<int> h_input(num_elements);
        int filter_dim = 2 * radius + 1;
        std::vector<int> h_filter(filter_dim * filter_dim);
        
        for (int i = 0; i < num_elements; i++) h_input[i] = (i % 10) + 1;
        for (int i = 0; i < (int)h_filter.size(); i++) h_filter[i] = (i % 3) + 1;

        int padded_row = n_row + 2 * radius;
        int padded_col = n_col + 2 * radius;
        std::vector<int> h_padded(padded_row * padded_col);
        host_padMatrix(h_input, h_padded, n_row, n_col, radius);

        std::vector<int> h_expected(num_elements);
        host_convolution(h_padded, h_filter, h_expected, n_row, n_col, radius);

        int *d_padded, *d_filter, *d_output;
        gpuErrchk(cudaMalloc(&d_padded, padded_row * padded_col * sizeof(int)));
        gpuErrchk(cudaMalloc(&d_filter, h_filter.size() * sizeof(int)));
        gpuErrchk(cudaMalloc(&d_output, num_elements * sizeof(int)));

        gpuErrchk(cudaMemcpy(d_padded, h_padded.data(), padded_row * padded_col * sizeof(int), cudaMemcpyHostToDevice));
        gpuErrchk(cudaMemcpy(d_filter, h_filter.data(), h_filter.size() * sizeof(int), cudaMemcpyHostToDevice));

        dim3 dimBlock(block_size, block_size);
        dim3 dimGrid((n_col + block_size - 1) / block_size, (n_row + block_size - 1) / block_size);

        int tile_dim = block_size + 2 * radius;
        size_t shared_mem_size = sizeof(int) * (tile_dim * tile_dim + filter_dim * filter_dim);

        convolution_kernel<<<dimGrid, dimBlock, shared_mem_size>>>(d_padded, d_filter, d_output, n_row, n_col, radius);
        gpuErrchk(cudaDeviceSynchronize());

        std::vector<int> h_actual(num_elements);
        gpuErrchk(cudaMemcpy(h_actual.data(), d_output, num_elements * sizeof(int), cudaMemcpyDeviceToHost));

        for (int i = 0; i < num_elements; i++) {
            ASSERT_EQ(h_actual[i], h_expected[i]) << "Mismatch at row " << i / n_col << ", col " << i % n_col << " with BS=" << block_size << " R=" << radius;
        }

        gpuErrchk(cudaFree(d_padded));
        gpuErrchk(cudaFree(d_filter));
        gpuErrchk(cudaFree(d_output));
    }
};

TEST_F(ConvolutionTest, SmallInput) {
    RunTest(16, 16);
}

TEST_F(ConvolutionTest, VariousRadii) {
    RunTest(32, 32, 16, 1);
    RunTest(32, 32, 16, 2);
    RunTest(32, 32, 16, 3);
}

TEST_F(ConvolutionTest, VariousBlockSizes) {
    RunTest(32, 32, 8, 2);
    RunTest(32, 32, 16, 2);
    RunTest(32, 32, 32, 2);
}

TEST_F(ConvolutionTest, NonMultiple) {
    RunTest(20, 25, 16, 2);
}

int main(int argc, char **argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
