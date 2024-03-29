# Contributing

Thanks for your interest in contributing to **Unipi Control OS**.

## Setting up

Clone the unipi-control-os repository.

```shell
git clone https://github.com/superbox-dev/unipi-control-os.git
```

Inside the repository,  use `make`to initialize the buildroot submodule and python virtualenv.

```shell
make install
```

## Building

Unipi Control OS use Buildroot for it's embedded systems. For more information visit [www.buildroot.org](https://buildroot.org) and read the [documentation](https://buildroot.org/downloads/manual/manual.html).

For compiling Buildroot images we use `make`.
> Execude `make help` for a detailed help.

### Run menuconfig (optionally)

```shell
make neuron_rpi3_64_defconfig
```

### Compile buildroot

You can create a image for e.g. Neuron Raspberry Pi 3 64 bit with:

```shell
make neuron_rpi3_64
```

Wait a long time ... and then write the image from `release/` to a SD card.

## Building with docker (Recommended)

Create a docker image:

```shell
docker build -t unipi-control-os .
```

Run docker image and start a bash shell:

```shell
docker run --rm --user $(id -u):$(id -g) -v "$PWD:/build" -it unipi-control-os bash
```

Compile buildroot with docker image shell:

```shell
make neuron_rpi3_64
```

## Making a pull request

The branch to contribute is `main`. You can create a draft pull request as long as your contribution is not ready. Please also update the `CHANGELOG.md` with the changes that your pull request makes!
