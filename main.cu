#include <iostream>
#include <vector>
#include <algorithm>
#include <numeric>

#include "evennoteven.cuh"
#include "extract.cuh"

using namespace std;

const std::size_t vecsize = 32;

int main()
{
  vector<int> vec(vecsize);
  vector<int> res(vecsize);

  for(int i = 0; i < vec.size(); i++) vec[i] = i;

  evennoteven(vec.data(), res.data(), res.size());

  for(int i = 0; i < vec.size(); i++) cout << vec[i] << '\n';

  cout << "\n---\n";

  for(int i = 0; i < res.size(); i++) cout << res[i] << '\n';
}
