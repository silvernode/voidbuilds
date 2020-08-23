#!/bin/bash
echo "========================="
echo "| RPI3 XFCE VOID AARCH64  |"
echo " ------------------------"

CURRENT=https://mirrors.servercentral.com/voidlinux/current/aarch64
NONFREE=https://mirrors.servercentral.com/voidlinux/current/aarch64/nonfree

FILENAME="void-rpi3"
DATE=$(date +%Y%m%d)
BUILDDIR="$(pwd)/build"

retry=0
 Run command with set architechure, repos and package list
until [ -f ${FILENAME}-xfce-unofficial-${DATE}.img ];do

    ((retry++))
    if [[ $retry -eq 2 ]];then
        break
    fi
	echo "MKROOTFS"
	sudo ./mkrootfs.sh -o ${FILENAME}-ROOTFS-${DATE}.tar.xz aarch64
	
	echo "MKPLATFORMFS"

    sudo ./mkplatformfs.sh \
        -r "${CURRENT}" \
        -r "${NONFREE}" \
        -p "$(grep '^[^#].' rpi3-xfce-aarch64.packages)" \
        -o ${FILENAME}-PLATFORMFS-${DATE}.tar.xz rpi3 ${FILENAME}-ROOTFS-${DATE}.tar.xz
	echo "MKIMAGE"
    sudo ./mkimage.sh -o ${FILENAME}-xfce-unofficial-${DATE}.img ${FILENAME}-PLATFORMFS-${DATE}.tar.xz
    
done

 Make sure resulting ISO exists and sent error to webpage if not
if [ ! -f ${FILENAME}-xfce-unofficial-${DATE}.img ];then   
        echo "Error: ${FILENAME}-xfce-unofficial-${DATE}.img : does not exist! Aborting!"
        echo "ERR=1" > error-status.txt
        exit 1
fi

# Add iso file to checksum list
${FILENAME}-xfce-unofficial-${DATE}.img >> sha256sums.txt



# Check if checksum file exists, send error to webpage if not
if [ ! -f sha256sums.txt ];then
    echo "Missing checksum file, aborting!"
    echo "ERR=1" > error-status.txt
    exit 1
fi

# make sure build directory exists and create it if not
if [ ! -d "${BUILDDIR}" ];then
    mkdir ${BUILDDIR}
fi

# Move the iso file to the build directory
mv ${FILENAME}-xfce-unofficial-${DATE}.img build
