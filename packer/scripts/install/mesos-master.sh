#!/bin/bash

apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF

echo "deb http://repos.mesosphere.com/ubuntu vivid main" | \
  tee /etc/apt/sources.list.d/mesosphere.list

apt-get -y update
apt-get -y install mesos

# the Mesos package starts both a master and a slave process on boot by default, this disables the slave
systemctl disable mesos-slave

# since upgrading to Ubuntu 15.04, Zookeeper needs to be enabled explicitly, likely because Zookeeper is still an upstart service
systemctl enable zookeeper
