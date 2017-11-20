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

echo '### add Docker repository, load aufs module, install Docker and add user to "docker" group ###'
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
    && echo "deb [arch=amd64] https://apt.dockerproject.org/repo ubuntu-$(lsb_release -c -s) main" |sudo tee -a /etc/apt/sources.list.d/docker.list
# WARNING! Utilizing a temporary workaround until Docker Ubuntu repo https comms issue is resolved
#sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
#    && echo "deb [arch=amd64] http://apt.dockerproject.org/repo ubuntu-$(lsb_release -c -s) main" |sudo tee -a /etc/apt/sources.list.d/docker.list
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
sudo pip install --no-cache docker-compose
if [ ! -d ${HOME}/.zsh/completion ]
then
    mkdir -p ${HOME}/.zsh/completion
fi
curl -L https://raw.githubusercontent.com/docker/compose/1.17.1/contrib/completion/zsh/_docker-compose > ~/.zsh/completion/_docker-compose

echo '### install Vagrant and base set of plugins ###'
sudo apt-get update -q && sudo apt-get install -y \
    libxslt-dev \
    libxml2-dev \
    libvirt-dev \
    zlib1g-dev
cd /tmp && wget https://releases.hashicorp.com/vagrant/1.9.1/vagrant_1.9.1_x86_64.deb
sudo dpkg -i vagrant_1.9.1_x86_64.deb
cd
vagrant plugin install \
    vagrant-rekey-ssh \
    vagrant-mutate \
    vagrant-libvirt

