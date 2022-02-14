################################################################################
#
# zsh-syntax-highlighting
#
################################################################################

ZSH_SYNTAX_HIGHLIGHTING_VERSION = 0.7.1
ZSH_SYNTAX_HIGHLIGHTING_SOURCE = $(ZSH_SYNTAX_HIGHLIGHTING_VERSION).zip
ZSH_SYNTAX_HIGHLIGHTING_SITE = https://github.com/zsh-users/zsh-syntax-highlighting/archive/refs/tags

ZSH_SYNTAX_HIGHLIGHTING_LICENSE = BSD 3-Clause
ZSH_SYNTAX_HIGHLIGHTING_FILES = COPYING.md

ZSH_SYNTAX_HIGHLIGHTING_DEPENDENCIES += zsh

define ZSH_SYNTAX_HIGHLIGHTING_EXTRACT_CMDS
	$(UNZIP) -d $(@D) $(ZSH_SYNTAX_HIGHLIGHTING_DL_DIR)/$(ZSH_SYNTAX_HIGHLIGHTING_SOURCE)
	mkdir -p  $(@D)/zsh-syntax-highlighting
	mv $(@D)/zsh-syntax-highlighting-$(ZSH_SYNTAX_HIGHLIGHTING_VERSION)/* $(@D)/zsh-syntax-highlighting
	$(RM) -r $(@D)/zsh-syntax-highlighting-$(ZSH_SYNTAX_HIGHLIGHTING_VERSION)
endef

define ZSH_SYNTAX_HIGHLIGHTING_INSTALL_TARGET_CMDS
	cp -R $(@D)/zsh-syntax-highlighting $(TARGET_DIR)/usr/share
endef

$(eval $(generic-package))
