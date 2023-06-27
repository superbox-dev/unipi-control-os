# Package manager

<!-- content start -->
## Install package

List all available packages, select a package and install it with:

```shell
opkg list
sudo opkg install PACKAGE_NAME
```

## Upgrade packages

Update the list of available packages and upgrade the packages with:

```shell
sudo opkg update
sudo opkg upgrade
```

## Develop

If you would install the newest develop releases you can enable the testing repository in the `/etc/opkg/opkg.conf`. Only do this if you know what you are doing!

<!-- content end -->
