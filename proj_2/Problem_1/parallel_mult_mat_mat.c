#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <omp.h>

#define DEBUG 0

/* ----------- Project 2 - Problem 1 - Matrix Mult -----------

    This file will multiply two matricies.
    Complete the TODOs in order to complete this program.
    Remember to make it parallelized!
*/ // ------------------------------------------------------ //


int main(int argc, char *argv[]) {
    // Catch console errors
    if (argc != 10) {
        printf(
            "USE LIKE THIS: parallel_mult_mat_mat file_A.csv n_row_A n_col_A file_B.csv n_row_B n_col_B result_matrix.csv time.csv num_threads \n");
        return EXIT_FAILURE;
    }

    // Get the input files
    FILE *inputMatrix1 = fopen(argv[1], "r");
    FILE *inputMatrix2 = fopen(argv[4], "r");

    char *p1;
    char *p2;

    // Get matrix 1's dims
    int row1 = strtol(argv[2], &p1, 10);
    int col1 = strtol(argv[3], &p2, 10);

    // Get matrix 2's dims
    int row2 = strtol(argv[5], &p1, 10);
    int col2 = strtol(argv[6], &p2, 10);

    // Get num threads
    int thread_count = strtol(argv[9], NULL, 10);

    // Get output files
    FILE *outputFile = fopen(argv[7], "w");
    FILE *outputTime = fopen(argv[8], "w");


    // TODO: malloc the two input matrices and the output matrix
    long int *matrixA = (long int *) malloc(row1 * col1 * sizeof(long int));
    long int *matrixB = (long int *) malloc(row2 * col2 * sizeof(long int));
    long int *matrixC = (long int *) calloc(row1 * col2, sizeof(long int));

    /*
     * There's sm really interesitng stuff of what happens when we calloc instead of malloc.
     *
     *
     * cite [1]: on why ijk lookup is faster https://stackoverflow.com/questions/20467117/for-matrix-operation-why-is-ikj-faster-than-ijk
     * cite [2}: diff btwn calloc malloc: https://stackoverflow.com/questions/807939/what-is-the-difference-between-new-and-malloc-and-calloc-in-c
     *
     *Malloc itself is pretty straighfoward, sizeof(long int) just to init datatype
     */

    // TODO: Parse the input csv files and fill in the input matrices


    /*
    if (matrixA == NULL || matrixB == NULL || matrixC == NULL) {
        printf("Error: Memory allocation failed.\n");
        return EXIT_FAILURE;
    }
    see if i can use a teranry operator on this or thrnE
     *
     */

    // We are interesting in timing the matrix-matrix multiplication only
    // Record the start time

    // todo later, js merge this into a func for tidy
    for (int i = 0; i < row1; i++) {
        for (int j = 0; j < col1; j++) {
            fscanf(inputMatrix1, "%ld%*c", &matrixA[i * col1 + j]);//possible FIXME, clangtidy doesnt like this because it's type converting at runtime
            //Clang-Tidy: 'fscanf' used to convert a string to an integer value, but function will not report conversion errors; consider using 'strtol' instead


        }
    }

    for (int i = 0; i < row2; i++) {
        for (int j = 0; j < col2; j++) {
            fscanf(inputMatrix2, "%ld%*c", &matrixB[i * col2 + j]);
        }
    }

    // TODO: Parallelize the matrix-matrix multiplication



    /*
     * Fancy method (again see the SO cite links)
     * if we do the ikj instead we can linearize the ascess array prompting faster lookup
     *
     */
    double start = omp_get_wtime();

    #pragma omp parallel //nvr spec how mny threads so js default
    for (int i = 0; i < row1; i++) {
        for (int k = 0; k < col1; k++) {
            long int r = matrixA[i * col1 + k];

            for (int j = 0; j < col2; j++) {
                // Because we iterate over j (columns), we access memory sequentially
                matrixC[i * col2 + j] += r * matrixB[k * col2 + j];
            }
        }
    }

    double end = omp_get_wtime();

    double time_passed = end - start;

    // Save time to file
    fprintf(outputTime, "%f", time_passed);

    /*
     * So I actually tested and it was only a slight slight bit faster using the ikj method, but it was really interestign to see!
     *
     */

    // Cleanup
    fclose(inputMatrix1);
    fclose(inputMatrix2);
    fclose(outputFile);
    fclose(outputTime);
    // Remember to free your buffers!
    free(matrixA);
    free(matrixB);
    free(matrixC);

    return 0;
}
