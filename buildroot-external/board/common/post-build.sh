#!/bin/bash
# shellcheck disable=SC1091

set -u
set -e

SCRIPT_DIR=${BR2_EXTERNAL_UNIPI_PATH}/board/common

BOARD_DIR=${2}
. "${BR2_EXTERNAL_UNIPI_PATH}/meta"
. "${BOARD_DIR}/meta"
. "${SCRIPT_DIR}/post-helpers.sh"

# Write os-release
(
    echo "NAME=\"${OS_NAME}\""
    echo "VERSION=\"$(os_version) (${BOARD_NAME})\""
    echo "ID=${OS_ID}"
    echo "VERSION_ID=$(os_version)"
    echo "PRETTY_NAME=\"${OS_NAME} $(os_version)\""
    echo "HOME_URL=https://github.com/superbox-dev"
) > "${TARGET_DIR}/usr/lib/os-release"

# Write issue
echo "${OS_NAME} $(os_version)" > "${TARGET_DIR}/etc/issue"

# Update motd
cat > "${TARGET_DIR}/etc/motd" <<EOL
---------------------------------------------------------------------
Hello, this is ${OS_NAME} $(os_version)
Run os-tools.sh to install or update Unipi Control

Documentation: https://github.com/superbox-dev/unipi-control#readme
---------------------------------------------------------------------
EOL

# Create mount point directories
mkdir -pv "${TARGET_DIR}/mnt/boot"
mkdir -pv "${TARGET_DIR}/mnt/data"
mkdir -pv "${TARGET_DIR}/mnt/overlay"

function setup_zsh() {
  sed -i '/^root:/s,:/bin/dash$,:/bin/zsh,' "${TARGET_DIR}/etc/passwd"
}

function setup_rauc() {
  sed -i "/compatible/s/=.*\$/=$(rauc_compatible)/" ${TARGET_DIR}/etc/rauc/system.conf
}

function fix_rootfs() {
  # Cleanup etc
  rm -rfv "${TARGET_DIR:?}/etc/init.d"
  rm -rfv "${TARGET_DIR:?}/etc/X11"
  rm -rfv "${TARGET_DIR:?}/etc/xdg"

  # Cleanup root
  rm -rfv "${TARGET_DIR:?}/media"
  rm -rfv "${TARGET_DIR:?}/srv"

  sed -i "/srv/d" "${TARGET_DIR}/usr/lib/tmpfiles.d/home.conf"

  mkdir -pv "${TARGET_DIR}/boot/"
  cp -fv "${BINARIES_DIR}/Image" "${TARGET_DIR}/boot/"

  mkdir -pv "${TARGET_DIR}/var/monit/"
}

setup_zsh
setup_rauc
fix_rootfs

"${HOST_DIR}/bin/systemctl" --root="${TARGET_DIR}" preset-all
