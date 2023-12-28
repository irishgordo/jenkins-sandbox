#!/usr/bin/bash

# if file /tmp/temp_known_hosts exists, delete it
if [ -f /tmp/temp_known_hosts ] ; then
    rm /tmp/temp_known_hosts
fi
touch /tmp/temp_known_hosts