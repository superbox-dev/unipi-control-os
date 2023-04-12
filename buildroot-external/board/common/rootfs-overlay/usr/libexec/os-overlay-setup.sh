#! /bin/bash

set -e

OVERLAY="/mnt/overlay"
ETC="${OVERLAY}/etc"
SSH="${ETC}/ssh"
DOCKER="${ETC}/docker"
SYSTEMD="${ETC}/systemd"
NETWORK="${SYSTEMD}/network"

mkdir -p $ETC
mkdir -p $SSH
mkdir -p $NETWORK

if [ ! -f "${ETC}/hostname" ]; then
  cp -fp /etc/hostname "${ETC}/hostname"
fi

if [ ! -f "${ETC}/hosts" ]; then
  cp -fp /etc/hosts "${ETC}/hosts"
fi

if [ ! -d ${DOCKER} ]; then
  cp -rfp /etc/docker ${DOCKER}
fi

if [ ! -f "${SYSTEMD}/timesyncd.conf" ]; then
  cp -fp /etc/systemd/timesyncd.conf "${SYSTEMD}/timesyncd.conf"
fi

if [ ! -f "${NETWORK}/20-wired.network" ]; then
  cp -fp /etc/systemd/network/20-wired.network "${NETWORK}/20-wired.network"
fi

if [ ! -f "${NETWORK}/25-wireless.network" ]; then
  cp -fp /etc/systemd/network/25-wireless.network "${NETWORK}/25-wireless.network"
fi
