#!/bin/bash
OS="$1"

if [OS -eq ""]
then
  echo "Please introduce repository (ubuntu/fedora)"
  exit 0
fi

echo "Installing Docker"
echo "Removing old versions of docker..."

if [OS -eq "fedora"]
then
  sudo dnf remove -y docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine
else
  sudo ${OS} remove -y docker docker-engine docker.io
fi
echo "Getting new version of docker"

if [OS -eq "fedora"]
then
  sudo dnf -y install dnf-plugins-core
  sudo dnf config-manager \
    --add-repo \
    https://download.docker.com/linux/fedora/docker-ce.repo
  sudo dnf install -y docker-ce docker-ce-cli containerd.io

  echo "Installing Docker Compose"
  sudo dnf install docker-compose
