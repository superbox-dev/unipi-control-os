################################################################################
#
# unipi-kernel-modules-v1
#
################################################################################

UNIPI_KERNEL_MODULES_V1_VERSION = 1.72
UNIPI_KERNEL_MODULES_V1_SOURCE = $(UNIPI_KERNEL_MODULES_V1_VERSION).tar.gz
UNIPI_KERNEL_MODULES_V1_SITE = https://github.com/UniPiTechnology/unipi-kernel-modules-v1/archive/refs/tags
UNIPI_KERNEL_MODULES_V1_LICENSE = GPL-2.0
UNIPI_KERNEL_MODULES_V1_LICENSE_FILES = COPYING

UNIPI_KERNEL_MODULES_V1_DEPENDENCIES += linux

UNIPI_KERNEL_MODULES_V1_MODULE_SUBDIRS = modules/unipi modules/rtc-unipi

$(eval $(kernel-module))
$(eval $(generic-package))
