#!/usr/bin/env bash
set -o xtrace
set -o verbose
set -o errexit
#set -o nounset

user='whoami'
#guest=$1
#guest_user=$2
guest=
guest_user=
image=

### add check if variables are present ###

#if [ "$guest_user" = "" ]; then
#	echo "User name (hit enter to use '$user')?"
#	read guest_user
#fi
#
#if [ "$guest_user" = "" ]; then
#	guest_user=$user
#fi

# (on GUEST)
ssh -T $guest_user@$guest '
sudo dd if=/dev/zero of=/mytempfile
sudo rm -rf /mytempfile
sudo shutdown -h now
'

# (on HOST)
sudo bash <<EOF
mv /vmdata/storage/${image}.img /vmdata/storage/${image}.img.backup
qemu-img convert -O qcow2 /vmdata/storage/${image}.img.backup /vmdata/storage/${image}.img
EOF
