#! /bin/sh

set -e

mkdir -p /mnt/overlay/etc/

if [ ! -f /mnt/overlay/etc/hostname ]; then
  cp -fp /etc/hostname /mnt/overlay/etc/hostname
fi

if [ ! -f /mnt/overlay/etc/hosts ]; then
  cp -fp /etc/hosts /mnt/overlay/etc/hosts
fi

if [ ! -f /mnt/overlay/etc/systemd/timesyncd.conf ]; then
  mkdir -p /mnt/overlay/etc/systemd
  cp -fp /etc/systemd/timesyncd.conf /mnt/overlay/etc/systemd/timesyncd.conf
fi
