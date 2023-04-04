#! /bin/sh

#/sbin/parted /dev/mmcblk0 resizepart 2 50% || exit 0
#/sbin/parted /dev/mmcblk0 mkpart primary 50% 100% || exit 0
#/sbin/resize2fs /dev/mmcblk0p2 || exit 0

