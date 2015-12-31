#!/usr/bin/env bash
#set -o xtrace
#set -o verbose
#set -o errexit
#set -o nounset

E_NOFILE=66
E_NOARGS=75
E_BADDIR=85

#CURRENT=`pwd`
HOST=$(hostname)
USER=$(whoami)
SYNC='rsync -aAX --no-links --numeric-ids --info=progress2'
OPT=$1
DEST=$2
BACKUP=${DEST}/Archive/BACKUP/${HOST}/snapshot-$(date +%d.%m.%y)
SHARED=${DEST}/Archive/SHARED/snapshot-$(date +%d.%m.%y)
VMDATA=/mnt/vmdata/snapshot-$(date +%d.%m.%y)

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

### make snapshot
case ${OPT} in
"--all")
    ### BACKUP
    # first create directory structure
    dir_exists ${BACKUP}/etc
    dir_exists ${BACKUP}/home/${USER}
    # sysconfig
    echo "Creating system configuration snapshot..."
    sudo ${SYNC} /etc/{apt,fstab} ${BACKUP}/etc/ && echo "System configuration snapshot created."
    #echo "Validating system configuration snapshot..."
    #if_in_sync /etc/ ${BACKUP}/etc/
    # dotfiles
    echo "Creating user configuration snapshot..."
    ${SYNC} /home/${USER}/{.credentials,.ssh} ${BACKUP}/home/${USER}/ && echo "User configuration snapshot created."
    #echo "Validating user configuration snapshot..."
    #if_in_sync /home/${USER}/ ${BACKUP}/home/${USER}/

    ### SHARED
    # first create directory structure
    dir_exists ${SHARED}/Dropbox
    echo "Creating cloud storage snapshot..."
    ${SYNC} /home/${USER}/Dropbox/ ${SHARED}/Dropbox/ && echo "Cloud storage snapshot created."
    #echo "Validating cloud storage snapshot..."
    #if_in_sync /home/${USER}/Dropbox/ ${SHARED}/Dropbox/

    ### VMDATA
    echo "Creating vmdata snapshot..."
    sudo ${SYNC} /vmdata/ ${VMDATA}/ && echo "vmdata snapshot created."
    #echo "Validating vmdata snapshot..."
    #if_in_sync /vmdata/ ${VMDATA}/
    ;;
"--backup")
    # first create directory structure
    dir_exists ${BACKUP}/etc
    dir_exists ${BACKUP}/home/${USER}
    # sysconfig
    echo "Creating system configuration snapshot..."
    sudo ${SYNC} /etc/{apt,fstab} ${BACKUP}/etc/ && echo "System configuration snapshot created."
    #echo "Validating system configuration snapshot..."
    #if_in_sync /etc/ ${BACKUP}/etc/
    # dotfiles
    echo "Creating user configuration snapshot..."
    ${SYNC} /home/${USER}/{.credentials,.ssh} ${BACKUP}/home/${USER}/ && echo "User configuration snapshot created."
    #echo "Validating user configuration snapshot..."
    #if_in_sync /home/${USER}/ ${BACKUP}/home/${USER}/
    ;;
"--shared")
    # first create directory structure
    dir_exists ${SHARED}/Dropbox
    # Dropbox
    echo "Creating Dropbox cloud storage snapshot..."
    ${SYNC} /home/${USER}/Dropbox/ ${SHARED}/Dropbox/ && echo "Dropbox cloud storage snapshot created."
    #echo "Validating Dropbox cloud storage snapshot..."
    #if_in_sync /home/${USER}/Dropbox/ ${SHARED}/Dropbox/
    ;;
"--vm")
    echo "Creating vmdata snapshot..."
    sudo ${SYNC} /vmdata/ ${VMDATA}/ && echo "vmdata snapshot created."
    #echo "Validating vmdata snapshot..."
    #if_in_sync /vmdata/ ${VMDATA}/
    ;;
esac

