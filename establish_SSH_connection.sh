#!/usr/bin/env bash

host=$1
host_name=$2
user=$3

# (if it does not exist) generate a new, password-less public key pair
if [ ! -f ${HOME}/.ssh/id_rsa.pub ]
then
    ssh-keygen -t rsa -b 2048 -f ${HOME}/.ssh/id_rsa -q -N ""
fi

# (if not present) add host to .ssh/known_hosts
if grep -q $host /etc/hosts
then
    echo "${host} entry already exists in /etc/hosts"
elif grep -q $host_name /etc/hosts
then
    echo "${host_name} entry already exists in /etc/hosts"
else
    sudo tee -a /etc/hosts > "${host} ${host_name}" 
fi

if [ ! -f ${HOME}/.ssh/known_hosts ]; then
    touch ${HOME}/.ssh/known_hosts
    chmod 0644 ${HOME}/.ssh/known_hosts
fi

if grep -q $host ${HOME}/.ssh/known_hosts
then
    echo "${host} entry already exists in ${HOME}/.ssh/known_hosts"
else
    ssh-keyscan ${host_name} > ${HOME}/.ssh/known_hosts
fi

# copy the public key to remote host
ssh-copy-id -i ${HOME}/.ssh/id_rsa.pub ${user}@${host_name}

