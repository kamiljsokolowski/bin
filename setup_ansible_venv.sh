#!/usr/bin/env bash
venv_dir=/home/${USER}
ansible_venv_dir=${venv_dir}/ansible-venv

if [ -f /etc/debian_version ] || [ grep -qi ubuntu /etc/lsb-release ]
then
    echo "INFO: Debian-based platform detected."
    echo "INFO: Install package requirements."
    sudo apt-get update -q && sudo apt-get install -y \
        build-essential \
        libssl-dev \
        python \
        python-dev \
        python-setuptools
elif [ -f /etc/centos-release ] || [ -f /etc/redhat-release ]
then
    echo "INFO: RedHat-based platform detected."
    echo "INFO: Install package requirements."
    # code
else
    echo "ERROR: Unsupported platform."
    echo "Exiting.."
    exit 1
fi

echo "INFO: Install pip."
sudo easy_install pip
sudo pip install virtualenv

echo "INFO: Create Ansible-dedicated virtualenv in ${ansible_venv_dir}."
virtualenv ${ansible_venv_dir}

echo "INFO: Install Ansible."
${ansible_venv_dir}/bin/pip install --no-cache ansible
${ansible_venv_dir}/bin/ansible --version
