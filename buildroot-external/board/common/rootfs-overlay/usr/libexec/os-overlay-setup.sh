#! /bin/bash

set -e

OVERLAY="/mnt/overlay"
DOCKER="${OVERLAY}/etc/docker"

overlay_paths=(
  "${OVERLAY}/etc"
  "${OVERLAY}/etc/ssh"
  "${OVERLAY}/etc/systemd/network/$NETWORK"
)

file_names=(
  "hostname"
  "hosts"
  "passwd"
  "group"
  "shadow"
  "systemd/timesyncd.conf"
  "systemd/network/20-wired.network"
  "systemd/network/25-wireless.network"
)

for overlay_path in "${overlay_paths[@]}"; do
  mkdir -p "${overlay_path}"
done

for file_name in "${file_names[@]}"; do
  if [ ! -f "${OVERLAY}/etc/${file_name}" ]; then
    cp -fp "/etc/${file_name}" "${OVERLAY}/etc/${file_name}"
  fi
done

if [ ! -d ${DOCKER} ]; then
  cp -rfp /etc/docker ${DOCKER}
fi
