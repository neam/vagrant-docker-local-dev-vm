#!/bin/bash

# debug
set -x

# fail on any error
set -o errexit

# set common variables
pwd=`pwd`
script_path=`dirname $0`
source $script_path/variables.inc.sh

# Get arguments

if [ "$1" == "" ]; then
    if [ "$DATA" == "" ]; then
        echo 'When ssh.sh is invoked without a parameter, it will default to "web-$DATA" but $DATA is empty'
        exit 1
    else
        MACHINE=web-$DATA
    fi
else
    MACHINE=$1
fi

# Work in local build directory

    cd $script_path/../build/$NAME

# SSH into web container:

    vagrant ssh $MACHINE

# Restore working directory and exit
cd $pwd
exit 0


