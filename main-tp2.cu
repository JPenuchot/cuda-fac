#include <iostream>
#include <vector>

#include "matadd.cuh"

using namespace std;

int N = 2048;

int main()
{
  vector<int> A(N * N);
  vector<int> B(N * N);

  matadd(A.data(), A.data(), B.data(), N);

  return 0;
}
