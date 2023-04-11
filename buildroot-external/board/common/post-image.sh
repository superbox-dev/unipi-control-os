#!/bin/bash
# shellcheck disable=SC2155,SC1091

set -u
set -e

SCRIPT_DIR=${BR2_EXTERNAL_UNIPI_PATH}/board/common

BOARD_DIR=${2}
. "${BR2_EXTERNAL_UNIPI_PATH}/meta"
. "${BOARD_DIR}/meta"
. "${SCRIPT_DIR}/post-helpers.sh"

BOOT_IMG="${BINARIES_DIR}/boot.vfat"
ROOTFS_IMG="${BINARIES_DIR}/rootfs.ext4"
BOOT_DATA="${BINARIES_DIR}/boot"
GENIMAGE_ROOTPATH="$(mktemp -d)"


function pre_image() {
  mkdir -pv "${TARGET_DIR}/boot"
}

function create_disk_image() {
  local image_name="$(os_image_name img)"
  local genbootfs_cfg="$(dirname ${BOARD_DIR})/genbootfs-$(basename ${BOARD_DIR}).cfg"
  local genimage_cfg="${BR2_EXTERNAL_UNIPI_PATH}/board/common/genimage.cfg"
  local genimage_tmp="${BUILD_DIR}/genimage.tmp"

  # Pass an empty rootpath. genimage makes a full copy of the given rootpath to
  # ${GENIMAGE_ROOTPATH}/root so passing TARGET_DIR would be a waste of time and disk
  # space. We don't rely on genimage to build the rootfs image, just to insert a
  # pre-built one in the disk image.
  trap 'rm -rf "${GENIMAGE_ROOTPATH}"' EXIT

  # Generate the boot filesystem image
  rm -rfv "${genimage_tmp}"
  genimage \
	  --rootpath "${GENIMAGE_ROOTPATH}" \
	  --tmppath "${genimage_tmp}" \
	  --inputpath "${BINARIES_DIR}" \
	  --outputpath "${BINARIES_DIR}" \
	  --config "${genbootfs_cfg}"

  # Generate the sdcard image
  rm -rfv "${genimage_tmp}"
  genimage \
    --rootpath "${GENIMAGE_ROOTPATH}"   \
    --tmppath "${genimage_tmp}"    \
    --inputpath "${BINARIES_DIR}"  \
    --outputpath "${BINARIES_DIR}" \
    --config "${genimage_cfg}"

  rm -fv "${image_name}"
  mv -v "${BINARIES_DIR}/sdcard.img" "${image_name}"
}

function create_rauc_bundle() {
    local bundle_file="$(os_image_name raucb)"
    local rauc_tmp="${BINARIES_DIR}/rauc"

    rm -rfv "${rauc_tmp}" "${bundle_file}"
    mkdir -pv "${rauc_tmp}"

    ln -Lv "${BINARIES_DIR}/boot.vfat" "${rauc_tmp}/"
    ln -Lv "${BINARIES_DIR}/rootfs.ext4" "${rauc_tmp}/"

    (
      echo "[update]"
      echo "compatible=$(rauc_compatible)"
      echo "version=$(os_version)"
      echo "[image.bootloader]"
      echo "filename=boot.vfat"
      echo "[bundle]"
      echo "format=verity"
      echo "[image.rootfs]"
      echo "filename=rootfs.ext4"
    ) > "${rauc_tmp}/manifest.raucm"

    rauc bundle \
	    --cert ${BR2_EXTERNAL_UNIPI_PATH}/openssl-ca/dev/development-1.cert.pem \
	    --key ${BR2_EXTERNAL_UNIPI_PATH}/openssl-ca/dev/private/development-1.key.pem \
	    --keyring ${TARGET_DIR}/etc/rauc/keyring.pem \
	    "${rauc_tmp}" \
	    "${bundle_file}"
}

function convert_disk_image_xz() {
  local image_name="$(os_image_name img)"

  rm -fv "${image_name}.xz"
  xz -v -3 -T0 "${image_name}"
}

pre_image

create_disk_image
create_rauc_bundle

convert_disk_image_xz
