#!/usr/bin/env bash
# This script installs AFL++ and Fuzztastic in the /workspaces/fuzzer directory.
# Assuming that the dependencies are already installed in the Docker image.
# Run this INSIDE the container

set -e

cd /workspaces/fuzzer

if [ ! -d AFLplusplus ]; then
  git clone https://github.com/AFLplusplus/AFLplusplus.git
  cd AFLplusplus
  git checkout tags/v4.34c
  bear --output /workspaces/fuzzer/afl_compile_commands.json -- make -j$(nproc)
  cd ..
fi

if [ ! -d fuzztastic ]; then
  git clone https://github.com/tum-i4/fuzztastic.git
  cd fuzztastic
  git checkout tags/v2.0.0
  poetry install --without dev
  cd instrumentation && mkdir -p build && cd build && \
    cmake .. -DCMAKE_EXPORT_COMPILE_COMMANDS=ON && \
    sudo make -j$(nproc) install && \
    cp compile_commands.json /workspaces/fuzzer/ft_compile_commands.json
  cd ../../
fi

cd /workspaces/fuzzer

# Merge AFL++ and Fuzztastic compile_commands.json files
sudo apt-get install -y jq
jq -s 'add' afl_compile_commands.json ft_compile_commands.json > compile_commands.json
rm afl_compile_commands.json ft_compile_commands.json

# Link FT Pass
sudo mkdir -p /fuzztastic/instrumentation/build && \
    sudo ln -s /workspaces/fuzzer/fuzztastic/instrumentation/build/libfuzztasticpass.so /fuzztastic/instrumentation/build/libfuzztasticpass.so

# Setup environment variables (optional)
export AFLPLUS_DIR="/workspaces/fuzzer/AFLplusplus"
export FT_DIR="/workspaces/fuzzer/fuzztastic"
export FT_RUNTIME_LIB_DIR="${FT_DIR}/instrumentation/build/runtime-lib"
echo "AFLPLUS_DIR=${AFLPLUS_DIR}"
echo "FT_DIR=${FT_DIR}"
echo "FT_RUNTIME_LIB_DIR=${FT_RUNTIME_LIB_DIR}"
