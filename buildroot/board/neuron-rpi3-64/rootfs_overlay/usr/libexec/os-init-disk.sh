#! /bin/sh

/sbin/parted /dev/mmcblk0 resizepart 3 100% || exit 0
#/sbin/mkfs.ext4 /dev/mmcblk0p3 || exit 0

#/sbin/resize2fs /dev/mmcblk0p2 || exit 0

