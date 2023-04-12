#!/bin/bash

set -e

MACHINE_ID=$(cat /etc/machine-id)

if [ "$(fw_printenv -n MACHINE_ID)" != "${MACHINE_ID}" ]; then
  echo "[INFO] set machine-id to ${MACHINE_ID}"
  fw_setenv MACHINE_ID "${MACHINE_ID}"
else
  echo "[INFO] machine-id is okay"
fi

