################################################################################
#
# unipi-modbus-tools
#
################################################################################

UNIPI_MODBUS_TOOLS_VERSION = 2.14
UNIPI_MODBUS_TOOLS_SOURCE = unipi-modbus-tools_$(UNIPI_MODBUS_TOOLS_VERSION)~bullseye_arm64.deb
UNIPI_MODBUS_TOOLS_SITE = https://repo.unipi.technology/debian/pool/main/u/unipi-tools
UNIPI_MODBUS_TOOLS_LICENSE = GPL-3.0+

UNIPI_MODBUS_TOOLS_DEPENDENCIES += libmodbus libtool

define UNIPI_MODBUS_TOOLS_EXTRACT_CMDS
    ar x $(UNIPI_MODBUS_TOOLS_DL_DIR)/$(UNIPI_MODBUS_TOOLS_SOURCE) --output $(@D)
    $(TAR) xf $(@D)/data.tar.xz -C $(@D)
endef

define UNIPI_MODBUS_TOOLS_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0644 $(@D)/etc/default/unipitcp -t $(TARGET_DIR)/etc/default
    $(INSTALL) -D -m 0755 $(@D)/opt/unipi/tools/unipi_tcp_server -t $(TARGET_DIR)/opt/unipi/tools
endef

define UNIPI_MODBUS_TOOLS_INSTALL_INIT_SYSTEMD
    $(INSTALL) -D -m 0644 $(@D)/lib/systemd/system/unipitcp.service -t $(TARGET_DIR)/usr/lib/systemd/system
endef

$(eval $(generic-package))
