
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "mpi.h"

#define MAX_LINE_LEN 128

/*
 * Parallel Dot Product
 * (Project_5_Instructions.pdf, Page 6)
 */

int main(int argc, char* argv[]) {
    /* Start MPI */
    int my_rank, comm_size;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);
    MPI_Comm_size(MPI_COMM_WORLD, &comm_size);

    /* Enforce strict CLI arguments */
    if (argc != 6) {
        if (my_rank == 0) {
            printf("USE LIKE THIS: dot_product_MPI n_items vec_1.csv vec_2.csv result_prob2_MPI.csv time_prob2_MPI.csv\n");
        }
        MPI_Finalize();
        return EXIT_FAILURE;
    }

    int n_items = strtol(argv[1], NULL, 10);

    double *global_vec1 = NULL;
    double *global_vec2 = NULL;

    if (my_rank == 0) {
        global_vec1 = malloc(n_items * sizeof(double));
        global_vec2 = malloc(n_items * sizeof(double));

        FILE* inputFile1 = fopen(argv[2], "r");
        if (inputFile1 == NULL) {
            printf("Could not open file %s\n", argv[2]);
            MPI_Abort(MPI_COMM_WORLD, 1);
        }

        FILE* inputFile2 = fopen(argv[3], "r");
        if (inputFile2 == NULL) {
            printf("Could not open file %s\n", argv[3]);
            MPI_Abort(MPI_COMM_WORLD, 1);
        }

        char str[MAX_LINE_LEN];
        int k = 0;
        while (fgets(str, MAX_LINE_LEN, inputFile1) != NULL) {
            sscanf(str, "%lf", &(global_vec1[k++]));
        }
        fclose(inputFile1);

        k = 0;
        while (fgets(str, MAX_LINE_LEN, inputFile2) != NULL) {
            sscanf(str, "%lf", &(global_vec2[k++]));
        }
        fclose(inputFile2);
    }

    int chunk_size = n_items / comm_size;
    double* local_vec1 = malloc(chunk_size * sizeof(double));
    double* local_vec2 = malloc(chunk_size * sizeof(double));

    /* "Start the timer after reading in the two arrays and stop the timer after the dot product is computed." (Project_5_Instructions.pdf, Page 6) */
    double start_time, end_time, elapsed_time;
    if (my_rank == 0) {
        start_time = MPI_Wtime();
    }

    MPI_Scatter(global_vec1, chunk_size, MPI_DOUBLE, local_vec1, chunk_size, MPI_DOUBLE, 0, MPI_COMM_WORLD);
    MPI_Scatter(global_vec2, chunk_size, MPI_DOUBLE, local_vec2, chunk_size, MPI_DOUBLE, 0, MPI_COMM_WORLD);

    double local_dot_product = 0.0;
    for (int i = 0; i < chunk_size; i++) {
        local_dot_product += local_vec1[i] * local_vec2[i];
    }

    double global_dot_product = 0.0;
    MPI_Reduce(&local_dot_product, &global_dot_product, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);

    if (my_rank == 0) {
        end_time = MPI_Wtime();
        elapsed_time = end_time - start_time;

        FILE* resultFile = fopen(argv[4], "w");
        fprintf(resultFile, "%.6f", global_dot_product);
        fclose(resultFile);

        FILE* timeFile = fopen(argv[5], "w");
        fprintf(timeFile, "%.6f", elapsed_time);
        fclose(timeFile);
    }

    free(local_vec1);
    free(local_vec2);
    if (my_rank == 0) {
        free(global_vec1);
        free(global_vec2);
    }

    MPI_Finalize();
    return 0;
}
