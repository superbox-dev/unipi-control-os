#! /bin/bash

set -e

OVERLAY="/mnt/overlay"
ETC="${OVERLAY}/etc"
SSH="${ETC}/ssh"
DOCKER="${ETC}/docker"
SYSTEMD="${ETC}/systemd"
NETWORK="${SYSTEMD}/network"

overlay_paths=(
  "$ETC"
  "$SSH"
  "$NETWORK"
)

file_names=(
  "hostname"
  "hosts"
  "passwd"
  "group"
  "shadow"
  "${SYSTEMD}/timesyncd.conf"
  "${NETWORK}/20-wired.network"
  "${NETWORK}/25-wireless.network"
)

for overlay_path in "${overlay_paths[@]}"; do
  mkdir -p "${overlay_path}"
done

for file_name in "${file_names[@]}"; do
  if [ ! -f "/etc/${file_name}" ]; then
    cp -fp "/etc/${file_name}" "${ETC}/${file_name}"
  fi
done

if [ ! -d ${DOCKER} ]; then
  cp -rfp /etc/docker ${DOCKER}
fi
