#!/bin/bash

set -e

NRDEVICES=$(grep -c ^processor /proc/cpuinfo | sed 's/^0$/1/')

case "$1" in
  "start")
    modprobe zram num_devices="${NRDEVICES}"

    # Calculate memory to use for zram (1/2 of ram)
    totalmem=$(LC_ALL=C free | grep -e "^Mem:" | sed -e 's/^Mem: *//' -e 's/  *.*//')
    mem=$(((totalmem / 2 / "$NRDEVICES") * 1024))

    for i in $(seq "$NRDEVICES"); do
      DEVNUMBER=$((i - 1))
      echo $mem > /sys/block/zram${DEVNUMBER}/disksize
      mkswap /dev/zram${DEVNUMBER}
      swapon -p 5 /dev/zram${DEVNUMBER}
    done
  ;;
  "stop")
    if DEVICES=$(grep zram /proc/swaps | awk '{print $1}'); then
      for i in $DEVICES; do
        swapoff "$i"
      done
    fi

    rmmod zram
  ;;
  *)
    echo "Usage: $(basename "$0") (start | stop)"
    exit 1
    ;;
esac
