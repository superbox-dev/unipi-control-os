#! /bin/bash

set -e

DATA="/mnt/data"
ROOT="${DATA}/root"
HOME="${DATA}/home"

if [ ! -d "${ROOT}" ]; then
  cp -rfp /root "${ROOT}"
fi

if [ ! -d "${HOME}" ]; then
  cp -rfp /home "${HOME}"
fi

paths=(
  "${DATA}/usr/local"
  "${DATA}/usr/local/etc"
  "${DATA}/usr/local/src"
  "${DATA}/usr/local/opt"
  "${DATA}/usr/local/opt/venv"
  "${DATA}/var/log"
)

for path in "${paths[@]}"; do
  if [ ! -d "${path}" ]; then
    mkdir -pv "${path}"
  fi
done
