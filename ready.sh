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

