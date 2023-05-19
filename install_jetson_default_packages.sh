#!/bin/bash
# MIT License
# Copyright (c) 2021-23 Jetsonhacks

#
# Run this script on the Jetson after flashing.
# This script installs the additional packages that are on the default SD card image for this JetPack release
#

# First check to see if we're on a Jetson

if [ $(arch) == 'aarch64' ]; then
  if [ ! -f /etc/nv_tegra_release ]; then
    echo 'This script must be run from on a NVIDIA Jetson'
    echo 'This machine does not appear to meet that requirement'
    exit
  fi
else
  echo 'This script must be run from on a NVIDIA Jetson'
  echo 'This machine does not appear to meet that requirement'
  exit
fi

# Now install the packages
sudo apt update
sudo apt-get install \
 nvidia-jetpack \
 python3-vpi1 \
 python3-libnvinfer-dev \
 python2.7-dev \
 python-dev \
 python-py \
 python-attr \
 python-funcsigs \
 python-pluggy \
 python-pytest \
 python-six \
 uff-converter-tf \
 libtbb-dev

# nvidia-jetpack installs these packages:
# nvidia-cuda
# nvidia-opencv
# nvidida-cudnn8
# nvidia-tensorrt
# nvidia-visionworks
# nvidia-container
# nvidia-vpi
# nvidia-l4t-jetson-multimedia-api


