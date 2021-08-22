# bootFromExternalStorage
Shell scripts to setup a NVIDIA Jetson AGX Xavier or Jetson Xavier NX Developer Kit to boot from external storage.

Installs JetPack 4.6, L4T 32.6.1 on the Jetson Developer Kit

With the advent of JetPack 4.6, The NVIDIA Jetson Xavier Developer Kits can now boot directly from external storage. 
There are four scripts here to help with this process.

The host machine here references a x86 based machine running Ubuntu distribution 16.04 or 18.04. To flash a Jetson Developer Kit using this method, the host machine builds a disk image. The host then flashes the disk image to the Jetson. 

_**Note for the Jetson Xavier NX:** No SD Card need be present for this process. Also, there is flash memory onboard the Xavier NX module, QSPI-Nor.  This script flashes the QSPI memory in addition to the disk image._

Around 34GB of free space is needed on the host for these scripts and Jetson disk image files.

Sequence on the host:
1. `install_dependencies.sh` - Installs dependencies needed for running the flash scripts
2. `get_jetson_files.sh` - Downloads the Jetson BSP and rootfs
3. `flash_jetson_external_storage.sh` - Flash the Jetson (make sure that the Jetson is connected via USB and in Force Recovery Mode)

Once the Jetson is flashed, switch to the Jetson and go through the standard oem-config procedure. Then from this repository run `install_jetson_default_packages.sh` to install the standard JetPack packages. See below for a list of packages that will be installed.

## Scripts

### get_jetson_files.sh
Downloads the Jetson BSP and rootfs for the Xavier Dev Kits. This script must be run on the host machine.

### install_dependencies.sh
Install dependencies for flashing the Jetson. This script must be run on the host machine.

### flash_jetson_external_storage.sh
Flashes the Jetson attached to the host via a USB cable. This script must be run on the host machine. The Jetson must be in Force Recovery Mode.
The script prepares external storage attached to the Jetson, either NVMe or USB. Default is NVMe as both the AGX Xavier and Xavier NX 
Developer Kits have M.2 Key M slots which accept NVMe SSDs. For the Xavier NX, this flashes the QSPI memory on the Jetson module.
```
Usage: ./flash_jetson_external_storage [OPTIONS]
  No option flashes to nvme0n1p1 by default
  -s | --storage - Specific storage media to flash; sda1 or nvme0n1p1
  -h | --help    - displays this message
```
 
 ### install_jetson_default_packages.sh
 Once the script flash_jetson_external_storage script completes, the Jetson is ready for setup. First, configure the Jetson through the standard oem-config process. Then you are ready to install the default JetPack packages using this script.  You will need to either download the script or clone this repository on the Jetson itself. The Jetson must be connected to the Internet.
 
 Executing the script will install the metapackage nvida-jetpack which in turn installs the following metapackages:
 
 * nvidia-cuda
 * nvidia-cudnn8
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

## Release Notes

### August 2021
* Initial Release
* JetPack 4.6
* L4T 32.6.1
* Tested on Xavier NX, NVMe SSD

