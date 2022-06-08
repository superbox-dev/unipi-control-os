################################################################################
#
# unipi-tools
#
################################################################################

UNIPI_TOOLS_VERSION = 1.2.46
UNIPI_TOOLS_SOURCE = $(UNIPI_TOOLS_VERSION).tar.gz
UNIPI_TOOLS_SITE = https://github.com/UniPiTechnology/unipi-tools/archive/refs/tags

# UNIPI_TOOLS_LICENSE = GPL-2.0
# UNIPI_TOOLS_LICENSE_FILES = COPYING

UNIPI_TOOLS_DEPENDENCIES += libmodbus libtool unipi-kernel

MODBUS_LIBDIR = $(STAGING_DIR)/usr/lib
BINFILES = unipi_tcp_server fwspi fwserial unipihostname unipicheck

define UNIPI_TOOLS_BUILD_CMDS
	cd $(@D)/src; $(MAKE) $(TARGET_CONFIGURE_OPTS) LDFLAGS="-L$(MODBUS_LIBDIR) -lmodbus -lm" PROJECT_VERSION=$(UNIPI_TOOLS_VERSION)
	cd $(@D)/overlays; $(MAKE) $(TARGET_CONFIGURE_OPTS) LINUX_DIR_PATH=$(LINUX_DIR)
endef

define UNIPI_TOOLS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(BINFILES:%=$(@D)/src/%) -t $(TARGET_DIR)/opt/unipi/tools
	$(INSTALL) -D -m 0644 $(@D)/src/unipi-target.map -t $(TARGET_DIR)/opt/unipi/data
	$(INSTALL) -D -m 0644 $(@D)/overlays/*.dtbo -t $(BINARIES_DIR)/rpi-firmware/overlays	
	$(INSTALL) -D -m 644 $(@D)/unipi-common/etc/modprobe.d/neuron-blacklist.conf $(TARGET_DIR)/etc/modprobe.d/neuron-blacklist.conf
	$(INSTALL) -D -m 644 $(@D)/unipi-common/etc/initramfs/modules.d/unipi $(TARGET_DIR)/etc/modules-load.d/unipi.conf
	$(INSTALL) -D -m 644 $(@D)/unipi-common/udev/95-unipi-plc-devices.rules $(TARGET_DIR)/etc/udev/rules.d/95-unipi-plc-devices.rules
	$(INSTALL) -D -m 644 $(@D)/unipi-common/udev/95-unipi-usb-serial.rules $(TARGET_DIR)/etc/udev/rules.d/95-unipi-usb-serial.rules
	$(INSTALL) -D -m 755 $(UNIPI_TOOLS_PKGDIR)unipiconfig $(TARGET_DIR)/opt/unipi/tools/unipiconfig
endef

define UNIPI_TOOLS_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 $(@D)/unipi-modbus-tools/etc/default/unipitcp $(TARGET_DIR)/etc/default/unipitcp
	$(INSTALL) -D -m 644 $(@D)/unipi-modbus-tools/systemd/system/unipitcp.service $(TARGET_DIR)/usr/lib/systemd/system/unipitcp.service
	$(INSTALL) -D -m 644 $(@D)/unipi-common/systemd/system/unipicheck.service $(TARGET_DIR)/usr/lib/systemd/system/unipicheck.service
	$(INSTALL) -D -m 644 $(@D)/unipi-common/systemd/system/unipigate.target $(TARGET_DIR)/usr/lib/systemd/system/unipigate.target
	$(INSTALL) -D -m 644 $(@D)/unipi-common/systemd/system/unipispi.target $(TARGET_DIR)/usr/lib/systemd/system/unipispi.target
	$(INSTALL) -D -m 644 $(@D)/unipi-common/etc/tmpfiles.d/cpufreq.conf $(TARGET_DIR)/etc/tmpfiles.d/cpufreq.conf
	$(INSTALL) -D -m 644 $(UNIPI_TOOLS_PKGDIR)systemd/hwclock.service $(TARGET_DIR)/usr/lib/systemd/system/hwclock.service
	$(INSTALL) -D -m 644 $(UNIPI_TOOLS_PKGDIR)systemd/unipiconfig.service $(TARGET_DIR)/usr/lib/systemd/system/unipiconfig.service
endef

$(eval $(generic-package))
