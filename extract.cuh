#pragma once

template<typename T>
__device__ void extract_kernel(T* dIn, T* dOut)
{
  auto id = threadIdx.x;
  dOut[id] = dIn[id * 2];
}

template<typename T>
void extract(T* hIn, T* hOut, std::size_t inNumelm)
{
  const auto outNumelm = insize / 2;

  T* dIn, dOut;
  
  const auto inTabsize = inNumelm * sizeof(T);
  const auto outTabsize = outNumelm * sizeof(T);

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