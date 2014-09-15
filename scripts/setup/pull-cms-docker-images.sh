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

    docker pull gapminder/cms:$APP

# Fetch the latest proxy docker image

    docker pull gapminder/proxy:$PROXY_APP

# Fetch the latest mailcatcher docker image

    docker pull nisenabe/mailcatcher

# Restore working directory and exit
cd $pwd
exit 0


