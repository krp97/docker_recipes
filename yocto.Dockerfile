FROM ubuntu:16.04

RUN apt-get -qq update && apt-get -qq install -y --no-install-recommends \
    build-essential \
    chrpath \
    cpio \
    curl \
    diffstat \
    file \
    g++-multilib \
    gawk \
    gcc-multilib \
    git \
    locales \
    python \
    texinfo \
    rsync \
    wget \
    zlib1g-dev \
    ca-certificates \
    software-properties-common 

ARG PYTHON_VERSION=3.9
ARG PYTHON_VERSION_MAJOR=3
 
RUN add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update && apt-get install -y --no-install-recommends \
    python$PYTHON_VERSION \
    python$PYTHON_VERSION_MAJOR-pip 

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -s https://storage.googleapis.com/git-repo-downloads/repo >> /usr/bin/repo
RUN chmod a+rx /usr/bin/repo

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
  && dpkg-reconfigure --frontend noninteractive locales \
  && locale-gen en_US.UTF-8 \
  && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8
