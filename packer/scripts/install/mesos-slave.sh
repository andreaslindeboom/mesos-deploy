#!/bin/bash

apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF

echo "deb http://repos.mesosphere.com/ubuntu vivid main" | \
  tee /etc/apt/sources.list.d/mesosphere.list

apt-get -y update
apt-get -y install mesos

# the Mesos package starts Mesos master and slave processes as well as Zookeper by default, this disables the master and Zookeeper
systemctl disable mesos-master
echo manual | tee /etc/init/zookeeper.override
