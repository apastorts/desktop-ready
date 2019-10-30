#!/bin/bash

SYSTEM="$1"

if [ "${SYSTEM}" = "" ]; then
  echo "Please introduce repository (ubuntu/fedora)"
  exit 0
fi

echo "Installing Basics"
if [ "${SYSTEM}" = "fedora" ]; then
  sudo dnf install -y git curl wget
else
  sudo apt-get install -y git curl wget
fi
echo "Installing Docker"
echo "Removing old versions of docker..."

if [ "${SYSTEM}" = "fedora" ]; then
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

if [ "${SYSTEM}" = "fedora" ]; then
  sudo dnf -y install dnf-plugins-core
  sudo dnf config-manager \
    --add-repo \
    https://download.docker.com/linux/fedora/docker-ce.repo
  sudo dnf install -y docker-ce docker-ce-cli containerd.io

  echo "Installing Docker Compose"
  sudo dnf install docker-compose
  sudo systemctl start docker
else
  sudo ${OS} update \
    && ${OS} install -y \
         apt-transport-https \
         ca-certificates \
         curl git htop wget zcat \
         software-properties-common

  echo "Adding Docker Keys"
  $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

  echo "Installing Docker Compose"
  sudo apt-get update \
  && sudo apt-get install -y docker-ce
  sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
fi

echo "Adding user to docker group"
sudo usermod -a -G docker $(whoami)

echo "Installing php"

if [ "${SYSTEM}" = "fedora" ]; then
  sudo dnf install php php-common php-mysqlnd php-xml php-json php-gd php-mbstring
else
  sudo dnf install php php-fpm php-mysqlnd php-xml php-json php-gd php-mbstring
fi

echo "Installing Composer"

cd
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'a5c698ffe4b8e849a443b120cd5ba38043260d5c4023dbf93e1558871f1f07f58274fc6f4c93bcfd858c6bd0775cd8d1') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php --install-dir=/usr/local/bin
php -r "unlink('composer-setup.php');"

echo "Installing Atom IDE"

if [ "${SYSTEM}" = "fedora" ]; then
  cd
  wget https://atom.io/download/rpm -O atom.rpm
  sudo dnf install ./atom.rpm
else
  sudo add-apt-repository ppa:webupd8team/atom
  sudo apt-get update
  sudo apt-get install -y atom
fi