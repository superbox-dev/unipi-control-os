################################################################################
#
# unipi-python-paho-mqtt
#
################################################################################

UNIPI_PYTHON_PAHO_MQTT_VERSION = 1.6.1
UNIPI_PYTHON_PAHO_MQTT_SOURCE = paho-mqtt-$(UNIPI_PYTHON_PAHO_MQTT_VERSION).tar.gz
UNIPI_PYTHON_PAHO_MQTT_SITE = https://files.pythonhosted.org/packages/f8/dd/4b75dcba025f8647bc9862ac17299e0d7d12d3beadbf026d8c8d74215c12
UNIPI_PYTHON_PAHO_MQTT_SETUP_TYPE = setuptools
UNIPI_PYTHON_PAHO_MQTT_LICENSE = OSI Approved

$(eval $(python-package))
