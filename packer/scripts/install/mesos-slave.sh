#!/bin/bash

apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF

echo "deb http://repos.mesosphere.com/ubuntu trusty main" | \
  tee /etc/apt/sources.list.d/mesosphere.list

apt-get -y update
apt-get -y install openjdk-7-jre-headless mesos

# the Mesos package starts Mesos master and slave processes as well as Zookeper by default, this disables the master and Zookeeper
echo manual | tee /etc/init/mesos-master.override | tee /etc/init/zookeeper.override
