#!/bin/bash

# set common variables
_pwd=`pwd`
_script_path=`dirname $0`

# work in parent directory
cd $_script_path/../

# Use the following docker images - include tags for version-pinning

    export DB_DOCKER_IMAGE=mariadb/local
    export LEMP_DOCKER_IMAGE=gapminder/cms:feature_cms-1023-friends-base-url-cms-6c65599-clean-db
    export PROXY_DOCKER_IMAGE=gapminder/cms:feature_cms-1023-friends-base-url-proxy-2d2f560-clean-db
    export MAILCATCHER_DOCKER_IMAGE=nisenabe/mailcatcher

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

# To use local source-code, set the following environment variable (relative path to the parent repo codebase):

    export LOCAL_SOURCE_CODE_RELATIVE="../../../"

# Find the absolute path of the cms codebase

    export LOCAL_SOURCE_CODE=$(cd "$LOCAL_SOURCE_CODE_RELATIVE";pwd)

# Restore working directory and exit
cd $_pwd
