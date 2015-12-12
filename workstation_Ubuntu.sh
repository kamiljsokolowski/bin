#!/usr/bin/env bash
set -x
set -v

### hardware
# ...

### core/base
# enable additional repositories & add 3rd party ones
sudo sed -i -e '/ partner/ s/# //' /etc/apt/sources.list         # Partner
sudo sed -i -e '/extras.ubuntu.com/ s/# //' /etc/apt/sources.list            # Extras
sudo sh -c "echo 'deb http://download.virtualbox.org/virtualbox/debian '$(lsb_release -cs)' contrib non-free' > /etc/apt/sources.list.d/virtualbox.list" && wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -           # Virtualbox
echo "deb http://linux.dropbox.com/ubuntu $(lsb_release -cs) main" |sudo tee -a /etc/apt/sources.list.d/dropbox.list && sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 1C61A2656FB57B7E4DE0F4C1FC918B335044912E            # Dropbox
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" |sudo tee --append /etc/apt/sources.list.d/google.list         # Google Chrome repo
sudo apt-add-repository -y ppa:pipelight/stable         # Silverlight OSS counterpart
# update /etc/passwd hashing algorithm
#sudo authconfig --passalgo=sha512 --update
# allow root only on tty1
#sudo echo "tty1" /etc/securetty
# only root can view /root dir
#sudo chmod 0700 /root

### sysadmin
sudo apt-get update -q && sudo apt-get install -y \
    htop \
    cifs-utils \
    unzip \
    unrar \
    p7zip-full \
    p7zip-rar \
    tcpdump \
    nmap

### server
# KVM/QEMU+libvirt
sudo apt-get update -q && sudo apt-get install -y \
    qemu-kvm \
    libvirt-bin \
    bridge-utils \
    libguestfs-tools 
# (headless) Virtualbox
sudo apt-get -y install build-essential dkms VirtualBox-5.0
cd /tmp && wget http://download.virtualbox.org/virtualbox/5.0.2/Oracle_VM_VirtualBox_Extension_Pack-5.0.2-102096.vbox-extpack
sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-*
cd
# Docker (repo config included)
sudo apt-get install -y linux-image-extra-$(uname -r)
echo "aufs" |sudo tee -a /etc/modules
sudo modprobe aufs
curl -sSL https://get.docker.com | sh
#sudo DEFAULT_FORWARD_POLICY="DROP" -> "ACCEPT" /etc/default/ufw
#sudo ufw reload
#sudo ln -sf /usr/bin/docker.io /usr/local/bin/docker
#sudo sed -i '$acomplete -F _docker docker' /etc/bash_completion.d/docker.io
#sudo update-rc.d docker.io defaults
# Vagrant
wget https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.4_x86_64.deb
sudo dpkg -i vagrant_1.7.4_x86_64.deb
sudo apt-get -y install libxslt-dev libxml2-dev libvirt-dev zlib1g-dev
vagrant plugin install vagrant-rekey-ssh \
    vagrant-mutate \
    vagrant-libvirt

### apps
sudo apt-get update -q && sudo apt-get install -y \
    curl \
    dropbox \
    tmux \
    git \
    vim \
    irssi \
    zsh \
    python-setuptools \
 && sudo easy_install pip
# (optional) zsh + oh-my-zsh plugin (requires reboot)
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - |sudo zsh
chsh -s `which zsh`

### desktop
# DE
sudo apt-get update -q && sudo apt-get install -y \
    ubuntu-gnome-desktop \
    gnome-tweak-tool \
    dconf-editor
# web
sudo apt-get update -q && sudo apt-get install -y \
    google-chrome-stable \
    pidgin \
    pidgin-sipe \
    deluge \
    rdesktop \
    flash-plugin-installer \
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

