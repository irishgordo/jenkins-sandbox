#!/bin/bash

# generate the Ansible SSH keypair if it doesn't exist
if [ ! -f './jenkins_ansible_key' ] ; then
    ssh-keygen -f jenkins_ansible_key
fi
docker build -t jenkins/jenkins-ansible:latest .