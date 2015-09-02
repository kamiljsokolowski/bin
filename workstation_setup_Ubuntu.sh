#!/usr/bin/env bash
set -o xtrace
set -o verbose
set -o errexit
#set -o nounset

### SYSTEM
# drivers
#------------------------------

# software repositories
sed -i -e '/ partner/ s/# //' /etc/apt/sources.list         # Partner
sed -i -e '/extras.ubuntu.com/ s/# //' /etc/apt/sources.list            # Extras
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -; echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list           # Google Chrome
sudo sh -c "echo 'deb http://download.virtualbox.org/virtualbox/debian '$(lsb_release -cs)' contrib non-free' > /etc/apt/sources.list.d/virtualbox.list"; wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -         # VirtualBox
echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list; apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9         # Docker
apt-add-repository -y ppa:pipelight/stable          # open source Silverlight counterpart
apt-get update


### APPS
sudo apt-get -y install curl tmux git vim irssi
sudo apt-get -y install build-essential dkms VirtualBox-5.0; cd /tmp && wget http://download.virtualbox.org/virtualbox/5.0.2/Oracle_VM_VirtualBox_Extension_Pack-5.0.2-102096.vbox-extpack; sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-*; cd           # headless vbox
#------------------------------

