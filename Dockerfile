FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install moreutils
RUN apt-get install --no-install-recommends -y curl ca-certificates software-properties-common debconf-utils git pkg-config zip g++ zlib1g-dev unzip python patch shellcheck ruby
RUN "echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections"
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update
RUN apt-get install --no-install-recommends -y oracle-java8-installer
ADD bazel_loader
RUN cd bazel_loader && ./bazel version
RUN rm -rf /var/lib/apt/lists/*
