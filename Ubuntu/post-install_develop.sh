#!/usr/bin/env bash
set -o xtrace
set -o verbose
set -o errexit
#set -o nounset

echo '### setup vmhost ###'
sudo apt-get update -q && sudo apt-get install -y \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual \
    linux-headers-$(uname -r)-generic \
    linux-headers-generic \
    build-essential
