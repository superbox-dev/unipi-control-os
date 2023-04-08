#! /bin/sh

set -e

DATA="/mnt/data"
HOME="${DATA}/users"

if [ ! -d $HOME ]; then
  cp -rfp /home/* "${HOME}/"
fi
