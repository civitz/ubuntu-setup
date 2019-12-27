#!/bin/bash
set -e
set -u
set -x

echo "checking for root"

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

echo "update apt"
sudo apt-get update

echo "install generic utilities"
apt install -y \
	git \
	vim \
	zip \
	unzip \
	byobu \
	zsh


## this section is copied from docker setup
echo "remove older versions of docker if present"
sudo apt remove -y docker docker-engine docker.io containerd runc

echo "install pre-requisites for docker"
sudo apt install -y\
   	apt-transport-https \
   	ca-certificates \
   	curl \
   	gnupg-agent \
   	software-properties-common

echo "import docker gpg key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

echo "checking saved key"
sudo apt-key fingerprint 0EBFCD88

echo "adding docker repo"
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

echo "update apt"
sudo apt update

echo "install docker"
sudo apt install -y docker-ce docker-ce-cli containerd.io

echo "verify hello world"
sudo docker run hello-world
