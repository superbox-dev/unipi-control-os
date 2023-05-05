#!/usr/bin/env bash

set -e

os_version="v${1}"

if [ "${GITHUB_REF_TYPE}" == "tag" ] && [ "${GITHUB_REF_NAME}" != "${os_version}" ]; then
  echo "Version number in Buildroot metadata does not match tag! (${GITHUB_REF_NAME} vs. ${os_version})."
  exit 1
fi
