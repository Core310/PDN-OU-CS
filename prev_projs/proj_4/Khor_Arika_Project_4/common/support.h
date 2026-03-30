/******************************************************************************
 *cr
 *cr            (C) Copyright 2010 The Board of Trustees of the
 *cr                        University of Illinois
 *cr                         All Rights Reserved
 *cr
 ******************************************************************************/

#ifndef __FILEH__
    #define __FILEH__


    #include <sys/time.h>
    typedef struct {
        struct timeval startTime;
        struct timeval endTime;
    } Timer;

#define gpuErrchk(ans) { gpuAssert((ans), __FILE__, __LINE__); }
inline void gpuAssert(cudaError_t code, const char *file, int line, bool abort=true)
{
   if (code != cudaSuccess) 
   {
      fprintf(stderr,"GPUassert: %s %s %d\n", cudaGetErrorString(code), file, line);
      if (abort) exit(code);
   }
}

__global__ void generate_hash_kernel(unsigned int* hash_array, unsigned int* nonce_array, unsigned int array_size, unsigned int* transactions, unsigned int n_transactions, unsigned int mod);

    #ifdef __cplusplus
    extern "C" {
        #endif
        void  initVector(unsigned int** vec_h, unsigned int size, unsigned int num_bins);
        void  verify(float* A, float* B, float* C, int n);
        void  startTime(Timer* timer);
        void  stopTime(Timer* timer);
        float elapsedTime(Timer timer);
        #ifdef __cplusplus
    }
    #endif

    #define FATAL(msg, ...) \
        do { \
            fprintf(stderr, "[%s:%d] " msg "\n", __FILE__, __LINE__, ##__VA_ARGS__); \
            exit(-1); \
        } while(0)

    #if __BYTE_ORDER != __LITTLE_ENDIAN
    #error "File I/O is not implemented for this system: wrong endianness."
    #endif

#endif
