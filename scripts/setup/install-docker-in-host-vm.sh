#!/bin/bash

# debug
set -x

# fail on any error
set -o errexit

# set common variables
pwd=`pwd`
script_path=`dirname $0`
source $script_path/../variables.inc.sh

# Work in local build directory

    cd $script_path/../../build/$NAME

# Install docker host vm first since we need local access to docker before provisioning the docker containers:

    cd install-docker-host-vm
    set +o errexit
    vagrant up --provider=docker # it's ok that it fails - the point of this command is to make vagrant install docker for us - "Docker host is required. One will be created if necessary -> Docker host VM is already ready"
    set -o errexit
    cd ..

# Restore working directory and exit
cd $pwd
exit 0