#!/usr/bin/env bash
#set -o xtrace
#set -o verbose
#set -o errexit
#set -o nounset

E_NOARGS=75
E_BADDIR=85

current=`pwd`
local=$1
remote=$2

if [ $# -lt 2 ]; then
    echo "Usage: `basename $0 $1` [local] [remote]"
    exit $E_NOARGS
fi

check_dir ()
{
    if [ ! -d "${local}" ]
    then
        echo "'${local}' is not a directory"
        return $E_BADDIR
    fi
}

check_dir ${local}
check_dir ${remote}

rsync -avz ${local} ${remote}

