part start mmc 0 2 dev_env

# Default environments
setenv console "serial"
setenv verbosity "6"

mmc read ${ramdisk_addr_r} ${dev_env} 0x20
env import -c ${ramdisk_addr_r} 0x4000

test -n "${BOOT_ORDER}" || setenv BOOT_ORDER "A B"
test -n "${BOOT_A_LEFT}" || setenv BOOT_A_LEFT 3
test -n "${BOOT_B_LEFT}" || setenv BOOT_B_LEFT 3

# Set console arguments
test "${console}" = "display" && setenv consoleargs "console=tty1"
test "${console}" = "serial" && setenv consoleargs "console=tty1 console=ttyS0,115200"

# Default bootargs
setenv bootargs_default "loglevel=${verbosity} fsck.repair=yes 8250.nr_uarts=1 cgroup_enable=memory ${consoleargs}"

# System A/B
setenv bootargs_a "root=PARTUUID=20230403-05 rootfstype=ext4 rootwait ro"
setenv bootargs_b "root=PARTUUID=20230404-06 rootfstype=ext4 rootwait ro"

setenv bootargs

for BOOT_SLOT in "${BOOT_ORDER}"; do
  if test "x${bootargs}" != "x"; then
    # skip remaining slots
  elif test "x${BOOT_SLOT}" = "xA"; then
    if test ${BOOT_A_LEFT} -gt 0; then
      setexpr BOOT_A_LEFT ${BOOT_A_LEFT} - 1
      echo "Trying to boot slot A, ${BOOT_A_LEFT} attempts remaining. Loading kernel ..."
      if load mmc 0:5 ${kernel_addr_r} /boot/Image; then
        setenv bootargs "${bootargs_default} ${bootargs_a} rauc.slot=A"
      fi
    fi
  elif test "x${BOOT_SLOT}" = "xB"; then
    if test ${BOOT_B_LEFT} -gt 0; then
      setexpr BOOT_B_LEFT ${BOOT_B_LEFT} - 1
      echo "Trying to boot slot B, ${BOOT_B_LEFT} attempts remaining. Loading kernel ..."
      if load mmc 0:6 ${kernel_addr_r} /boot/Image; then
        setenv bootargs "${bootargs_default} ${bootargs_b} rauc.slot=B"
      fi
    fi
  fi
done

if test -n "${bootargs}"; then
  env export -c -s 0x4000 ${ramdisk_addr_r} BOOT_ORDER BOOT_A_LEFT BOOT_B_LEFT
  mmc write ${ramdisk_addr_r} ${dev_env} 0x20
else
  echo "No valid slot found, resetting tries to 3"
  setenv BOOT_A_LEFT 3
  setenv BOOT_B_LEFT 3
  env export -c -s 0x4000 ${ramdisk_addr_r} BOOT_ORDER BOOT_A_LEFT BOOT_B_LEFT
  mmc write ${ramdisk_addr_r} ${dev_env} 0x20
  reset
fi

printenv bootargs
echo "Starting kernel"
booti ${kernel_addr_r} - ${fdt_addr}

echo "Boot failed, resetting..."
reset

# Recompile with:
# mkimage -C none -A arm -T script -d /boot/boot.cmd /boot/efi/boot.scr
