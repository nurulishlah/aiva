# build: docker build -t kengz/aiva .
# run: docker run -t -i --rm --name aiva-setup kengz/aiva /bin/bash

FROM ubuntu:14.04
MAINTAINER Wah Loon Keng <kengzwl@gmail.com>

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# General dependencies
RUN apt-get update && apt-get install -y git curl
RUN apt-get install -y git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev libatlas-dev libzmq3-dev libboost-all-dev libgflags-dev libgoogle-glog-dev liblmdb-dev protobuf-compiler libopenblas-dev libblas-dev liblapack-dev gfortran

# Nodejs
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs
# gulp for streaming build, forever for keep-alive
RUN npm i -g gulp forever ngrok istanbul

# Python
RUN apt-get install -y python python3-dev python3-pip python3-numpy python3-scipy python3-matplotlib
RUN pip3 install -U pip setuptools virtualenvwrapper
# spacy for NLP
RUN pip3 install -U spacy
RUN python3 -m spacy.en.download
# ML & TensorFlow
RUN pip3 install -U scikit-learn pandas
RUN pip3 install -U https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.8.0-cp34-cp34m-linux_x86_64.whl

# Ruby on Rails
RUN git clone git://github.com/sstephenson/rbenv.git /root/.rbenv
RUN git clone git://github.com/sstephenson/ruby-build.git /root/.rbenv/plugins/ruby-build
RUN /root/.rbenv/plugins/ruby-build/install.sh
ENV PATH /root/.rbenv/bin:/root/.rbenv/shims:$PATH
RUN echo 'eval "$(rbenv init -)"' >> ~/.bashrc
RUN rbenv install 2.3.0
RUN rbenv global 2.3.0
RUN echo "gem: --no-ri --no-rdoc" > /.gemrc
RUN echo $(rbenv global)
RUN echo $(ruby -v)
RUN gem update --system
RUN gem install bundler rails
RUN rbenv rehash