# If you are a Stripe employee, please see https://go/types/sorbet-build-image
# for instructions on how to deploy updates to this image.

FROM ubuntu:18.04

ADD bazel_loader bazel_loader
# Install libstdc++6 from ppa:ubuntu-toolchain-r/test to get GLIBCXX_3.4.26
# Unfortunately 18.04 repositories only provide GLIBCXX_3.4.25
RUN apt-get update && \
      apt-get install --no-install-recommends -y autoconf ca-certificates curl debconf-utils file g++ git gpg-agent jq libgmp-dev libreadline-dev libssl-dev libtinfo-dev libxml2 make moreutils openssh-client patch pkg-config python ruby rubygems software-properties-common unzip wget xxd zip zlib1g-dev && \
      curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
      echo "deb https://deb.nodesource.com/node_14.x bionic main" | tee /etc/apt/sources.list.d/nodesource.list && \
      echo "deb-src https://deb.nodesource.com/node_14.x bionic main" | tee -a /etc/apt/sources.list.d/nodesource.list && \
      curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
      echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
      curl -sS https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
      echo "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-9 main" | tee /etc/apt/sources.list.d/llvm.list && \
      apt-get update && \
      apt-get install --no-install-recommends -y nodejs yarn clang-9 && \
      add-apt-repository --yes ppa:ubuntu-toolchain-r/test && \
      apt-get update && \
      apt-get install --yes --only-upgrade libstdc++6 && \
      cd bazel_loader && \
      ./bazel version && \
      rm -rf /var/lib/apt/lists/*

RUN curl -fsSOL https://github.com/koalaman/shellcheck/releases/download/v0.7.2/shellcheck-v0.7.2.linux.$(arch).tar.xz && \
     tar -xf shellcheck-v0.7.2.linux.$(arch).tar.xz && \
     cp shellcheck-v0.7.2/shellcheck /usr/local/bin && \
     rm -rf shellcheck-v0.7.2 && \
     rm shellcheck-v0.7.2.linux.$(arch).tar.xz && \
     shellcheck --version

ENV PATH=/root/.rbenv/bin:/root/.rbenv/shims:$PATH
RUN curl -fsSL https://raw.githubusercontent.com/rbenv/rbenv-installer/108c12307621a0aa06f19799641848dde1987deb/bin/rbenv-installer | bash -x
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init -)"' >> /root/.bashrc
RUN rbenv install 2.7.2
RUN rbenv global 2.7.2
RUN rbenv install 2.7.7
RUN rbenv install 3.1.2

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "-g", "--"]
