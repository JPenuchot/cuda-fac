#pragma once

template<typename T>
__device__ void evennoteven_kernel(T* dIn, T* dOut)
{
  if(dIn[threadIdx.x] % 2 == 0) dOut[threadIdx.x] = dIn[threadIdx] * 2;
}

template<typename T>
void evennoteven(T* dIn, T* dOut, std::size_t numelm)
{
  const auto tabsize = numelm * sizeof(T);

  //  Memory allocation
  cudaMalloc(&((void*)dIn), numelm * sizeof(T));
  cudaMalloc(&((void*)dOut), numelm * sizeof(T));

  evennoteven_kernel <<< 1, numelm >>>;
}
