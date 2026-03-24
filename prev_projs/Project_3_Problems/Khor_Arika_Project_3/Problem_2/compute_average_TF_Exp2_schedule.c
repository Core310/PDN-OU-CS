#include <stdlib.h> 
#include <string.h>
#include <stdio.h>
#include <math.h>
#include <omp.h>

#define MAX_LINE_LENGTH 1000000
#define GENE_ARRAY_SIZE 164000 
#define NUM_TETRANUCS   256
#define GENE_SIZE       10000

struct Genes {
    unsigned char* gene_sequences;
    int* gene_sizes;
    int  num_genes;
};

typedef struct {
    FILE* input;
    FILE* output;
    FILE* time;
    int num_threads;
} Setup;

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
    if (s.num_threads < 1) { fprintf(stderr, "ERROR: num_threads >= 1\n"); exit(-8); }
    omp_set_num_threads(s.num_threads);
    s.input = fopen(argv[1], "r");
    if (s.input == NULL) { exit(-2); }
    s.output = fopen(argv[2], "w");
    if (s.output == NULL) { fclose(s.input); exit(-3); }
    s.time = fopen(argv[3], "w");
    if (s.time == NULL) { fclose(s.input); fclose(s.output); exit(-4); }
    return s;
}

void cleanup_setup(Setup* s) {
    if (s) {
        fclose(s->input);
        fclose(s->output);
        fclose(s->time);
    }
}

void write_results(FILE* output, double* data) {
    for (int i = 0; i < NUM_TETRANUCS; ++i) {
        fprintf(output, "%.6f", data[i]);
        if (i < NUM_TETRANUCS - 1) fprintf(output, "\n");
    }
}

void process_tetranucs(struct Genes genes, int* gene_TF, int gene_index) {
    int N = genes.gene_sizes[gene_index];
    if (N < 4) { exit(-6); }
    unsigned char* sequence = &genes.gene_sequences[(long)gene_index * GENE_SIZE];
    for (int i = 0; i <= N - 4; ++i) {
        gene_TF[get_window_index(sequence, i)]++;
    }
}

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
    if (TF == NULL) { exit(-9); }

    double start = omp_get_wtime();

    /* 
     * Req: Page 7, Experiment 2 - "Please select the quickest algorithm from Experiment 1 
     * and try to speed it up by improving its load balancing... 
     * You learned three schedules: static, dynamic and guided. Please try each schedule..."
     */
    #pragma omp parallel for default(none) shared(genes, TF, stderr) schedule(runtime)
    for (int gene_index = 0; gene_index < genes.num_genes; ++gene_index) {
        int* gene_TF = (int*)calloc(NUM_TETRANUCS, sizeof(int));
        if (gene_TF == NULL) { exit(-9); }
        process_tetranucs(genes, gene_TF, gene_index);
        aggregate_results_critical(TF, gene_TF);
        free(gene_TF);
    }

    double* average_TF = (double*)malloc(NUM_TETRANUCS * sizeof(double));
    if (average_TF == NULL) { exit(-9); }
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
