#!/usr/bin/env bash

### hardware
# ...

### core/base
# enable additional repositories & add 3rd party ones
sudo add-apt-repository ppa:webupd8team/sublime-text-3 --yes          # Sublime Text
sudo add-apt-repository ppa:webupd8team/atom --yes            # Atom
sudo add-apt-repository ppa:snwh/pulp            # Paper GTK theme
echo "deb http://linux.dropbox.com/ubuntu $(lsb_release -cs) main" |sudo tee -a /etc/apt/sources.list.d/dropbox.list \
    && sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 1C61A2656FB57B7E4DE0F4C1FC918B335044912E            # Dropbox
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" |sudo tee --append /etc/apt/sources.list.d/google.list         # Google Chrome repo
wget http://repo.vivaldi.com/stable/linux_signing_key.pub -P /tmp \
    && sudo apt-key add /tmp/linux_signing_key.pub \
    && echo "deb [arch=amd64] http://repo.vivaldi.com/stable/deb/ stable main" |sudo tee --append /etc/apt/sources.list.d/vivaldi.list            # Vivaldi repo
sudo apt-add-repository -y ppa:pipelight/stable         # Silverlight OSS counterpart
# update /etc/passwd hashing algorithm
#sudo authconfig --passalgo=sha512 --update
# allow root only on tty1
#sudo echo "tty1" /etc/securetty
# only root can view /root dir
#sudo chmod 0700 /root

### sysadmin
sudo apt-get update -q && sudo apt-get install -y \
    nmap

### server
# KVM/QEMU+libvirt
#sudo apt-get update -q && sudo apt-get install -y \
#    qemu-kvm \
#    libvirt-bin \
#    bridge-utils \
#    libguestfs-tools 
# Docker (repo config included)
echo "aufs" |sudo tee -a /etc/modules
sudo modprobe aufs
sudo apt-get update -q && sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    docker-engine
#curl -sSL https://get.docker.com/ | sh
sudo groupadd docker || true
sudo usermod -aG docker $USER
#sudo DEFAULT_FORWARD_POLICY="DROP" -> "ACCEPT" /etc/default/ufw
#sudo ufw reload
#sudo ln -sf /usr/bin/docker.io /usr/local/bin/docker
#sudo sed -i '$acomplete -F _docker docker' /etc/bash_completion.d/docker.io
#sudo update-rc.d docker.io defaults
# Vagrant
sudo apt-get update -q && sudo apt-get install -y \
    libxslt-dev \
    libxml2-dev \
    libvirt-dev \
    zlib1g-dev
wget https://releases.hashicorp.com/vagrant/1.8.6/vagrant_1.8.6_x86_64.deb
sudo dpkg -i vagrant_1.8.6_x86_64.deb
vagrant plugin install \
    vagrant-rekey-ssh \
    vagrant-mutate \
    vagrant-libvirt

### apps
sudo apt-get update -q && sudo apt-get install -y \
    dropbox

### desktop
# DE
sudo apt-get update -q && sudo apt-get install -y \
    ubuntu-gnome-desktop \
    gnome-tweak-tool \
    dconf-editor \
    paper-gtk-theme \
    paper-icon-theme \
    paper-cursor-theme
# sysadmin
sudo apt-get update -q && sudo apt-get install -y \
    wireshark \
    vinagre
# web
sudo apt-get update -q && sudo apt-get install -y \
    sublime-text-installer \
    atom \
    google-chrome-stable \
    vivaldi-stable \
    pidgin \
    pidgin-sipe \
    deluge \
    rdesktop \
    browser-plugin-freshplayer-pepperflash \
    icedtea-7-plugin \
    openjdk-7-jre \
    pipelight-multi \
    && sudo pipelight-plugin --enable silverlight \
    && sudo pipelight-plugin --enable widevine
# media
sudo apt-get update -q && sudo apt-get install -y \
    ubuntu-restricted-extras \
    ubuntu-restricted-addons \
    libdvdcss2 \
    libdvdnav4 \
    libdvdread4 \
    vlc

