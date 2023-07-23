################################################################################
#
# unipi-kernel-modules
#
################################################################################

UNIPI_KERNEL_MODULES_VERSION = 1.124
UNIPI_KERNEL_MODULES_SOURCE = v$(UNIPI_KERNEL_MODULES_VERSION).tar.gz
UNIPI_KERNEL_MODULES_SITE = https://github.com/superbox-dev/unipi-kernel/archive/refs/tags
UNIPI_KERNEL_MODULES_LICENSE = GPL-3.0+

UNIPI_KERNEL_MODULES_DEPENDENCIES += linux
UNIPI_KERNEL_MODULES_MODULE_SUBDIRS = modules/rtc-unipi modules/unipi modules/unipi-id modules/unipi-rfkill

define UNIPI_KERNEL_MODULES_BUILD_CMDS
	cd $(@D)/overlays; $(MAKE) $(TARGET_CONFIGURE_OPTS) LINUX_DIR_PATH=$(LINUX_DIR)
endef

define UNIPI_KERNEL_MODULES_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(@D)/overlays/*.dtbo -t $(BINARIES_DIR)/rpi-firmware/overlays
endef

$(eval $(kernel-module))
$(eval $(generic-package))
