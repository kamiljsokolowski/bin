#!/usr/local/env bash

# db sync first
sudo apt-get -q update

# update the system
sudo apt-get -y upgrade \
&& apt-get -y dist-upgrade \
&& apt-get -y autoremove \
&& apt-get clean

# update apps not managed via repos
pip install --upgrade pip

