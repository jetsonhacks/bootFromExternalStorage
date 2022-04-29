#!/bin/bash

# 
# MIT License
# Copyright (c) 2021, JetsonHacks
# Install the dependencies required to flash Jetson
#

# Sanity warning; Make sure we're not running from a Jetson
# First check to see if we're running on Ubuntu
# Next, check the architecture to make sure it's x86, not a Jetson
if [ -f /etc/os-release ]; then
  if [[ ! $( grep Ubuntu < /etc/os-release ) ]] ; then
    echo 'WARNING: This does not appear to be an Ubuntu machine. The script is targeted for Ubuntu, and may not work with other distributions.'
    read -p 'Continue with installation (Y/n)?' answer
    case ${answer:0:1} in
       y|Y )
         echo Yes
       ;;
       * )
         exit
       ;;
    esac
    
  else
    if [ $(arch) == 'aarch64' ]; then
      echo 'This script must be run from a x86 host machine'
      if [ -f /etc/nv_tegra_release ]; then
	 echo 'A aarch64 Jetson cannot be the host machine'
      fi
      exit
    fi
  fi
else
    echo 'WARNING: This does not appear to be an Ubuntu machine. The script is targeted for Ubuntu, and may not work with other distributions.'
    read -p 'Continue with installation (Y/n)?' answer
    case ${answer:0:1} in
       y|Y )
         echo Yes
       ;;
       * )
         exit
       ;;
    esac
fi

# Install dependencies
sudo apt update -y
sudo apt install libxml2-utils network-manager abootimg sshpass device-tree-compiler -y
# Previous to 18.04, simg2img was in android-tools-fsutils
if [[ $(lsb_release -rs) == "16.04" ]] ; then
  sudo apt install android-tools-fsutils -y
else
  sudo apt install simg2img qemu-user-static -y
fi

# Install dependency for secure boot
sudo apt install openssh-server -y

