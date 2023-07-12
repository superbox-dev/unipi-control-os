################################################################################
#
# unipi-os-configurator-data
#
################################################################################

UNIPI_OS_CONFIGURATOR_DATA_VERSION = 0.50
UNIPI_OS_CONFIGURATOR_DATA_SOURCE = unipi-os-configurator-data_$(UNIPI_OS_CONFIGURATOR_DATA_VERSION)~bullseye-neuron_armhf.deb
UNIPI_OS_CONFIGURATOR_DATA_SITE = https://repo.unipi.technology/debian/pool/neuron-main/u/unipi-os-configurator-data
UNIPI_OS_CONFIGURATOR_DATA_LICENSE = GPL-3.0+

define UNIPI_OS_CONFIGURATOR_DATA_EXTRACT_CMDS
	$(AR) x --output $(@D) $(UNIPI_OS_CONFIGURATOR_DATA_DL_DIR)/$(UNIPI_OS_CONFIGURATOR_DATA_SOURCE)
	$(TAR) xf $(@D)/data.tar.xz -C $(@D)
endef

define UNIPI_OS_CONFIGURATOR_DATA_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(@D)/opt/unipi/os-configurator/udev/* $(TARGET_DIR)/opt/unipi/os-configurator/udev
	$(INSTALL) -D -m 0644 $(@D)/lib/udev/rules.d/* $(TARGET_DIR)/lib/udev/rules.d
endef

$(eval $(generic-package))
