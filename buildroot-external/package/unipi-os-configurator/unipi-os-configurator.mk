################################################################################
#
# unipi-os-configurator
#
################################################################################

UNIPI_OS_CONFIGURATOR_VERSION = 0.42
UNIPI_OS_CONFIGURATOR_SOURCE = unipi-os-configurator_$(UNIPI_OS_CONFIGURATOR_VERSION)~bullseye_arm64.deb
UNIPI_OS_CONFIGURATOR_SITE = https://repo.unipi.technology/debian/pool/main/u/unipi-os-configurator
UNIPI_OS_CONFIGURATOR_LICENSE = GPL-3.0+

define UNIPI_OS_CONFIGURATOR_EXTRACT_CMDS
	$(AR) x --output $(@D) $(UNIPI_OS_CONFIGURATOR_DL_DIR)/$(UNIPI_OS_CONFIGURATOR_SOURCE)
	$(TAR) xf $(@D)/data.tar.xz -C $(@D)
endef

define UNIPI_OS_CONFIGURATOR_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0744 $(@D)/opt/unipi/tools/{uhelper,unipiid} -t $(TARGET_DIR)/opt/unipi/tools
	$(INSTALL) -D -m 0644 $(@D)/lib/udev/rules.d/90-unipi-id.rules -t $(TARGET_DIR)/lib/udev/rules.d
endef

$(eval $(generic-package))
