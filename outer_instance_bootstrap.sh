#!/usr/bin/env bash

# This script is run inside Amazon Linux instance on boot
# It's run _outside_ of bazel or docker.
# Note that it does not have _any_ access to secrets as they have not been provisioned yet.
sudo mkdir -p /usr/local/var/bazelcache/
sudo chown buildkite-agent /usr/local/var/bazelcache/

echo "Bootstrap succeeded"
