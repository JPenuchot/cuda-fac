#pragma once

#include <iostream>

__global__ void evennoteven_kernel(int* dIn)
{
  const int bid = blockIdx.x;
  const int bdim = blockDim.x;
  const int tid = threadIdx.x;

  const int id = bid * bdim + tid;

  dIn[id * 2] *= 2;
}

void evennoteven(int* hIn, int* hOut, std::size_t numelm)
{
  const std::size_t tabsize = numelm * sizeof(int);

  int maxThreads;
  cudaDeviceGetAttribute(&maxThreads, cudaDevAttrMaxThreadsPerBlock, 0);

  std::cout << "Max " << maxThreads << " threads.\n\n";

  //  Memory allocation

  int* dIn;

  if(cudaMalloc(&dIn, tabsize))
    std::cout << "Error at device memory allocation.\n";

  if(cudaMemcpy(dIn, hIn, tabsize, cudaMemcpyHostToDevice))
    std::cout << "Error at copy from host to device.\n";

  int nbBlocks = (numelm / 2 / maxThreads) + 1;
  int nbThreads = ((numelm / 2) - 1 % maxThreads) + 1;

  std::cout << nbBlocks << " * " << nbThreads << '\n';

  evennoteven_kernel <<< nbBlocks, nbThreads >>> (dIn);

  if(cudaMemcpy(hOut, dIn, tabsize, cudaMemcpyDeviceToHost))
    std::cout << "Error at copy from device to host.\n";
}
