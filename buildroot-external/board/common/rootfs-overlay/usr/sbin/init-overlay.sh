#!/bin/sh

echo "TEST OVERLAY"

mount /dev/mmcblk0p5 /mnt/overlay
mkdir -pv /mnt/overlay/{etc,.work-etc}
mount -t overlay -o lowerdir=/etc,upperdir=/mnt/overlay/etc,workdir=/mnt/overlay/.work-etc overlay /etc

exec /sbin/init
