#!/bin/bash

# debug
set -x

# fail on any error
set -o errexit

# set common variables
pwd=`pwd`
script_path=`dirname $0`
source $script_path/variables.inc.sh

# Work in local build directory

    cd $script_path/../build/$NAME

# Generate the local vagrant config for the host vm:

    cd host-vm/
    vagrant reload

# Restore working directory and exit
cd $pwd
exit 0