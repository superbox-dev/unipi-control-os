################################################################################
#
# unipi-python-pymodbus
#
################################################################################

UNIPI_PYTHON_PYMODBUS_VERSION = 2.5.3
UNIPI_PYTHON_PYMODBUS_SOURCE = v$(UNIPI_PYTHON_PYMODBUS_VERSION).tar.gz
UNIPI_PYTHON_PYMODBUS_SITE = https://github.com/riptideio/pymodbus/archive/refs/tags
UNIPI_PYTHON_PYMODBUS_SETUP_TYPE = setuptools
UNIPI_PYTHON_PYMODBUS_LICENSE_FILES = LICENCE

$(eval $(python-package))
