FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install --no-install-recommends -y curl ca-certificates software-properties-common debconf-utils git pkg-config zip g++ zlib1g-dev unzip python patch shellcheck ruby moreutils
ADD bazel_loader bazel_loader
RUN cd bazel_loader && ./bazel version
RUN rm -rf /var/lib/apt/lists/*
