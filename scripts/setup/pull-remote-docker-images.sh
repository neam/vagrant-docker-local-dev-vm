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

# Login to the docker registry and fetch the latest CMS base image (Can not be run by vagrant because of https://github.com/mitchellh/vagrant/issues/4042):

    docker pull $LEMP_DOCKER_IMAGE

# Fetch the latest proxy docker image

    docker pull $PROXY_DOCKER_IMAGE

# Fetch the latest mailcatcher docker image

    docker pull $MAILCATCHER_DOCKER_IMAGE

# Fetch the latest ubuntu:trusty docker image since it is used by the docker-md-plugin and it is conventient to pull all remote images in the same step

    docker pull ubuntu:trusty

# Restore working directory and exit
cd $pwd
exit 0


