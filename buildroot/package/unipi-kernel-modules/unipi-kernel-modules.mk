################################################################################
#
# unipi-kernel-modules
#
################################################################################

UNIPI_KERNEL_MODULES_VERSION = 2.22
UNIPI_KERNEL_MODULES_SOURCE = $(UNIPI_KERNEL_MODULES_VERSION).tar.gz
UNIPI_KERNEL_MODULES_SITE = https://github.com/UniPiTechnology/unipi-kernel-modules/archive/refs/tags
UNIPI_KERNEL_MODULES_LICENSE = GPL-2.0
UNIPI_KERNEL_MODULES_LICENSE_FILES = COPYING

UNIPI_KERNEL_MODULES_DEPENDENCIES += linux

UNIPI_KERNEL_MODULES_MODULE_SUBDIRS = modules/rtc-unipi modules/unipi-id modules/unipi-rfkill modules/unipi-mfd

$(eval $(kernel-module))
$(eval $(generic-package))
