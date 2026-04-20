//
// Created by arika on 2/13/26.
//

/*

 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <omp.h>

int count_the_occurrences(unsigned char* text, long size) {
    int count = 0;
    for (long i = 0; i < size - 2; i++) {
        if ((text[i] == 't' || text[i] == 'T') &&
            (text[i+1] == 'h' || text[i+1] == 'H') &&
            (text[i+2] == 'e' || text[i+2] == 'E')) {
            count++;
        }
    }
    return count;
}

int main(int argc, char* argv[]) {
    if (argc != 5) {
        //catch case
        return EXIT_FAILURE;
    }
    FILE* inputFile = fopen(argv[1], "rb");
    FILE* keyFile = fopen(argv[2], "w");
    FILE* timeFile = fopen(argv[3], "w");
    int num_threads = strtol(argv[4], NULL, 10);

    if (!inputFile || !keyFile || !timeFile) {
        return EXIT_FAILURE;
    }//catch case

    fseek(inputFile, 0L, SEEK_END);
    /*
     *fseek:
     *  Seek to a certain position on STREAM.
     *  Trick to get filesize by just vjumping to the end of the file in O(1) time instead of having to read the entire thing

    */
    long file_size = ftell(inputFile);//since our pointer is now @ EOF, we can get file size 2 malloc
    rewind(inputFile);//then obv we want cursor at start pos again..

    unsigned char* ciphertext = malloc(file_size);
    fread(ciphertext, 1, file_size, inputFile); // dun care abt this
    fclose(inputFile);//or this now

    int best_key = 0;
    int max_the_count = -1;

    double start = omp_get_wtime();//same start time lgoic as problem 1

    #pragma omp parallel num_threads(num_threads)
    {
        int local_max_count = -1;
        int local_best_key = 0;
        unsigned char* local_buffer = malloc(file_size);
        /*Sign extension is a thing in C
         * and I hate it a ton
         * We were never taught this stuff...
         * why is this so hard (sigh)
         * https://stackoverflow.com/questions/5814072/sign-extend-a-nine-bit-number-in-c
         *
         */

        #pragma omp for
        for (int k = 0; k < 256; k++) {
            for (long i = 0; i < file_size; i++) {
                // Decrypt (buffer + key) % 256 encryption, - key
                local_buffer[i] = (unsigned char)((ciphertext[i] - k + 256) % 256);
            }
            int current_count = count_the_occurrences(local_buffer, file_size);
            if (current_count > local_max_count) {
                local_max_count = current_count;
                local_best_key = k;
            }
        }
/*I mean by right I don't have to use critical (see problem 1 SO link cite 1 or 2 i think)*/
        #pragma omp critical
        {
            if (local_max_count > max_the_count) {
                max_the_count = local_max_count;
                best_key = local_best_key;
            }
        }
        free(local_buffer);
    }

    double end = omp_get_wtime();

    fprintf(keyFile, "%d", best_key);
    fprintf(timeFile, "%f", end - start);

    fclose(keyFile);
    fclose(timeFile);
    free(ciphertext);

    return 0;
}