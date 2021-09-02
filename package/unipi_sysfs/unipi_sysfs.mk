################################################################################
#
# unipi_sysfs
#
################################################################################

UNIPI_SYSFS_VERSION = 1.70
UNIPI_SYSFS_SOURCE = unipi-kernel-$(UNIPI_SYSFS_VERSION).tar.gz
UNIPI_SYSFS_SITE = https://git.unipi.technology/UniPi/unipi-kernel/-/archive/$(UNIPI_SYSFS_VERSION)

UNIPI_SYSFS_LICENSE = GPL-2.0
UNIPI_SYSFS_LICENSE_FILES = COPYING

UNIPI_SYSFS_DEPENDENCIES += linux

UNIPI_SYSFS_MODULE_SUBDIRS = modules/unipi modules/rtc-unipi

$(eval $(kernel-module))

define UNIPI_SYSFS_INSTALL_DTB_OVERLAYS
	$(INSTALL) -D -m 0644 $(BR2_EXTERNAL_UNIPI_PATH)/package/unipi_sysfs/device_tree/neuron-spi-new.dtbo $(BINARIES_DIR)/rpi-firmware/overlays/
endef

UNIPI_SYSFS_POST_INSTALL_TARGET_HOOKS += UNIPI_SYSFS_INSTALL_DTB_OVERLAYS

$(eval $(generic-package))
