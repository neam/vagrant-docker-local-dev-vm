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

# Remove previous web containers (if they are not removed, vagrant won't attempt to start a new working container in the reload-step)

    docker ps -a | grep '_web_' | awk '{ print $1 }' | xargs docker rm -f

# Vagrant "reload" for the web container

    vagrant halt web
    vagrant up --provider=docker web

# Restore working directory and exit
cd $pwd
exit 0