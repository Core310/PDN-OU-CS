#include <stdio.h>
#include <stdlib.h> 
// Use more libraries as necessary

#define DEBUG 0

/* ---------- Project 1 - Problem 2 - Mat-Vec Mult ----------
    This file will multiply a matrix and vector.
    Complete the TODOs left in this file.
*/ // ------------------------------------------------------ //


void read_files_in(FILE *matFile, FILE *vecFile, int n_row1, int n_col1, int vec_dim, long int *matrix, long int *vec) {
    // Read Matrix
    for (int i = 0; i < n_row1 * n_col1; i++) {
        // Space before %ld skips whitespaces and newlines
        // %*c skips the comma or trailing newline
        if (fscanf(matFile, " %ld%*c", &matrix[i]) != 1) {
            printf("Error reading matrix file at index %d\n", i);
            break;
        }
    }

    // Read Vector
    for (int i = 0; i < vec_dim; i++) {
        if (fscanf(vecFile, " %ld%*c", &vec[i]) != 1) {
            printf("Error reading vector file at index %d\n", i);
            break;
        }
    }
}

void matrix_vector_multi(int matrix_row, int matrix_col, long int *matrix, long int *vec, long int *result) {
    for (int i = 0; i < matrix_row; ++i) {
        long int sum = 0;

        for (int j = 0; j < matrix_col; ++j) {
            // matrix[i * n_col1 + j]
            //check document, we can't use a 2d array, so have 2
            //do weird math
            sum += matrix[i * matrix_col + j] * vec[j];
        }
        result[i] = sum;
    }
}

int main (int argc, char *argv[])
{
    // Catch console errors
    if( argc != 7)
    {
        printf("USE LIKE THIS: serial_mult_mat_vec in_mat.csv n_row_1 n_col_1 in_vec.csv n_row_2 output_file.csv \n");
        return EXIT_FAILURE;
    }

    // Get the input files
    FILE *matFile = fopen(argv[1], "r");
    FILE *vecFile = fopen(argv[4], "r");

    // Get dim of the matrix
    char* p1;
    char* p2;
    int matrix_row = strtol(argv[2], &p1, 10 );
    int matrix_col = strtol(argv[3], &p2, 10 );

    // Get dim of the vector
    char* p3;
    int vec_dim = strtol(argv[5], &p3, 10 );

    // Get the output file
    FILE *outputFile = fopen(argv[6], "w");


    // init matricies + vector +
    //matrix p easy
    //vec
    long int* matrix = (long int*) malloc(matrix_row * matrix_col * sizeof(long int));

    long int* vec = (long int*) malloc(vec_dim * sizeof(long int));

    long int* result = (long int*) malloc(matrix_row * sizeof(long int));

    // TODO: Parse the input CSV files

    //we need 2 parse 2 files: vec and matrix files
    //sadly we can't do this in 1 run
    read_files_in(matFile, vecFile, matrix_row, matrix_col, vec_dim, matrix, vec);

    // TODO: Perform the matrix-vector multiplication

    /*
     * Hm I want to multiply a 2d vector via 1d
     * But I don't think I can do [i][j], so need 2 do it manually
     * then lets just calculate each and regenerate each index via 2 for loops
     *
     *
     */
    matrix_vector_multi(matrix_row, matrix_col, matrix, vec, result);

    // TODO: Write the output CSV file

    //just fprintf right
    for(int i = 0; i < matrix_row; i++) {
        fprintf(outputFile, "%ld\n", result[i]);
    }

    // TODO: Free memory
    free(matrix);
    free(vec);
    free(result);

    // Cleanup
    fclose (matFile);
    fclose (vecFile);
    fclose (outputFile);
    // Free buffers here as well!

    return 0;
}
