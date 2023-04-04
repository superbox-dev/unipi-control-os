#!/bin/sh

set -u
set -e

HDD_IMG="${BINARIES_DIR}/sdcard.img"
BOOT_IMG="${BINARIES_DIR}/boot.vfat"
ROOTFS_IMG="${BINARIES_DIR}/rootfs.ext4"
BOOT_DATA="${BINARIES_DIR}/boot"

pre_image() {
  mkdir -p "${TARGET_DIR}/boot"
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
  data_img="${BINARIES_DIR}/data.ext4"
  overlay_img="${BINARIES_DIR}/overlay.ext4"

  rm -f "${HDD_IMG}"
  truncate --size="1778MiB" "${HDD_IMG}"

  (
     echo "label: dos"
     echo "label-id: 0x20230403"
     echo "unit: sectors"
     echo "boot      : start=1MiB,      size=30MiB,     type=c, bootable"   # Create the boot partition
     echo "bootstate : start=31MiB,     size=8MiB,      type=83"            # Make a Linux partition
     echo "data      : start=1678MiB,   size=100MiB,    type=83"            # Make a Linux partition
     echo "extended  : start=39MiB,     size=1639MiB,   type=5"             # Make an extended partition
     echo "system    : start=40MiB,     size=768MiB,    type=83"            # Make a logical Linux partition
     echo "system    : start=809MiB,    size=768MiB,    type=83"            # Make a logical Linux partition
     echo "overlay   : start=1578MiB,   size=100MiB,    type=83"            # Make a logical Linux partition
  ) > "${disk_layout}"

  sfdisk "${HDD_IMG}" < "${disk_layout}"

  dd if="${BOOT_IMG}" of="${HDD_IMG}" conv=notrunc,sparse bs=512 seek=2048
  dd if="${ROOTFS_IMG}" of="${HDD_IMG}" conv=notrunc,sparse bs=512 seek=81920

  rm -f "${data_img}"
  truncate --size="100MiB" "${data_img}"
  mkfs.ext4 "${data_img}"
  dd if="${data_img}" of="${HDD_IMG}" conv=notrunc,sparse bs=512 seek=3436544

  rm -f "${overlay_img}"
  truncate --size="100MiB" "${overlay_img}"
  mkfs.ext4 "${overlay_img}"
  dd if="${overlay_img}" of="${HDD_IMG}" conv=notrunc,sparse bs=512 seek=3231744
}

convert_disk_image_xz() {
    rm -f "${HDD_IMG}.xz"
    xz -3 -T0 "${HDD_IMG}"
}

pre_image
create_boot_image
create_disk_mbr
convert_disk_image_xz
