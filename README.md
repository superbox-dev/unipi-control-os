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
5. Run `sudo os-install.sh --install` to install or upgrade Unipi Control.
6. Read the [documentation](https://github.com/mh-superbox/unipi-control#configuration) to configure your Unipi Neuron.

Now you can start the service with:

```shell
$ systemctl enable unipi-control.service
$ systemctl start unipi-control.service
```

## Development

Unipi Control OS use Buildroot for it's embedded systems. For more information visit [www.buildroot.org](https://buildroot.org) and read the [documentation](https://buildroot.org/downloads/manual/manual.html).

```shell
~$ git clone https://github.com/mh-superbox/unipi-buildroot.git
~$ git clone git://git.buildroot.net/buildroot

~$ cd /buildroot
~/buildroot$ # checkout LTS version
~/buildroot$ git checkout 2022.02.10

~/buildroot$ make BR2_EXTERNAL=../unipi-buildroot/buildroot list-defconfigs
~/buildroot$ make neuron_rpi3_64_defconfig

# You can change the hostname with the BR2_TARGET_GENERIC_HOSTNAME variable
~/buildroot$ make BR2_TARGET_GENERIC_HOSTNAME=unipi clean all
```

Wait a long time ... and then write the image `~/buildroot/output/images/sdcard.img` to a SD card.
