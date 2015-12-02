#!/usr/bin/env bash
set -x
set -v

# enable additional repositories & add 3rd party ones
sudo sed -i -e '/ partner/ s/# //' /etc/apt/sources.list         # Partner
sudo sed -i -e '/extras.ubuntu.com/ s/# //' /etc/apt/sources.list            # Extras
sudo sh -c "echo 'deb http://download.virtualbox.org/virtualbox/debian '$(lsb_release -cs)' contrib non-free' > /etc/apt/sources.list.d/virtualbox.list" && wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -           # Virtualbox
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" |sudo tee --append /etc/apt/sources.list.d/google.list         # Google Chrome repo
sudo apt-add-repository -y ppa:pipelight/stable         # Silverlight OSS counterpart


# install APPS
sudo apt-get update -q && apt-get install -y \
    curl \
    tmux \
    git \
    vim \
    irssi \
    zsh \
    python-setuptools \
 && easy_install pip
# (optional) zsh + oh-my-zsh plugin (requires reboot)
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - |sudo zsh
chsh -s `which zsh`
# (headless) Virtualbox
sudo apt-get -y install build-essential dkms VirtualBox-5.0
cd /tmp && wget http://download.virtualbox.org/virtualbox/5.0.2/Oracle_VM_VirtualBox_Extension_Pack-5.0.2-102096.vbox-extpack
sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-*
cd
# Docker (repo config included)
sudo apt-get install -y linux-image-extra-$(uname -r)
sudo echo aufs >> /etc/modules
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


### USER ###
# dotfiles
git clone https://github.com/sokolowskik/dotfiles.git .dotfiles
cd .dotfiles
chmod +x bootstrap.sh
./bootstrap.sh
