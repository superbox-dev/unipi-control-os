################################################################################
#
# unipi-python-pyyaml
#
################################################################################

UNIPI_PYTHON_PYYAML_VERSION = 6.0
UNIPI_PYTHON_PYYAML_SOURCE = PyYAML-$(UNIPI_PYTHON_PYYAML_VERSION).tar.gz
UNIPI_PYTHON_PYYAML_SITE = https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844
UNIPI_PYTHON_PYYAML_SETUP_TYPE = setuptools
UNIPI_PYTHON_PYYAML_LICENSE = MIT License

$(eval $(python-package))
