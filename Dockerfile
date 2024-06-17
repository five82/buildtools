# buildtools

# Use debian:stable for our image
FROM docker.io/debian:stable-slim

# Set the working directory to /build
WORKDIR /build

# Add /usr/local/lib to the library path
ENV LD_LIBRARY_PATH=/lib:/usr/lib:/usr/local/lib

# Update and install packages
RUN apt-get update && \
    apt-get install -y \
        autoconf \
        automake \
        build-essential \
        cmake \
        git-core \
        meson \
        nasm \
        ninja-build \
        pkg-config \
        texinfo \
        curl \
        yasm \
        libssl-dev \
        clang \
        zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Install cargo-c
RUN /root/.cargo/bin/cargo install cargo-c --jobs $(nproc)