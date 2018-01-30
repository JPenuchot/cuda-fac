#pragma once

__global__ void extract_kernel(int* dIn, int* dOut)
{
  const int bid = blockIdx.x;
  const int bdim = blockDim.x;
  const int tid = threadIdx.x;

  const int id = bid * bdim + tid;

  dOut[id] = dIn[id * 2];
}

void extract(int* hIn, int* hOut, std::size_t inNumelm)
{
  const std::size_t outNumelm = inNumelm / 2;

  int* dIn;
  int* dOut;
  
  const std::size_t inTabsize = inNumelm * sizeof(int);
  const std::size_t outTabsize = outNumelm * sizeof(int);

  int maxThreads;  
  cudaDeviceGetAttribute(&maxThreads, cudaDevAttrMaxThreadsPerBlock, 0);

  //  Memory allocation with a bit of error management for q. 5
  if(cudaMalloc(&dIn, inTabsize))
    { std::cout << "errno : " << cudaGetLastError() << '\n'; return; }

  if(cudaMalloc(&dOut, outTabsize))
    { std::cout << "errno : " << cudaGetLastError() << '\n'; return; }

  //  Copy from host to device
  cudaMemcpy(dIn, hIn, inTabsize, cudaMemcpyHostToDevice);

  //  Execute kernel

  int nbBlocks = (outNumelm / maxThreads) + 1;
  int nbThreads = ((outNumelm - 1) % maxThreads) + 1;

  std::cout << nbBlocks << " * " << nbThreads << '\n';

  extract_kernel <<< nbBlocks , nbThreads >>> (dIn, dOut);
 
 // Copy from device to host
  cudaMemcpy(hOut, dOut, outTabsize, cudaMemcpyDeviceToHost);
}

