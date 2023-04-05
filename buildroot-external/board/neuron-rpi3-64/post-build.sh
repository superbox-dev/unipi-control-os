#!/bin/sh

set -u
set -e

# Update motd
cat > "${TARGET_DIR}/etc/motd" <<EOL
---------------------------------------------------------------------
Hello, this is $(cat "${TARGET_DIR}/etc/issue")
Run os-tools.sh to install or update Unipi Control

Documentation: https://github.com/superbox-dev/unipi-control#readme
---------------------------------------------------------------------
EOL

# Create mount point directories
mkdir -p "${TARGET_DIR}/mnt/boot"
mkdir -p "${TARGET_DIR}/mnt/data"
mkdir -p "${TARGET_DIR}/mnt/overlay"

setup_mosquitto() {
  sed -i 's/#listener/listener 1883 0.0.0.0/g' "${TARGET_DIR}/etc/mosquitto/mosquitto.conf"
  sed -i 's/#allow_anonymous false/allow_anonymous true/g' "${TARGET_DIR}/etc/mosquitto/mosquitto.conf"
}

setup_user() {
  # Allow members of group wheel to execute any command
  sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' "${TARGET_DIR}/etc/sudoers"
}

setup_systemd() {
  sed -i 's/#Storage=auto/Storage=volatile/' "${TARGET_DIR}/etc/systemd/journald.conf"
  sed -i 's/#SystemMaxUse=/SystemMaxUse=500M/' "${TARGET_DIR}/etc/systemd/journald.conf"
  sed -i 's/#FallbackNTP=.*/FallbackNTP=time.cloudflare.com/' "${TARGET_DIR}/etc/systemd/timesyncd.conf"
  sed -i 's/#DNSOverTLS=opportunistic/DNSOverTLS=no/' "${TARGET_DIR}/etc/systemd/resolved.conf"
  sed -i 's/#DNSStubListener=yes/DNSStubListener=no/' "${TARGET_DIR}/etc/systemd/resolved.conf"
}

setup_zsh() {
  sed -i '/^root:/s,:/bin/dash$,:/bin/zsh,' "${TARGET_DIR}/etc/passwd"
}

fix_rootfs() {
  # Cleanup etc
  rm -rf "${TARGET_DIR:?}/etc/init.d"
  rm -rf "${TARGET_DIR:?}/etc/X11"
  rm -rf "${TARGET_DIR:?}/etc/xdg"

  # Cleanup root
  rm -rf "${TARGET_DIR:?}/media"
  rm -rf "${TARGET_DIR:?}/srv"
  rm -rf "${TARGET_DIR:?}/opt"

  sed -i "/srv/d" "${TARGET_DIR}/usr/lib/tmpfiles.d/home.conf"
}

setup_mosquitto
setup_user
setup_systemd
setup_zsh
fix_rootfs

"${HOST_DIR}/bin/systemctl" --root="${TARGET_DIR}" preset-all
