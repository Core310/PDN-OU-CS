#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <math.h>
#include <time.h>
#include "mpi.h"

/*
 * (Project_5_Instructions.pdf, Page 4)
 * "Your program should be run like this: pingpong_MPI n_items time_prob1_MPI.csv"
 * "n_items: number of items in array"
 * "time_prob1_MPI.csv: time after back and forth transmission for 1000 times"
 */

int main(int argc, char* argv[]) {
    int my_rank, comm_sz, i, round;
    int* ping_array = NULL;
    double starttime, endtime;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);
    MPI_Comm_size(MPI_COMM_WORLD, &comm_sz);

    if (argc != 3) {
        if (my_rank == 0) {
            printf("USE LIKE THIS: pingpong_MPI n_items time_prob1_MPI.csv\n");
        }
        MPI_Finalize();
        return EXIT_FAILURE;
    }

    int n_items = strtol(argv[1], NULL, 10);
    ping_array = (int*)malloc(n_items * sizeof(int));

    /*
     * (Project_5_Instructions.pdf, Page 4)
     * "Given an array of random integers, Write MPI_Send and MPI_Recv to send an 
     * entire array back and forth between process 0 and process 1 (two processes) 
     * for 1000 times."
     */

    if (my_rank == 0) {
        for (i = 0; i < n_items; i++) {
            ping_array[i] = i;
        }

        starttime = MPI_Wtime();

        for (round = 0; round < 1000; round++) {
            MPI_Send(ping_array, n_items, MPI_INT, 1, 0, MPI_COMM_WORLD);
            MPI_Recv(ping_array, n_items, MPI_INT, 1, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        }

        endtime = MPI_Wtime();

        FILE* outputFile = fopen(argv[2], "w");
        if (outputFile != NULL) {
            fprintf(outputFile, "%.6f\n", endtime - starttime);
            fclose(outputFile);
        }
    } else if (my_rank == 1) {
        for (round = 0; round < 1000; round++) {
            MPI_Recv(ping_array, n_items, MPI_INT, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            MPI_Send(ping_array, n_items, MPI_INT, 0, 0, MPI_COMM_WORLD);
        }
    }

    free(ping_array);
    MPI_Finalize();
    return 0;
}

