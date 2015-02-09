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

# Relative path to the project root

    export PROJECT_ROOT_RELATIVE="../../.."

# Find the absolute path of the project root

    export PROJECT_ROOT=$(cd "$PROJECT_ROOT_RELATIVE/";pwd)

# Project directory name

    export PROJECT_ROOT_DIR_NAME=$(basename $PROJECT_ROOT);

# Source project-specific local dev vm config

    cd "$PROJECT_ROOT_RELATIVE"
    source .local-dev-vm-env
    cd -

# Create the build directories for our local set-up:

    export NAME=vm-$HOST_VM_PROVIDER
    mkdir -p build/$NAME/host-vm

# Restore working directory and exit
cd $_pwd
