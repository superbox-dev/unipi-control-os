#!/bin/sh

exec /bin/bash

mount -t proc proc /proc
mount -t ext4 -o defaults,noatime,commit=30 /dev/mmcblk0p5 /mnt/overlay

setup_overlay() {
  mkdir -p "/mnt/overlay/$1"
  mkdir -p "/mnt/overlay/$2"

  mount overlay -t overlay -o "lowerdir=/$1,upperdir=/mnt/overlay/$1,workdir=/mnt/overlay/$2" "/$1"
}

teardown_overlay() {
  umount /mnt/overlay
  umount /proc
}

setup_overlay "etc" ".work-etc"
setup_overlay "home" ".work-home"
setup_overlay "opt/unipi" ".work-opt-unipi"
setup_overlay "root" ".work-root"
setup_overlay "usr/local" ".work-usr-local"
setup_overlay "var" ".work-var"

teardown_overlay

exec /sbin/init
