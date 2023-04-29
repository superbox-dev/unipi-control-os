#!/bin/bash

DEVICE_OVERLAY="$(findfs PARTUUID=20230403-05)"
mount -t ext4 -o defaults,noatime,commit=30 "$DEVICE_OVERLAY" /mnt/overlay

function setup_overlay() {
  mkdir -p "/mnt/overlay/$1"
  mkdir -p "/mnt/overlay/$2"

  mount overlay -t overlay \
    -o "lowerdir=/$1,upperdir=/mnt/overlay/$1,workdir=/mnt/overlay/$2" "/$1"
}

setup_overlay "etc" ".work-etc"
setup_overlay "home" ".work-home"
setup_overlay "opt/unipi" ".work-opt-unipi"
setup_overlay "root" ".work-root"
setup_overlay "usr/local" ".work-usr-local"
setup_overlay "var" ".work-var"

exec /sbin/init
