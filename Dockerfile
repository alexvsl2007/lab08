FROM ubuntu:22.04 as builder

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    cmake \
    make \
    g++ \
    git \
    libgtest-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY . .

RUN apt-get install -y libgtest-dev && \
    cd /usr/src/googletest && \
    cmake . && make && make install

RUN mkdir build && cd build && \
    cmake .. && \
    cmake --build . --config Release --parallel $(nproc) && \
    ctest --output-on-failure && \
    cpack -G TGZ
