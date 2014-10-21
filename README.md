Vagrant Docker Local Dev VM
-----------------------------

Uses [Vagrant](http://www.vagrantup.com/) to provision [Docker](https://www.docker.com/) containers for local development purposes.

# Features

* Installs docker properly on OSX (Using a host vm through Vagrant's docker provider)
* Uses only 1 virtual machine but allows installation of as many docker containers that are necessary to set-up services locally (LAMP stack, LEMP stack, MEAN stack, any databases, SMTP, RabbitMQ etc - anything at https://registry.hub.docker.com/ is game)
* Includes scripts for setting up MariaDB docker container with persistent data
* Port forwards necessary ports so that docker containers are accessible in the browser
* Sets up a tcp proxy that enable access to the selenium server running on the developer machine on port 14444 within docker containers (So that acceptance tests can be run from within the containers)

# Requirements

* OSX (Pull requests for Windows and Linux support welcome)

# Installation

1. Fork this repo
2. Alter the composer metadata to reflect your fork
3. Add your fork as a submodule or add it as a composer dependency

# Developer machine local set-up

## Installation of prerequisites

Install vagrant from [http://www.vagrantup.com/]() (v1.6.3) and VirtualBox from [https://www.virtualbox.org/]().

Install the VirtualBox guest additions plugin:

    vagrant plugin install vagrant-vbguest

Install the docker client for OSX:

    brew install docker

Add the following to `~/.bash_profile`, `~/.profile` or similar:

    export DOCKER_HOST=tcp://localhost:4243

## Install the docker daemon

Open up a terminal window and cd into the same directory as this readme file.

Run the following scripts:

    scripts/setup/generate-host-vm-vagrant-config.sh
    scripts/setup/install-docker-in-host-vm.sh

(Note: The above command should fail with the error message `Stderr: Unable to find image 'this-image-should/make-vagrant-fail-it-is-ok-and-expected' locally`. This is OK and expected. The non-existing image name was just used temporarily to make vagrant install Docker in the host vm.)

## Setup docker containers

Login to the docker registry (unless you have already done so previously):

    docker login

(Note: Make sure you have signed up on [https://registry.hub.docker.com]() and have been invited to access any private repositories of docker images that your project is using)

Pull the latest docker images (Can not be run by vagrant because it requires login - [https://github.com/mitchellh/vagrant/issues/4042]()):

    scripts/setup/pull-remote-docker-images.sh

Make sure submodules are initialized:

    git submodule update --init --recursive

Bring up and provision the docker containers:

    scripts/setup-containers.sh

Tip: You can run `watch docker ps` in another terminal to see the current status of running containers as they are started. The output should look something like the following when all containers are up (Note: only showing the first five columns below):

    CONTAINER ID   IMAGE                                                                      COMMAND                CREATED         STATUS
    cd7e51984d33   gapminder/proxy:feature_cms-1023-friends-base-url-proxy-2d2f560-clean-db   /bin/bash /vagrant/p   2 minutes ago   Up About a minute
    af7300296836   fooproject/cms:feature_foo-123-new-nginx-configuration-2d2f560             /bin/bash /vagrant/w   3 minutes ago   Up 2 minutes
    ae24cb46f35c   nisenabe/mailcatcher:latest                                                mailcatcher -f --ver   3 minutes ago   Up 2 minutes
    7d713175b2b9   mariadb/cms:latest                                                         /usr/bin/start_maria   4 minutes ago   Up 2 minutes

After this, the getting-started instructions should be continued in the main project readme.

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
    scripts/logs.sh web
    scripts/logs.sh mailcatcher
    scripts/logs.sh proxy

To ssh into the host vm, cd into `host-vm` and run `vagrant ssh`.

## Troubleshooting

Sometimes the `scripts/setup-containers.sh` command fail seemingly due to a vagrant bug (`padding error, need 3037648479 block 16`), but it is most likely a false alarm, the containers should be up and running. If not, re-run the script until all containers are up and running.

If you are running into `warning: Insecure world writable dir /usr in PATH, mode 040777`, try removing global write access from /usr and it's sub-directories:

    sudo chmod -R o-w /usr/

If you can't connect to the database and cant figure out why, try starting off from scratch by running the following:

    rm -r build/cms-virtualbox/.mariadb
    scripts/setup-containers.sh

If you simply can't connect to any port locally, vagrant or virtualbox may have run into some networking issue. Reboot your machine (seriously, it has actually helped). If that didn't help - either restart or remove the virtual machine from virtualbox and run the setup routine again.

The virtual machine requires significant free disk space (>10 Gb) since the host virtual machine increases in size on each vagrant rsync.

# Updating the docker base images for LEMP and PROXY

This makes the nginx configuration, system files, vendor libs etc built by the buildpack available for use in the local dev vm.

## On dokku host

Set the docker images to base the update on (replace with the appropriate deployed app names to base the future local dev container images on):

    export LEMP_APP=feature_cmsint-155-produce-pages-pu-cms-clean-db
    export PROXY_APP=feature_cms-1023-friends-base-url-proxy-abc1234-clean-db

Make sure the containers are running on the current dokku host:

    docker ps | grep ${LEMP_APP}
    docker ps | grep ${PROXY_APP}

Tag and push cms docker lemp app:

    export CONTAINER_ID=`docker ps | grep dokku/${LEMP_APP}:latest | awk '{print $1}'`

    docker commit $CONTAINER_ID fooproject/cms:${LEMP_APP}
    # todo - strip away existing config since it contains secrets
    docker push fooproject/cms

Tag and push cms docker proxy app:

    export PROXY_CONTAINER_ID=`docker ps | grep dokku/${PROXY_APP}:latest | awk '{print $1}'`

    docker commit $PROXY_CONTAINER_ID fooproject/proxy:${PROXY_APP}
    docker push fooproject/proxy

## In local dev vm config

Update the docker image tag in `scripts/variables.inc.sh` to the one(s) you just pushed above.

# Using the vagrant configuration to deploy containers on a remote host

TODO: This section is not finished nor tested at the moment, pull requests are welcome.

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
