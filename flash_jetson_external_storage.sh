#!/bin/bash
#MIT License
#Copyright (c) 2021 Jetsonhacks

# Flash Jetson Xavier to run from external storage

# Sanity warning; Make sure we're not running from a Jetson
# First check to see if we're running on Ubuntu
# Next, check the architecture to make sure it's x86, not a Jetson

JETSON_FOLDER=R32.7.1
LINUX_FOR_TEGRA_DIRECTORY="$JETSON_FOLDER/Linux_for_Tegra"

function help_func
{
	echo "Usage: ./flash_jetson_external_storage [OPTIONS]"
	echo "   No option flashes to nvme0n1p1 by default"
	echo "   -s | --storage - Specific storage media to flash; sda1 or nvme0n1p1"
	echo "   -h | --help - displays this message"
}

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

if [[ ! -d $LINUX_FOR_TEGRA_DIRECTORY ]] ; then
   echo "Could not find the Linux_for_Tegra folder."
   echo "Please download the Jetson sources and ensure they are in $JETSON_FOLDER/Linux_for_Tegra"
   exit 1
fi

function check_board_setup
{
  cd $LINUX_FOR_TEGRA_DIRECTORY
  echo $PWD
  # Check to see if we can see the Jetson
  echo "Checking Jetson ..."

  FLASH_BOARDID=$(sudo ./nvautoflash.sh --print_boardid)
  if [ $? -eq 1 ] ; then
    # There was an error with the Jetson connected
    # It may not be detectable, be in force recovery mode
    # Or there may be more than one Jetson in FRM 
    echo "$FLASH_BOARDID" | grep Error
    echo "Make sure that your Jetson is connected through"
    echo "a USB port and in Force Recovery Mode"
    exit 1
  else
    if [[ $FLASH_BOARDID == *"jetson-agx-xavier-devkit"* ]] || [[ $FLASH_BOARDID == *"jetson-xavier-nx-devkit"* ]] ; then
      echo "$FLASH_BOARDID" | grep found
      if [[ $FLASH_BOARDID == *"jetson-xavier-nx-devkit"* ]] ; then
        read -p "Make sure the SD card and the force recovery jumper are removed. Continue (Y/n)?" answer
        case ${answer:0:1} in
          y|Y )
          ;;
          * )
          echo 'You need to remove the force recovery jumper before flashing.'
          exit 1
          ;;
        esac
      fi
    else
      echo "$FLASH_BOARDID" | grep found
      echo "ERROR: Unsupported device."
      echo "This method currently only works for the Jetson AGX Xavier"
      echo "and Jetson Xavier NX Development Kits."
      exit 1
   fi
 fi
}

# If Ubuntu 20.04, /usr/bin/python may not be set
# The NV flash script uses this symlink to point to Python
SCRIPT_SET_PYTHON=false


# In Ubuntu 20.04, the symbolic link /usr/bin/python is not set
# The NV scripts use that link to determine the Python to use

function check_python_install
{
  if [[ $(lsb_release -rs) == "20.04" ]] ; then
    if [ ! -L "/usr/bin/python" ] ; then
      echo "Setting Python"
      # This will show some warnings from the NV scripts
      # The NV scripts are for Python 2
      sudo apt install python-is-python3
      SCRIPT_SET_PYTHON=true
    fi 
  fi
} 

# Made it this far, we're ready to start the flashy bit
# Before we flash, we need to shutdown the udisks2 service
# Check to see if it is running
UDISKS2_ACTIVE=$(sudo systemctl is-active udisks2.service)

trap cleanup 1 2 3 6

cleanup()
{
  if [[ ${UDISKS2_ACTIVE} == 'active' ]] ; then
   sudo systemctl start udisks2.service
  fi
  if [ "$SCRIPT_SET_PYTHON" == true ] ; then
    echo "Unset python"
    sudo apt remove python-is-python3
  fi
  exit
}


function flash_jetson
{
  local storage=$1
  check_board_setup
  check_python_install
  if [[ $(lsb_release -rs) == "20.04" ]] ; then
    export LC_ALL=C.UTF-8
  fi 
  # Turn off USB mass storage during flashing
  sudo systemctl stop udisks2.service
  
  # Now do the heavy lifting and flash the Jetson
  echo "Flashing to $storage"
  echo $storage
  sudo ./nvsdkmanager_flash.sh --storage "${storage}"

  # Restart the udisks2 service if it was running when the script was called
  cleanup
}

# Parse command line arguments
storage_arg="nvme0n1p1"

# If no arguments, assume nvme
if [  "$1" == "" ]; then
  flash_jetson "${storage_arg}"
  exit 0
fi 

while [ "$1" != "" ];
do
   case $1 in
	-s | --storage )
		shift
		storage_arg=$1
		flash_jetson "${storage_arg}"
		exit 0;
		;;
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

