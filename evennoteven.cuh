#pragma once

__global__ void evennoteven_kernel(int* dIn, int* dOut)
{
  if(dIn[threadIdx.x] % 2 == 0) dOut[threadIdx.x] = dIn[threadIdx.x] * 2;
}

void evennoteven(int* dIn, int* dOut, std::size_t numelm)
{
  const std::size_t tabsize = numelm * sizeof(int);

  //  Memory allocation
  cudaMalloc(&dIn, tabsize);
  cudaMalloc(&dOut, tabsize);

  evennoteven_kernel <<< 1, numelm >>> (dIn, dOut);
}

