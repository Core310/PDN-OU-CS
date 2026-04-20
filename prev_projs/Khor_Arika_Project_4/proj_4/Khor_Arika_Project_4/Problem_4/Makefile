
NVCC        = nvcc
NVCC_FLAGS  = -O3 -I/usr/local/cuda/include
LD_FLAGS    = -lcudart -L/usr/local/cuda/lib64
EXE         = convolution_maxpooling_CUDA
OBJ         = convolution_maxpooling.o support.o

default: $(EXE)

convolution_maxpooling.o: convolution_maxpooling.cu kernel.cu support.h
	$(NVCC) -c -o $@ convolution_maxpooling.cu $(NVCC_FLAGS)

support.o: support.cu support.h
	$(NVCC) -c -o $@ support.cu $(NVCC_FLAGS)

$(EXE): $(OBJ)
	$(NVCC) $(OBJ) -o $(EXE) $(LD_FLAGS)

clean:
	rm -rf *.o $(EXE)
