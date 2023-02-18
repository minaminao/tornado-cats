FROM rust:1.65.0 as rust

# Circom 2
RUN git clone --depth 1 https://github.com/iden3/circom.git
WORKDIR /circom
RUN cargo build --release
RUN cargo install --path circom

FROM node:18.12.1 as node

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y
RUN apt-get install -y \
    curl \
    wget \
    git \
    make \
    build-essential \ 
    python3 \
    python-is-python3 \
    python3-pip \
    vim \
    file \
    sudo \
    tmux

# User Setting
RUN useradd -m cat && echo "cat:cat" | chpasswd && adduser cat sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER cat
WORKDIR /home/cat

# Foundry
ENV SHELL /bin/bash
RUN curl -L https://foundry.paradigm.xyz | bash
RUN $HOME/.foundry/bin/foundryup

# Rust
COPY --from=rust /usr/local/cargo /home/cat/.cargo
ENV PATH $PATH:/home/cat/.cargo/bin

# Node.js
COPY --from=node /usr/local/bin /usr/local/bin
COPY --from=node /usr/local/lib/node_modules/npm /usr/local/lib/node_modules/npm
COPY --from=node /opt/yarn* /opt/yarn
RUN sudo ln -fs /opt/yarn/bin/yarn /usr/local/bin/yarn && \
    sudo ln -fs /opt/yarn/bin/yarnpkg /usr/local/bin/yarnpkg
RUN sudo npm install -g npm@9.2.0

# snarkjs
RUN sudo npm install -g snarkjs

# tornado-core
RUN git clone --depth 1 https://github.com/tornadocash/tornado-core.git
