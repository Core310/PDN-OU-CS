#include "setup.h"
#include <stdlib.h>
#include <string.h>
#include <omp.h>

/* Helper for qsort integer comparisons. */
int compare_ints(const void* a, const void* b) {
    return (*(int*)a - *(int*)b);
}

int char_to_val(char c) {
    if (c == 'A') return 0;
    if (c == 'C') return 1;
    if (c == 'G') return 2;
    if (c == 'T') return 3;
    fprintf(stderr, "ERROR: Non-ACGT character '%c' encountered!\n", c);
    exit(-5);
}

int get_window_index(unsigned char* sequence, int pos) {
    return (char_to_val(sequence[pos]) << 6) |
           (char_to_val(sequence[pos+1]) << 4) |
           (char_to_val(sequence[pos+2]) << 2) |
           char_to_val(sequence[pos+3]);
}

void process_tetranucs(struct Genes genes, int* gene_TF, int gene_index) {
    int N = genes.gene_sizes[gene_index];
    if (N < 4) {
        fprintf(stderr, "ERROR: Gene %d shorter than 4 chars\n", gene_index);
        exit(-6);
    }
    unsigned char* sequence = &genes.gene_sequences[(long)gene_index * GENE_SIZE];
    for (int i = 0; i <= N - 4; ++i) {
        gene_TF[get_window_index(sequence, i)]++;
    }
}

struct Genes read_genes(FILE* inputFile) {
    struct Genes genes;
    genes.gene_sequences = (unsigned char*)malloc((long)GENE_ARRAY_SIZE * GENE_SIZE * sizeof(unsigned char));
    if (genes.gene_sequences == NULL) { fprintf(stderr, "ERROR: malloc fail\n"); exit(-9); }
    genes.gene_sizes = (int*)malloc(GENE_ARRAY_SIZE * sizeof(int));
    if (genes.gene_sizes == NULL) { fprintf(stderr, "ERROR: malloc fail\n"); exit(-9); }
    genes.num_genes = 0;

    char line[MAX_LINE_LENGTH] = { 0 };
    if (!fgets(line, MAX_LINE_LENGTH, inputFile) || line[0] != '>') {
        fprintf(stderr, "ERROR: Input file must start with a '>' header!\n");
        exit(-7);
    }

    int currentGeneIndex = 0;
    while (fgets(line, MAX_LINE_LENGTH, inputFile)) {
        if (strcmp(line, "") == 0) break;
        else if (line[0] != '>') {
            int line_len = strlen(line);
            for (int i = 0; i < line_len; ++i) {
                char c = line[i];
                if (c == 'A' || c == 'C' || c == 'G' || c == 'T') {
                    genes.gene_sequences[(long)genes.num_genes * GENE_SIZE + currentGeneIndex] = c;
                    currentGeneIndex += 1;
                }
            }
        }
        else if (line[0] == '>') {
            genes.gene_sizes[genes.num_genes] = currentGeneIndex;
            genes.num_genes += 1;
            currentGeneIndex = 0;
        }
    }
    genes.gene_sizes[genes.num_genes] = currentGeneIndex;
    genes.num_genes += 1;
    return(genes);
}

void free_genes(struct Genes* genes) {
    if (genes) {
        free(genes->gene_sequences);
        free(genes->gene_sizes);
    }
}

Setup handle_setup(int argc, char* argv[], const char* usage) {
    if (argc != 5) {
        fprintf(stderr, "USE LIKE THIS: %s\n", usage);
        exit(-1);
    }

    Setup s;
    s.num_threads = atoi(argv[4]);
    if (s.num_threads < 1) {
        fprintf(stderr, "ERROR: num_threads >= 1\n");
        exit(-8);
    }
    omp_set_num_threads(s.num_threads);

    s.input = fopen(argv[1], "r");
    if (s.input == NULL) { fprintf(stderr, "ERROR: input file\n"); exit(-2); }
    
    s.output = fopen(argv[2], "w");
    if (s.output == NULL) { fclose(s.input); fprintf(stderr, "ERROR: output file\n"); exit(-3); }
    
    s.time = fopen(argv[3], "w");
    if (s.time == NULL) { fclose(s.input); fclose(s.output); fprintf(stderr, "ERROR: time file\n"); exit(-4); }

    return s;
}

void cleanup_setup(Setup* s) {
    if (s) {
        fclose(s->input);
        fclose(s->output);
        fclose(s->time);
    }
}

double find_median(int* freqs, int n) {
    qsort(freqs, n, sizeof(int), compare_ints);
    if (n % 2 == 0)
        return (double)(freqs[n / 2 - 1] + freqs[n / 2]) / 2.0;
    else
        return (double)freqs[n / 2];
}

void write_results(FILE* output, double* data) {
    for (int i = 0; i < NUM_TETRANUCS; ++i) {
        fprintf(output, "%.6f", data[i]);
        if (i < NUM_TETRANUCS - 1) fprintf(output, "\n");
    }
}
