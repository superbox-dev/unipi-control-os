BUILDDIR := $(shell pwd)
RELEASE_DIR = $(BUILDDIR)/release

BUILDROOT = $(BUILDDIR)/buildroot
BUILDROOT_EXTERNAL = $(BUILDDIR)/buildroot-external
DEFCONFIG_DIR = $(BUILDROOT_EXTERNAL)/configs
O := $(BUILDDIR)/output

TARGETS := $(notdir $(patsubst %_defconfig,%,$(wildcard $(DEFCONFIG_DIR)/*_defconfig)))
TARGETS_CONFIG := $(notdir $(wildcard $(DEFCONFIG_DIR)/*_defconfig))
TARGETS_SAVE := $(notdir $(patsubst %_defconfig,%_savedefconfig,$(wildcard $(DEFCONFIG_DIR)/*_defconfig)))

HOSTNAME := "unipi-dev"
VERSION_DATE := $(shell date --utc +'%Y%m%d')
VERSION_DEV := dev-$(VERSION_DATE)

.ONESHELL:
SHELL = /bin/bash
.SHELLFLAGS = -e

.NOTPARALLEL:
.PHONY: docs

all: $(TARGETS)

$(RELEASE_DIR):
	mkdir -p $(RELEASE_DIR)

$(TARGETS_SAVE): %_savedefconfig:
	@echo "Save $* configuration"
	$(MAKE) -C $(BUILDROOT) O=$(O) BR2_EXTERNAL=$(BUILDROOT_EXTERNAL) BR2_DEFCONFIG=$(DEFCONFIG_DIR)/$*_defconfig savedefconfig

$(TARGETS_CONFIG): %_defconfig:
	@echo "Load $* configuration"
	$(MAKE) -C $(BUILDROOT) O=$(O) BR2_EXTERNAL=$(BUILDROOT_EXTERNAL) $*_defconfig

$(TARGETS): %: $(RELEASE_DIR) %_defconfig
	@echo "Build image for $@"
	$(MAKE) -C $(BUILDROOT) O=$(O) BR2_EXTERNAL=$(BUILDROOT_EXTERNAL) BR2_CCACHE_DIR=$(BUILDDIR)/cache/cc BR2_DL_DIR=$(BUILDDIR)/cache/dl BR2_TARGET_GENERIC_HOSTNAME=$(HOSTNAME) VERSION_DEV=$(VERSION_DEV)
	mv -v $(O)/images/unipi-control-os-* $(RELEASE_DIR)/
	@echo "Finished $@"

venv:
	python -m venv $(BUILDDIR)/.venv
	. $(BUILDDIR)/.venv/bin/activate

install: venv
	pip install -r requirements.txt

uninstall:
	rm -rfv $(BUILDDIR)/.venv

clean:
	$(MAKE) -C $(BUILDROOT) O=$(O) BR2_EXTERNAL=$(BUILDROOT_EXTERNAL) clean

help:
	@echo "Supported targets: $(TARGETS)"
	@echo "Run 'make <target>' to build a target image."
	@echo "Run 'make all' to build all target images."
	@echo "Run 'make clean' to clean the build output."
	@echo "Run 'make <target>_defconfig' to configure buildroot for a target."

