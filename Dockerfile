FROM ubuntu:14.04

ADD bazel_loader bazel_loader
RUN apt-get update && \
      apt-get install --no-install-recommends -y curl ca-certificates software-properties-common debconf-utils git pkg-config zip g++ zlib1g-dev unzip python patch shellcheck ruby moreutils && \
      cd bazel_loader && \
      ./bazel version && \
      gem install bundler && \
      rm -rf /var/lib/apt/lists/*
