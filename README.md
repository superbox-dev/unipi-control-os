# Unipi Control OS

Unipi Control OS is a Linux based operating system optimized to host [Unipi Control](https://github.com/mh-superbox/unipi-control).

## Features

- Lightweight and memory-efficient
- OWFS 1-Wire (http://unipi.local:8080)

## Supported hardware

- Unipi Neuron (Raspberry Pi 3B+)

If you have an Unipi device, that is not supported, then contact me.

## Getting Started

1. Download the latests [release](https://github.com/mh-superbox/unipi-control-os/releases).
2. Write the image to your SD card with [Balena Etcher](https://www.balena.io/etcher).
3. Insert SD card to your Unipi Neuron and power the system on.
4. Connect to your Unipi Neuron with `ssh unipi@unipi.local` (The username and password are `unipi`).
5. Run `sudo os-tools.sh --install` to install Unipi Control.
6. Read the [documentation](https://github.com/mh-superbox/unipi-control#configuration) to configure your Unipi Neuron.

Now you can start the service with:

```shell
$ sudo systemctl enable --now unipi-control.service
```

## Development

Unipi Control OS use Buildroot for it's embedded systems. For more information visit [www.buildroot.org](https://buildroot.org) and read the [documentation](https://buildroot.org/downloads/manual/manual.html).

```shell
~$ git clone https://github.com/mh-superbox/unipi-buildroot.git
~$ cd unipi-buildroot
~$ git submodule update --init
~$ make neuron_rpi3_64
```

Wait a long time ... and then write the image `~/unipi-buildroot/release/sdcard.img` to a SD card.
