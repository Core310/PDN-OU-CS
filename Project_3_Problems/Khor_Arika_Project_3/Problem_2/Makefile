CC=gcc
CFLAGS=-fopenmp -O3 -Wall -std=c99
LDFLAGS=-lm
SETUP=../setup/setup.c

TARGETS=compute_average_TF_Exp1_starter compute_average_TF_Exp1_critical compute_average_TF_Exp1_atomic compute_average_TF_Exp1_locks compute_average_TF_Exp2_schedule

all: $(TARGETS)

compute_average_TF_Exp1_starter: compute_average_TF_Exp1_starter.c $(SETUP)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

compute_average_TF_Exp1_critical: compute_average_TF_Exp1_critical.c $(SETUP)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

compute_average_TF_Exp1_atomic: compute_average_TF_Exp1_atomic.c $(SETUP)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

compute_average_TF_Exp1_locks: compute_average_TF_Exp1_locks.c $(SETUP)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

compute_average_TF_Exp2_schedule: compute_average_TF_Exp2_schedule.c $(SETUP)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

clean:
	$(RM) $(TARGETS)
