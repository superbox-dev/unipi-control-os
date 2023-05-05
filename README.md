[![license-url](https://img.shields.io/badge/license-Apache%202-yellowgreen)](https://opensource.org/license/apache-2-0/)

# Unipi Control OS

<!-- pitch start -->
Unipi Control OS is a Linux based operating system optimized to host [Unipi Control](https://github.com/mh-superbox/unipi-control).
<!-- pitch end -->

### Support me if you like this project 😀

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/F2F0KXO6D)

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/yellow_img.png)](https://www.buymeacoffee.com/superbox_dev)

## Features

- Lightweight and memory-efficient
- OWFS 1-Wire (http://unipi.local:8080)

## Supported hardware

- Unipi Neuron (Raspberry Pi 3B+)

If you have an Unipi device, that is not supported, then contact me.

<!-- quickstart start -->
## Getting Started

### Install

1. Download the latest [release](https://github.com/mh-superbox/unipi-control-os/releases) `unipi-control-os-neuron-rpi3-64-1.x.img.xz`.
2. Write the image to your SD card with [Balena Etcher](https://www.balena.io/etcher).
3. Insert SD card to your Unipi Neuron and power the system on.
4. Connect to your Unipi Neuron with `ssh unipi@unipi.local` (The username and password are `unipi`).
5. Run `sudo opkg install unipi-control` to install Unipi Control.
6. Read the [documentation](https://github.com/mh-superbox/unipi-control#configuration) to configure your Unipi Neuron and copy the configuration files to `/usr/local/etc/unipi`.

Now you can start the service with:

```shell
sudo systemctl start unipi-control.service
```
<!-- quickstart end -->

### Update

WIP

<!-- development start -->
## Development

Unipi Control OS use Buildroot for it's embedded systems. For more information visit [www.buildroot.org](https://buildroot.org) and read the [documentation](https://buildroot.org/downloads/manual/manual.html).

```shell
~$ git clone https://github.com/mh-superbox/unipi-control-os.git
~$ cd unipi-buildroot
~$ git submodule update --init
~$ # For more info use:
~$ make help
~$ # Create 64 bit image for Neuron Raspberry Pi 3:
~$ make neuron_rpi3_64
```

Wait a long time ... and then write the image from `~/unipi-buildroot/release/` to a SD card.
<!-- development end -->
