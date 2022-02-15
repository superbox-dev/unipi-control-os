#!/bin/bash

set -e

for arg in "$@"
do
	case "${arg}" in
		--add-neuron-overlay)
		if ! grep -qE '^dtoverlay=neuron-spi-new' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
			echo "Adding 'dtoverlay=neuron-spi-new' to config.txt."
			cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# Neuron
dtparam=i2c_arm=on
dtoverlay=i2c-rtc,mcp7941x
dtoverlay=neuron-spi-new
__EOF__
		fi
		;;
	esac

done

exit $?
