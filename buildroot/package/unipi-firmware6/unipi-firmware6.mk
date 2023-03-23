################################################################################
#
# unipi-firmware6
#
################################################################################

UNIPI_FIRMWARE6_VERSION = 6.14
UNIPI_FIRMWARE6_SOURCE = unipi-firmware6_$(UNIPI_FIRMWARE6_VERSION)_all.deb
UNIPI_FIRMWARE6_SITE = https://repo.unipi.technology/debian/pool/main/u/unipi-firmware6
UNIPI_FIRMWARE6_LICENSE = GPL-3.0+

define UNIPI_FIRMWARE6_EXTRACT_CMDS
    ar x $(UNIPI_FIRMWARE6_DL_DIR)/$(UNIPI_FIRMWARE6_SOURCE) --output $(@D)
    $(TAR) xf $(@D)/data.tar.xz -C $(@D)
endef

define UNIPI_FIRMWARE6_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(@D)/opt/unipi/firmware)/* -t $(TARGET_DIR)/opt/unipi/firmware
endef

$(eval $(generic-package))
