# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

## [Unreleased]

## Added

- Added udev rules and device tree overlays from `unipi-os-configurator-data` debian package
- Added binary, udev rules from `unipi-os-configurator`

## Changed

- Bump Unipi kernel modules to v2.26

## [1.2] - 2023-07-07

## Changed

- Bump Unipi kernel modules to v1.124

## [1.1] - 2023-06-29

### Added

- Enabled support to mount samba and nfs shares.
- Wrote documentation for [remote backup](docs/backup-config.md) to a samba or nfs share.

### Removed

- Removed deprecated superbox-utils pip package from `os-develop.sh`.

## [1.0] - 2023-06-25

Initial release with Buildroot 2023.02.2
