#! /bin/sh

set -e

DEVICE_CHILD="$(findfs PARTLABEL=data)"
DEVICE_CHILD_NAME="$(basename "${DEVICE_CHILD}")"
DEVICE_ROOT_NAME="$(lsblk -no pkname "${DEVICE_CHILD}")"
DEVICE_ROOT="/dev/${DEVICE_ROOT_NAME}"
PART_NUM="$(cat "/sys/class/block/${DEVICE_CHILD_NAME}/partition")"

PART_TABLE="$(sfdisk -lqJ "${DEVICE_ROOT}")"
PART_LABEL="$(echo "${PART_TABLE}" | jq -r '.partitiontable.label')"

if [ "${PART_LABEL}" = "dos" ]; then
  echo "[INFO] Detected MBR partition label on ${DEVICE_ROOT}"

  DEVICE_SIZE=$(blockdev --getsize64 "${DEVICE_ROOT}")
  LAST_USABLE_LBA=$(echo "${PART_TABLE}" | jq -r "${DEVICE_SIZE} / .partitiontable.sectorsize")

  echo "[INFO] Last usable logical block ${LAST_USABLE_LBA}"

  JQ_FILTER=".partitiontable.partitions[] | select ( .node == \"${DEVICE_CHILD}\" ) | .start + .size"
  DATA_PARTITION_END="$(echo "${PART_TABLE}" | jq "${JQ_FILTER}")"
  echo "[INFO] Data partition end block ${DATA_PARTITION_END}"

  UNUSED_BLOCKS=$((LAST_USABLE_LBA - DATA_PARTITION_END))
  if [ "${UNUSED_BLOCKS}" -le "16384" ]; then
    echo "[INFO] No resize of data partition needed"
    exit 0
  fi

  echo "[INFO] Update data partition ${PART_NUM}"
  echo ", +" | sfdisk --no-reread --no-tell-kernel -N "${PART_NUM}" "${DEVICE_ROOT}"
  sfdisk -V "${DEVICE_ROOT}"

  partx -u "${DEVICE_ROOT}"
  udevadm settle

  resize2fs "${DEVICE_CHILD}"

  if ! systemctl start "dev-disk-by\\x2dlabel-data.device"; then
    echo "[ERROR] Data partition not found!"
    exit 1
  fi

  echo "[INFO] Finished data partition resizing"
fi

