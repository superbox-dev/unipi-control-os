#!/usr/bin/env bash

ref_name="${GITHUB_REF_NAME}"
tag_version="${ref_name/.dev/}"
version="${{ inputs.version }}"
os_version="${version/.dev${GITHUB_RUN_NUMBER}/}"

if [ "${tag_version}" != "${os_version}" ]; then
  echo "Version number in Buildroot metadata does not match tag! (${tag_version} vs. ${os_version})."
  exit 1
fi
