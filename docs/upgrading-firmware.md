# Upgrading Firmware

<!-- content start -->
The Unipi Neuron firmware can be updated like the original upgrade process from [kb.unipi.technology](https://kb.unipi.technology/en:sw:04-unipi-firmware).

1. Install the latest firmware with the package manager:
    ```shell
    sudo opkg install unipi-firmware6
    ```
2. Check the current firmware version installed:
    ```shell
    /opt/unipi/tools/fwspi -v --auto
    ```
3. Update to the latest obtained FW version with:
    ```shell
    /opt/unipi/tools/fwspi --auto -P
    ```
4. Re-check the current firmware version installed:
    ```shell
    /opt/unipi/tools/fwspi --auto
    ```
<!-- content end -->
