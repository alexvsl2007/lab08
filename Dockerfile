FROM ubuntu:22.04 as builder

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    cmake \
    make \
    g++ \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src

RUN git clone --recursive https://github.com/lab08.git app

WORKDIR /usr/src/app
RUN mkdir build && cd build && \
    cmake .. && \
    cmake --build . --config Release --parallel $(nproc) && \
    ctest --output-on-failure && \
    cpack -G TGZ

FROM alpine:latest
COPY --from=builder /usr/src/app/build/*.tar.gz /output/
COPY --from=builder /usr/src/app/build/Testing/Temporary/LastTest.log /output/test_results.log
WORKDIR /output
CMD ["sh", "-c", "ls -lh && cat test_results.log"]
