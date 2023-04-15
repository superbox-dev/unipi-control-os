#!/usr/bin/env bash

set -euo pipefail

if ! command -v unipi-control &> /dev/null; then
    exit 1
fi

LATEST_RELEASE=$(curl -s -L https://api.github.com/repos/superbox-dev/unipi-control/releases/latest | jq --raw-output '.tag_name')
CURRENT_RELEASE=$(unipi-control --version | cut -d " " -f 2)

COLOR_BOLD_WHITE="\033[1;97m"
COLOR_RESET="\033[0m"

if [ "$LATEST_RELEASE" != "$CURRENT_RELEASE" ]; then
    echo "Unipi Control update available:"
    echo -e "${COLOR_BOLD_WHITE}Installed:${COLOR_RESET}  ${CURRENT_RELEASE}"
    echo -e "${COLOR_BOLD_WHITE}Latest:${COLOR_RESET}     ${LATEST_RELEASE}\n"
fi
