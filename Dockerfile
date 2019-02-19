FROM ubuntu:14.04

ADD bazel_loader bazel_loader
RUN apt-get update && \
      apt-get install --no-install-recommends -y curl ca-certificates software-properties-common debconf-utils git pkg-config zip g++ zlib1g-dev unzip python patch shellcheck moreutils make ruby && \
      cd bazel_loader && \
      ./bazel version

ENV PATH=/root/.rbenv/bin:/root/.rbenv/shims:$PATH
RUN apt-get install libssl-dev libreadline-dev
RUN curl -fsSL https://raw.githubusercontent.com/rbenv/rbenv-installer/108c12307621a0aa06f19799641848dde1987deb/bin/rbenv-installer | bash -x
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init -)"' >> /root/.bashrc
RUN rbenv install 2.4.3 && \
      rbenv global 2.4.3 && \
      gem install bundler && \
      rm -rf /var/lib/apt/lists/*
