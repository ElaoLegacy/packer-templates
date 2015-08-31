#!/bin/bash

apt-get update
apt-get -y install openssh-server
mkdir -p /var/run/sshd
