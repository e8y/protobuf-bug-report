FROM ubuntu:jammy

# Install dependencies from apt
RUN \
    apt-get update && apt-get -y upgrade && apt-get install -y \
    build-essential \
    lsb-release \
    software-properties-common \
    gnupg \
    git \
    cmake \
    ninja-build \
    wget

# Install LLVM toolchain
ENV LLVM_VERSION=18
RUN \
    wget https://apt.llvm.org/llvm.sh && \
    chmod +x ./llvm.sh && \
    ./llvm.sh $LLVM_VERSION all

# Install protobuf
RUN \
    git clone -b v27.2 https://github.com/protocolbuffers/protobuf.git && \
    cd protobuf && \
    git submodule update --init --recursive && \
    cmake -DCMAKE_INSTALL_PREFIX:PATH=/opt/protobuf -Dprotobuf_BUILD_TESTS=OFF . && \
    make -j 4 install

