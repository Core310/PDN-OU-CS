#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <time.h>
#include "mpi.h"

#define MAXLINE 25
#define DEBUG   0
// helper merge sorted arrays
float* merge(float* a, int aa ,float* b, int bb){
    float* res = (float*)malloc((aa+bb)*sizeof(float));
    int i=0,j=0,k=0;
    while(i<aa && j<bb){
        if(a[i]<=b[j]) res[k++]=a[i++];
        else res[k++] = b[j++];
    }
    while (i<aa) res[k++] = a[i++];
    while (j<bb) res[k++] = b[j++];
    return res;
}

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
    // TODO: initialize your arrays here
    int local_n = n_items / comm_size;
    float* global_array = NULL;
    if(my_rank==0) global_array = read_input(inputFile, n_items);

    float* local_array = (float*)malloc(local_n * sizeof(float));

    // get start time
    double local_start, local_finish, local_elapsed, elapsed;
    MPI_Barrier(MPI_COMM_WORLD);
    local_start = MPI_Wtime();



    // TODO: implement solution here
    MPI_Scatter(global_array, local_n, MPI_FLOAT, local_array, local_n, MPI_FLOAT, 0, MPI_COMM_WORLD);

    qsort(local_array, local_n, sizeof(float), cmpfloat);

    int step =1;
    int curr_n = local_n;
    while (step < comm_size){
        if(my_rank % (2* step) == 0){
            if(my_rank + step < comm_size){
                float* recv_array = (float*)malloc(curr_n * sizeof(float));
                MPI_Recv(recv_array, curr_n, MPI_FLOAT, my_rank + step, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
    
                float* merged_array = merge(local_array, curr_n, recv_array, curr_n);
                free(local_array); free(recv_array);
                local_array = merged_array;
                curr_n *=2;
            } else{
                int target = my_rank - step;
                MPI_Send(local_array, curr_n, MPI_FLOAT, target, 0, MPI_COMM_WORLD);
                break;
            }
            step*=2;
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

        // TODO: output
        for(int i=0; i<n_items;i++) fprintf(outputFile, "%f\n", local_array[i]);

        fprintf(timeFile, "%0.6f\n", elapsed);

        fclose(outputFile);
        fclose(timeFile);

        free(global_array);
    }

    free(local_array);
    
    MPI_Finalize();

    if(DEBUG) printf("Finished!\n");
    return 0;
} // End Main //



/* Read Input -------------------- */
float* read_input(FILE* inputFile, int n_items) {
    float* arr = (float*)malloc(n_items * sizeof(float));
    char line[MAXLINE] = {0};
    int i = 0;
    // char* ptr;
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
    return (fa > fb) - (fa < fb);
} // Cmp Int //
