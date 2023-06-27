<!-- update_packages start -->
# Package manager

## Install package

List all available packages, select a package and install it with:

```shell
opkg list
opkg install PACKAGE_NAME
```

## Upgrade packages

Update the list of available packages and upgrade the packages with:

```shell
opkg update
opkg upgrade
```

## Develop

If you would install the newest develop releases you can enable the testing repository in the `/etc/opkg/opkg.conf`. Only do this if you know what you are doing!

<!-- update_packages end -->
