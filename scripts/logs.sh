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

# Follow logs for the container

    vagrant docker-logs --follow $1

# Restore working directory and exit
cd $pwd
exit 0


