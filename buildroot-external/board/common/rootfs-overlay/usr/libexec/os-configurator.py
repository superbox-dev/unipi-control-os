#!/usr/bin/env python3
"""Configurator for the Unipi Control OS."""

import contextlib
import logging
import os
import subprocess
import sys
from pathlib import Path
from subprocess import CalledProcessError
from subprocess import CompletedProcess
from typing import ClassVar

logging.basicConfig(level=logging.INFO, format="%(message)s")
logging.getLogger("os-configurator")


class UnipiId:
    path: Path = Path("/sys/devices/platform/unipi-id/unipi-id/")

    @classmethod
    def get_line_item(cls: type["UnipiId"], item: str) -> str:
        """Read file from unipi-id sys path.

        Parameters
        ----------
        item: str
            Filename

        Returns
        -------
        str:
            Content from file.
        """
        with (cls.path / item).open("r", encoding="utf-8") as f:
            return f.readline().strip()

    @classmethod
    def get_hex_item(cls: type["UnipiId"], item: str) -> int:
        """Convert hexadecimal value to integer.

        Parameters
        ----------
        item: str
            Hexadecimal value

        Returns
        -------
        int
        """
        return int(cls.get_line_item(item), 16)


class Product:
    def __init__(self, product_id: int, name: str, **kwargs: str) -> None:
        self.id: int = product_id
        self.name: str = name
        self.vars: dict[str, str] = kwargs


class Products:
    products: ClassVar[dict[int, Product]] = {
        259: Product(259, "S103", dt="unipi_s103", udev="s103", has_ds2482="1"),
        2563: Product(2563, "S103_G", dt="unipi_s103_g", udev="s103_g", has_ds2482="1", has_gprs="1"),
        263: Product(263, "S107"),
        519: Product(519, "S207"),
        1799: Product(1799, "S117"),
        2567: Product(2567, "S167"),
        515: Product(515, "M103", dt="unipi_m103", udev="m103", has_ds2482="1"),
        771: Product(771, "M203", dt="unipi_m203", udev="m203", has_ds2482="1"),
        775: Product(775, "M207"),
        2055: Product(2055, "M267"),
        1027: Product(1027, "M303", dt="unipi_m303", udev="m303", has_ds2482="1"),
        2819: Product(2819, "M403", dt="unipi_m403", udev="m403", has_ds2482="1"),
        3075: Product(3075, "M503", dt="unipi_m503", udev="m503", has_ds2482="1"),
        1031: Product(1031, "M527"),
        1283: Product(1283, "M523", dt="unipi_m523", udev="m523", has_ds2482="1"),
        2311: Product(2311, "M567"),
        3331: Product(3331, "M603"),
        1539: Product(1539, "L203", dt="unipi_l203", udev="l203", has_ds2482="1"),
        1287: Product(1287, "L207"),
        3587: Product(3587, "L303", dt="unipi_l303", udev="l303", has_ds2482="1"),
        1795: Product(1795, "L403", dt="unipi_l403", udev="l403", has_ds2482="1"),
        3843: Product(3843, "L503", dt="unipi_l503", udev="l503", has_ds2482="1"),
        4099: Product(4099, "L513", dt="unipi_l513", udev="l513", has_ds2482="1"),
        1543: Product(1543, "L527"),
        2051: Product(2051, "L523", dt="unipi_l523", udev="l523", has_ds2482="1"),
        2307: Product(2307, "L533", dt="unipi_l533", udev="l533", has_ds2482="1"),
    }

    @classmethod
    def get_product_info_by_name(cls: type["Products"], product_name: str) -> Product | None:
        """Get product info by name.

        Parameters
        ----------
        product_name: str
            Product name

        Returns
        -------
            Return product info or None.
        """
        product_name = product_name.lower()

        for product in cls.products.values():
            if product.name.lower() == product_name:
                return product

        return None

    @classmethod
    def get_product_info(cls: type["Products"]) -> Product | None:
        """Read product identification from eeprom.

        Returns
        -------
        Product, optional
            Return product info or None.
        """
        product_id: int = UnipiId.get_hex_item("platform_id")

        # validate product_id in library
        if product_info := cls.products.get(product_id):
            return product_info

        # try fallback method via product_name for legacy eeprom
        product_name: str = UnipiId.get_line_item("product_model")

        if not (product_info := cls.get_product_info_by_name(product_name)):
            logging.warning("Unknown product %s %04x", product_name, product_id)

        return product_info


class OSConfigurator:
    OLD_FINGERPRINT: Path = Path("/opt/unipi/os-configurator/fingerprint")
    CONFIG_UNIPI: Path = Path("/mnt/boot/config_unipi.txt")

    @classmethod
    def _get_fingerprint(cls: type["OSConfigurator"]) -> str:
        try:
            result: CompletedProcess = subprocess.run(
                "/opt/unipi/tools/unipiid fingerprint", shell=True, check=True, capture_output=True  # ruff: noqa: S602
            )
        except CalledProcessError as error:
            logging.error(error.stderr.decode())
            sys.exit(1)

        stdout: str = result.stdout.decode()
        return stdout

    @classmethod
    def _update_config_txt(cls: type["OSConfigurator"], env: dict[str, str]) -> None:
        config_text: str = ""

        if env["has_ds2482"] == "1":
            config_text += "dtoverlay=ds2482\n"

        if env["dt"]:
            config_text += f"dtoverlay={env['dt']}\n"

        cls.CONFIG_UNIPI.write_text(config_text, encoding="utf-8")

    @classmethod
    def _link_udev_rules(cls: type["OSConfigurator"], env: dict[str, str]) -> None:
        if env["udev"]:
            for rule in Path("/etc/udev/rules.d").rglob("50-*.rules"):
                rule.unlink()

            Path(f"/etc/udev/rules.d/50-{env['udev']}.rules").symlink_to(
                Path(f"/opt/unipi/os-configurator/udev/{env['udev']}.rules")
            )

    @classmethod
    def _get_env(cls: type["OSConfigurator"]) -> dict[str, str]:
        env: dict[str, str] = {}

        try:
            if product_info := Products.get_product_info():
                env = product_info.vars
        except FileNotFoundError as error:
            logging.error("Missing unipi-id module or bad id eprom.")  # ruff: noqa: TRY400
            raise SystemExit(1) from error

        return env

    @classmethod
    def check(cls: type["OSConfigurator"]) -> bool:
        """Check if changes found that required an update."""
        logging.info("OS Configurator: check started")

        if (
            cls.OLD_FINGERPRINT.exists()
            and cls.OLD_FINGERPRINT.read_text(encoding="utf-8") == cls._get_fingerprint()
            and cls.CONFIG_UNIPI.exists()
        ):
            logging.info("OS Configurator: Check complete, no changes")
            return True

        logging.info("OS Configurator: Changes found, calling update...")
        return False

    @classmethod
    def update(cls: type["OSConfigurator"]) -> None:
        """Update OS configuration."""
        logging.info("OS Configurator: Update invoked")
        fingerprint: str = cls._get_fingerprint()

        cls.OLD_FINGERPRINT.write_text(fingerprint, encoding="utf-8")

        env: dict[str, str] = cls._get_env()

        cls._update_config_txt(env)
        cls._link_udev_rules(env)

        logging.info("Reboot system to apply all changes in configuration")
        os.system("/sbin/reboot")  # ruff: noqa: S605


def main() -> None:
    """Entrypoint for Unipi OS Configurator."""
    if not OSConfigurator.check():
        OSConfigurator.update()


if __name__ == "__main__":
    with contextlib.suppress(KeyboardInterrupt):
        main()
