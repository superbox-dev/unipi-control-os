#!/usr/bin/env bash

ref_name="${GITHUB_REF_NAME}"
tag_version="${ref_name/.dev/}"
os_version="${${1:-}/.dev${GITHUB_RUN_NUMBER}/}"

if [ "${tag_version}" != "${os_version}" ]; then
  echo "Version number in Buildroot metadata does not match tag! (${tag_version} vs. ${os_version})."
  exit 1
fi
