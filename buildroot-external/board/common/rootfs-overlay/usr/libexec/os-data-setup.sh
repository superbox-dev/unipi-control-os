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
  "${DATA}/src"
  "${DATA}/venv"
  "${DATA}/config"
)

for path in "${paths[@]}"; do
  if [ ! -d "${path}" ]; then
    mkdir -pv "${path}"
    chown unipi:unipi "${path}"
  fi
done
