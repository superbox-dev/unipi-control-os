#!/bin/dash

COLOR_YELLOW="\033[1;93m"
COLOR_BOLD_WHITE="\033[1;97m"
COLOR_RESET="\033[0m"

if [ -f /usr/local/bin/unipi-control ]; then
    echo -n "Run ${COLOR_YELLOW}opkg install unipi-control${COLOR_RESET} to install Unipi Control.\n"
else
  LATEST_RELEASE=$(curl -s -L https://api.github.com/repos/mh-superbox/unipi-control/releases/latest | jq --raw-output '.tag_name')
  CURRENT_RELEASE=$(/usr/local/bin/unipi-control --version | cut -d " " -f 2)

  if awk "BEGIN {exit !($LATEST_RELEASE > $CURRENT_RELEASE)}"; then
      echo -n "${COLOR_YELLOW}Unipi Control${COLOR_RESET} update available:"
      echo -n "${COLOR_BOLD_WHITE}Installed:${COLOR_RESET}  ${CURRENT_RELEASE}"
      echo -n "${COLOR_BOLD_WHITE}Latest:${COLOR_RESET}     ${LATEST_RELEASE}\n"
  fi
fi
