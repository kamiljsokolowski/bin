#!/usr/bin/env bash
#set -o xtrace
#set -o verbose
#set -o errexit
#set -o nounset

E_NOFILE=66
E_NOARGS=75
E_BADDIR=85

#CURRENT=`pwd`
OPT=$1
DEST=$2/snapshot-$(date +%d.%m.%y)

dir_exists ()
{
    dir=$1
    if [ ! -d "${dir}" ]
    then
        echo "'${dir}' does not exist. Creating..."
        mkdir -p ${dir}
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

### perform tests
if [ $# -lt 1 ]; then
    echo "Usage: `basename $0 $1` [option] [remote]"
    exit $E_NOARGS
fi

dir_exists ${DEST}

### make snapshot
case ${OPT} in
"--all")
    # first create directory structure
    dir_exists ${DEST}/etc
    # sysconfig
    echo "Creating system configuration snapshot..."
    sudo rsync -aAX --no-links --numeric-ids --info=progress2 /etc/{apt,fstab} ${DEST}/etc/ && echo "System configuration snapshot created."
    echo "Validating system configuration snapshot..."
    if_in_sync /etc/ ${DEST}/snapshot-$(date +%d.%m.%y)/etc/
    ;;
"--sysconfig")
    # first create directory structure
    dir_exists ${DEST}/etc
    # sysconfig
    echo "Creating system configuration snapshot..."
    sudo rsync -aAX --no-links --numeric-ids --info=progress2 /etc/{apt,fstab} ${DEST}/etc/ && echo "System configuration snapshot created."
    echo "Validating if system configuration snapshot..."
    if_in_sync /etc/ ${DEST}/snapshot-$(date +%d.%m.%y)/etc/
    ;;
esac

