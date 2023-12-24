# bootFromExternalStorage
<b>These scripts were written before there was official support in the NVIDIA SDK Manager for booting from external storage. The NVIDIA SDK Manager is a tool used to flash and configure the Jetson. You may prefer to use the SDK Manager instead of these scripts. To get started with SDK Manager: https://developer.nvidia.com/nvidia-sdk-manager</b>

Shell scripts to setup a NVIDIA Jetson Xavier or Orin (AGX, NX, Nano models) to boot from external storage.

Support code for the video and article: [**Native Boot for Jetson Xaviers**](https://www.jetsonhacks.com/2021/08/25/native-boot-for-jetson-xaviers/)

_** JetPack 4.6+ releases are in the jetpack-4 branch **_

**Please read the Issues section below before proceeding**

Installs JetPack 5.1.2, L4T 35.4.1 on the Jetson Developer Kit

The NVIDIA Jetson Xavier and Orins can boot directly from external storage. 
There are four scripts here to help with this process.

The host machine here references a x86 based machine running Ubuntu distribution 18.04, 20.04 or 22.04. To flash a Jetson Developer Kit using this method, the host machine builds a disk image. The host then flashes the disk image to the Jetson. 

_**Warning for the Jetson Xavier NX and AGX Xavier:** There is an issue with the USB stack. You cannot boot from USB on these systems._

_**Note for the Jetson Xavier NX:** For a Jetson AGX Xavier system, the board must be initially flashed to eMMC before using this method._

_**Note for the Jetson Xavier NX:** Remove the SD card for this process. Also, there is flash memory onboard the Xavier NX module, QSPI-Nor.  This script flashes the QSPI memory in addition to the disk image._

_**Note for the Jetson Orin Nano and Orin NX:** There is flash memory onboard the Orin modules, QSPI-Nor.  This script flashes the QSPI memory in addition to the disk image._

Around 40GB of free space is needed on the host for these scripts and Jetson disk image files. More is better.


## WARNING
This process will format the external storage attached to the Jetson that you specify. Existing data on that drive will not be recoverable.

On the host machine, follow this sequence:
1. `get_jetson_files.sh` - Downloads the Jetson BSP and sample rootfs, copies NVIDA user space libraries to rootfs. Also installs dependencies needed to flash the Jetson.
2. `flash_jetson_external_storage.sh` - Flash the Jetson (make sure that the Jetson is connected via USB, external storage is attached to the Jetson and that the Jetson is in Force Recovery Mode)

Once the Jetson is flashed, switch to the Jetson. Go through the standard oem-config procedure. On the Jetson, from this repository run the script `install_jetson_default_packages.sh` to install the standard JetPack packages. See below for a detailed list of packages that will be installed.

## Scripts

### get_jetson_files.sh
Downloads the Jetson BSP and rootfs for the Xavier/Orin Dev Kits. This script must be run on the host machine.

### install_dependencies.sh
Install dependencies for flashing the Jetson. This script must be run on the host machine. This is done by get_jetson_files.sh, but is added here as legacy.

### flash_jetson_external_storage.sh
Flashes the Jetson attached to the host via a USB cable. This script must be run on the host machine. The Jetson must be in Force Recovery Mode.
The script prepares external storage attached to the Jetson, either NVMe, USB or SD Card. Default is NVMe as the Orin and Xaviers have M.2 Key M slots which accept NVMe SSDs. The SSDs must be PCIE, SATA does not work. For the Xavier NX and Orin NX and Orin Nano, this flashes the QSPI memory on the Jetson module.
```
Usage: ./flash_jetson_external_storage [OPTIONS]
  No option flashes to nvme0n1p1 by default
  -s | --storage - Specific storage media to flash; sda1, nvme0n1p1 or mmcblk1p1
  -h | --help    - displays this message
```
 
 ### install_jetson_default_packages.sh
 Once the script flash_jetson_external_storage script completes, the Jetson is ready for setup. First, configure the Jetson through the standard oem-config process. Then you are ready to install the default JetPack packages using this script.  You will need to either download the script or clone this repository on the Jetson itself. The Jetson must be connected to the Internet.
 
 Executing the script will install the metapackage nvida-jetpack which in turn installs the following metapackages:
 
 * nvidia-cuda
 * nvidia-cudnn
 * nvidia-tensorrt
 * nvidia-visionworks
 * nvidia-vpi
 * nvidia-l4t-jetson-multimedia-api
 * nvidia-opencv
 
 The script installs other packages, to match the default SD Card installation. These include:
 
 * libtbb-dev
 * uff-converter-tf
 * python3-vpi1
 * python3-libnvinfer-dev
 * Various Python2.7 support files

## Issues
* Currently this works for NVMe storage; USB is exhibiting issues on the Xavier NX
* The Jetson AGX Xavier can be flashed using this method. However there appears to be an issue with oem-config running on first boot.

If oem-config does not run on first boot, you can create a default user:

`sudo ./tools/l4t_create_default_user.sh -u ubuntu -p ubuntu # this command create username ubuntu and password ubuntu`

on the host in the Linux_for_Tegra folder and reflash.

## Release Notes

### September 2023
* JetPack 5.1.2
* L4T 35.4.1
* Add support for Orin Nano Developer Kit
* Tested on Orin Nano, NVMe SSD
* Tested on x86 host running Ubuntu 20.04

### May 2023
* JetPack 5.1.1
* L4T 35.3.1
* Add support for Orin Nano Developer Kit
* Tested on Orin Nano, NVMe SSD
* Tested on x86 host running Ubuntu 20.04

### February 2023
* JetPack 5.1
* L4T 35.2.1
* JetPack 4.X are in the JetPack 4.x branch
* Tested on Xavier NX, NVMe SSD
* Tested on x86 host running Ubuntu 20.04

### August 2021
* Initial Release
* JetPack 4.6
* L4T 32.6.1
* Tested on Xavier NX, NVMe SSD
* Initial Host Ubuntu 20.04 support; 

#### Thanks!
* Thank you to @KyleLeneau for JetPack 5 initial support
* Thank you Ran @ranrubin for initial Ubuntu 20.04 support.
* Thank you Richard @RchGrav for pointing out the AGX typo in the flash script.
* Thank you Jack @jasilberman and Sergey @sskorol for pointing out a Python issue on Ubuntu 20.04
* Thank you Linh @anhmiuhv for guidance on issues encountered
* Thank you @diamandbarcode for testing

