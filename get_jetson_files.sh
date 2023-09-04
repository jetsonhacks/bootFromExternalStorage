#!/bin/bash
# Get the Jetson BSP and rootfs, then prepare for flashing

# 
# MIT License
# Copyright (c) 2021-23, JetsonHacks
#

# Sanity warning; Make sure we're not running from a Jetson
# First check to see if we're running on Ubuntu
# Next, check the architecture to make sure it's not aarch64, not a Jetson

JETSON_FOLDER=R35.4.1


function help_func
{
	echo "Usage: ./get_jetson_files.sh [OPTIONS]"
	echo "   -h | --help - displays this message"
}

if [ -f /etc/os-release ]; then
  if [[ ! $( grep Ubuntu < /etc/os-release ) ]] ; then
    echo 'WARNING: This does not appear to be an Ubuntu machine. The script is targeted for Ubuntu, and may not work with other distributions.'
    read -p 'Continue with installation (Y/n)? ' answer
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
  read -p 'Continue with installation (Y/n)? ' answer
  case ${answer:0:1} in
    y|Y )
      echo Yes
    ;;
    * )
      exit
    ;;
  esac
fi

while [ "$1" != "" ];
do
   case $1 in
 	-h | --help )
		help_func
		exit
	  ;;
	* )
		echo "*** ERROR Invalid flag"
		help_func
		exit
	   ;;
	esac
	shift
done


echo 'Ready to download!'
mkdir $JETSON_FOLDER
cd $JETSON_FOLDER

# Made it this far, we're ready to start the downloads

# Get the 35.4.1 Tegra system
# Get the L4T Driver Package - BSP
wget -N https://developer.nvidia.com/downloads/embedded/l4t/r35_release_v4.1/release/jetson_linux_r35.4.1_aarch64.tbz2
# Get the Sample Root File System (rootfs)
wget -N https://developer.nvidia.com/downloads/embedded/l4t/r35_release_v4.1/release/tegra_linux_sample-root-filesystem_r35.4.1_aarch64.tbz2

# Unpack the files, creating the Linux_for_Tegra folder
sudo tar -xpvf jetson_linux_r35.4.1_aarch64.tbz2

cd Linux_for_Tegra/rootfs/
sudo tar -xpvf ../../tegra_linux_sample-root-filesystem_r35.4.1_aarch64.tbz2
cd ../..
cd Linux_for_Tegra/

if [[ $(lsb_release -rs) == "20.04" ]] ; then
  export LDK_ROOTFS_DIR=$PWD
fi
if [[ $(lsb_release -rs) == "22.04" ]] ; then
  export LDK_ROOTFS_DIR=$PWD
fi

# Copy NVIDIA user space libraries into target file system
sudo ./apply_binaries.sh
# Install the prerequisite dependencies for flashing
sudo ./tools/l4t_flash_prerequisites.sh
