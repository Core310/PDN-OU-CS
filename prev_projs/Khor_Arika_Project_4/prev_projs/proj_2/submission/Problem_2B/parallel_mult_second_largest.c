//
// Created by arika on 2/14/26.
//

#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <limits.h>

void LDA_Matricies(char **argv, int rowA, int colA, int rowB, int colB, long int *matrixA, long int *matrixB) {
    FILE *fileA = fopen(argv[1], "r");
    for (int i = 0; i < rowA * colA; i++) {
        fscanf(fileA, "%ld%*c", &matrixA[i]);
    }
    fclose(fileA);


    FILE *fileB = fopen(argv[4], "r");
    for (int i = 0; i < rowB * colB; i++) {
        fscanf(fileB, "%ld%*c", &matrixB[i]);
    }
    fclose(fileB);
}

int main(int argc, char *argv[]) {
    int rowA = atoi(argv[2]),
     colA = atoi(argv[3]),
     rowB = atoi(argv[5]),
     colB = atoi(argv[6]),
     num_threads = atoi(argv[9]); //needs 2 b kept 4 manual testing args

    long int *matrixA = (long int *)malloc(rowA * colA * sizeof(long int));
    long int *matrixB = (long int *)malloc(rowB * colB * sizeof(long int));
    //store row/col into matirices
    LDA_Matricies(argv, rowA, colA, rowB, colB, matrixA, matrixB);

    long int global_max1 = LONG_MIN,
    global_max2 = LONG_MIN;

    double start_time = omp_get_wtime();

    #pragma omp parallel num_threads(num_threads)
    {
        long int
        local_max1 = LONG_MIN,
        local_max2 = LONG_MIN;

        // Parallelize over columns of B; see psudo code
        #pragma omp for
        for (int j = 0; j < colB; j++) {
            for (int i = 0; i < rowA; i++) {
                long int dot_product = 0;
                for (int k = 0; k < colA; k++) {
                    dot_product += matrixA[i * colA + k] * matrixB[k * colB + j];
                }

                // Update local top2
                if (dot_product > local_max1) {
                    local_max2 = local_max1;
                    local_max1 = dot_product;
                } else if (dot_product > local_max2 && dot_product < local_max1) {
                    local_max2 = dot_product;
                }
            }
        }

        #pragma omp critical
        {
            long int values[2] = {local_max1, local_max2};
            for (int v = 0; v < 2; v++) {
                long int x = values[v];
                if (x > global_max1) {
                    global_max2 = global_max1;
                    global_max1 = x;
                } else if (x > global_max2 && x < global_max1) {
                    global_max2 = x;
                }
            }
        }
    }

    double end_time = omp_get_wtime();

    FILE *resFile = fopen(argv[7], "w");
    fprintf(resFile, "%ld\n", global_max2);
    fclose(resFile);

    FILE *timeFile = fopen(argv[8], "w");
    fprintf(timeFile, "%f\n", end_time - start_time);
    fclose(timeFile);

    free(matrixA);
    free(matrixB);

    return 0;
}
