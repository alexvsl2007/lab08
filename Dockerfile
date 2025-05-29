FROM alpine:latest as builder

RUN apk add --no-cache \
    cmake \
    make \
    g++ \
    git \
    linux-headers


COPY . /usr/src/app
WORKDIR /usr/src/app/build

RUN cmake .. && \
    cmake --build . --config Release && \
    cpack -G TGZ

FROM alpine:latest
COPY --from=builder /usr/src/app/build/*.tar.gz /output/
COPY --from=builder /usr/src/app/build/Testing/Temporary/LastTest.log /output/test_results.log

WORKDIR /output

CMD ["sh", "-c", "echo 'Build artifacts:' && ls -lh && echo '\nTest results:' && cat test_results.log"]
