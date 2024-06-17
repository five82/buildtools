# buildtools

# Use debian:stable for our image
FROM --platform=$BUILDPLATFORM docker.io/debian:stable-slim

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
ARG TARGETPLATFORM
RUN case "$TARGETPLATFORM" in \
        "linux/amd64") \
            RUST_TARGET="x86_64-unknown-linux-gnu";; \
        "linux/arm64") \
            RUST_TARGET="aarch64-unknown-linux-gnu";; \
        *) echo "Unsupported platform: $TARGETPLATFORM" && exit 1 ;; \
    esac && \
    /root/.cargo/bin/rustup target add $RUST_TARGET && \
    /root/.cargo/bin/cargo install cargo-c \
    --jobs $(nproc) \
    --target $RUST_TARGET