ARG TOP_IMAGE

FROM $TOP_IMAGE

ARG DEBIAN_FRONTEND=noninteractive
ARG USER="yarnapp"
ARG GROUP="hadoop"

COPY --from=registry.service.consul:4443/base:3.0.0-SNAPSHOT /srv/hops /srv/hops
COPY --from=registry.service.consul:4443/base:3.0.0-SNAPSHOT /usr/local/cuda-11.0 /usr/local/cuda-11.0
COPY --from=registry.service.consul:4443/base:3.0.0-SNAPSHOT /usr/local/bin /usr/local/bin

RUN groupadd -g 1234 $GROUP && \
    useradd -m --uid 1235  --gid 1234 $USER

RUN apt-get update && apt-get install -y \
    openjdk-8-jdk \
    net-tools curl \
    wget \
    build-essential \
    libcurl3-dev \
    git \
    libfreetype6-dev \
    libpng-dev \
    libzmq3-dev \
    pkg-config \
    python3-dev \
    python3-numpy \
    python3-pip \
    software-properties-common \
    swig \
    zip \
    zlib1g-dev \
    libstdc++6 \
    libkrb5-dev \
    libsasl2-dev \
    libpq-dev && \   
    curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/local/cuda/samples 



ENV CUDA_HOME=/usr/local/cuda-11.0
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
ENV HADOOP_HOME=/srv/hops/hadoop
ENV BASE_ENV=/srv/hops/anaconda/envs/theenv


ENV C_INCLUDE_PATH=${BASE_ENV}/include
ENV CPLUS_INCLUDE_PATH=${BASE_ENV}/include

ENV PATH=${PATH}:${CUDA_HOME}/bin:${CUDA_HOME}/nvvm/bin:${BASE_ENV}/bin:/srv/hops/anaconda/bin:${HADOOP_HOME}/bin:${JAVA_HOME}
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${CUDA_HOME}/targets/x86_64-linux/lib:${CUDA_HOME}/nvvm/lib64:${CUDA_HOME}/extras/CUPTI/lib64:${CUDA_HOME}/extras/Debugger/lib64:${JAVA_HOME}/jre/lib/amd64/server:${HADOOP_HOME}/lib/native:${BASE_ENV}/lib
ENV BASE_DIR /srv/hops

RUN chmod +x /usr/local/bin/*.sh
