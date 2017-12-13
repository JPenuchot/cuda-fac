__global__ void matadd_kernel ( int* dest
                              , int* A, int* B
                              , std::size_t matWidth
                              , const int offsetX = 0, const int offsetY = 0
                              )
{
  const int posX = offsetX + (blockIdx.x * blockDim.x + threadIdx.x);
  const int posY = offsetY + (blockIdx.y * blockDim.y + threadIdx.y);

  const int id = posY * matWidth + posX;

  dest[id] = A[id] + B[id];
}

void matadd(int* hDest, int* hA, int* hB, std::size_t n)
{
  int maxThreads;
  cudaDeviceGetAttribute(&maxThreads, cudaDevAttrMaxThreadsPerBlock, 0);

  std::cout << "Max " << maxThreads << " threads.\n\n";

  int threadDim = sqrt(maxThreads);
  
  int matsize = n * n * sizeof(int);

  int* dA;
  int* dB;
  int* dDest;

  cudaMalloc(&dA, matsize);
  cudaMalloc(&dB, matsize);
  cudaMalloc(&dDest, matsize);

  cudaMemcpy(dA, hA, matsize, cudaMemcpyHostToDevice);
  cudaMemcpy(dB, hB, matsize, cudaMemcpyHostToDevice);

  dim3 blocks();
  dim3 threads();

  /* thinking.jpg */
  
  int numBlock = n / threadDim;

  //  Coeur
  matadd_kernel<<< dim3(numBlock,numBlock,1) , dim3(threadDim, threadDim, 1) >>>
  (dDest, dA, dB, n);
  
  //  Bas
  //matadd_kernel<<< dim3(,,1) , dim3(,,1) >>> (dDest, dA, dB, n);

  //  Droite
  //matadd_kernel<<< dim3(,,1) , dim3(,,1) >>> (dDest, dA, dB, n);

  //  Bas-droite
  //matadd_kernel<<< dim3(,,1) , dim3(,,1) >>> (dDest, dA, dB, n);

  cudaMemcpy(hDest, dDest, matsize, cudaMemcpyDeviceToHost);
}
