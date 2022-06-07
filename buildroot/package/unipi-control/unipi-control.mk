################################################################################
#
# unipi-control
#
################################################################################

UNIPI_CONTROL_VERSION = 1.2.0
UNIPI_CONTROL_SOURCE = $(UNIPI_CONTROL_VERSION).tar.gz
UNIPI_CONTROL_SITE = https://github.com/mh-superbox/unipi-control/archive/refs/tags
UNIPI_CONTROL_SETUP_TYPE = setuptools
UNIPI_CONTROL_LICENSE = MIT
UNIPI_CONTROL_LICENSE_FILES = LICENCE

define UNIPI_CONTROL_INSTALL_CONFIG
	cp -rf $(@D)/src/unipi_control/installer/etc/unipi -t $(TARGET_DIR)/etc
endef

UNIPI_CONTROL_POST_INSTALL_TARGET_HOOKS += UNIPI_CONTROL_INSTALL_CONFIG 

define UNIPI_CONTROL_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 $(@D)/src/unipi_control/installer/etc/systemd/system/unipi-control.service \
	       	$(TARGET_DIR)/etc/systemd/system/unipi-control.service
endef

$(eval $(python-package))
