################################################################################
#
# unipi_kernel
#
################################################################################

UNIPI_KERNEL_VERSION = 1.72
UNIPI_KERNEL_SOURCE = $(UNIPI_KERNEL_VERSION).tar.gz
UNIPI_KERNEL_SITE = https://github.com/UniPiTechnology/unipi-kernel/archive/refs/tags

UNIPI_KERNEL_LICENSE = GPL-2.0
UNIPI_KERNEL_LICENSE_FILES = COPYING

UNIPI_KERNEL_DEPENDENCIES += linux

UNIPI_KERNEL_MODULE_SUBDIRS = modules/unipi modules/rtc-unipi

$(eval $(kernel-module))
$(eval $(generic-package))
