[system]
compatible={{ env "bundle_compatible" }}
mountprefix=/run/rauc
statusfile=/mnt/data/rauc.db
bootloader=uboot

[keyring]
path=/etc/rauc/keyring.pem

[slot.boot.0]
device=/dev/disk/by-partlabel/boot
type=vfat
allow-mounted=true

[slot.rootfs.0]
device=/dev/disk/by-partlabel/system0
type=raw
bootname=A

[slot.rootfs.1]
device=/dev/disk/by-partlabel/system1
type=raw
bootname=B

