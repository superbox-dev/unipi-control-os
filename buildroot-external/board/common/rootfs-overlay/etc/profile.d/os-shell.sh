OS_SHELL="/usr/local/bin/os-shell"

[ -f "${OS_SHELL}" ] || exit 1
PYTHONUSERBASE=/usr/local ${OS_SHELL}
