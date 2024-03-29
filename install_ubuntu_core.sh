#!/bin/bash -e

# install Ubuntu packages
sudo apt-get update -yq
sudo apt-get install -yq --no-install-recommends \
  curl \
  ca-certificates \
  gnupg \
  git \
  git-lfs \
  vim \
  tmux \
  htop \
  keychain \
  rsync \
  locales \
  python3-dev

sudo rm -rf /var/lib/apt/lists/*

# locale setup
sudo locale-gen en_US.UTF-8
sudo update-locale LANG=en_US.UTF-8

# time zone setup
sudo timedatectl set-timezone Asia/Tokyo  # "Europe/London"
timedatectl

# git setup
git config --global user.name "Petras Petroskevicius"
git config --global user.email "p.petroskevicius@gmail.com"
git config --list

echo "[ ] completed in t=$SECONDS"
