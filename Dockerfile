FROM centos:7

# alternatively `-j` to enable parallel compile
ARG MAKE_EXTRA_ARGS=

RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
  yum update -y && \
  yum groupinstall -y "Development Tools" && \
  yum install -y \
    wget \
    vim \
    libtool \
    zlib-devel \
    libevent-devel \
    openssl-devel

# install git 2.x
RUN yum remove -y git && \
  yum install -y https://centos7.iuscommunity.org/ius-release.rpm && \
  yum install -y git2u

# install gcc-7.5.0
RUN wget --progress=dot:mega https://github.com/gcc-mirror/gcc/archive/gcc-7_5_0-release.tar.gz && \
  tar -xzf gcc-7_5_0-release.tar.gz && \
  cd gcc-gcc-7_5_0-release && \
  ./contrib/download_prerequisites && \
  mkdir build && \
  cd build && \
  ../configure --prefix=/usr/local/gcc-7_5_0/ --disable-multilib --enable-languages=c,c++ --enable-checking=release --with-system-zlib && \
  make ${MAKE_EXTRA_ARGS} && \
  yum remove -y gcc && \ 
  make install-strip && \
  cd / && \
  rm -rf gcc-gcc-7_5_0-release gcc-7_5_0-release.tar.gz

# install cmake3
RUN wget --progress=dot:mega https://github.com/Kitware/CMake/releases/download/v3.14.1/cmake-3.14.1-Linux-x86_64.tar.gz && \
  tar -zxf cmake-3.14.1-Linux-x86_64.tar.gz && \
  mv cmake-3.14.1-Linux-x86_64 /usr/local/ && \
  rm -rf cmake-3.14.1-Linux-x86_64.tar.gz

# set env
ENV GCC_HOME=/usr/local/gcc-7_5_0
ENV CMAKE_HOME=/usr/local/cmake-3.14.1-Linux-x86_64
ENV PATH=${GCC_HOME}/bin/:${CMAKE_HOME}/bin/:$PATH
ENV CPATH=${GCC_HOME}/include/:$CPATH
ENV LIBRARY_PATH=${GCC_HOME}/lib64/:${GCC_HOME}/lib/:$LIBRARY_PATH
ENV LD_LIBRARY_PATH=${GCC_HOME}/lib64/:${GCC_HOME}/lib/:$LD_LIBRARY_PATH


# labels
LABEL maintainer="lihanjie@58.com"
