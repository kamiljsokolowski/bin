#!/usr/bin/env bash
set -o xtrace
set -o verbose
set -o errexit
#set -o nounset

echo '### setup vmhost ###'
sudo apt-get update -q && sudo apt-get install -y \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual \
    linux-headers-$(uname -r)-generic \
    linux-headers-generic \
    build-essential

echo '### add VirtualBox repository, install VirtualBox along with Extension Pack ###'
echo 'deb http://download.virtualbox.org/virtualbox/debian '$(lsb_release -c -s)' contrib non-free' |sudo tee /etc/apt/sources.list.d/virtualbox.list \
    && wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox_2016.asc -O- |sudo apt-key add -
sudo apt-get update -q && sudo apt-get install -y \
    dkms \
    virtualbox-5.1
cd /tmp && wget http://download.virtualbox.org/virtualbox/5.1.12/Oracle_VM_VirtualBox_Extension_Pack-5.1.12.vbox-extpack
sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-5.1.12.vbox-extpack
cd
#sudo /sbin/vboxconfig

