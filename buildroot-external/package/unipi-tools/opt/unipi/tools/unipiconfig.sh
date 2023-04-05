#!/bin/sh

# Set Unipi Neuron platform detection

if ! [ -f "/sys/bus/i2c/devices/1-0057/eeprom" ] ; then
    echo "24c01 0x57" > /sys/bus/i2c/devices/i2c-1/new_device
fi
