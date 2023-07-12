################################################################################
#
# zsh-autosuggestions
#
################################################################################

ZSH_AUTOSUGGESTIONS_VERSION = 0.7.0
ZSH_AUTOSUGGESTIONS_SOURCE = v$(ZSH_AUTOSUGGESTIONS_VERSION).zip
ZSH_AUTOSUGGESTIONS_SITE = https://github.com/zsh-users/zsh-autosuggestions/archive/refs/tags

ZSH_AUTOSUGGESTIONS_LICENSE = MIT
ZSH_AUTOSUGGESTIONS_FILES = LICENSE

ZSH_AUTOSUGGESTIONS_DEPENDENCIES += zsh

define ZSH_AUTOSUGGESTIONS_EXTRACT_CMDS
	$(UNZIP) -d $(@D) $(ZSH_AUTOSUGGESTIONS_DL_DIR)/$(ZSH_AUTOSUGGESTIONS_SOURCE)
	$(MKDIR) $(@D)/zsh-autosuggestions
	$(MV) $(@D)/zsh-autosuggestions-$(ZSH_AUTOSUGGESTIONS_VERSION)/* $(@D)/zsh-autosuggestions
	$(RM) -r $(@D)/zsh-autosuggestions-$(ZSH_AUTOSUGGESTIONS_VERSION)
endef

define ZSH_AUTOSUGGESTIONS_INSTALL_TARGET_CMDS
	$(CP) -R $(@D)/zsh-autosuggestions $(TARGET_DIR)/usr/share
endef

$(eval $(generic-package))
