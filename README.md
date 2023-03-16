# Unipi Control Operating System

Unipi Control Operating System is a Linux based operating system optimized to host [Unipi Control](https://github.com/mh-superbox/unipi-control).

## Features

- Lightweight and memory-efficient
- OWFS 1-Wire (http://unipi.local:8080)

## Supported hardware

- Unipi Neuron (Raspberry Pi 3B+)

## Getting Started

## Development

Unipi Control Operating System use Buildroot for it's embedded systems. For more information visit [www.buildroot.org](https://buildroot.org) and read the [documentation](https://buildroot.org/downloads/manual/manual.html).


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

Wait a long time ... and then write the image to a sdcard.

```shell
~/buildroot$ cd output/images/
~/buildroot/output/images$ dd bs=4M if=sdcard.img of=/dev/XXX status=progress
```
Boot you Unipi Neuron with the sdcard and connect with ssh:
The username and password are `unipi`.

```shell
~$ ssh unipi@unipi.local
```
