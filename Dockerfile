FROM rocm/dev-ubuntu-18.04:latest
MAINTAINER Fabian Lober <f.lober@nouplink.de>

ENV HCC_AMDGPU_TARGET=gfx906
ENV PATH="${PATH}:/opt/rocm/bin" HIP_PLATFORM="hcc"
ENV PATH="/root/anaconda3/bin:${PATH}" KMTHINLTO="1"

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl && \
  curl -sL http://repo.radeon.com/rocm/apt/debian/rocm.gpg.key | apt-key add - && \
  sh -c 'echo deb [arch=amd64] http://repo.radeon.com/rocm/apt/debian/ xenial main > /etc/apt/sources.list.d/rocm.list' && \
  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  sudo \
  libelf1 \
  build-essential \
  bzip2 \
  ca-certificates \
  cmake \
  ssh \
  apt-utils \
  pkg-config \
  g++-multilib \
  gdb \
  git \
  less \
  libunwind-dev \
  libfftw3-dev \
  libelf-dev \
  libncurses5-dev \
  libomp-dev \
  libpthread-stubs0-dev \
  make \
  miopen-hip \
  python-dev \
  python-future \
  python-yaml \
  python-pip \
  vim \
  libssl-dev \
  libboost-dev \
  libboost-system-dev \
  libboost-filesystem-dev \
  libopenblas-dev \
  rpm \
  wget \
  net-tools \
  iputils-ping \
  libnuma-dev \
  rocm-dev \
  rocrand \
  rocblas \
  rocfft \
  hipcub \
  ninja-build \
  rocm-dkms rocm-libs miopen-hip rccl \
  rocthrust \
  hipsparse && \
  curl -sL https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
  sh -c 'echo deb [arch=amd64] http://apt.llvm.org/xenial/ llvm-toolchain-xenial-7 main > /etc/apt/sources.list.d/llvm7.list' && \
  sh -c 'echo deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial-7 main >> /etc/apt/sources.list.d/llvm7.list' && \
  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  clang-7 && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# fix capitalization in some cmake files...
RUN sed -i 's/find_dependency(hip)/find_dependency(HIP)/g' /opt/rocm/rocsparse/lib/cmake/rocsparse/rocsparse-config.cmake
RUN sed -i 's/find_dependency(hip)/find_dependency(HIP)/g' /opt/rocm/rocfft/lib/cmake/rocfft/rocfft-config.cmake
RUN sed -i 's/find_dependency(hip)/find_dependency(HIP)/g' /opt/rocm/miopen/lib/cmake/miopen/miopen-config.cmake
RUN sed -i 's/find_dependency(hip)/find_dependency(HIP)/g' /opt/rocm/rocblas/lib/cmake/rocblas/rocblas-config.cmake

RUN sed --in-place=.rocm-backup 's|^\(PATH=.*\)"$|\1:/opt/rocm/bin"|' /etc/environment

WORKDIR /root
COPY util/pytorch_build.sh .
COPY util/pytorch_install.sh .
RUN chmod +x pytorch_build.sh pytorch_install.sh

COPY util/Anaconda3-2020.02-Linux-x86_64.sh .
RUN  bash Anaconda3-2020.02-Linux-x86_64.sh -b &&  rm Anaconda3-2020.02-Linux-x86_64.sh

RUN \
  pip install setuptools

RUN \
  pip install pyyaml

RUN \
  pip install numpy scipy

RUN \
  pip install typing

RUN \
  pip install enum34

RUN \
  pip install hypothesis

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/clang-7 50
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/clang++-7 50

# Run pytorch build on start
CMD ["/bin/bash", "/root/pytorch_build.sh"]
