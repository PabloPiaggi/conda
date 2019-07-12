#!/bin/bash
set -e

opt=""

if [[ $(uname) == Darwin ]]; then
  opt="-DCMAKE_OSX_SYSROOT=${CONDA_BUILD_SYSROOT} -DCMAKE_OSX_DEPLOYMENT_TARGET=10.9 -DGMX_BLAS_USER=$PREFIX/lib/libblas.dylib -DGMX_LAPACK_USER=$PREFIX/lib/liblapack.dylib"
else
  opt="-DGMX_BLAS_USER=$PREFIX/lib/libblas.so -DGMX_LAPACK_USER=$PREFIX/lib/liblapack.so"
fi

echo "CHECK ME $opt"

plumed-patch -p --runtime -e gromacs-2018.6
mkdir build
cd build
cmake .. \
  $opt \
  -DGMX_DEFAULT_SUFFIX=ON \
  -DGMX_MPI=OFF \
  -DGMX_GPU=OFF \
  -DGMX_SIMD=SSE2 \
  -DCMAKE_PREFIX_PATH=$PREFIX \
  -DCMAKE_INSTALL_PREFIX=$PREFIX
make VERBOSE=1 -j $CPU_COUNT
make install
