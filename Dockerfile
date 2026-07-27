# If you are a Stripe employee, please see https://go/types/sorbet-build-image
# for instructions on how to deploy updates to this image.

FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

# Useful debugging commands / Docker cheatsheet:
#
#   # Interactive shell inside a container:
#   docker run --rm -it --platform linux/arm64 ubuntu:20.04 bash
#
#   # Flags that make building respect the host's HTTP proxy settings
#   --network host --build-arg http_proxy="$http_proxy" --build-arg https_proxy="$https_proxy" --build-arg no_proxy="$no_proxy"

ADD bazel_loader bazel_loader
RUN apt-get update && \
      apt-get install --no-install-recommends -y autoconf ca-certificates curl debconf-utils file g++ git gpg-agent jq libgmp-dev libreadline-dev libffi-dev libssl-dev libtinfo-dev libxml2 libyaml-dev make moreutils openssh-client patch pkg-config python ruby rubygems software-properties-common unzip wget xxd xz-utils zip zlib1g-dev libtinfo5
RUN mkdir -p /usr/share/keyrings /etc/apt/keyrings && \
      curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /usr/share/keyrings/nodesource.gpg && \
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_16.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
      echo "deb-src [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_16.x nodistro main" | tee -a /etc/apt/sources.list.d/nodesource.list && \
      curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor -o /etc/apt/keyrings/yarn-archive-keyring.gpg && \
      echo "deb [signed-by=/etc/apt/keyrings/yarn-archive-keyring.gpg] https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
      apt-get update && \
      apt-get install --no-install-recommends -y nodejs yarn && \
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
RUN rbenv install 3.3.12
RUN rbenv install 3.4.9
RUN rbenv install 4.0.6
RUN rbenv global 3.3.12

ENV TINI_VERSION v0.18.0
RUN curl -fsSL -o /tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static-$(dpkg --print-architecture)
RUN chmod +x /tini
ENTRYPOINT ["/tini", "-g", "--"]
