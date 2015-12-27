#!/usr/bin/env bash
#set -o xtrace
#set -o verbose
#set -o errexit
#set -o nounset

E_NOFILE=66
E_NOARGS=75
E_BADDIR=85

#CURRENT=`pwd`
REMOTE=$1

dir_exists ()
{
    dir=$1
    if [ ! -d "${dir}" ]
    then
        echo "'${dir}' does not exist. Creating..."
        mkdir -p ${REMOTE}
        echo "'${dir}' has been created."
    fi
}

if_in_sync ()
{
    src=$1
    targ=$2
    fail=0
    for LINE in `find ${src}/ -type f -printf "%P\n"`
    do
        if [[ ! -f ${targ}/${LINE} ]]
        then
            echo "${LINE} is not in sync"
            let "fail++"
        fi
    done
    if [ $fail != 0 ]
    then
        echo "Total of ${fail} files are not in sync"
        exit $E_NOFILE
    fi
}

### tests
if [ $# -lt 1 ]; then
    echo "Usage: `basename $0` [remote]"
    exit $E_NOARGS
fi

dir_exists ${REMOTE}

### sync
# first create directory structure
echo "Creating snapshot directory structure..."
mkdir -p ${REMOTE}/snapshot-$(date +%d.%m.%y)/{etc} && echo "Snapshot directory structure has been created."
# sysconfig
echo "Creating system configuration snapshot..."
sudo rsync -aAX --no-links --numeric-ids --info=progress2 /etc/ ${REMOTE}/snapshot-$(date +%d.%m.%y)/etc/
echo "System configuration snapshot created."

### check if in sync
echo "Validating if system configuration snapshot..."
sudo if_in_sync /etc/ ${REMOTE}/snapshot-$(date +%d.%m.%y)/etc/

