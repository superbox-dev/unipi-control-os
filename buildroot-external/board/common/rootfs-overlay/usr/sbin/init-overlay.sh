#!/bin/bash
# shellcheck disable=SC2155

set -u
set -e

function fail() {
	echo -e "$1"
	/bin/bash
}

CHROOT=/mnt
OVERLAY_DEVICE=/dev/mmcblk0p5

mount -t proc proc /proc
mount -t tmpfs inittemp "${CHROOT}"

if [ $? -ne 0 ]; then
  fail "ERROR: could not create a temporary filesystem to mount the base filesystems for overlayfs"
fi

function setup_chroot() {
  local root_device=$(awk '$2 == "/" {print $1}' /proc/mounts)
  local root_mount_opt=$(awk '$2 == "/" {print $4}' /proc/mounts)
  local root_fs_type=$(awk '$2 == "/" {print $3}' /proc/mounts)

  mount -t ${root_fs_type} -o ${root_mount_opt} ${root_device} "${CHROOT}"
  if [ $? -ne 0 ]; then
    fail "ERROR: could not mount original root partition"
  fi

  mount -t ext4 -o defaults,noatime,commit=30 $OVERLAY_DEVICE "${CHROOT}/overlay"
  if [ $? -ne 0 ]; then
    fail "ERROR: could not mount overlay partition"
  fi
}

function setup_overlay() {
  mkdir -p "${CHROOT}/overlay/$1"
  mkdir -p "${CHROOT}/overlay/$2"

  mount overlay -t overlay -o "lowerdir=/$1,upperdir=${CHROOT}/overlay/$1,workdir=${CHROOT}/overlay/$2" "${CHROOT}/$1"
  if [ $? -ne 0 ]; then
    fail "ERROR: could not mount overlayFS for $1"
  fi
}

setup_chroot

setup_overlay "etc" ".work-etc"
setup_overlay "home" ".work-home"
setup_overlay "opt/unipi" ".work-opt-unipi"
setup_overlay "root" ".work-root"
setup_overlay "usr/local" ".work-usr-local"
setup_overlay "var" ".work-var"

cd "${CHROOT}"
pivot_root . ./
exec chroot . /sbin/init
