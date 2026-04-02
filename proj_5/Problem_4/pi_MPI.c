#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>

/*
 * Parallel Monte Carlo Pi Estimation
 * (Project_5_Instructions.pdf, Page 11)
 */

int main(int argc, char* argv[]) {
    /* Start MPI */
    int world_rank, world_size;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);

    /* Enforce strict CLI arguments */
    if (argc != 3) {
        if (world_rank == 0) {
            printf("USE LIKE THIS: pi_MPI result_prob4_MPI.csv time_prob4_MPI.csv\n");
        }
        MPI_Finalize();
        return EXIT_FAILURE;
    }

    // Seed the random number generator to get different results for each process
    srand48(time(NULL) + world_rank);

    long long TOTAL_POINTS = 1 << 16; // Fixed total points for the problem
    long long num_iterations_per_process = TOTAL_POINTS / world_size;
    long long local_in_circle_count = 0;
    
    double start_time, end_time, elapsed_time;
    MPI_Barrier(MPI_COMM_WORLD); // Synchronize before timing
    start_time = MPI_Wtime();

    for (long long i = 0; i < num_iterations_per_process; i++) {
        double x = drand48();
        double y = drand48();
        if (x * x + y * y < 1.0) {
            local_in_circle_count++;
        }
    }

    end_time = MPI_Wtime();
    elapsed_time = end_time - start_time;


    printf("Process %d local in circle count: %lld\n", world_rank, local_in_circle_count);

    long long global_in_circle_count;
    long long total_points;

    MPI_Reduce(&local_in_circle_count, &global_in_circle_count, 1, MPI_LONG_LONG, MPI_SUM, 0, MPI_COMM_WORLD);
    MPI_Reduce(&num_iterations_per_process, &total_points, 1, MPI_LONG_LONG, MPI_SUM, 0, MPI_COMM_WORLD);

    if (world_rank == 0) {
        double pi_estimate = 4.0 * (double)global_in_circle_count / total_points;
        printf("Estimated Pi: %.10f\n", pi_estimate);

        // Write to result file
        FILE* resultFile = fopen(argv[1], "w");
        if (resultFile == NULL) {
            printf("Could not open result file %s\n", argv[1]);
            // Not aborting as it's a secondary output
        } else {
            fprintf(resultFile, "%.10f\n", pi_estimate);
            fclose(resultFile);
        }

        // Write to time file
        FILE* timeFile = fopen(argv[2], "w");
        if (timeFile == NULL) {
            printf("Could not open time file %s\n", argv[2]);
        } else {
            fprintf(timeFile, "%.6f\n", elapsed_time);
            fclose(timeFile);
        }
    }


    MPI_Finalize();
    return 0;
}
