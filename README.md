# Unipi Neuron buildroot

This is an external buildroot tree for the [Unipi Neuron](https://www.unipi.technology/) and the [Unipi Control](https://github.com/mh-superbox/unipi-control).

Device config for:
* Unipi Neuron - RPi 3B+
* Unipi Neuron - RPi 4B

## Usage

```shell
~$ git clone https://github.com/mh-superbox/rpi-buildroot.git
~$ git clone git://git.buildroot.net/buildroot

~$ cd /buildroot
~/buildroot$ # checkout LTS version
~/buildroot$ git checkout 2022.02.2

~/buildroot$ make BR2_EXTERNAL=../unipi-buildroot/buildroot list-defconfigs
~/buildroot$ make unipi_neuron_rpi3b_defconfig

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

For more information visit https://buildroot.org/ and read the documenation.

## Features

* Monit is run at http://unipi.local:2812/ (Username and password are `unipi`)
* OWFS (1-Wire) is run at http://unipi.local:8080/