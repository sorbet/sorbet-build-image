FROM ubuntu:18.04

ADD bazel_loader bazel_loader
RUN apt-get update && \
      apt-get install --no-install-recommends -y file libssl-dev libreadline-dev curl ca-certificates software-properties-common debconf-utils git pkg-config zip g++ zlib1g-dev unzip autoconf python patch shellcheck moreutils make ruby nodejs libxml2 gpg-agent jq openssh-client rubygems wget libtinfo-dev xxd && \
      curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
      echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
      apt-get update && \
      apt-get install --no-install-recommends -y yarn && \
      cd bazel_loader && \
      ./bazel version && \
      rm -rf /var/lib/apt/lists/*

ENV PATH=/root/.rbenv/bin:/root/.rbenv/shims:$PATH
RUN curl -fsSL https://raw.githubusercontent.com/rbenv/rbenv-installer/108c12307621a0aa06f19799641848dde1987deb/bin/rbenv-installer | bash -x
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init -)"' >> /root/.bashrc
RUN rbenv install 2.6.3 && \
      rbenv global 2.6.3 && \
      gem install bundler && \
      ln -s /root/.rbenv/versions/2.6.3 /root/.rbenv/versions/2.6

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "-g", "--"]
