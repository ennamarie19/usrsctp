# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake clang git

## Add source code to the build stage.
RUN git clone https://github.com/ennamarie19/usrsctp.git
WORKDIR /usrsctp
RUN git checkout mayhem

## TODO: ADD YOUR BUILD INSTRUCTIONS HERE.
RUN ./boostrap && ./configure && make
RUN mkdir -p build
WORKDIR build
RUN CC=clang CXX=clang++ cmake .. -D sctp_build_fuzzer=1
RUN cmake --build .

# Package Stage
FROM --platform=linux/amd64 ubuntu:20.04

## TODO: Change <Path in Builder Stage>
COPY --from=builder /usrsctp/build/fuzzer/fuzzer_listen /

