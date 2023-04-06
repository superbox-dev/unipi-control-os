#!/bin/bash

function os_image_name() {
  echo "${BINARIES_DIR}/${OS_ID}-${BOARD_ID}-$(os_version).${1}"
}

function os_version() {
  if [ -z "${VERSION_DEV}" ]; then
    echo "${VERSION_MAJOR}.${VERSION_BUILD}"
  else
    echo "${VERSION_MAJOR}.${VERSION_BUILD}.${VERSION_DEV}"
  fi
}
