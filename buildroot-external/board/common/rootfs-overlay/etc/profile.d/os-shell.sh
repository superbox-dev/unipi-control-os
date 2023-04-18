#!/bin/sh

OS_SHELL="/usr/local/bin/os-shell"

[ -f "${OS_SHELL}" ] || exit 1
${OS_SHELL}
