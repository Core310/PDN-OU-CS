
#include <gtest/gtest.h>
#include <cuda_runtime.h>
#include <vector>
#include <algorithm>
#include <limits.h>

#include "../common/support.h"
#include "../Problem_1/reduction_kernel.cu"

// Helper function for host-side serial reduction
void host_reduction(const std::vector<unsigned int>& hashes, const std::vector<unsigned int>& nonces, unsigned int& min_hash, unsigned int& min_nonce) {
    min_hash = 123123123; // MAX constant from the problem
    min_nonce = 0xFFFFFFFFU;
    for (size_t i = 0; i < hashes.size(); ++i) {
        if (hashes[i] < min_hash) {
            min_hash = hashes[i];
            min_nonce = nonces[i];
        } else if (hashes[i] == min_hash) {
            if (nonces[i] < min_nonce) {
                min_nonce = nonces[i];
            }
        }
    }
}

class ReductionTest : public ::testing::Test {
protected:
    void RunTest(int num_elements, int block_size = 1024) {
        std::vector<unsigned int> h_hashes(num_elements);
        std::vector<unsigned int> h_nonces(num_elements);

        // Seed with predictable random data
        srand(42);
        for (int i = 0; i < num_elements; ++i) {
            h_hashes[i] = rand() % 1000000;
            h_nonces[i] = i;
        }

        // Host reduction
        unsigned int expected_hash, expected_nonce;
        host_reduction(h_hashes, h_nonces, expected_hash, expected_nonce);

        // Device allocation
        unsigned int *d_hashes, *d_nonces;
        unsigned long long *d_min_result;
        gpuErrchk(cudaMalloc(&d_hashes, num_elements * sizeof(unsigned int)));
        gpuErrchk(cudaMalloc(&d_nonces, num_elements * sizeof(unsigned int)));
        gpuErrchk(cudaMalloc(&d_min_result, sizeof(unsigned long long)));

        // Copy data to device
        gpuErrchk(cudaMemcpy(d_hashes, h_hashes.data(), num_elements * sizeof(unsigned int), cudaMemcpyHostToDevice));
        gpuErrchk(cudaMemcpy(d_nonces, h_nonces.data(), num_elements * sizeof(unsigned int), cudaMemcpyHostToDevice));

        // Initialize global minimum
        unsigned long long h_initial_min = ((unsigned long long)123123123 << 32) | 0xFFFFFFFFULL;
        gpuErrchk(cudaMemcpy(d_min_result, &h_initial_min, sizeof(unsigned long long), cudaMemcpyHostToDevice));

        // Kernel launch
        int num_blocks = (num_elements + block_size - 1) / block_size;
        reduction_kernel<<<num_blocks, block_size, 2 * block_size * sizeof(unsigned int)>>>(d_hashes, d_nonces, num_elements, d_min_result);
        gpuErrchk(cudaDeviceSynchronize());

        // Copy result back
        unsigned long long h_final_result;
        gpuErrchk(cudaMemcpy(&h_final_result, d_min_result, sizeof(unsigned long long), cudaMemcpyDeviceToHost));

        unsigned int actual_hash = (unsigned int)(h_final_result >> 32);
        unsigned int actual_nonce = (unsigned int)(h_final_result & 0xFFFFFFFFULL);

        EXPECT_EQ(actual_hash, expected_hash) << "Failed for size " << num_elements;
        EXPECT_EQ(actual_nonce, expected_nonce) << "Failed for size " << num_elements;

        // Cleanup
        gpuErrchk(cudaFree(d_hashes));
        gpuErrchk(cudaFree(d_nonces));
        gpuErrchk(cudaFree(d_min_result));
    }
};

TEST_F(ReductionTest, SmallInput) {
    RunTest(1024);
}

TEST_F(ReductionTest, LargeInput) {
    RunTest(1000000);
}

TEST_F(ReductionTest, NonPowerOfTwo) {
    RunTest(12345);
}

TEST_F(ReductionTest, SingleElement) {
    RunTest(1);
}

TEST_F(ReductionTest, VariousBlockSizes) {
    RunTest(10000, 256);
    RunTest(10000, 512);
    RunTest(10000, 1024);
}

TEST_F(ReductionTest, TieBreaking) {
    int num_elements = 10;
    std::vector<unsigned int> h_hashes(num_elements, 500);
    std::vector<unsigned int> h_nonces(num_elements);
    for (int i = 0; i < num_elements; ++i) h_nonces[i] = i + 100;

    // Minimum nonce should be 100
    unsigned int expected_hash = 500;
    unsigned int expected_nonce = 100;

    unsigned int *d_hashes, *d_nonces;
    unsigned long long *d_min_result;
    gpuErrchk(cudaMalloc(&d_hashes, num_elements * sizeof(unsigned int)));
    gpuErrchk(cudaMalloc(&d_nonces, num_elements * sizeof(unsigned int)));
    gpuErrchk(cudaMalloc(&d_min_result, sizeof(unsigned long long)));

    gpuErrchk(cudaMemcpy(d_hashes, h_hashes.data(), num_elements * sizeof(unsigned int), cudaMemcpyHostToDevice));
    gpuErrchk(cudaMemcpy(d_nonces, h_nonces.data(), num_elements * sizeof(unsigned int), cudaMemcpyHostToDevice));

    unsigned long long h_initial_min = ((unsigned long long)123123123 << 32) | 0xFFFFFFFFULL;
    gpuErrchk(cudaMemcpy(d_min_result, &h_initial_min, sizeof(unsigned long long), cudaMemcpyHostToDevice));

    reduction_kernel<<<1, 1024, 2 * 1024 * sizeof(unsigned int)>>>(d_hashes, d_nonces, num_elements, d_min_result);
    gpuErrchk(cudaDeviceSynchronize());

    unsigned long long h_final_result;
    gpuErrchk(cudaMemcpy(&h_final_result, d_min_result, sizeof(unsigned long long), cudaMemcpyDeviceToHost));

    unsigned int actual_hash = (unsigned int)(h_final_result >> 32);
    unsigned int actual_nonce = (unsigned int)(h_final_result & 0xFFFFFFFFULL);

    EXPECT_EQ(actual_hash, expected_hash);
    EXPECT_EQ(actual_nonce, expected_nonce);

    gpuErrchk(cudaFree(d_hashes));
    gpuErrchk(cudaFree(d_nonces));
    gpuErrchk(cudaFree(d_min_result));
}

int main(int argc, char **argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
