[![license-url](https://img.shields.io/badge/license-Apache%202-yellowgreen)](https://opensource.org/license/apache-2-0/)

<!-- pitch start -->
# Unipi Control OS

Unipi Control OS is a lightweight and memory-efficient Linux based operating system optimized to host [Unipi Control](https://github.com/mh-superbox/unipi-control).
<!-- pitch end -->

<!-- quickstart start -->
## Getting started

1. Download the latest [release](https://github.com/mh-superbox/unipi-control-os/releases) `*.img.xz` from GitHub.
2. Write the image `*.img.xz` to your SD card with [Balena Etcher](https://www.balena.io/etcher).
3. Insert SD card to your Unipi Neuron and power the system on.
4. Connect to your Unipi Neuron with `ssh` on Linux/macOS or with [Putty](https://www.putty.org/) on Windows (The username and password are `unipi`).
   ```shell
   ssh unipi@unipi.local
   ```
5. Install Unipi Control with the OPKG package manager.
   ```shell
   sudo opkg install unipi-control
   ```
6. Read the [Unipi Control documentation](https://github.com/mh-superbox/unipi-control#configuration) to configure your Unipi Neuron and copy the configuration files to `/usr/local/etc/unipi`.
7. Start the service with:
   ```shell
   sudo systemctl start unipi-control.service
   ```

The Unipi Neuron I/O are now available in your network via MQTT.

> Optionally: You can use the Unipi Neuron I/O in Home Assistant. Read the [MQTT documentation](https://www.home-assistant.io/integrations/mqtt) from Home Assistant.

<!-- quickstart end -->

## Supported hardware

- Unipi Neuron (Raspberry Pi 3B+)

If you have an Unipi device, that is not supported, then contact use.

## Changelog

The changelog lives in the [CHANGELOG.md](CHANGELOG.md) document. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

## Contributing

We're happy about your contributions to the project!

You can get started by reading the [CONTRIBUTING.md](CONTRIBUTING.md).

<!-- donation start -->
## Donation

We put a lot of time into this project. If you like it, you can support us with a donation.

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/F2F0KXO6D)
<!-- donation end -->

<!-- additional_info start -->
## Additional information

This is a third-party software for [Unipi Neuron](https://www.unipi.technology). This software **is NOT** from [Unipi Technology s.r.o.](https://www.unipi.technology). 
<!-- additional_info end -->
