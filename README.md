# buildroot

An external buildroot tree for Unipi Neuron (https://www.unipi.technology/).

## Usage

Download buildroot-2021.05 from https://buildroot.org/download.html and add this repro as external path.

```shell
$ cd /buildroot-2021.05
$ make BR2_EXTERNAL=/unipi-buildroot list-defconfigs
$ make unipi_neuron_defconfig
```

For more information visit https://buildroot.org/ and read the documenation.
