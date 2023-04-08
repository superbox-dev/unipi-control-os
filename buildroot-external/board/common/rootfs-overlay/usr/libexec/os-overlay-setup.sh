#! /bin/sh

set -e

OVERLAY="/mnt/overlay"
ETC="${OVERLAY}/etc"
DOCKER="${OVERLAY}/etc/docker"
SYSTEMD="${OVERLAY}/etc/systemd"
NETWORK="${SYSTEMD}/network"
HOME="${OVERLAY}/home"
LOG="${OVERLAY}/var/log"

mkdir -p $ETC
mkdir -p $HOME
mkdir -p $NETWORK
mkdir -p $LOG

if [ ! -f "${ETC}/hostname" ]; then
  cp -fp /etc/hostname "${ETC}/hostname"
fi

if [ ! -f "${ETC}/hosts" ]; then
  cp -fp /etc/hosts "${ETC}/hosts"
fi

if [ ! -d ${DOCKER} ]; then
  cp -fp /etc/docker "${DOCKER}/"
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

if [ ! -d $HOME ]; then
  cp -rfp /home "${OVERLAY}/"
fi
