################################################################################
#
# unipi-python-asyncio-mqtt
#
################################################################################

UNIPI_PYTHON_ASYNCIO_MQTT_VERSION = 0.12.1
UNIPI_PYTHON_ASYNCIO_MQTT_SOURCE = v$(UNIPI_PYTHON_ASYNCIO_MQTT_VERSION).tar.gz
UNIPI_PYTHON_ASYNCIO_MQTT_SITE = https://github.com/sbtinstruments/asyncio-mqtt/archive/refs/tags
UNIPI_PYTHON_ASYNCIO_MQTT_SETUP_TYPE = setuptools
UNIPI_PYTHON_ASYNCIO_MQTT_LICENSE = BSD-3-Clause
UNIPI_PYTHON_ASYNCIO_MQTT_LICENSE_FILES = LICENCE

$(eval $(python-package))
