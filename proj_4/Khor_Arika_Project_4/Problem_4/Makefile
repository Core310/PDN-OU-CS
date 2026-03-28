
NVCC        = nvcc
NVCC_FLAGS  = -O3 -I/usr/local/cuda/include -I../common
LD_FLAGS    = -lcudart -L/usr/local/cuda/lib64
EXE         = convolution_maxpooling_CUDA
OBJ         = convolution_maxpooling.o ../common/support.o

default: $(EXE)

convolution_maxpooling.o: convolution_maxpooling.cu kernel.cu ../common/support.h
	$(NVCC) -c -o $@ convolution_maxpooling.cu $(NVCC_FLAGS)

../common/support.o: ../common/support.cu ../common/support.h
	$(NVCC) -c -o $@ ../common/support.cu $(NVCC_FLAGS)

$(EXE): $(OBJ)
	$(NVCC) $(OBJ) -o $(EXE) $(LD_FLAGS)

clean:
	rm -rf *.o $(EXE) ../common/support.o
