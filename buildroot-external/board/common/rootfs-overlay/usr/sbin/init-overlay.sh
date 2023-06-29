#!/bin/dash

ROOT_DEVICE=/dev/mmcblk0

resize_overlay() {
  part_table=$(sfdisk -lqJ ${ROOT_DEVICE})
  device_size=$(blockdev --getsize64 ${ROOT_DEVICE})
  last_usable_lba=$(echo "${part_table}" | jq -r "${device_size} / .partitiontable.sectorsize")
  overlay_partition_end="$(echo "${part_table}" | jq ".partitiontable.partitions[] | select ( .node == \"${ROOT_DEVICE}p5\" ) | .start + .size")"
  unused_blocks=$((last_usable_lba - overlay_partition_end))

  if [ "${unused_blocks}" -gt "16384" ]; then
    echo ", +" | sfdisk -q --no-reread --no-tell-kernel -N 4 ${ROOT_DEVICE}
    echo ", +" | sfdisk -q --no-reread --no-tell-kernel -N 5 ${ROOT_DEVICE}
    sfdisk -q -V ${ROOT_DEVICE}
    partx -u ${ROOT_DEVICE}
    udevadm settle
    resize2fs ${ROOT_DEVICE}p5
  fi
}

setup_overlay() {
  mkdir -p "/mnt/overlay/$1"
  mkdir -p "/mnt/overlay/$2"

  mount overlay -t overlay -o "lowerdir=/$1,upperdir=/mnt/overlay/$1,workdir=/mnt/overlay/$2" "/$1"
}

teardown_overlay() {
  umount /mnt/overlay
  umount /proc
}

mount -t proc proc /proc

resize_overlay

mount -t ext4 -o defaults,noatime,commit=30 ${ROOT_DEVICE}p5 /mnt/overlay

setup_overlay "etc" ".work-etc"
setup_overlay "home" ".work-home"
setup_overlay "media" ".media-var"
setup_overlay "opt/unipi" ".work-opt-unipi"
setup_overlay "root" ".work-root"
setup_overlay "usr/local" ".work-usr-local"
setup_overlay "var" ".work-var"

teardown_overlay

exec /sbin/init
