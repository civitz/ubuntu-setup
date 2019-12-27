#!/bin/bash
#set -e
set -u

TRUE=0
FALSE=1

aptupdated=$FALSE

echo "checking for root"

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

function confirm () {
	echo -n ${1}
	read -p "? (Y/n) " -n 1 -r
	echo    # (optional) move to a new line
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		# do dangerous stuff
		return $TRUE
	else
		return $FALSE
	fi
}

apt_update () {
	if [ $aptupdated -eq $FALSE ]
	then
		echo "update apt"
		sudo apt update
		aptupdated=$TRUE
	else
		echo "apt up-to-date"
	fi
}

install_utils () {
	echo "install generic utilities"
	apt_update
	apt install -y \
		vim \
		byobu \
		zsh \
		curl
}

install_git () {
	apt_update
	apt install -y git git-cola
	got_alias=$(cat ~/.gitconfig | grep -q lg1)
	if [[ $got_alias -eq 1 ]]
	then
		echo "install git aliases for pretty logging"
		curl https://gist.githubusercontent.com/civitz/305d7a61d5f7236aa13c2bfc46a877c1/raw/2ccd97fd9210dffa90ca9aad1f6cd1154f83245a/gitconfig.sh >> ~/.gitconfig
	else
		echo "git aliases already installed"
	fi
}


install_docker () {
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
}

confirm "install utils"
if [ $? = $TRUE ]; then
	install_utils
fi

confirm "install git"
if [ $? = $TRUE ]; then
	install_git
fi

confirm "install docker"
if [ $? = $TRUE ]; then
	install_docker
fi