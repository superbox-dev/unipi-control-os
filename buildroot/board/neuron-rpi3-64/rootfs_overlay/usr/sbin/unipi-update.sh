#!/usr/bin/env bash

set -euo pipefail

###############################################################################
# Environment

_ME="$(basename "${0}")"
UNIPI_CONFIG="/etc/unipi"
SYSTEMD="/etc/systemd/system"
SYSTEMD_SERVICE="unipi-control.service"
SITE_PACKAGES="$(python3 -c 'import sysconfig; print(sysconfig.get_paths()["purelib"])')"

###############################################################################
# Help

print_help() {
  cat <<HEREDOC
Unipi Control Updater
Usage: ${_ME} [-h] [-u] [-i] [-s]

Options:
  -h, --help               Show show this help message and exit
  -u, --update             Update Unipi Control
  -i, --install            Install config files and systemd service
  -c, --install-config     Install config files to ${UNIPI_CONFIG}
  -s, --install-service    Install systemd service: ${SYSTEMD_SERVICE}
HEREDOC
}

###############################################################################
# Program Functions

update_python_packages() {
  pip install --root-user-action=ignore --upgrade pip
  pip install --root-user-action=ignore --upgrade unipi-control
}

install_config() {
  if [ -d "$UNIPI_CONFIG" ]; then
    echo "Error: ${UNIPI_CONFIG} already exists! Can't write config files."
    exit 1
  else
    echo "Installing config files in ${UNIPI_CONFIG}"
    mkdir ${UNIPI_CONFIG}
    cp -R "${SITE_PACKAGES}/unipi_control/config/${UNIPI_CONFIG}" ${UNIPI_CONFIG}
  fi
}

install_service() {
  if [ -f "$SYSTEMD/$SYSTEMD_SERVICE" ]; then
    echo "Error: ${SYSTEMD}/${SYSTEMD_SERVICE} already exists! Can't write systemd services file."
    exit 1
  else
    echo "Installing systemd service to ${SYSTEMD}/${SYSTEMD_SERVICE}"
    cp -R "${SITE_PACKAGES}/unipi_control/config/${SYSTEMD}/${SYSTEMD_SERVICE}" "${SYSTEMD}/${SYSTEMD_SERVICE}"
    systemctl enable --now ${SYSTEMD_SERVICE}
  fi
}


###############################################################################
# Main

main() {
  if [[ "${1:-}" =~ ^-h|--help$  ]]
  then
    print_help
  elif [[ "${1:-}" =~ ^-u|--update$  ]]
  then
    update_python_packages "$@"
  elif [[ "${1:-}" =~ ^-i|--install$  ]]
  then
    install_config "$@"
    install_service "$@"
  elif [[ "${1:-}" =~ ^-c|--install-config$  ]]
  then
    install_config "$@"
  elif [[ "${1:-}" =~ ^-s|--install-service$  ]]
  then
    install_service "$@"
  else
    print_help
  fi
}

main "$@"
