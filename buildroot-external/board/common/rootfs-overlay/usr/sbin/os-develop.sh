#! /bin/bash

set -euo pipefail

###############################################################################
# Environment

_ME="$(basename "${0}")"
UNIPI_CONFIG="/usr/local/etc/unipi-dev"
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
Unipi Control OS Develop
Usage: ${_ME} [-h] [-i]

Options:
  -h, --help               Show show this help message and exit
  -i, --install            Install Unipi Control
HEREDOC
}

###############################################################################
# Program Functions

function install_packages() {
  echo -e "${COLOR_BOLD_WHITE}[1/5] Create virtualenv ${VIRTUAL_ENV}${COLOR_RESET}"
  create_virtualenv "$@"
  echo -e "${COLOR_BOLD_WHITE}[2/5] Install unipi-control to ${SOURCE}${COLOR_RESET}"
  install_unipi_control "$@"
  echo -e "${COLOR_BOLD_WHITE}[3/5] Install superbox-utils to ${SOURCE}${COLOR_RESET}"
  install_superbox_utils "$@"
  echo -e "${COLOR_BOLD_WHITE}[4/5] Install config files to ${UNIPI_CONFIG}${COLOR_RESET}"
  install_config "$@"
  echo -e "${COLOR_BOLD_WHITE}[5/5] Install systemd service"
  install_systemd_service "$@"
}

function create_virtualenv() {
  cat > "/etc/profile.d/unipi-control-dev.sh" <<EOL
#!/bin/dash

# Set virtualenv path for Unipi Control develop environment.
export PATH="${PATH}:${VIRTUAL_ENV}/bin"
EOL

  if [ ! -f "${VIRTUAL_ENV}/bin/python" ]; then
    mkdir -pv "${VIRTUAL_ENV}"
    chown -v unipi: "${VIRTUAL_ENV}"

    su - unipi -s /bin/bash -c "
      python -m venv '${VIRTUAL_ENV}' \
      && source '${VIRTUAL_ENV}/bin/activate' \
      && pip install --upgrade pip"
  else
    echo -e "${SKIP_TEXT} Virtualenv ${VIRTUAL_ENV} already exists."
  fi
}

function install_unipi_control() {
  local unipi_control="${SOURCE}/unipi-control"

  if [ -d "${unipi_control}" ] && [ "$(ls -A ${unipi_control})" ]; then
    echo -e "${SKIP_TEXT} Directory ${unipi_control} is not empty! Can't install unipi-control."
  else
    mkdir -pv "${unipi_control}"
    chown -v unipi: "${unipi_control}"

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
    mkdir -pv "${superbox_utils}"
    chown -v unipi: "${superbox_utils}"

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
    mkdir -pv "${UNIPI_CONFIG}"
    chown -v unipi: "${UNIPI_CONFIG}"

    su - unipi -s /bin/bash -c " \
      cp -R '${unipi_control}/opkg/data/usr/local/etc/unipi/'* '${UNIPI_CONFIG}'"
    echo -e "${OK_TEXT} Installed config files to ${UNIPI_CONFIG}"
  fi
}

function install_systemd_service() {
  cat > "/etc/systemd/system/unipi-control-dev.service" <<EOL
[Unit]
Description=Unipi Control
After=multi-user.target
Requires=unipitcp.service
ConditionPathExists=${VIRTUAL_ENV}/bin/unipi-control
ConditionPathExists=${UNIPI_CONFIG}/control.yaml
Conflicts=unipi-control.service

[Service]
Type=simple
ExecStart=${VIRTUAL_ENV} --config ${UNIPI_CONFIG} --log systemd
Environment=PYTHONUNBUFFERED=1

[Install]
WantedBy=multi-user.target
EOL

  systemctl --system daemon-reload
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
