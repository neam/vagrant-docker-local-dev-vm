#!/bin/bash

# do not fail on any error
# set -o errexit

# set common variables
pwd=`pwd`
script_path=`dirname $0`
source $script_path/variables.inc.sh

# debug
set -x

# Work in local build directory

    cd $script_path/../build/$NAME

# Start the host vm so that the docker host becomes available

    ../../scripts/setup/install-docker-in-host-vm.sh

# Halt any running containers

    vagrant halt db
    vagrant halt web
    vagrant halt mailcatcher

# Halt any legacy containers

    vagrant halt web # TODO: Remove after no-one is using this configuration

# Restore working directory and exit
cd $pwd
exit 0


