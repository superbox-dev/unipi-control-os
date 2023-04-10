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

function pre_image() {
  mkdir -pv "${TARGET_DIR}/boot"
  cp "$(dirname ${BOARD_DIR})/boot.cmd" "${TARGET_DIR}/"
}

function size2sectors() {
  local f=0

  for v in "${@}"
  do
    local p=$(echo "$v" | awk \
      'BEGIN{IGNORECASE = 1}
       function printsectors(n,b,p) {printf "%u\n", n*b^p/512}
       /B$/{     printsectors($1,  1, 0)};
       /K(iB)?$/{printsectors($1,  2, 10)};
       /M(iB)?$/{printsectors($1,  2, 20)};
       /G(iB)?$/{printsectors($1,  2, 30)};
       /T(iB)?$/{printsectors($1,  2, 40)};
       /KB$/{    printsectors($1, 10,  3)};
       /MB$/{    printsectors($1, 10,  6)};
       /GB$/{    printsectors($1, 10,  9)};
       /TB$/{    printsectors($1, 10, 12)}')

    for s in $p
    do
      f=$((f+s))
    done
  done

  echo $f
}

function create_disk_image() {
  local image_name="$(os_image_name img)"
  local genbootfs_cfg="$(dirname ${BOARD_DIR})/genbootfs-$(basename ${BOARD_DIR}).cfg"
  local genimage_cfg="${BR2_EXTERNAL_UNIPI_PATH}/board/common/genimage.cfg"
  local genimage_tmp="${BUILD_DIR}/genimage.tmp"

  # Pass an empty rootpath. genimage makes a full copy of the given rootpath to
  # ${genimage_tmp}/root so passing TARGET_DIR would be a waste of time and disk
  # space. We don't rely on genimage to build the rootfs image, just to insert a
  # pre-built one in the disk image.

  trap 'rm -rf "${rootpath_tmp}"' EXIT
  local rootpath_tmp="$(mktemp -d)"

  # Generate the boot filesystem image
  rm -rfv "${genimage_tmp}"
  genimage \
	  --rootpath "${rootpath_tmp}" \
	  --tmppath "${genimage_tmp}" \
	  --inputpath "${BINARIES_DIR}" \
	  --outputpath "${BINARIES_DIR}" \
	  --config "${genbootfs_cfg}"

  # Generate the sdcard image
  rm -rfv "${genimage_tmp}"
  genimage \
    --rootpath "${rootpath_tmp}"   \
    --tmppath "${genimage_tmp}"    \
    --inputpath "${BINARIES_DIR}"  \
    --outputpath "${BINARIES_DIR}" \
    --config "${genimage_cfg}"

  rm -fv "${image_name}"
  mv -v "${BINARIES_DIR}/sdcard.img" "${image_name}"
}

function create_update_bundle() {
    local bundle_file="$(os_image_name raucb)"
    local bundle_compatible="$(rauc_compatible)"
    local bundle_version="$(os_version)"
    local rauc_folder="${BINARIES_DIR}/rauc"
    local boot="${BINARIES_DIR}/boot.vfat"
    local rootfs="${BINARIES_DIR}/rootfs.ext4"
    local key="${BR2_EXTERNAL_UNIPI_PATH}/key.pem"
    local cert="${BR2_EXTERNAL_UNIPI_PATH}/cert.pem"
    local keyring="${TARGET_DIR}/etc/rauc/keyring.pem"

    if [ ! -f "${key}" ]; then
        echo "Skip creating update bundle because of missing key ${key}!"
        return 0
    fi

    rm -rfv "${rauc_folder}" "${bundle_file}"
    mkdir -pv "${rauc_folder}"

    cp -fv "${boot}" "${rauc_folder}/boot.vfat"
    cp -fv "${rootfs}" "${rauc_folder}/rootfs.img"
    # cp -fv "${BR2_EXTERNAL_UNIPI_PATH}/ota/rauc-hook" "${rauc_folder}/hook"

    (
      echo "[update]"
      echo "compatible=${bundle_compatible}"
      echo "version=${bundle_version}"
      echo "[image.rootfs]"
      echo "filename=rootfs.img"
    ) > "${rauc_folder}/manifest.raucm"

    rauc bundle -d --cert="${cert}" --key="${key}" --keyring="${keyring}" "${rauc_folder}" "${bundle_file}"
}

function convert_disk_image_xz() {
  local image_name="$(os_image_name img)"

  rm -fv "${image_name}.xz"
  xz -v -3 -T0 "${image_name}"
}

pre_image

create_disk_image
# create_update_bundle

convert_disk_image_xz
