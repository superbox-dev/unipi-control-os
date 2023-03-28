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

# Copy Kernel to /boot
mkdir -p "${TARGET_DIR}/boot/efi"
install -D -m 0744 "${BINARIES_DIR}/Image" -t "${TARGET_DIR}/boot"

# Disable owftpd
ln -fs /dev/null "${TARGET_DIR}/etc/systemd/system/owftpd.service"

# Update mosquitto listener
sed -i 's/#listener/listener 1883 0.0.0.0/g' "${TARGET_DIR}/etc/mosquitto/mosquitto.conf"

# Update mosquitto authentication
sed -i 's/#allow_anonymous false/allow_anonymous true/g' "${TARGET_DIR}/etc/mosquitto/mosquitto.conf"

# Init systemd
mkdir -p "${TARGET_DIR}/etc/systemd/system/multi-user.target.wants"

# Enable systemd zram service
ln -fs ../systemd-zram.service "${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/systemd-zram.service"

# Allow members of group wheel to execute any command
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' "${TARGET_DIR}/etc/sudoers"

# Update Systemd Journald
sed -i 's/#Storage=auto/Storage=volatile/' "${TARGET_DIR}/etc/systemd/journald.conf"

# Set ZSH for root user
sed -i '/^root:/s,:/bin/dash$,:/bin/zsh,' "${TARGET_DIR}/etc/passwd"
