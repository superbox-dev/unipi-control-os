#!/bin/dash

# Set python user base to /usr/local.
# pip install packages without venv to this location.
export PYTHONUSERBASE=/usr/local

# Set virtualenv path for Unipi Control develop environment.
export PATH="${PATH}:/usr/local/opt/venv/unipi-control/bin"
