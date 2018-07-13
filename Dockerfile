FROM ubuntu:16.04

WORKDIR /root

# install protoc
RUN apt-get update \
    && apt-get install -y curl unzip
RUN curl -OL https://github.com/google/protobuf/releases/download/v3.4.0/protoc-3.4.0-linux-x86_64.zip \
    && unzip protoc-3.4.0-linux-x86_64.zip -d protoc3 \
    && mv protoc3/bin/* /usr/local/bin/ \
    && mv protoc3/include/* /usr/local/include/ \
    && chown root /usr/local/bin/protoc \
    && chown -R root /usr/local/include/google

# install cuda9.0
RUN apt-get install -y wget \
    && wget https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda-repo-ubuntu1604-9-0-local_9.0.176-1_amd64-deb \
    && dpkg -i cuda-repo-ubuntu1604-9-0-local_9.0.176-1_amd64-deb
#RUN apt-key add /var/cuda-repo-9-0-local/7fa2af80.pub \
#&& apt-get update \
#&& apt-get install -y cuda 

# install tensorflow
RUN apt-get install -y python3 python3-pip \ 
    && pip3 install tensorflow-gpu==1.5

# Tensorflow Object Detection API
RUN pip3 install pillow \
    && pip3 install lxml \
    && pip3 install jupyter \
    && pip3 install matplotlib
RUN apt-get install -y git
RUN git clone https://github.com/tensorflow/models \
    && cd models/research
RUN cd /root/models/research \
    && export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim \
    && export LD_LIBRARY_PATH=/usr/local/cuda-9.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}:/usr/lib/nvidia-396/ \
    # && protoc object_detection/protos/*.proto --python_out=. #會噴錯，改下面那行
    && protoc -I=./ --python_out=./ object_detection/protos/*.proto

# Git clone Head-Counter
RUN apt-get install -y git \
    && cd /root \
    && git clone https://github.com/NCNU-OpenSource/Head-Counter.git
RUN cp Head-Counter/main.py models/research/object_detection/ \
    && cp Head-Counter/visualization_utils.py models/research/object_detection/utils

RUN apt-key add /var/cuda-repo-9-0-local/7fa2af80.pub \
    && apt-get update \
    && apt-get install -y cuda 