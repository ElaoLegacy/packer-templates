#!/bin/bash

apt-get update
apt-get -y install python-pycurl
apt-get -y install python-dev libyaml-dev libgmp-dev python-pip
pip install ansible
apt-get -y --purge autoremove python-dev libyaml-dev libgmp-dev python-pip
apt-get -y --purge autoremove build-essential
apt-get -y --purge autoremove dpkg-dev
apt-get -y --purge autoremove fakeroot
