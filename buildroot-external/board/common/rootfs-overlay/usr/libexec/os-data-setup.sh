#! /bin/sh

set -e

DATA="/mnt/data"
ROOT="${DATA}/root"
HOME="${DATA}/home"

if [ ! -d $ROOT ]; then
  cp -rfp /root ${ROOT}
fi

if [ ! -d $HOME ]; then
  cp -rfp /home ${HOME}
fi
