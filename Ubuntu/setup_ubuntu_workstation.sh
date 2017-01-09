#!/usr/bin/env bash

### hardware
# ...

### core/base
# enable additional repositories & add 3rd party ones
# update /etc/passwd hashing algorithm
#sudo authconfig --passalgo=sha512 --update
# allow root only on tty1
#sudo echo "tty1" /etc/securetty
# only root can view /root dir
#sudo chmod 0700 /root

# media
sudo apt-get update -q && sudo apt-get install -y \
    ubuntu-restricted-extras \
    ubuntu-restricted-addons \
    libdvdcss2 \
    libdvdnav4 \
    libdvdread4 \
    vlc

