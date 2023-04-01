setenv rootfs "/dev/mmcblk0p2"
setenv rootfstype "ext4"
setenv console "serial"
setenv verbosity "3"
setenv docker_optimizations "on"

if test -e ${devtype} ${devnum}:1 uboot.env; then
    echo 'Loading environments...';
    load ${devtype} ${devnum}:1 ${kernel_addr_r} uboot.env
    env import -t ${kernel_addr_r} ${filesize}
fi

if test "${console}" = "ttyS0,115200"; then setenv console "both"; fi
if test "${console}" = "display" || test "${console}" = "both"; then setenv consoleargs "console=tty1"; fi
if test "${console}" = "serial" || test "${console}" = "both"; then setenv consoleargs "console=ttyS0,115200 ${consoleargs}"; fi

setenv bootargs "root=${rootfs} rootwait rootfstype=${rootfstype} ${consoleargs} loglevel=${verbosity} consoleblank=0 fsck.repair=yes 8250.nr_uarts=1 ${extraargs}"

if test "${docker_optimizations}" = "on"; then setenv bootargs "${bootargs} cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1"; fi

load ${devtype} ${devnum}:1 ${kernel_addr_r} Image
booti ${kernel_addr_r} - ${fdt_addr}

echo "Boot failed, resetting..."
reset

# Recompile with:
# mkimage -C none -A arm -T script -d /boot/boot.cmd /boot/boot.scr
