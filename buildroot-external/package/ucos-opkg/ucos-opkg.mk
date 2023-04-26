################################################################################
#
# ucos-opkg
#
################################################################################

UCOS_OPKG_VERSION = 0.6.1
UCOS_OPKG_SOURCE = opkg-$(UCOS_OPKG_VERSION).tar.gz
UCOS_OPKG_SITE = https://downloads.yoctoproject.org/releases/opkg
UCOS_OPKG_DEPENDENCIES = host-pkgconf libarchive libgpgme libgpg-error
UCOS_OPKG_LICENSE = GPL-2.0+
UCOS_OPKG_LICENSE_FILES = COPYING
UCOS_OPKG_INSTALL_STAGING = YES
UCOS_OPKG_CONF_OPTS = --enable-sha256 --enable-lz4

# Ensure directory for lockfile exists
define UCOS_OPKG_CREATE_LOCKDIR
	mkdir -p $(TARGET_DIR)/usr/lib/opkg
endef

UCOS_OPKG_CONF_ENV += \
	ac_cv_path_GPGME_CONFIG=$(STAGING_DIR)/usr/bin/gpgme-config \
	ac_cv_path_GPGERR_CONFIG=$(STAGING_DIR)/usr/bin/gpg-error-config

UCOS_OPKG_POST_INSTALL_TARGET_HOOKS += UCOS_OPKG_CREATE_LOCKDIR

$(eval $(autotools-package))
