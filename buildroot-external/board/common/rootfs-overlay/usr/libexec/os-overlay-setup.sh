#! /bin/bash

set -e

OVERLAY="/mnt/overlay"

overlay_paths=(
  "${OVERLAY}/etc"
  "${OVERLAY}/home"
  "${OVERLAY}/root"
  "${OVERLAY}/opt/unipi"
  "${OVERLAY}/usr/local"
  "${OVERLAY}/var"
  "${OVERLAY}/.work-etc"
  "${OVERLAY}/.work-home"
  "${OVERLAY}/.work-root"
  "${OVERLAY}/.work-opt-unipi"
  "${OVERLAY}/.work-opt-usr-local"
  "${OVERLAY}/.work-var"
)

for overlay_path in "${overlay_paths[@]}"; do
  mkdir -p "${overlay_path}"
done
