#!/bin/bash

# debug
set -x

# fail on any error
set -o errexit

# set common variables
pwd=`pwd`
script_path=`dirname $0`
source $script_path/../variables.inc.sh

# Work in local build directory

    cd $script_path/../../build/$NAME

# Prepare the SSH key for installation in the docker containers:

    if [ ! -f insecure_key ]; then
        curl -o insecure_key -fSL https://github.com/phusion/baseimage-docker/raw/master/image/insecure_key
    fi
    chmod 600 insecure_key
    if [ ! -f insecure_key.pub ]; then
        curl -o insecure_key.pub -fSL https://github.com/phusion/baseimage-docker/raw/master/image/insecure_key.pub
    fi
    export SSH_PUBLIC_KEY_CONTENTS=`cat $SSH_PUBLIC_KEY`
    erb ../../docker-container-ssh.sh.erb > docker-container-ssh.sh

# Generate the local vagrant config for the docker containers:

    export DB_PASS=$(cat "./.mariadb/pwd_$DB_APP")
    export DB_VOLUME=$(cat "./.mariadb/volume_$DB_APP")
    erb ../../Vagrantfile.erb > Vagrantfile
    erb ../../provision.sh.erb > provision.sh
    erb ../../web-start.sh.erb > web-start.sh
    erb ../../api-config.sh.erb > api-config.sh
    erb ../../external-yii-frontend-config.sh.erb > external-yii-frontend-config.sh
    erb ../../internal-yii-frontend-config.sh.erb > internal-yii-frontend-config.sh
    erb ../../proxy-start.sh.erb > proxy-start.sh
    erb ../../proxy-config.sh.erb > proxy-config.sh

# Restore working directory and exit
cd $pwd
exit 0


