#!/usr/bin/env bash

os_id=$(grep OS_ID < "${GITHUB_WORKSPACE}/buildroot-external/meta" | cut -d'=' -f2 | tr -d '"')
os_hostname=$(grep OS_HOSTNAME < "${GITHUB_WORKSPACE}/buildroot-external/meta" | cut -d'=' -f2 | tr -d '"')
major=$(grep VERSION_MAJOR < "${GITHUB_WORKSPACE}/buildroot-external/meta" | cut -d'=' -f2)
build=$(grep VERSION_BUILD < "${GITHUB_WORKSPACE}/buildroot-external/meta" | cut -d'=' -f2)

version_dev=$(echo "${GITHUB_REF_NAME}" | cut -d '.' -f 3)

if [ "${version_dev}" == "" ]; then
  {
    echo "hostname=${os_hostname}"
    echo "version=${major}.${build}"
    echo "release=1"
  } >> "${GITHUB_OUTPUT}"
else
  {
    echo "hostname=${os_hostname}-dev"
    echo "version=${major}.${build}.${version_dev}${GITHUB_RUN_NUMBER}"
    echo "release=0"
  } >> "${GITHUB_OUTPUT}"
fi

{
  echo "version-dev=${version_dev}${GITHUB_RUN_NUMBER}"
  echo "os-id=${os_id}"
} >> "${GITHUB_OUTPUT}"
