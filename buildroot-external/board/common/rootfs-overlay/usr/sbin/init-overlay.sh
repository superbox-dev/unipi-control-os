#!/bin/sh
# shellcheck disable=SC2155

set -u
set -e

fail() {
	echo "$1"
	exit 1
}

if ! mount -t tmpfs inittemp /mnt; then
  fail "ERROR: could not create a temporary filesystem to mount the base filesystems for overlayFS"
fi

setup_overlay() {
  mkdir -p "/mnt/overlay/$1"
  mkdir -p "/mnt/overlay/$2"

  if ! mount overlay -t overlay -o "lowerdir=/$1,upperdir=/mnt/overlay/$1,workdir=/mnt/overlay/$2" "/$1"; then
    fail "ERROR: could not mount overlayFS for $1"
  fi
}

setup_overlay "etc" ".work-etc"
setup_overlay "home" ".work-home"
setup_overlay "opt/unipi" ".work-opt-unipi"
setup_overlay "root" ".work-root"
setup_overlay "usr/local" ".work-usr-local"
setup_overlay "var" ".work-var"

umount /mnt/overlay
umount /mnt
umount /proc

exec /sbin/init
