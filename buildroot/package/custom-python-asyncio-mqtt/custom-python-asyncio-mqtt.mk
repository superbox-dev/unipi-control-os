################################################################################
#
# custom-python-asyncio-mqtt
#
################################################################################

CUSTOM_PYTHON_ASYNCIO_MQTT_VERSION = 0.12.1
CUSTOM_PYTHON_ASYNCIO_MQTT_SOURCE = v$(CUSTOM_PYTHON_ASYNCIO_MQTT_VERSION).tar.gz
CUSTOM_PYTHON_ASYNCIO_MQTT_SITE = https://github.com/sbtinstruments/asyncio-mqtt/archive/refs/tags
CUSTOM_PYTHON_ASYNCIO_MQTT_SETUP_TYPE = setuptools
CUSTOM_PYTHON_ASYNCIO_MQTT_LICENSE = BSD-3-Clause
CUSTOM_PYTHON_ASYNCIO_MQTT_LICENSE_FILES = LICENCE

$(eval $(python-package))
