# Unipi Neuron buildroot

This is an external buildroot tree for the Unipi Neuron (https://www.unipi.technology/).
All images contain Systemd, Python 3, Unipi kernel, Unipi tools and many useful system tools. 
The sdcard image is less than 300 MB!

Device config for:
* Unipi Neuron - RPi 3B+
* Unipi Neuron - RPi 4B

## Usage

Download buildroot from https://buildroot.org/download.html and add this repro as external path.

```shell
$ git clone git@github.com:mh-superbox/rpi-buildroot.git
$ git clone git://git.buildroot.net/buildroot

$ cd /buildroot
$ # checkout LTS version
$ git checkout 2021.02.8

$ make BR2_EXTERNAL=../rpi-buildroot list-defconfigs
$ make unipi_neuron_rpi3b_defconfig
```

For more information visit https://buildroot.org/ and read the documenation.

The username and password are `unipi`.
