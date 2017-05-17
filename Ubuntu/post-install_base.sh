#!/usr/bin/env bash
set -o xtrace
set -o verbose
set -o errexit
#set -o nounset

echo '### enable additional Ubuntu repositories ###'
sudo cp /etc/apt/sources.list{,.backup}
sudo sed -i -e '/ partner/ s/# //' /etc/apt/sources.list         # Partner
sudo sed -i -e '/extras.ubuntu.com/ s/# //' /etc/apt/sources.list            # Extras

echo '### install base tools ###'
sudo apt-get update -q && sudo apt-get install -y \
    ssh \
    htop \
    cifs-utils \
    unzip \
    unrar \
    p7zip-full \
    p7zip-rar \
    tcpdump \
    tree \
    iptraf-ng \
    curl \
    tmux \
    git \
    vim \
    irssi \
    zsh \
    python-setuptools \
 && sudo easy_install pip

echo '### setup oh-my-zsh plugin (log out and log back in for changes to take place) ###'
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - |sudo zsh
chsh -s `which zsh`

