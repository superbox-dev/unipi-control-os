################################################################################
#
# unipi-kernel-modules-v2
#
################################################################################

UNIPI_KERNEL_MODULES_V2_VERSION = 2.22
UNIPI_KERNEL_MODULES_V2_SOURCE = $(UNIPI_KERNEL_MODULES_V2_VERSION).tar.gz
UNIPI_KERNEL_MODULES_V2_SITE = https://github.com/UniPiTechnology/unipi-kernel-modules/archive/refs/tags
UNIPI_KERNEL_MODULES_V2_LICENSE = GPL-2.0
UNIPI_KERNEL_MODULES_V2_LICENSE_FILES = COPYING

UNIPI_KERNEL_MODULES_V2_DEPENDENCIES += linux

UNIPI_KERNEL_MODULES_V2_MODULE_SUBDIRS = modules/rtc-unipi modules/unipi-id modules/unipi-rfkill modules/unipi-mfd

$(eval $(kernel-module))
$(eval $(generic-package))
