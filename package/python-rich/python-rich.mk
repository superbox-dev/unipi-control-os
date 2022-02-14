################################################################################
#
# python-rich
#
################################################################################

PYTHON_RICH_VERSION = 11.2.0
PYTHON_RICH_SOURCE = v$(PYTHON_RICH_VERSION).tar.gz
PYTHON_RICH_SITE = https://github.com/Textualize/rich/archive/refs/tags
PYTHON_RICH_SETUP_TYPE = setuptools
PYTHON_RICH_LICENSE = MIT
PYTHON_RICH_LICENSE_FILES = LICENCE

$(eval $(python-package))
