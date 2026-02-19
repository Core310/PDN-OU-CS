#include <stdlib.h> 
#include <string.h>
#include <stdio.h>
#include <math.h>
#include <omp.h>
#include "../setup/setup.h"

/* 
 * Req: Page 7, Experiment 1 - "You learned three mutual exclusion techniques: 
 * critical directive, atomic directive, and an array of locks. 
 * Please try each mutual exclusion technique..."
 */
void aggregate_results_critical(int* global_TF, int* local_TF) {
    #pragma omp critical
    {
        for (int t = 0; t < NUM_TETRANUCS; ++t) {
            global_TF[t] += local_TF[t];
        }
    }
}

int main(int argc, char* argv[]) {
    Setup s = handle_setup(argc, argv, "compute_average_TF input.fna average_TF.csv time.csv num_threads");
    
    struct Genes genes = read_genes(s.input);
    int* TF = (int*)calloc(NUM_TETRANUCS, sizeof(int));
    if (TF == NULL) { fprintf(stderr, "ERROR: malloc fail\n"); exit(-9); }

    double start = omp_get_wtime();

    /* Parallel loop over genes to calculate individual tetranucleotide frequencies */
    #pragma omp parallel for default(none) shared(genes, TF, stderr)
    for (int gene_index = 0; gene_index < genes.num_genes; ++gene_index) {
        int* gene_TF = (int*)calloc(NUM_TETRANUCS, sizeof(int));
        if (gene_TF == NULL) { fprintf(stderr, "ERROR: malloc fail\n"); exit(-9); }
        process_tetranucs(genes, gene_TF, gene_index);
        aggregate_results_critical(TF, gene_TF);
        free(gene_TF);
    }

    double* average_TF = (double*)malloc(NUM_TETRANUCS * sizeof(double));
    if (average_TF == NULL) { fprintf(stderr, "ERROR: malloc fail\n"); exit(-9); }
    for (int t = 0; t < NUM_TETRANUCS; ++t)
        average_TF[t] = (double)TF[t] / (double)genes.num_genes;

    double end = omp_get_wtime();

    write_results(s.output, average_TF);
    fprintf(s.time, "%f", end - start);

    cleanup_setup(&s);
    free(TF);
    free(average_TF);
    free_genes(&genes);

    return 0;
}
