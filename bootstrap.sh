#!/usr/bin/env bash

sudo mkdir -p /usr/local/var/bazelcache/
sudo chown buildkite-agent /usr/local/var/bazelcache/

echo "Bootstrap succeeded"
