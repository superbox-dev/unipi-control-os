################################################################################
#
# unipi_tools
#
################################################################################

UNIPI_TOOLS_VERSION = 1.2.46
UNIPI_TOOLS_SOURCE = $(UNIPI_TOOLS_VERSION).tar.gz
UNIPI_TOOLS_SITE = https://github.com/UniPiTechnology/unipi-tools/archive/refs/tags

# UNIPI_TOOLS_LICENSE = GPL-2.0
# UNIPI_TOOLS_LICENSE_FILES = COPYING

UNIPI_TOOLS_DEPENDENCIES += libmodbus libtool unipi_kernel

MODBUS_LIBDIR = $(STAGING_DIR)/usr/lib
BINFILES = unipi_tcp_server fwspi fwserial unipihostname unipicheck

define UNIPI_TOOLS_BUILD_CMDS
	cd $(@D)/src; $(MAKE) $(TARGET_CONFIGURE_OPTS) LDFLAGS="-L$(MODBUS_LIBDIR) -lmodbus -lm"
	cd $(@D)/overlays; $(MAKE) $(TARGET_CONFIGURE_OPTS) LINUX_DIR_PATH=$(LINUX_DIR)
endef

define UNIPI_TOOLS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(BINFILES:%=$(@D)/src/%) -t $(TARGET_DIR)/opt/unipi/tools
	$(INSTALL) -D -m 0644 $(@D)/src/unipi-target.map -t $(TARGET_DIR)/opt/unipi/data
	$(INSTALL) -D -m 0644 $(@D)/overlays/*.dtbo -t $(BINARIES_DIR)/rpi-firmware/overlays
endef

$(eval $(generic-package))
