CC=gcc
CFLAGS=-fopenmp -O3 -Wall -std=c99
LDFLAGS=-lm

TARGETS=compute_average_TF_Exp1_starter compute_average_TF_Exp1_critical compute_average_TF_Exp1_atomic compute_average_TF_Exp1_locks compute_average_TF_Exp2_schedule

all: $(TARGETS)

compute_average_TF_Exp1_starter: compute_average_TF_Exp1_starter.c
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

compute_average_TF_Exp1_critical: compute_average_TF_Exp1_critical.c
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

compute_average_TF_Exp1_atomic: compute_average_TF_Exp1_atomic.c
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

compute_average_TF_Exp1_locks: compute_average_TF_Exp1_locks.c
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

compute_average_TF_Exp2_schedule: compute_average_TF_Exp2_schedule.c
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

clean:
	$(RM) $(TARGETS)
