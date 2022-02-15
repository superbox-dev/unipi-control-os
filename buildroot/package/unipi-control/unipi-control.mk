################################################################################
#
# unipi-control
#
################################################################################

UNIPI_CONTROL_VERSION = 1.0.5
UNIPI_CONTROL_SOURCE = $(UNIPI_CONTROL_VERSION).tar.gz
UNIPI_CONTROL_SITE = https://github.com/mh-superbox/unipi-control/archive/refs/tags
UNIPI_CONTROL_SETUP_TYPE = setuptools
UNIPI_CONTROL_LICENSE = MIT
UNIPI_CONTROL_LICENSE_FILES = LICENCE

$(eval $(python-package))
