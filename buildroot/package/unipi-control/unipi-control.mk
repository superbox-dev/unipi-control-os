################################################################################
#
# unipi-control
#
################################################################################

UNIPI_CONTROL_VERSION = 2023.3
UNIPI_CONTROL_SOURCE = unipi-control-$(UNIPI_CONTROL_VERSION).tar.gz
UNIPI_CONTROL_SITE = https://files.pythonhosted.org/packages/bc/47/2cfae354ea112889a72c93c2df5fe643528b6aa5153d3b6dac008787ffdf

UNIPI_CONTROL_LICENSE = MIT
UNIPI_CONTROL_LICENSE_FILES = LICENSE

UNIPI_CONTROL_SETUP_TYPE = setuptools

define UNIPI_CONTROL_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(UNIPI_CONTROL_PKGDIR)etc/unipi/control.yaml $(TARGET_DIR)/etc/unipi/control.yaml
	$(INSTALL) -D -m 0644 $(@D)/install/etc/unipi/control.yaml -t $(TARGET_DIR)/etc/unipi/control.yaml.example
	$(INSTALL) -D -m 0644 $(@D)/install/etc/unipi/hardware/neuron/L203.yaml -t $(TARGET_DIR)/etc/unipi/hardware/neuron/L203.yaml
	$(INSTALL) -D -m 0644 $(@D)/install/etc/unipi/hardware/extensions/Eastron_SDM120M.yaml -t $(TARGET_DIR)/etc/unipi/hardware/extensions/Eastron_SDM120M.yaml
endef

define UNIPI_CONTROL_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 $(@D)src/unipi_control/install/etc/systemd/system/unipi-control.service $(TARGET_DIR)/usr/lib/systemd/system/unipi-control.service
endef

$(eval $(python-package))
$(eval $(generic-package))
