#!/usr/bin/env bash

set -e

os_id=$(grep OS_ID < "${GITHUB_WORKSPACE}/buildroot-external/meta" | cut -d'=' -f2 | tr -d '"')
os_hostname=$(grep OS_HOSTNAME < "${GITHUB_WORKSPACE}/buildroot-external/meta" | cut -d'=' -f2 | tr -d '"')
major=$(grep VERSION_MAJOR < "${GITHUB_WORKSPACE}/buildroot-external/meta" | cut -d'=' -f2)
build=$(grep VERSION_BUILD < "${GITHUB_WORKSPACE}/buildroot-external/meta" | cut -d'=' -f2)

version_dev="dev${GITHUB_RUN_NUMBER}"

if [ "${GITHUB_REF_TYPE}" == "tag" ]; then
  {
    echo "hostname=${os_hostname}"
    echo "version=${major}.${build}"
    echo "release=1"
  } >> "${GITHUB_OUTPUT}"
else
  {
    echo "hostname=${os_hostname}-dev"
    echo "version=${major}.${build}.${version_dev}"
    echo "release=0"
  } >> "${GITHUB_OUTPUT}"
fi

{
  echo "version-dev=${version_dev}"
  echo "os-id=${os_id}"
} >> "${GITHUB_OUTPUT}"
