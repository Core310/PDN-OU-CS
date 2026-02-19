#include <stdlib.h> 
#include <string.h>
#include <stdio.h>
#include <math.h>
#include <omp.h>
#include "../setup/setup.h"

int main(int argc, char* argv[]) {
    Setup s = handle_setup(argc, argv, "compute_median_TF input.fna median_TF.csv time.csv num_threads");
    
    struct Genes genes = read_genes(s.input);
    int* tf_matrix = (int*)calloc((long)genes.num_genes * NUM_TETRANUCS, sizeof(int));
    if (tf_matrix == NULL) { fprintf(stderr, "ERROR: malloc fail\n"); exit(-9); }

    double start = omp_get_wtime();

    #pragma omp parallel for default(none) shared(genes, tf_matrix, stderr)
    for (int gene_index = 0; gene_index < genes.num_genes; ++gene_index) {
        process_tetranucs(genes, &tf_matrix[(long)gene_index * NUM_TETRANUCS], gene_index);
    }

    double* median_TF = (double*)calloc(NUM_TETRANUCS, sizeof(double));
    if (median_TF == NULL) { fprintf(stderr, "ERROR: malloc fail\n"); exit(-9); }

    /* 
     * Req: Page 10, Problem 3 - "In the map reduce pattern, we exploit the 
     * parallelization opportunity presented by the fact that the reduce step 
     * is performed independently for many elements in an array of intermediate result."
     */
    #pragma omp parallel for default(none) shared(genes, tf_matrix, median_TF, stderr)
    for (int tet = 0; tet < NUM_TETRANUCS; ++tet) {
        int num_genes = genes.num_genes;
        int* freqs = (int*)calloc(num_genes, sizeof(int));
        if (freqs == NULL) { fprintf(stderr, "ERROR: malloc fail\n"); exit(-9); }
        for (int gene = 0; gene < num_genes; ++gene)
            freqs[gene] = tf_matrix[(long)gene * NUM_TETRANUCS + tet];
        median_TF[tet] = find_median(freqs, num_genes);
        free(freqs);
    }

    double end = omp_get_wtime();

    write_results(s.output, median_TF);
    fprintf(s.time, "%f", end - start);

    cleanup_setup(&s);
    free(tf_matrix);
    free(median_TF);
    free_genes(&genes);

    return 0;
}
