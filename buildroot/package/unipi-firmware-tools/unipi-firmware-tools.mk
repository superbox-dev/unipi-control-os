################################################################################
#
# unipi-firmware-tools
#
################################################################################

UNIPI_FIRMWARE_TOOLS_VERSION = 2.14
UNIPI_FIRMWARE_TOOLS_SOURCE = unipi-firmware-tools_$(UNIPI_FIRMWARE_TOOLS_VERSION)~bullseye_arm64.deb
UNIPI_FIRMWARE_TOOLS_SITE = https://repo.unipi.technology/debian/pool/main/u/unipi-tools
UNIPI_FIRMWARE_TOOLS_LICENSE = GPL-3.0+

BINFILES = fwspi fwserial

define UNIPI_FIRMWARE_TOOLS_EXTRACT_CMDS
    ar x $(UNIPI_FIRMWARE_TOOLS_DL_DIR)/$(UNIPI_FIRMWARE_TOOLS_SOURCE) --output $(@D)
    $(TAR) xf $(@D)/data.tar.xz -C $(@D)
endef

define UNIPI_FIRMWARE_TOOLS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(BINFILES:%=$(@D)/opt/unipi/tools/%) -t $(TARGET_DIR)/opt/unipi/tools
endef

define UNIPI_FIRMWARE_TOOLS_INSTALL_INIT_SYSTEMD
    $(INSTALL) -D -m 0644 $(@D)/lib/systemd/system/unipifwupdate.service -t $(TARGET_DIR)/usr/lib/systemd/system
endef

$(eval $(generic-package))
