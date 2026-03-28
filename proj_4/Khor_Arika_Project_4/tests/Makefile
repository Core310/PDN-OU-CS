
NVCC        = nvcc
NVCC_FLAGS  = -O3 -I/usr/local/cuda/include -I../common -I/usr/include/gtest
LD_FLAGS    = -lcudart -L/usr/local/cuda/lib64 /usr/lib/x86_64-linux-gnu/libgtest.a -lpthread

# Test Executables
TEST_REDUCTION   = test_reduction
TEST_CONVOLUTION = test_convolution

all: $(TEST_REDUCTION) $(TEST_CONVOLUTION)

test: $(TEST_REDUCTION) $(TEST_CONVOLUTION)
	./$(TEST_REDUCTION)
	./$(TEST_CONVOLUTION)

$(TEST_REDUCTION): test_reduction.cu ../common/support.o
	$(NVCC) $(NVCC_FLAGS) -o $@ $^ $(LD_FLAGS)

$(TEST_CONVOLUTION): test_convolution.cu ../common/support.o
	$(NVCC) $(NVCC_FLAGS) -o $@ $^ $(LD_FLAGS)

../common/support.o: ../common/support.cu ../common/support.h
	$(NVCC) -c -o $@ ../common/support.cu $(NVCC_FLAGS)

clean:
	rm -f $(TEST_REDUCTION) $(TEST_CONVOLUTION) *.o
