# Dev container base for AFL++ + your extension
# Ubuntu 24.04 (Noble) + LLVM 20 + GCC 11

FROM ubuntu:24.04
LABEL maintainer="AFL++ team & Howard’s devcontainer"

ARG DEBIAN_FRONTEND=noninteractive
ARG LLVM_VERSION=20
ARG GCC_VERSION=11

# --- Environment matching AFL++ upstream ---
ENV NO_CORESIGHT=1 \
    NO_NYX=1 \
    NO_ARCH_OPT=1 \
    IS_DOCKER=1 \
    LLVM_VERSION=${LLVM_VERSION} \
    GCC_VERSION=${GCC_VERSION} \
    WORKDIR="/workspaces/fuzzer" \
    FT_DIR=/workspaces/fuzzer/fuzztastic \
    AFLPLUS_DIR=/workspaces/fuzzer/AFLplusplus

# --- Core system setup ---
RUN apt-get update && apt-get full-upgrade -y && \
    apt-get install -y --no-install-recommends \
    ca-certificates apt-transport-https gnupg wget curl xz-utils bzip2 xxd \
    software-properties-common && \
    rm -rf /var/lib/apt/lists/*

# --- Add apt.llvm.org repo (LLVM 20 for Noble) ---
RUN mkdir -p /etc/apt/keyrings && \
    wget -qO /etc/apt/keyrings/llvm-snapshot.gpg.key https://apt.llvm.org/llvm-snapshot.gpg.key && \
    echo "deb [signed-by=/etc/apt/keyrings/llvm-snapshot.gpg.key] \
    http://apt.llvm.org/noble/ llvm-toolchain-noble-${LLVM_VERSION} main" \
    > /etc/apt/sources.list.d/llvm.list

# --- Install dependencies (LLVM 20 toolchain + utilities; NO libc++) ---
# --- Install Fuzztastic dependencies ---
RUN apt-get update && apt-get install -y --no-install-recommends \
    make cmake automake meson ninja-build pkg-config bison flex git jq \
    nano jupp joe bash-completion less vim htop btop psmisc tmux python3 python3-dev python3-pip \
    python-is-python3 python3-venv libtool libtool-bin libglib2.0-dev \
    libpixman-1-dev libdwarf-dev libelf-dev gnuplot-nox bc lcov gdb bear ccache \
    gcc-${GCC_VERSION} g++-${GCC_VERSION} gcc-${GCC_VERSION}-plugin-dev \
    clang-${LLVM_VERSION} clang-tools-${LLVM_VERSION} \
    lld-${LLVM_VERSION} lldb-${LLVM_VERSION} llvm-${LLVM_VERSION} \
    llvm-${LLVM_VERSION}-dev llvm-${LLVM_VERSION}-runtime llvm-${LLVM_VERSION}-tools \
    libclang1-${LLVM_VERSION} libclang-${LLVM_VERSION}-dev \
    libclang-cpp${LLVM_VERSION} libclang-cpp${LLVM_VERSION}-dev \
    libomp-${LLVM_VERSION}-dev libomp5-${LLVM_VERSION} \
    golang-go libffi-dev libssl-dev pkg-config rapidjson-dev unzip libxxhash-dev \
    $([ "$(dpkg --print-architecture)" = "amd64" ] && echo gcc-${GCC_VERSION}-multilib gcc-multilib) \
    $([ "$(dpkg --print-architecture)" = "arm64" ] && echo libcapstone-dev) && \
    rm -rf /var/lib/apt/lists/*

# --- Compiler alternatives ---
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-${GCC_VERSION} 0 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-${GCC_VERSION} 0 && \
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-${LLVM_VERSION} 0 && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-${LLVM_VERSION} 0 && \
    update-alternatives --install /usr/bin/llvm-link llvm-link /usr/bin/llvm-link-${LLVM_VERSION} 0 && \
    update-alternatives --install /usr/bin/opt opt /usr/bin/opt-${LLVM_VERSION} 0 && \
    update-alternatives --install /usr/bin/llvm-dis llvm-dis /usr/bin/llvm-dis-${LLVM_VERSION} 0

# --- Rust (for unicornafl) ---
RUN wget -qO- https://sh.rustup.rs | CARGO_HOME=/etc/cargo sh -s -- -y -q --no-modify-path
ENV PATH="${PATH}:/etc/cargo/bin"

# --- Install Go-based gllvm (for bitcode extraction) ---
RUN go install github.com/SRI-CSL/gllvm/cmd/...@latest
ENV GOPATH="/opt/go"
ENV PATH="${GOPATH}/bin:${PATH}"

# --- Install DynamoRIO for dynamic instrumentation ---
# Using stable release 11.3.0 (10.0.0 has critical bugs causing SIGFPE crashes)
# See: https://github.com/DynamoRIO/dynamorio/issues/5437
ARG DYNAMORIO_VERSION=11.3.0
RUN cd /tmp && \
    wget -q https://github.com/DynamoRIO/dynamorio/releases/download/release_${DYNAMORIO_VERSION}-1/DynamoRIO-Linux-${DYNAMORIO_VERSION}.tar.gz && \
    tar xzf DynamoRIO-Linux-${DYNAMORIO_VERSION}.tar.gz && \
    mv DynamoRIO-Linux-${DYNAMORIO_VERSION}-1 /opt/dynamorio && \
    rm DynamoRIO-Linux-${DYNAMORIO_VERSION}.tar.gz
ENV DYNAMORIO_HOME="/opt/dynamorio"
ENV PATH="${DYNAMORIO_HOME}/bin64:${PATH}"

# --- Install Poetry for Fuzztastic CLI ---
ENV POETRY_HOME="/opt/poetry"
ENV POETRY_NO_INTERACTION=1
RUN curl -sSL https://install.python-poetry.org | python3 - && \
    chmod +x ${POETRY_HOME}/bin/poetry
ENV PATH="${POETRY_HOME}/bin:${PATH}"

# --- Environment variables for Fuzztastic runtime ---
ENV LLVM_DIR="/usr/lib/llvm-${LLVM_VERSION}/lib/cmake/llvm"
ENV FT_RUNTIME_LIB_DIR="${FT_DIR}/instrumentation/build/runtime-lib"
ENV LD_LIBRARY_PATH="${FT_RUNTIME_LIB_DIR}:$LD_LIBRARY_PATH"
ENV LIBRARY_PATH="${FT_RUNTIME_LIB_DIR}:$LIBRARY_PATH"

# --- AFL-friendly environment vars ---
ENV LLVM_CONFIG=llvm-config-${LLVM_VERSION} \
    AFL_SKIP_CPUFREQ=1 \
    AFL_TRY_AFFINITY=1 \
    AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1

# --- Install afl-cov ---
RUN git clone --depth=1 https://github.com/vanhauser-thc/afl-cov /tmp/afl-cov && \
    make -C /tmp/afl-cov install && rm -rf /tmp/afl-cov

# --- Non-root user (VS Code convention) ---
ARG USERNAME=vscode
ARG USER_UID=1001
ARG USER_GID=${USER_UID}
RUN if ! getent group ${USER_GID} >/dev/null; then groupadd --gid ${USER_GID} ${USERNAME}; fi && \
    if ! id -u ${USERNAME} >/dev/null 2>&1; then \
    useradd -s /bin/bash --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME}; \
    fi && \
    apt-get update && apt-get install -y sudo && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-${USERNAME} && \
    chmod 0440 /etc/sudoers.d/90-${USERNAME}

USER ${USERNAME}
WORKDIR /workspaces/fuzzer

# --- Quality-of-life tweaks ---
RUN python3 -m pip install --no-cache-dir --upgrade pip --break-system-packages && \
    echo "set encoding=utf-8" > ~/.vimrc && \
    echo ". /etc/bash_completion" >> ~/.bashrc

RUN echo "AFLPLUS_DIR=${AFLPLUS_DIR}" && \
    echo "FT_DIR=${FT_DIR}"

CMD ["bash"]
