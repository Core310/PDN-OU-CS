#include <stdio.h>
#include <stdlib.h> // for strtol
#include <string.h>
#include <time.h>
#include "mpi.h"

#define MAXCHAR 25
#define BILLION 1000000000.0

int main(int argc, char *argv[])
{
    if (argc != 6)
    {
        printf("USE LIKE THIS: dotprod_serial vector_size vec_1.csv vec_2.csv result.csv time.csv\n");
        return EXIT_FAILURE;
    }

    // init MPI var
    int my_rank, comm_size;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);
    MPI_Comm_size(MPI_COMM_WORLD, &comm_size);

    // Size
    int vec_size = strtol(argv[1], NULL, 10);
    int local_size = vec_size / comm_size;

    double *vec_1 = NULL;
    double *vec_2 = NULL;

    if (my_rank == 0)
    {
        FILE *inputFile1 = fopen(argv[2], "r");
        FILE *inputFile2 = fopen(argv[3], "r");
        // Input files
        if (inputFile1 == NULL){
            printf("Could not open file %s", argv[2]);
            MPI_Abort(MPI_COMM_WORLD,EXIT_FAILURE);
        }
        if (inputFile2 == NULL){   
            printf("Could not open file %s", argv[3]);
            MPI_Abort(MPI_COMM_WORLD,EXIT_FAILURE);        
        }    

        // To Read in
        vec_1 = malloc(vec_size * sizeof(double));
        vec_2 = malloc(vec_size * sizeof(double));

        // Store values of vector
        int k = 0;
        char str[MAXCHAR];
        while (fgets(str, MAXCHAR, inputFile1) != NULL)
        {
            sscanf(str, "%lf", &(vec_1[k]));
            k++;
        }
        fclose(inputFile1);

        // Store values of vector
        k = 0;
        while (fgets(str, MAXCHAR, inputFile2) != NULL)
        {
            sscanf(str, "%lf", &(vec_2[k]));
            k++;
        }
        fclose(inputFile2);
    }

    double *local_vec_1 = (double *)malloc(local_size * sizeof(double));
    double *local_vec_2 = (double *)malloc(local_size * sizeof(double));

    MPI_Barrier(MPI_COMM_WORLD);
    double start = MPI_Wtime();

    MPI_Scatter(vec_1, local_size, MPI_DOUBLE, local_vec_1, local_size, MPI_DOUBLE, 0, MPI_COMM_WORLD);
    MPI_Scatter(vec_2, local_size, MPI_DOUBLE, local_vec_2, local_size, MPI_DOUBLE, 0, MPI_COMM_WORLD);

    double local_dot = 0.0;
    double global_dot = 0.0;
    
    for (int i = 0; i < local_size; i++) local_dot += local_vec_1[i] * local_vec_2[i];
    
    MPI_Reduce(&local_dot, &global_dot, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);
    double end = MPI_Wtime();

    if (my_rank == 0)
    {
        // Output files
        FILE *outputFile = fopen(argv[4], "w");
        FILE *timeFile = fopen(argv[5], "w");

        fprintf(outputFile, "%lf\n", global_dot);
        fprintf(timeFile, "%0.2f\n", (end - start));
        // Cleanup
        fclose(outputFile);
        fclose(timeFile);
        free(vec_1);
        free(vec_2);
    }

    free(local_vec_1);
    free(local_vec_2);
    MPI_Finalize();
    return 0;
}