################################################################################
#
# unipi-firmware
#
################################################################################

UNIPI_FIRMWARE_VERSION = 5.64
UNIPI_FIRMWARE_SOURCE = unipi-firmware_$(UNIPI_FIRMWARE_VERSION)_all.deb
UNIPI_FIRMWARE_SITE = https://repo.unipi.technology/debian/pool/main/u/unipi-firmware
UNIPI_FIRMWARE_LICENSE = GPL-3.0+

define UNIPI_FIRMWARE_EXTRACT_CMDS
    ar x $(UNIPI_FIRMWARE_DL_DIR)/$(UNIPI_FIRMWARE_SOURCE) --output $(@D)
    $(TAR) xf $(@D)/data.tar.xz -C $(@D)
endef

define UNIPI_FIRMWARE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(@D)/opt/unipi/firmware)/* -t $(TARGET_DIR)/opt/unipi/firmware
endef

$(eval $(generic-package))
