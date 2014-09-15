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

# Remove previous db containers (if they are not removed, vagrant won't attempt to start a new working container in the reload-step)

    docker ps -a | grep '_db_' | awk '{ print $1 }' | xargs docker rm -f

# Vagrant "reload" for the db container

    vagrant halt db
    vagrant up --provider=docker db

# Restore working directory and exit
cd $pwd
exit 0