################################################################################
#
# unipi_kernel
#
################################################################################

UNIPI_KERNEL_VERSION = 1.70
UNIPI_KERNEL_SOURCE = $(UNIPI_KERNEL_VERSION).tar.gz
UNIPI_KERNEL_SITE = https://github.com/mh-superbox/unipi-kernel/archive/refs/tags
#UNIPI_KERNEL_SOURCE = unipi-kernel-$(UNIPI_KERNEL_VERSION).tar.gz
#UNIPI_KERNEL_SITE = https://git.unipi.technology/UniPi/unipi-kernel/-/archive/$(UNIPI_KERNEL_VERSION)

UNIPI_KERNEL_LICENSE = GPL-2.0
UNIPI_KERNEL_LICENSE_FILES = COPYING

UNIPI_KERNEL_DEPENDENCIES += linux

UNIPI_KERNEL_MODULE_SUBDIRS = modules/unipi modules/rtc-unipi

$(eval $(kernel-module))

define UNIPI_KERNEL_INSTALL_DTB_OVERLAYS
	$(INSTALL) -D -m 0644 $(BR2_EXTERNAL_UNIPI_PATH)/package/unipi_kernel/device_tree/neuron-spi-new.dtbo $(BINARIES_DIR)/rpi-firmware/overlays/
endef

UNIPI_KERNEL_POST_INSTALL_TARGET_HOOKS += UNIPI_KERNEL_INSTALL_DTB_OVERLAYS

$(eval $(generic-package))
