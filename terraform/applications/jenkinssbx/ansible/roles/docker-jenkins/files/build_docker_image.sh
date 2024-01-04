#!/bin/bash
cd /home/ubuntu
# generate the Ansible SSH keypair if it doesn't exist
if [ ! -f './jenkins_ansible_key' ] ; then
    ssh-keygen -f jenkins_ansible_key -q -N ""
fi
#export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
#sudo chown ubuntu:ubuntu $DOCKER_HOST
/usr/bin/docker build -t jenkins/jenkins-ansible:latest .