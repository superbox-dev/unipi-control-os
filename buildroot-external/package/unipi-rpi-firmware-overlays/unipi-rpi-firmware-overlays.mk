################################################################################
#
# unipi-rpi-firmware-overlays
#
################################################################################

UNIPI_RPI_FIRMWARE_OVERLAYS_VERSION = 1.2.46
UNIPI_RPI_FIRMWARE_OVERLAYS_SOURCE = $(UNIPI_RPI_FIRMWARE_OVERLAYS_VERSION).tar.gz
UNIPI_RPI_FIRMWARE_OVERLAYS_SITE = https://github.com/UniPiTechnology/unipi-tools/archive/refs/tags

UNIPI_RPI_FIRMWARE_OVERLAYS_DEPENDENCIES += unipi-kernel-modules-v1

define UNIPI_RPI_FIRMWARE_OVERLAYS_BUILD_CMDS
	cd $(@D)/overlays; $(MAKE) $(TARGET_CONFIGURE_OPTS) LINUX_DIR_PATH=$(LINUX_DIR)
endef

define UNIPI_RPI_FIRMWARE_OVERLAYS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(@D)/overlays/*.dtbo -t $(BINARIES_DIR)/rpi-firmware/overlays
endef

$(eval $(generic-package))
