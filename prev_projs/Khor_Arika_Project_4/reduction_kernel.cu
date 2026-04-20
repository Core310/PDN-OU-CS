__global__
void reduction_kernel(unsigned int* hash_array, unsigned int* nonce_array, unsigned int* out_hash, unsigned int* out_nonce, unsigned int array_size, unsigned int max_val){
    extern __shared__ unsigned int s[];
    unsigned int* s_hash = s;
    unsigned int* s_nonce = (unsigned int*)&s_hash[blockDim.x];

    unsigned int threadid = threadIdx.x;

    unsigned int i = blockIdx.x * (blockDim.x * 2) + threadIdx.x;

    unsigned int local_min_hash = max_val;
    unsigned int local_min_nonce = max_val;

    if (i < array_size){ // 1st elem
        local_min_hash = hash_array[i];
        local_min_nonce = nonce_array[i];
    }
    
    if (i + blockDim.x < array_size){ // 2nd elem
        if (hash_array[i + blockDim.x] < local_min_hash){
            local_min_hash = hash_array[i + blockDim.x];
            local_min_nonce = nonce_array[i + blockDim.x];
        }
    }

    s_hash[threadid] = local_min_hash;  
    s_nonce[threadid] = local_min_nonce;
    __syncthreads();
    
    for(unsigned int i = blockDim.x / 2; i>0; i>>=1){
        if (threadid < i && s_hash[threadid + i] < s_hash[threadid]){
            s_hash[threadid] = s_hash[threadid + i];
            s_nonce[threadid] = s_nonce[threadid + i];
        }
        __syncthreads();
    }

    if (threadid == 0){
        out_hash[blockIdx.x] = s_hash[0];
        out_nonce[blockIdx.x] = s_nonce[0];
    }
}