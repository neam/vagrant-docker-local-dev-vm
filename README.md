Gapminder CMS Local Dev VM
-----------------------------

Uses [Vagrant](http://www.vagrantup.com/) to provision docker containers that runs Gapminder CMS.

Note: Requires significant free disk space (>10 Gb) since the host virtual machine increases in size on each vagrant reload rsync.

# Requirements

* OSX (Pull requests for Windows and Linux support welcome)

# Installation of prerequisites

Install vagrant from [http://www.vagrantup.com/]() (v1.6.3) and VirtualBox from [https://www.virtualbox.org/]().

Install the VirtualBox guest additions plugin:

    vagrant plugin install vagrant-vbguest

Install the docker client for OSX:

    brew install docker

Add the following to `~/.bash_profile`, `~/.profile` or similar:

    export DOCKER_HOST=tcp://localhost:4243

# Local set-up

Open up a terminal window and cd into the same directory as this readme file.

Run the following scripts:

    scripts/setup/generate-host-vm-vagrant-config.sh
    scripts/setup/install-docker-in-host-vm.sh

Login to the docker registry (unless you have already done so previously):

    docker login

(Note: Make sure you have signed up on [https://registry.hub.docker.com]() and have been invited to access Gapminder's private repository of docker images)

Pull the latest CMS base image (Can not be run by vagrant because it requires login - [https://github.com/mitchellh/vagrant/issues/4042]()):

    scripts/setup/pull-remote-docker-images.sh

Bring up and provision the docker containers:

    scripts/setup-containers.sh

Note: Currently the above command seems to fail due to a vagrant bug (`padding error, need 3037648479 block 16`), but it is most likely a false alarm, the containers should be up and running. Re-run the script if this happens (to be sure).

In the local CMS code, adapt `local/envbootstrap.php` to use the database details given by:

    scripts/list-db-credentials.sh

After this, the getting-started instructions should be continued in the CMS readme.

## Update to the latest git changes

After pulling the latest git changes, run the following to bring up the containers using the latest configuration:

    scripts/setup/generate-host-vm-vagrant-config.sh
    scripts/vagrant-reload-host-vm.sh
    scripts/setup-containers.sh

## Useful commands

To quickly bring up and provision the docker containers without running setup scripts again (for instance after rebooting your laptop but not changed / pulled any changes to the vm configuration):

    scripts/start-containers.sh

To verify that the database can be accessed from the local work station:

    scripts/verify-db-access.sh

To ssh into the web container (Note: the db container does not support ssh):

    scripts/ssh.sh web
    # scripts/ssh.sh proxy # The proxy container should support ssh but it is not currently working

To follow the logs in the containers, run:

    scripts/logs.sh

To follow the logs in a specific container, run one of the following:

    scripts/logs.sh db
    scripts/logs.sh api
    scripts/logs.sh external-yii-frontend
    scripts/logs.sh internal-yii-frontend
    scripts/logs.sh mailcatcher
    scripts/logs.sh proxy

To ssh into the host vm, cd into `host-vm` and run `vagrant ssh`.

## Troubleshooting

If you can't connect to the database and cant figure out why, try starting off from scratch by running the following:

    rm -r build/cms-virtualbox/.mariadb
    scripts/setup-containers.sh

If you simply can't connect to any port locally, vagrant or virtualbox may have run inte som networking issue. Either restart or remove the virtual machine from virtualbox and run the setup routine again.

# Updating the docker base images for LEMP and PROXY

## On dokku host

Set the docker images to base the update on (replace with the appropriate deployed app names):

    export LEMP_APP=feature_cms-1023-friends-base-url-cms-abc1234-clean-db
    export PROXY_APP=feature_cms-1023-friends-base-url-proxy-abc1234-clean-db

Make sure the containers are running on the current dokku host:

    docker ps | grep ${LEMP_APP}
    docker ps | grep ${PROXY_APP}

Tag and push cms docker lemp app:

    export CONTAINER_ID=`docker ps | grep dokku/${LEMP_APP}:latest | awk '{print $1}'`

    docker commit $CONTAINER_ID gapminder/cms:${LEMP_APP}
    # todo - strip away existing config since it contains secrets
    docker push gapminder/cms

Tag and push cms docker proxy app:

    export PROXY_CONTAINER_ID=`docker ps | grep dokku/${PROXY_APP}:latest | awk '{print $1}'`

    docker commit $PROXY_CONTAINER_ID gapminder/proxy:${PROXY_APP}
    docker push gapminder/proxy

# TODO

## Digital Ocean

To use the digital ocean provider, you need the vagrant digital ocean plugin:

    vagrant plugin install vagrant-digitalocean

Some general configuration variables are necessary for the configurations before provisioning the instances:

    export DIGITAL_OCEAN_CLIENT_ID="replaceme"
    export DIGITAL_OCEAN_API_KEY="replaceme"
    export DIGITAL_OCEAN_REGION="Amsterdam 2"

Set configuration that depends on performance requirements:

Example 1:

    export HOSTNAME=foo.example.com
    export SIZE=8GB

Example 2:

    export HOSTNAME=foo.example.com
    export SIZE=4GB

First time, run:

    vagrant up --provider=digital_ocean

## Amazon EC2

To use the digital ocean provider, you need the vagrant digital ocean plugin:

    vagrant plugin install vagrant-aws

Some general configuration variables are necessary for the configurations before provisioning the instances:

    export FOO="bar"
