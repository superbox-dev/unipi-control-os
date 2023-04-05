#!/bin/bash

set -e

if CMD="$(command -v "$1")"; then
  shift
  "$CMD" "$@"
else
  echo "Command not found: $1"
  exit 1
fi
