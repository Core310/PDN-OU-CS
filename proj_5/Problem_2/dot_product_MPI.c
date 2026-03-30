#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "mpi.h"

/*
 * Parallel Dot Product
 * (Project_5_Instructions.pdf, Page 6)
 */

int main(int argc, char* argv[]) {
    /* Enforce strict CLI arguments */
    if (argc != 6) {
        printf("USE LIKE THIS: dot_product_MPI n_items vec_1.csv vec_2.csv result_prob2_MPI.csv time_prob2_MPI.csv\n");
        return EXIT_FAILURE;
    }

    /* Start MPI */
    int my_rank, comm_size;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);
    MPI_Comm_size(MPI_COMM_WORLD, &comm_size);

    /* TODO: Implement parallel dot product logic */

    MPI_Finalize();
    return 0;
}
