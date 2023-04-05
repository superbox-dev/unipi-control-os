RELEASE_DIR = release
BUILDROOT = buildroot
BUILDROOT_EXTERNAL = buildroot-external
DEFCONFIG_DIR = $(BUILDROOT_EXTERNAL)/configs
O = output

TARGETS := $(notdir $(patsubst %_defconfig,%,$(wildcard $(DEFCONFIG_DIR)/*_defconfig)))
TARGETS_CONFIG := $(notdir $(wildcard $(DEFCONFIG_DIR)/*_defconfig))
TARGETS_SAVE := $(notdir $(patsubst %_defconfig,%_savedefconfig,$(wildcard $(DEFCONFIG_DIR)/*_defconfig)))

.NOTPARALLEL: $(TARGETS) $(TARGETS_SAVE) $(TARGETS_CONFIG) all
.PHONY: $(TARGETS) $(TARGETS_SAVE) $(TARGETS_CONFIG) all clean help

all: $(TARGETS)

$(RELEASE_DIR):
	mkdir -p $(RELEASE_DIR)

menuconfig:
	$(MAKE) -C $(BUILDROOT) O=../$(O) BR2_EXTERNAL=../$(BUILDROOT_EXTERNAL) menuconfig

$(TARGETS_SAVE): %_savedefconfig:
	@echo "Save $* configuration"
	$(MAKE) -C $(BUILDROOT) O=../$(O) BR2_EXTERNAL=../$(BUILDROOT_EXTERNAL) BR2_DEFCONFIG=../$(DEFCONFIG_DIR)/$*_defconfig savedefconfig

$(TARGETS_CONFIG): %_defconfig:
	@echo "Load $* configuration"
	$(MAKE) -C $(BUILDROOT) O=../$(O) BR2_EXTERNAL=../$(BUILDROOT_EXTERNAL) $*_defconfig

$(TARGETS): %: $(RELEASE_DIR) %_defconfig
	@echo "Build image for $@"
	$(MAKE) -C $(BUILDROOT) O=../$(O) BR2_EXTERNAL=../$(BUILDROOT_EXTERNAL)
	cp -f $(O)/images/sdcard.img $(RELEASE_DIR)/

	# Do not clean when building for one target
ifneq ($(words $(filter $(TARGETS),$(MAKECMDGOALS))), 1)
	@echo "Clean $@"
	$(MAKE) -C $(BUILDROOT) O=../$(O) BR2_EXTERNAL=../$(BUILDROOT_EXTERNAL) clean
endif
	@echo "Finished $@"

clean:
	$(MAKE) -C $(BUILDROOT) O=../$(O) BR2_EXTERNAL=../$(BUILDROOT_EXTERNAL) clean

help:
	@echo "Supported targets: $(TARGETS)"
	@echo "Run 'make <target>' to build a target image."
	@echo "Run 'make all' to build all target images."
	@echo "Run 'make clean' to clean the build output."
	@echo "Run 'make <target>_defconfig' to configure buildroot for a target."

