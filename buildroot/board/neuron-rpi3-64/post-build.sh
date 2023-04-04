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
mkdir /mnt/boot
mkdir /mnt/data
mkdir /mnt/overlay

# Disable owftpd
ln -fs /dev/null "${TARGET_DIR}/etc/systemd/system/owftpd.service"

# Update mosquitto listener
sed -i 's/#listener/listener 1883 0.0.0.0/g' "${TARGET_DIR}/etc/mosquitto/mosquitto.conf"

# Update mosquitto authentication
sed -i 's/#allow_anonymous false/allow_anonymous true/g' "${TARGET_DIR}/etc/mosquitto/mosquitto.conf"

# Allow members of group wheel to execute any command
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' "${TARGET_DIR}/etc/sudoers"

# Update Systemd
sed -i 's/#Storage=auto/Storage=volatile/' "${TARGET_DIR}/etc/systemd/journald.conf"
sed -i 's/#SystemMaxUse=/SystemMaxUse=500M/' "${TARGET_DIR}/etc/systemd/journald.conf"
sed -i 's/#FallbackNTP=.*/FallbackNTP=time.cloudflare.com/' "${TARGET_DIR}/etc/systemd/timesyncd.conf"
sed -i 's/#DNSOverTLS=opportunistic/DNSOverTLS=no/' "${TARGET_DIR}/etc/systemd/resolved.conf"
sed -i 's/#DNSStubListener=yes/DNSStubListener=no/' "${TARGET_DIR}/etc/systemd/resolved.conf"
# Set ZSH for root user
sed -i '/^root:/s,:/bin/dash$,:/bin/zsh,' "${TARGET_DIR}/etc/passwd"

