#! /bin/sh

set -e

mkdir -p /mnt/overlay/etc
mkdir -p /mnt/overlay/home

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

if [ ! -f /mnt/overlay/var/lib/NetworkManager ]; then
  cp -rfp /var/lib/NetworkManager/* /mnt/overlay/var/lib/NetworkManager
fi

if [ ! -f /mnt/overlay/home ]; then
  cp -rfp /home/* /mnt/overlay/home
fi

if [ ! -f /mnt/overlay/root ]; then
  cp -rfp /root/* /mnt/overlay/root
fi
