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

# Create and prepare the database container image:

    ../../vendor/docker-md-plugin/install
    ../../vendor/docker-md-plugin/commands mariadb:create $APP
    # remove the container (keeping the image) since we want docker to manage the container
    docker ps | grep $(cat "./.mariadb/port_$APP") | awk '{ print $1 }' | xargs docker rm -f

    # db password and persistent volume path is already set by the mariadb docker plugin but needs to be forwarded to vagrant
    echo $DB_PORT > ./.mariadb/port_$APP

# Restore working directory and exit
cd $pwd
exit 0