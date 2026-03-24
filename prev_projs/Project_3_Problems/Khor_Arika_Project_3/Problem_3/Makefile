CC=gcc
CFLAGS=-fopenmp -O3 -Wall -std=c99
LDFLAGS=-lm

TARGETS=compute_median_TF_Exp1_starter compute_median_TF_Exp1_baseline compute_median_TF_Exp2_mapreduce

all: $(TARGETS)

compute_median_TF_Exp1_starter: compute_median_TF_Exp1_starter.c
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

compute_median_TF_Exp1_baseline: compute_median_TF_Exp1_baseline.c
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

compute_median_TF_Exp2_mapreduce: compute_median_TF_Exp2_mapreduce.c
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

clean:
	$(RM) $(TARGETS)
