//
// Created by arika on 2/14/26.
//

#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

/* ------------ Project 2 - Matrix Max Multiplication ------------
    This program finds the maximum value in AxB without
    storing the resulting matrix.
*/ // ----------------------------------------------------------- //


void LDA_Matricies(char *fileA, int rA, int cA, char *fileB, int rB, int cB, double *A, double *B) {
    FILE *fA = fopen(fileA, "r");
    for (int i = 0; i < rA * cA; i++) fscanf(fA, "%lf,", &A[i]);
    fclose(fA);

    FILE *fB = fopen(fileB, "r");
    for (int i = 0; i < rB * cB; i++) fscanf(fB, "%lf,", &B[i]);
    fclose(fB);
}

void save_results(char *fileRes, char *fileTime, int num_threads, double global_maximum, double start_time, double end_time) {
    // sv max rslt
    FILE *fOut = fopen(fileRes, "w");
    fprintf(fOut, "%f\n", global_maximum);
    fclose(fOut);

    // Save timing data
    FILE *fTime = fopen(fileTime, "w");
    fprintf(fTime, "%f\n", end_time - start_time);
    fclose(fTime);
}

int main(int argc, char *argv[]) {
    if (argc != 10) {
        printf("USE LIKE THIS: parallel_mult_max file_A.csv n_row_A n_col_A file_B.csv n_row_B n_col_B result_maximum.csv time.csv num_threads\n");
        return EXIT_FAILURE;
    }

    /*
     * "Your program shuld b run via following cmd part:
     * then js bind each 2 sm inp frm argv
     *
     */
    char *fileA = argv[1],
     *fileB = argv[4],
     *fileRes = argv[7],
     *fileTime = argv[8];

    int rA = atoi(argv[2]),
     cA = atoi(argv[3]),
     rB = atoi(argv[5]),
     cB = atoi(argv[6]),
     num_threads = atoi(argv[9]);

    /*sometimes its nice to have everything nicely defiend :)
     *instead of bein lazy and just directly calling each arugment (but this leads to me getting laid off so oof...)
     *
     */

    double *A = (double *)malloc(rA * cA * sizeof(double));
    double *B = (double *)malloc(rB * cB * sizeof(double));

    //load in matriiceis
    LDA_Matricies(fileA, rA, cA, fileB, rB, cB, A, B);

    double global_maximum = 0;
    omp_set_num_threads(num_threads);

    double start_time = omp_get_wtime();

    /*
     * where da magic habbens
     *
     */
    #pragma omp parallel for schedule(static) reduction(max:global_maximum)
    for (int col_b = 0; col_b < cB; col_b++) {
        for (int row_a = 0; row_a < rA; row_a++) {
            double dot_product = 0;
            for (int k = 0; k < cA; k++) {   // Dot product loop
                dot_product += A[row_a * cA + k] * B[k * cB + col_b];
            }
            global_maximum = (dot_product > global_maximum) ? dot_product : global_maximum;
        }
    }

    double end_time = omp_get_wtime();

    save_results(fileRes, fileTime, num_threads, global_maximum, start_time, end_time);

    free(A);
    free(B);

    return 0;
}
