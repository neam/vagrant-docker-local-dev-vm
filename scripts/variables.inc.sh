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

# Source project-specific local dev vm config

    source ../../../.local-dev-vm-env

# Create the build directories for our local set-up:

    export NAME=vm-$HOST_VM_PROVIDER
    mkdir -p build/$NAME/host-vm

# Relative path to the project root

    export PROJECT_ROOT_RELATIVE="../../.."

# Find the absolute path of the project root

    export PROJECT_ROOT=$(cd "$PROJECT_ROOT_RELATIVE/";pwd)

# Project directory name

    export PROJECT_ROOT_DIR_NAME=$(dirname $PROJECT_ROOT);

# Restore working directory and exit
cd $_pwd
