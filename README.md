# bootFromExternalStorage
Shell scripts to setup a NVIDIA Jetson AGX Xavier or Jetson Xavier NX Developer Kit to boot from external storage.

JetPack 4.6, L4T 32.6.1

# Work In Progress

With the advent of JetPack 4.6, The NVIDIA Jetson Xavier Developer Kits can now boot directly from external storage. 
There are four scripts here to help with this process.

The host machine here references a x86 based machine running Ubuntu distribution 16.04 or 18.04.

### get_jetson_files.sh
Downloads the Jetson BSP and rootfs for the Xavier Dev Kits. This must be run on the host machine.

### install_dependencies.sh
Install dependencies for flashing the Jetson. This must be run on the host machine.

### flash_jetson_external_storage.sh
Flashes the Jetson attached to the host via a USB cable. This script must be run on the host machine. The Jetson must be in Force Recovery Mode.
You flash to external storage attached to the Jetson, either NVMe or USB. Default is NVMe. Both the AGX Xavier and Xavier NX 
Developer Kits have M2.Key M slots which accept NVMe SSDs. 
```
Usage: ./flash_jetson_external_storage [OPTIONS]
  No option flashes to nvme0n1p1 by default
  -s | --storage - Specific storage media to flash; sda1 or nvme0n1p1
  -h | --help    - displays this message
```
 
 ### install_jetson_default_packages.sh
 Once the script flash_jetson_external_storage completes, the Jetson is ready to install the default JetPack packages. This script is for the Jetson. You will need to either download the script or clone this repository on the Jetson itself. The Jetson must be connected to the Internet.
 
 The script will install the metapackage nvida-jetpack which in turn installs the following metapackages:
 
 * nvidia-cuda
 * nvidia-cudnn8
 * nvidia-tensorrt
 * nvidia-visionworks
 * nvidia-vpi
 * nvidia-l4t-jetson-multimedia-api
 * nvidia-opencv
 
 There are also some other packages installed, so that the configuration matches that of the default SD Card installation. These include:
 
 * libtbb-dev
 * uff-converter-tf
 * python3-vpi1
 * python3-libnvinfer-dev
 * Various Python2.7 support files

As usual, configure these to your liking.

## Release Notes

### August 2021
* Initial Release
* JetPack 4.6
* L4T 32.6.1

