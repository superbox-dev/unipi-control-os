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

setup_mosquitto() {
  sed -i 's/#listener/listener 1883 0.0.0.0/g' "${TARGET_DIR}/etc/mosquitto/mosquitto.conf"
  sed -i 's/#allow_anonymous false/allow_anonymous true/g' "${TARGET_DIR}/etc/mosquitto/mosquitto.conf"
}

function setup_systemd() {
  sed -i 's/#Storage=auto/Storage=volatile/' "${TARGET_DIR}/etc/systemd/journald.conf"
  sed -i 's/#SystemMaxUse=/SystemMaxUse=500M/' "${TARGET_DIR}/etc/systemd/journald.conf"
  sed -i 's/#FallbackNTP=.*/FallbackNTP=time.cloudflare.com/' "${TARGET_DIR}/etc/systemd/timesyncd.conf"
  sed -i 's/#DNSOverTLS=opportunistic/DNSOverTLS=no/' "${TARGET_DIR}/etc/systemd/resolved.conf"
  sed -i 's/#DNSStubListener=yes/DNSStubListener=no/' "${TARGET_DIR}/etc/systemd/resolved.conf"
}

function setup_zsh() {
  sed -i '/^root:/s,:/bin/dash$,:/bin/zsh,' "${TARGET_DIR}/etc/passwd"
}

function setup_sshd() {
  sed -i 's/#HostKey \/etc\/ssh\/ssh_host_rsa_key/HostKey \/mnt\/overlay\/etc\/ssh\/ssh_host_rsa_key/' "${TARGET_DIR}/etc/ssh/sshd_config"
  sed -i 's/#HostKey \/etc\/ssh\/ssh_host_ecdsa_key/HostKey \/mnt\/overlay\/etc\/ssh\/ssh_host_ecdsa_key/' "${TARGET_DIR}/etc/ssh/sshd_config"
  sed -i 's/#HostKey \/etc\/ssh\/ssh_host_ed25519_key/HostKey \/mnt\/overlay\/etc\/ssh\/ssh_host_ed25519_key/' "${TARGET_DIR}/etc/ssh/sshd_config"
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
}

setup_mosquitto
setup_systemd
setup_zsh
setup_sshd
fix_rootfs

"${HOST_DIR}/bin/systemctl" --root="${TARGET_DIR}" preset-all
