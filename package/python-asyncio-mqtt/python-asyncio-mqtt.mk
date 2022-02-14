################################################################################
#
# python-asyncio-mqtt
#
################################################################################

PYTHON_ASYNCIO_MQTT_VERSION = 0.12.1
PYTHON_ASYNCIO_MQTT_SOURCE = v$(PYTHON_ASYNCIO_MQTT_VERSION).tar.gz
PYTHON_ASYNCIO_MQTT_SITE = https://github.com/sbtinstruments/asyncio-mqtt/archive/refs/tags
PYTHON_ASYNCIO_MQTT_SETUP_TYPE = setuptools
PYTHON_ASYNCIO_MQTT_LICENSE = BSD-3-Clause
PYTHON_ASYNCIO_MQTT_LICENSE_FILES = LICENCE

$(eval $(python-package))
