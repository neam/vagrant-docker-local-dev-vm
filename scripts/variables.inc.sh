#!/bin/bash

# set common variables
_pwd=`pwd`
_script_path=`dirname $0`

# work in extension root directory

if [ "$(basename $script_path)" == "setup" ]; then
    cd $_script_path/../../
else
    cd $_script_path/../
fi

# Use the following docker images - include tags for version-pinning

    export DB_DOCKER_IMAGE=mariadb/local
    export LEMP_DOCKER_IMAGE=gapminder/cms:dna2-cms
    export PROXY_DOCKER_IMAGE=gapminder/proxy:feature_cms-1023-friends-base-url-proxy-2d2f560-clean-db
    export MAILCATCHER_DOCKER_IMAGE=nisenabe/mailcatcher

# Used by docker-md-plugin to set-up a db container for our app (named and with a certain port)

    export DB_APP=cms
    export DB_PORT=13306

# Choose a provider depending on where to provision the docker host:

    export HOST_VM_PROVIDER=virtualbox
    # todo:
    # export HOST_VM_PROVIDER=digital-ocean
    # export HOST_VM_PROVIDER=aws

# Create the build directories for our local set-up:

    export NAME=cms-$HOST_VM_PROVIDER
    mkdir -p build/$NAME/host-vm

# Choose either an insecure or a secure ssh key (note that automatic provisioning will not work when using secure keys):

    export SSH_PRIVATE_KEY=insecure_key
    export SSH_PUBLIC_KEY=insecure_key.pub
    # OR
    # export SSH_PRIVATE_KEY=~/.ssh/id_rsa
    # export SSH_PUBLIC_KEY=~/.ssh/id_rsa.pub

# Only relevant and correctly set for scripts in the setup directory, thus we only set it when run from there, avoiding confusion
if [ "$(basename $script_path)" == "setup" ]; then

    # To use local source-code, set the following environment variable (relative path from the setup directory to the parent repo codebase):

        export LOCAL_SOURCE_CODE_RELATIVE="../../../../"

    # Find the absolute path of the cms codebase

        export LOCAL_SOURCE_CODE=$(cd "$LOCAL_SOURCE_CODE_RELATIVE";pwd)

fi

# Restore working directory and exit
cd $_pwd
