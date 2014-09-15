#!/bin/bash

# debug
#set -x

# fail on any error
set -o errexit

# set common variables
pwd=`pwd`
script_path=`dirname $0`
source $script_path/variables.inc.sh

# Work in local build directory

    cd $script_path/../build/$NAME

# Bring up and provision the docker containers for Gapminder CMS:

    echo "== Use the following database credentials in order to connect from inside the container =="

    ../../vendor/docker-md-plugin/commands mariadb:info $DB_APP

    echo "== Use the following database credentials in order to connect from your work station =="

    ../../vendor/docker-md-plugin/commands mariadb:info $DB_APP | sed 's/172.17.42.1/127.0.0.1/'

# Restore working directory and exit
cd $pwd
exit 0


