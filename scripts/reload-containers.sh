#!/bin/bash

# fail on any error
set -o errexit

# set common variables
pwd=`pwd`
script_path=`dirname $0`
source $script_path/variables.inc.sh

# debug
set -x

# Reload containers by halting then starting (vagrant reload does not work reliably)

    $script_path/halt-containers.sh
    $script_path/start-containers.sh

# Restore working directory and exit
cd $pwd
exit 0