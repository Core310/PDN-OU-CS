
# Makefile for Problem 1

NVCC=nvcc
EXE=gpu_mining_problem1
SRC=gpu_mining_problem1.cu

all: $(EXE)

$(EXE): $(SRC)
	$(NVCC) -o $(EXE) $(SRC)

clean:
	rm -f $(EXE)
