#! /bin/sh

if [ -z "$1" ]; then
  echo "Usage: `basename $0` <container-name>"
  exit 0
fi

docker top "$1"
exit $?
