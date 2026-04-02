#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <time.h>
#include "mpi.h"

#define MAXLINE 25
#define DEBUG   0

// to read in file
float* read_input(FILE* inputFile, int n_items);
int cmpfloat(const void* a, const void* b);

/* Main Program -------------- */
int main (int argc, char *argv[])
{
    if( argc != 5)
    {
        printf("USE LIKE THIS: merge_sort_MPI n_items input.csv output.csv time.csv\n");
        return EXIT_FAILURE;
    }

    // input file and size
    FILE* inputFile = fopen(argv[2], "r");
    int  n_items = strtol(argv[1], NULL, 10);

    // Start MPI
    int my_rank, comm_size;
    MPI_Init(NULL, NULL);
    MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);
    MPI_Comm_size(MPI_COMM_WORLD, &comm_size);

    // arrays to use
    float* arr = NULL;
    int local_n = n_items / comm_size;
    float* local_arr = (float*)malloc(local_n * sizeof(float));

    // get start time
    double local_start, local_finish, local_elapsed, elapsed;
    
    if (my_rank == 0) {
        arr = read_input(inputFile, n_items);
    }

    MPI_Barrier(MPI_COMM_WORLD);
    local_start = MPI_Wtime();

    // Scatter the data
    MPI_Scatter(arr, local_n, MPI_FLOAT, local_arr, local_n, MPI_FLOAT, 0, MPI_COMM_WORLD);

    // Local sort
    qsort(local_arr, local_n, sizeof(float), cmpfloat);

    // Tree-based merge
    for (int i = comm_size / 2; i > 0; i /= 2) {
        if (my_rank < i) {
            // Receive from partner
            int partner_rank = my_rank + i;
            int received_size;
            MPI_Status status;
            MPI_Probe(partner_rank, 0, MPI_COMM_WORLD, &status);
            MPI_Get_count(&status, MPI_FLOAT, &received_size);

            float* received_arr = (float*)malloc(received_size * sizeof(float));
            MPI_Recv(received_arr, received_size, MPI_FLOAT, partner_rank, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

            // Merge
            float* merged_arr = (float*)malloc((local_n + received_size) * sizeof(float));
            int k = 0, j = 0, m = 0;
            while (k < local_n && j < received_size) {
                if (local_arr[k] < received_arr[j]) {
                    merged_arr[m++] = local_arr[k++];
                } else {
                    merged_arr[m++] = received_arr[j++];
                }
            }
            while (k < local_n) {
                merged_arr[m++] = local_arr[k++];
            }
            while (j < received_size) {
                merged_arr[m++] = received_arr[j++];
            }
            
            free(local_arr);
            local_arr = merged_arr;
            local_n += received_size;
            free(received_arr);
        } else if (my_rank < i * 2) {
            // Send to partner
            int partner_rank = my_rank - i;
            MPI_Send(local_arr, local_n, MPI_FLOAT, partner_rank, 0, MPI_COMM_WORLD);
        }
    }




    // get elapsed time
    local_finish  = MPI_Wtime();
    local_elapsed = local_finish-local_start;

    // send time to main process
    MPI_Reduce(
        &local_elapsed, 
        &elapsed, 
        1, 
        MPI_DOUBLE,
        MPI_MAX, 
        0, 
        MPI_COMM_WORLD
    );

    // Write output (Step 5)
    if (my_rank == 0) {
        FILE* outputFile = fopen(argv[3], "w");
        FILE* timeFile = fopen(argv[4], "w");

        for (int i = 0; i < n_items; i++) {
            fprintf(outputFile, "%.6f\n", local_arr[i]);
        }
        fprintf(timeFile, "%f", elapsed);

        fclose(outputFile);
        fclose(timeFile);
    }


    MPI_Finalize();

    if(DEBUG) printf("Finished!\n");
    return 0;
} // End Main //



/* Read Input -------------------- */
float* read_input(FILE* inputFile, int n_items) {
    float* arr = (float*)malloc(n_items * sizeof(float));
    char line[MAXLINE] = {0};
    int i = 0;
    while (fgets(line, MAXLINE, inputFile)) {
        sscanf(line, "%f", &(arr[i]));
        ++i;
    }
    return arr;
} // Read Input //



/* Cmp Int ----------------------------- */
// use this for qsort
// source: https://stackoverflow.com/questions/3886446/problem-trying-to-use-the-c-qsort-function
int cmpfloat(const void* a, const void* b) {
    float fa = *(const float*)a;
    float fb = *(const float*)b;
    if (fa < fb) return -1;
    if (fa > fb) return 1;
    return 0;
} // Cmp Int //
