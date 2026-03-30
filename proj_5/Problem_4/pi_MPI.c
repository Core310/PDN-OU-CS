#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "mpi.h"

/*
 * Parallel Monte Carlo Pi Estimation
 * (Project_5_Instructions.pdf, Page 11)
 */

int main(int argc, char* argv[]) {
    /* Enforce strict CLI arguments */
    if (argc != 3) {
        printf("USE LIKE THIS: pi_MPI result_prob4_MPI.csv time_prob4_MPI.csv\n");
        return EXIT_FAILURE;
    }

    /* Start MPI */
    int my_rank, comm_size;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);
    MPI_Comm_size(MPI_COMM_WORLD, &comm_size);

    /* TODO: Implement parallel Monte Carlo Pi logic */

    MPI_Finalize();
    return 0;
}
