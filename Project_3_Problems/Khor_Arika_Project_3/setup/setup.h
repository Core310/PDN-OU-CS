#ifndef SETUP_H
#define SETUP_H

#include <stdio.h>

#define MAX_LINE_LENGTH 1000000
#define GENE_ARRAY_SIZE 164000 
#define NUM_TETRANUCS   256
#define GENE_SIZE       10000

/* 
 * Stores all genomic data loaded from a Fasta file. 
 * gene_sequences: contiguous memory for nucleotide characters.
 * gene_sizes: array storing the length of each individual gene.
 */
struct Genes {
    unsigned char* gene_sequences;
    int* gene_sizes;
    int  num_genes;
};

/* 
 * Encapsulates the execution environment state including 
 * open file pointers and configured thread count.
 */
typedef struct {
    FILE* input;
    FILE* output;
    FILE* time;
    int num_threads;
} Setup;

/* Maps ACGT characters to values 0-3. Terminates on malformed data. */
int ACGT_check(char c);

/* 
 * Req: Page 5 - "A gene’s TFs can be counted by a moving window of size 4... 
 * idx = Window[0]*64 + Window[1]*16 + Window[2]*4 + Window[3]"
 */
int get_slide_window_index(unsigned char* sequence, int pos);

/* 
 * Req: Page 6 - "For each i between 0 and N-4: Get the substring from i to i+3... 
 * Convert this tetranucleotide to its array index, idx... TF[idx]++"
 */
void process_tetranucs(struct Genes genes, int* gene_TF, int gene_index);

/* Parses a Fasta file and allocates memory for genomic data. */
struct Genes read_genes(FILE* inputFile);

/* Properly releases all memory allocated within a Genes structure. */
void free_genes(struct Genes* genes);

/* Handles 5-arg CLI parsing, thread configuration, and file I/O setup. */
Setup handle_setup(int argc, char* argv[], const char* usage);

/* Closes all file handles stored in the Setup structure. */
void cleanup_setup(Setup* s);

/* 
 * Calculates the median of an array of integers. 
 * Correctly handles even and odd counts.
 */
double find_median(int* freqs, int n);

/* Writes 256 double-precision frequencies to a file, one per line. */
void write_results(FILE* output, double* data);

#endif
