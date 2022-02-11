#!/bin/sh

set -u
set -e

# Disable owftpd
ln -fs /dev/null ${TARGET_DIR}/etc/systemd/system/owftpd.service 

