#!/usr/bin/env bash

# configure hosts file for Vagrant internal network
#sudo cat >> /etc/hosts <<EOL
sudo tee -a /etc/hosts > /dev/null <<EOL

# vagrant env nodes
10.10.32.10 mgmt
10.10.32.21 vps
EOL

# generate SSH key and distribute it to all nodes
if [ ! -f ${HOME}/.ssh/id_rsa.pub ]; then
    ssh-keygen -t rsa -b 2048 -f ${HOME}/.ssh/id_rsa -q -N ""
fi

