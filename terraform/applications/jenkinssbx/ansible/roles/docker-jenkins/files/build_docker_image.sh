#!/bin/bash

# generate the Ansible SSH keypair if it doesn't exist
if [ ! -f './jenkins_ansible_key' ] ; then
    ssh-keygen -f jenkins_ansible_key -q -N ""
fi
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
docker -H $DOCKER_HOST build -t jenkins/jenkins-ansible:latest .