#!/bin/bash

if grep -q rauc.slot=A /proc/cmdline; then
  RAUC_SLOT_NO=0
  RAUC_SLOT_NAME=A
elif grep -q rauc.slot=B /proc/cmdline; then
  RAUC_SLOT_NO=1
  RAUC_SLOT_NAME=B
fi

CHROOT=/mnt/rootfs
SYSTEM_DEVICE=$(sed -n "/\[slot\.system\.${RAUC_SLOT_NO}\]/,/\[.*\]/{/^device=/s/\(.*\)=\(.*\)/\\2/p}" /etc/rauc/system.conf)
OVERLAY_DEVICE=/dev/mmcblk0p5

function mount_devices() {
  mount $SYSTEM_DEVICE /mnt/rootfs
  mount -o defaults,noatime,commit=30 $OVERLAY_DEVICE "${CHROOT}/overlay"

  mount -t proc /proc "${CHROOT}/proc"
  mount --rbind /sys "${CHROOT}/sys"
  mount --rbind /dev "${CHROOT}/dev"
}

function setup_overlay() {
  mkdir -p "${CHROOT}/overlay/$1"
  mkdir -p "${CHROOT}/overlay/$2"

  mount overlay -t overlay \
    -o "lowerdir=/$1,upperdir=${CHROOT}/overlay/$1,workdir=${CHROOT}/overlay/$2" "${CHROOT}/$1"
}

mount_devices

setup_overlay "etc" ".work-etc"
setup_overlay "home" ".work-home"
setup_overlay "opt/unipi" ".work-opt-unipi"
setup_overlay "root" ".work-root"
setup_overlay "usr/local" ".work-usr-local"
setup_overlay "var" ".work-var"

exec chroot "${CHROOT}" /sbin/init
