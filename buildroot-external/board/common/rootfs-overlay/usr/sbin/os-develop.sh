#! /bin/bash

set -euo pipefail

###############################################################################
# Environment

_ME="$(basename "${0}")"
UNIPI_CONFIG="/usr/local/etc/unipi"
VIRTUAL_ENV="/usr/local/opt/venv/unipi-control"
SOURCE="/usr/local/src"

COLOR_GREEN="\033[1;92m"
COLOR_RED="\033[1;91m"
COLOR_YELLOW="\033[1;93m"
COLOR_BOLD_WHITE="\033[1;97m"
COLOR_RESET="\033[0m"

SKIP_TEXT="${COLOR_BOLD_WHITE}[${COLOR_RESET}${COLOR_YELLOW}SKIP${COLOR_RESET}${COLOR_BOLD_WHITE}]${COLOR_RESET}"
OK_TEXT="${COLOR_BOLD_WHITE}[${COLOR_RESET}${COLOR_GREEN}OK${COLOR_RESET}${COLOR_BOLD_WHITE}]${COLOR_RESET}"
ERROR_TEXT="${COLOR_BOLD_WHITE}[${COLOR_RESET}${COLOR_RED}ERROR${COLOR_RESET}${COLOR_BOLD_WHITE}]${COLOR_RESET}"

export SOURCE
export PATH="${PATH}:${VIRTUAL_ENV}/bin"

###############################################################################
# Help

function print_help() {
  cat <<HEREDOC
Unipi Control OS Tools
Usage: ${_ME} [-h] [-i]

Options:
  -h, --help               Show show this help message and exit
  -i, --install            Install Unipi Control
HEREDOC
}

###############################################################################
# Program Functions

function install_packages() {
  echo -e "${COLOR_BOLD_WHITE}[1/4] Create virtualenv ${VIRTUAL_ENV}${COLOR_RESET}"
  create_virtualenv "$@"
  echo -e "${COLOR_BOLD_WHITE}[2/4] Install unipi-control to ${SOURCE}${COLOR_RESET}"
  install_unipi_control "$@"
  echo -e "${COLOR_BOLD_WHITE}[3/4] Install superbox-utils to ${SOURCE}${COLOR_RESET}"
  install_superbox_utils "$@"
  echo -e "${COLOR_BOLD_WHITE}[4/4] Install config files to ${UNIPI_CONFIG}${COLOR_RESET}"
  install_config "$@"
}

function create_virtualenv() {
  if [ ! -f "${VIRTUAL_ENV}/bin/python" ]; then
    su - unipi -s /bin/bash -c "
      mkdir -pv '${VIRTUAL_ENV}' \
      && python -m venv '${VIRTUAL_ENV}' \
      && source '${VIRTUAL_ENV}/bin/activate' \
      && pip install --upgrade pip"
  fi
}

function install_unipi_control() {
  local unipi_control="${SOURCE}/unipi-control"

  if [ -d "${unipi_control}" ] && [ "$(ls -A ${unipi_control})" ]; then
    echo -e "${SKIP_TEXT} Directory ${unipi_control} is not empty! Can't install unipi-control."
  else
    su - unipi -s /bin/bash -c " \
      git clone git@github.com:mh-superbox/unipi-control.git '${unipi_control}/' \
      && source '${VIRTUAL_ENV}/bin/activate' \
      && pip install -e '${unipi_control}'"
  fi
}

function install_superbox_utils() {
  local superbox_utils="${SOURCE}/superbox-utils"

  if [ -d "${superbox_utils}" ] && [ "$(ls -A ${superbox_utils})" ]; then
    echo -e "${SKIP_TEXT} Directory ${superbox_utils} is not empty! Can't install superbox-utils."
  else
    su - unipi -s /bin/bash -c " \
      git clone git@github.com:mh-superbox/superbox-utils.git '${superbox_utils}' \
      && source '${VIRTUAL_ENV}/bin/activate' \
      && pip install -e '${superbox_utils}'"
  fi
}

function install_config() {
  local unipi_control="${SOURCE}/unipi-control"

  if [ -d "$UNIPI_CONFIG" ] && [ "$(ls -A ${UNIPI_CONFIG})" ]; then
    echo -e "${SKIP_TEXT} Configuration files in ${UNIPI_CONFIG} already exists! Can't write config files."
  else
    su - unipi -s /bin/bash -c " \
      mkdir -pv '${UNIPI_CONFIG}' \
      && cp -R '${unipi_control}/src/unipi_control/config/etc/unipi/'* '${UNIPI_CONFIG}'"
    echo -e "${OK_TEXT} Installed config files to ${UNIPI_CONFIG}"
  fi
}


###############################################################################
# Main

function main() {
  if [ "$(id -u)" != 0 ]; then
    echo -e "${ERROR_TEXT} ${_ME} can only run as root user!"
    exit 1
  fi

  if [[ "${1:-}" =~ ^-h|--help$ ]]
  then
    print_help
  elif [[ "${1:-}" =~ ^-i|--install$ ]]
  then
    install_packages "$@"
  else
    print_help
  fi
}

main "$@"
