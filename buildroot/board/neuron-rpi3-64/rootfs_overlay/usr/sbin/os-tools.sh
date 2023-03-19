#!/usr/bin/env bash

set -euo pipefail

###############################################################################
# Environment

_ME="$(basename "${0}")"
UNIPI_CONFIG="/etc/unipi"
SYSTEMD="/etc/systemd/system"
SYSTEMD_SERVICE="unipi-control.service"
VIRTUAL_ENV="/opt/.venv"
DEVELOPMENT="/opt/develop"

COLOR_GREEN="\033[1;92m"
COLOR_RED="\033[1;91m"
COLOR_YELLOW="\033[1;93m"
COLOR_BOLD_WHITE="\033[1;97m"
COLOR_RESET="\033[0m"

SKIP_TEXT="${COLOR_BOLD_WHITE}[${COLOR_RESET}${COLOR_YELLOW}SKIP${COLOR_RESET}${COLOR_BOLD_WHITE}]${COLOR_RESET}"
OK_TEXT="${COLOR_BOLD_WHITE}[${COLOR_RESET}${COLOR_GREEN}OK${COLOR_RESET}${COLOR_BOLD_WHITE}]${COLOR_RESET}"
ERROR_TEXT="${COLOR_BOLD_WHITE}[${COLOR_RESET}${COLOR_RED}ERROR${COLOR_RESET}${COLOR_BOLD_WHITE}]${COLOR_RESET}"

export DEVELOPMENT
export PIP_REQUIRE_VIRTUALENV=false
export PATH="${VIRTUAL_ENV}/bin:${PATH}"

###############################################################################
# Help

print_help() {
  cat <<HEREDOC
Unipi Control OS Tools
Usage: ${_ME} [-h] [-i] [-u]

Options:
  -h, --help               Show show this help message and exit
  -i, --install            Install Unipi Control
  -u, --update             Update Unipi Control
HEREDOC
}

###############################################################################
# Program Functions

update_python_packages() {
  if [ ! -d "$VIRTUAL_ENV" ]; then
    python -m venv ${VIRTUAL_ENV}
  fi

  pip install --upgrade pip
  pip install --upgrade unipi-control

  if [ ! -f /bin/unipi-control ]; then
    ln -s ${VIRTUAL_ENV}/bin/unipi-control /bin/unipi-control
  fi
}

install_config() {

if [ -d "$UNIPI_CONFIG" ]; then
    echo -e "${SKIP_TEXT} ${UNIPI_CONFIG} already exists! Can't write config files."
  else
    mkdir ${UNIPI_CONFIG}
    cp -R "$(python3 -c 'import sysconfig; print(sysconfig.get_paths()["purelib"])')/unipi_control/config${UNIPI_CONFIG}/"* ${UNIPI_CONFIG}
    echo -e "${OK_TEXT} Installed config files to ${UNIPI_CONFIG}"
  fi
}

install_service() {
  if [ -f "$SYSTEMD/$SYSTEMD_SERVICE" ]; then
    echo -e "${SKIP_TEXT} ${SYSTEMD}/${SYSTEMD_SERVICE} already exists! Can't write systemd services file."
  else
    cp -R "$(python3 -c 'import sysconfig; print(sysconfig.get_paths()["purelib"])')/unipi_control/config/${SYSTEMD}/${SYSTEMD_SERVICE}" "${SYSTEMD}/${SYSTEMD_SERVICE}"
    echo -e "${OK_TEXT} Installed systemd service to ${SYSTEMD}/${SYSTEMD_SERVICE}"
  fi
}

install_unipi_control() {
  echo -e "${COLOR_BOLD_WHITE}[1/3] Install Unipi-Control...${COLOR_RESET}"
  update_python_packages "$@"
  echo -e "${COLOR_BOLD_WHITE}[2/3] Install config files...${COLOR_RESET}"
  install_config "$@"
  echo -e "${COLOR_BOLD_WHITE}[2/3] Install systemd service...${COLOR_RESET}"
  install_service "$@"
}

install_development() {
  if [ -d "$DEVELOPMENT" ]; then
    echo -e "${ERROR_TEXT} ${DEVELOPMENT} already exists! Can't install development environment."
    exit 1
  fi

  mkdir ${DEVELOPMENT}
  chown unipi:unipi ${DEVELOPMENT}
  su - unipi -s /bin/bash -c " \
    python -m venv '${DEVELOPMENT}/.venv' \
    && git clone git@github.com:mh-superbox/unipi-control.git '${DEVELOPMENT}/unipi-control' \
    && git clone git@github.com:mh-superbox/superbox-utils.git '${DEVELOPMENT}/superbox-utils' \
    && source '${DEVELOPMENT}/.venv/bin/activate' \
    && pip install --upgrade pip
    && pip install -e '${DEVELOPMENT}/superbox-utils' \
    && pip install -e '${DEVELOPMENT}/unipi-control'"

  echo -e "${OK_TEXT} Installed development environment to ${DEVELOPMENT}"
}


###############################################################################
# Main

main() {
  if [ "$(id -u)" != 0 ]; then
    echo -e "${ERROR_TEXT} ${_ME} can only run as root user!"
    exit 1
  fi

  if [[ "${1:-}" =~ ^-h|--help$ ]]
  then
    print_help
  elif [[ "${1:-}" =~ ^-i|--install$ ]]
  then
    install_unipi_control "$@"
  elif [[ "${1:-}" =~ ^-u|--update$ ]]
  then
    update_python_packages "$@"
  elif [[ "${1:-}" =~ ^--dev$ ]]
  then
    install_development "$@"
  else
    print_help
  fi
}

main "$@"
