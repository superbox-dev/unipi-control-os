# Upgrading OS

<!-- content start -->
Unipi Control OS use [RAUC](https://rauc.io/) to upgrade the system.
The latest release can be downloaded from our [repository](https://unipi.superbox.one/unipi-control-os/releases/) or from [GitHub](https://github.com/superbox-dev/unipi-control-os/releases).

1. Connect to your Unipi Neuron with `ssh` on Linux/macOS or with [Putty](https://www.putty.org/) on Windows.
    ```shell
    ssh unipi@unipi.local
    ```
2. Download the latest [release](https://github.com/superbox-dev/unipi-control-os/releases) `*.rauc` from GitHub.
    ```shell
    wget https://github.com/superbox-dev/unipi-control-os/releases/download/v1.0/unipi-control-os-neuron-rpi3-64-1.0.raucb
    ```
3. Install the RAUC file with:
    ```shell
    sudo rauc install unipi-control-os-neuron-rpi3-64-1.0.raucb
    ```
4. Reboot the system with `sudo reboot`
<!-- content end -->
