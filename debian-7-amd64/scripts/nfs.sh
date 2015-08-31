#!/bin/bash

# Install nfs & enable cache
apt-get -y install nfs-common cachefilesd
sed -i 's/#RUN/RUN/' /etc/default/cachefilesd
