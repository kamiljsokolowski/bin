#!/usr/bin/env bash

# db sync first
sudo apt-get -q update

# update the server
sudo apt-get -y upgrade \
&& sudo apt-get -y dist-upgrade \
&& sudo apt-get -y autoremove \
&& sudo apt-get clean

# add non-root user with sudo priviledges
# (vagrant user already exists)

