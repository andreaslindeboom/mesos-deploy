#!/bin/bash

apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF

echo "deb http://repos.mesosphere.com/ubuntu trusty main" | \
  tee /etc/apt/sources.list.d/mesosphere.list

apt-get -y update
apt-get -y install openjdk-7-jre-headless mesos

# the Mesos package starts both a master and a slave process on boot by default, this disables the master
echo manual | tee /etc/init/mesos-master.override
