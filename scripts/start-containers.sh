#!/bin/bash

# fail on any error
set -o errexit

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

# Remove any containers that failed to start (if they are not removed, vagrant won't attempt to start a new working container)

    docker ps -a | grep '_db_' | grep 'Exited' | awk '{ print $1 }' | xargs docker rm -f
    docker ps -a | grep '_web_' | grep 'Exited' | awk '{ print $1 }' | xargs docker rm -f
    docker ps -a | grep '_mailcatcher_' | grep 'Exited' | awk '{ print $1 }' | xargs docker rm -f
    docker ps -a | grep '_proxy_' | grep 'Exited' | awk '{ print $1 }' | xargs docker rm -f

# Bring up and provision the docker containers for Gapminder CMS:

    vagrant up --provider=docker db
    vagrant up --provider=docker web
    vagrant up --provider=docker mailcatcher
    vagrant up --provider=docker proxy & # last and run in background to work around https://github.com/mitchellh/vagrant/issues/3951

# Prevent users from thinking that the script is stuck

    sleep 10
    echo ""
    echo "Script finished!"
    echo ""

# Restore working directory and exit
cd $pwd
exit 0


