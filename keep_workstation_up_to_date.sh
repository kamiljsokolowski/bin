#!/usr/bin/env bash

# db sync first
sudo apt-get -q update

# update the system
sudo apt-get -y upgrade \
&& sudo apt-get -y dist-upgrade \
&& sudo apt-get -y autoremove \
&& sudo apt-get clean

# update apps not managed via repos
sudo pip install --upgrade pip

