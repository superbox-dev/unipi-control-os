################################################################################
#
# unipi-kernel-modules
#
################################################################################

UNIPI_KERNEL_MODULES_VERSION = 1.124
UNIPI_KERNEL_MODULES_SOURCE = unipi-kernel-modules-dkms_$(UNIPI_KERNEL_MODULES_VERSION)_all.deb
UNIPI_KERNEL_MODULES_SITE = https://repo.unipi.technology/debian/pool/main/u/unipi-kernel-modules
UNIPI_KERNEL_MODULES_LICENSE = GPL-3.0+

UNIPI_KERNEL_MODULES_DEPENDENCIES += linux
UNIPI_KERNEL_MODULES_MODULE_SUBDIRS = modules/rtc-unipi modules/unipi modules/unipi-id modules/unipi-rfkill

define UNIPI_KERNEL_MODULES_EXTRACT_CMDS
	$(AR) x --output $(@D) $(UNIPI_KERNEL_MODULES_DL_DIR)/$(UNIPI_KERNEL_MODULES_SOURCE)
	$(TAR) xf $(@D)/data.tar.xz -C $(@D)
	mkdir $(@D)/modules
	mv $(@D)/usr/src/unipi-$(UNIPI_KERNEL_MODULES_VERSION)/* $(@D)/modules
endef

$(eval $(kernel-module))
$(eval $(generic-package))
