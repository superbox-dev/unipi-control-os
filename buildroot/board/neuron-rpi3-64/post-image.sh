#!/bin/sh

set -u
set -e

BOOT_IMG="${BINARIES_DIR}/boot.vfat"
ROOTFS_IMG="${BINARIES_DIR}/rootfs.ext4"
BOOT_DATA="${BINARIES_DIR}/boot"

pre_image() {
  mkdir -p "${TARGET_DIR}/boot/efi"
  cp "${BR2_EXTERNAL_UNIPI_PATH}/board/neuron-rpi3-64/boot.cmd" "${TARGET_DIR}/"
}

create_boot_image() {
  rm -rf "${BOOT_DATA}"
  mkdir "${BOOT_DATA}"

  cp -t "${BOOT_DATA}" \
    "${BINARIES_DIR}/u-boot.bin" \
    "${BINARIES_DIR}/boot.scr"
  cp "${BINARIES_DIR}"/*.dtb "${BOOT_DATA}/"
  cp -r "${BINARIES_DIR}/rpi-firmware/"* "${BOOT_DATA}/"
  rm "${BOOT_DATA}/cmdline.txt"

  echo "mtools_skip_check=1" > ~/.mtoolsrc
  rm -f "${BOOT_IMG}"
  truncate --size=30MiB "${BOOT_IMG}"
  mkfs -t vfat -n "BOOT" "${BOOT_IMG}"
  mcopy -i "${BOOT_IMG}" -sv "${BOOT_DATA}"/* ::
}

create_disk_mbr() {
  disk_layout="${BINARIES_DIR}/disk.layout"
  hdd_img="${BINARIES_DIR}/sdcard.img"

  rm -f "${hdd_img}"
  truncate --size="1066MiB" "${hdd_img}"

  (
     echo "label: dos"
     echo "label-id: 0x20230403"
     echo "unit: sectors"
     echo "boot      : start=1MiB,      size=30MiB,     type=c, bootable"   # Create the boot partition
     echo "bootstate : start=31MiB,     size=8MiB,      type=83"            # Make a Linux partition
     echo "data      : start=1065MiB,   size=1MiB,      type=83"            # Make a Linux partition
     echo "extended  : start=39MiB,     size=1026MiB,   type=5"             # Make an extended partition
     echo "system    : start=40MiB,     size=512MiB,    type=83"            # Make a logical Linux partition
     echo "system    : start=553MiB,    size=512MiB,    type=83"            # Make a logical Linux partition
  ) > "${disk_layout}"

  sfdisk "${hdd_img}" < "${disk_layout}"

  dd if="${BOOT_IMG}" of="${hdd_img}" conv=notrunc,sparse bs=512 seek=2048
  dd if="${ROOTFS_IMG}" of="${hdd_img}" conv=notrunc,sparse bs=512 seek=81920
}

pre_image
create_boot_image
create_disk_mbr
