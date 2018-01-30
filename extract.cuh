#pragma once

__device__ void extract_kernel(int* dIn, int* dOut)
{
  auto id = threadIdx.x;
  dOut[id] = dIn[id * 2];
}

void extract(int* hIn, int* hOut, std::size_t inNumelm)
{
  const auto outNumelm = insize / 2;

  int* dIn, dOut;
  
  const auto inTabsize = inNumelm * sizeof(int);
  const auto outTabsize = outNumelm * sizeof(int);

  //  Memory allocation
  cudaMalloc(&((void*)dIn), inTabsize);
  cudaMalloc(&((void*)dOut), outTabsize);

  //  Copy from host to device
  cudaMemcpy(dIn, hIn, inTabsize, cudaMemcpyHostToDevice);

  //  Execute kernel
  extract_kernel <<<1, outNumelm>>> (dIn, dOut);
 
 // Copy from device to host
  cudaMemcpy(hOut, dOut, outTabsize, cudaMemcpyDeviceToHost);
}