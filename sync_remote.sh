#!/usr/bin/env bash
#set -o xtrace
#set -o verbose
#set -o errexit
#set -o nounset

E_NOFILE=66
E_NOARGS=75
E_BADDIR=85

CURRENT=`pwd`
LOCAL=$1
REMOTE=$2

dir_exists ()
{
    dir=$1
    if [ ! -d "${dir}" ]
    then
        echo "'${dir}' is not a directory"
        return $E_BADDIR
    fi
}

if_in_sync ()
{
    src=$1
    targ=$2
    for LINE in `find ${src}/ -type f -printf "%P\n"`
    do
        if [[ ! -f ${targ}/${LINE} ]]
        then
            echo "${LINE} was not synced"
            exit $E_NOFILE
        fi
    done
}

### tests
if [ $# -lt 2 ]; then
    echo "Usage: `basename $0 $1` [local] [remote]"
    exit $E_NOARGS
fi

dir_exists ${LOCAL}
dir_exists ${REMOTE}

### sync
rsync -avz ${LOCAL}/ ${REMOTE}

### check if in sync
if_in_sync ${LOCAL} ${REMOTE}

