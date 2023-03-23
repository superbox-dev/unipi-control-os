################################################################################
#
# unipi-os-configurator-data
#
################################################################################

UNIPI_OS_CONFIGURATOR_DATA_VERSION = 0.30
UNIPI_OS_CONFIGURATOR_DATA_SOURCE = unipi-os-configurator-data_$(UNIPI_OS_CONFIGURATOR_DATA_VERSION)~bullseye-neuron64_arm64.de
UNIPI_OS_CONFIGURATOR_DATA_SITE = https://repo.unipi.technology/debian/pool/neuron-main/u/unipi-os-configurator-data
UNIPI_OS_CONFIGURATOR_DATA_LICENSE = GPL-3.0+

UDEV_RULES = 30-unipi-rtc.rules 95-unipi-extcomm.rules 95-unipi-usb-serial.rules
TMPFILES = cpufreq.conf spi_nosleep.conf

define UNIPI_OS_CONFIGURATOR_DATA_EXTRACT_CMDS
    ar x $(UNIPI_OS_CONFIGURATOR_DATA_DL_DIR)/$(UNIPI_OS_CONFIGURATOR_DATA_SOURCE) --output $(@D)
    $(TAR) xf $(@D)/data.tar.xz -C $(@D)
endef

define UNIPI_OS_CONFIGURATOR_DATA_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0644 $(@D)/etc/modprobe.d/neuron-blacklist.conf -t $(TARGET_DIR)/etc/modprobe.d
    $(INSTALL) -D -m 0644 $(@D)/etc/modules-load.d/i2c-dev.conf -t $(TARGET_DIR)/etc/modules-load.d
    $(INSTALL) -D -m 0644 $(@D)/lib/modprobe.d/ds2482-i2c-alias.conf -t $(TARGET_DIR)/lib/modprobe.d
    $(INSTALL) -D -m 0644 $(@D)/lib/systemd/system.conf.d/unipi.conf -t $(TARGET_DIR)/lib/systemd/system.conf.d
    $(INSTALL) -D -m 0644 $(UDEV_RULES:%=$(@D)/lib/udev/%) -t $(TARGET_DIR)/lib/udev
	$(INSTALL) -D -m 0644 $(TMPFILES:%=$(@D)/usr/lib/tmpfiles.d/%) $-t (TARGET_DIR)/usr/lib/tmpfiles.d
endef

define UNIPI_OS_CONFIGURATOR_DATA_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 $(UNIPI_OS_CONFIGURATOR_DATA_PKGDIR)usr/lib/systemd/system/hwclock.service $(TARGET_DIR)/usr/lib/systemd/system/hwclock.service
endef

$(eval $(generic-package))
