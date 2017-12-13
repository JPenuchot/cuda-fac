#pragma once

__global__ void extract_kernel(int* dIn, int* dOut)
{
  int id = threadIdx.x;
  dOut[id] = dIn[id * 2];
}

void extract(int* hIn, int* hOut, std::size_t inNumelm)
{
  const std::size_t outNumelm = inNumelm / 2;

  int* dIn;
  int* dOut;
  
  const std::size_t inTabsize = inNumelm * sizeof(int);
  const std::size_t outTabsize = outNumelm * sizeof(int);

  //  Memory allocation
  cudaMalloc(&dIn, inTabsize);
  cudaMalloc(&dOut, outTabsize);

  std::cout << "Errno : " << cudaGetLastError() << "\n";

  //  Copy from host to device
  cudaMemcpy(dIn, hIn, inTabsize, cudaMemcpyHostToDevice);

  //  Execute kernel
  extract_kernel <<<1, outNumelm>>> (dIn, dOut);
 
 // Copy from device to host
  cudaMemcpy(hOut, dOut, outTabsize, cudaMemcpyDeviceToHost);
}
