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

# Verify that you can connect to the MySQL (actually MariaDB) server:

    export DB_PASS=$(cat "./.mariadb/pwd_$DB_APP")
    echo "SELECT 1;" | mysql -h127.0.0.1 -P$DB_PORT -uroot -p$DB_PASS

# Restore working directory and exit
cd $pwd
exit 0


