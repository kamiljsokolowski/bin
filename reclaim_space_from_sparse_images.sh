#!/usr/bin/env bash
set -o xtrace
set -o verbose
set -o errexit
#set -o nounset

user=`whoami`
guest=$1
image=$2
guest_user=$3

### add check if variables are present ###

if [ "$guest_user" = "" ]; then
	echo "User name (hit enter to use '$user')?"
	read guest_user
fi

if [ "$guest_user" = "" ]; then
	guest_user=$user
fi

# host
sudo bash <<EOF
virsh destroy --domain ${image}
cp /vmdata/storage/${image}.img /vmdata/storage/${image}.img.backup
virsh start --domain ${image}
sleep 60
EOF

# guest
ssh -T $guest_user@$guest<<EOSSH
sudo dd if=/dev/zero of=/mytempfile
sudo rm -rf /mytempfile
EOSSH

# (again) host
sudo bash <<EOF
virsh destroy --domain ${image}
sleep 60
mv /vmdata/storage/${image}.img /vmdata/storage/${image}.img.tmp
qemu-img convert -O qcow2 /vmdata/storage/${image}.img.tmp /vmdata/storage/${image}.img
virsh start --domain $image && rm -rf /vmdata/storage/${image}.img.tmp
EOF

