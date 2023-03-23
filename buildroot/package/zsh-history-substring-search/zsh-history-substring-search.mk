################################################################################
#
# zsh-history-substring-search
#
################################################################################

ZSH_HISTORY_SUBSTRING_SEARCH_VERSION = 1.0.2
ZSH_HISTORY_SUBSTRING_SEARCH_SOURCE = v$(ZSH_HISTORY_SUBSTRING_SEARCH_VERSION).zip
ZSH_HISTORY_SUBSTRING_SEARCH_SITE = https://github.com/zsh-users/zsh-history-substring-search/archive/refs/tags

ZSH_HISTORY_SUBSTRING_SEARCH_DEPENDENCIES += zsh

define ZSH_HISTORY_SUBSTRING_SEARCH_EXTRACT_CMDS
	$(UNZIP) -d $(@D) $(ZSH_HISTORY_SUBSTRING_SEARCH_DL_DIR)/$(ZSH_HISTORY_SUBSTRING_SEARCH_SOURCE)
	mkdir -p $(@D)/zsh-history-substring-search
	mv $(@D)/zsh-history-substring-search-$(ZSH_HISTORY_SUBSTRING_SEARCH_VERSION)/* $(@D)/zsh-history-substring-search
	$(RM) -r $(@D)/zsh-history-substring-search-$(ZSH_HISTORY_SUBSTRING_SEARCH_VERSION)
endef

define ZSH_HISTORY_SUBSTRING_SEARCH_INSTALL_TARGET_CMDS
	cp -R $(@D)/zsh-history-substring-search $(TARGET_DIR)/usr/share
endef

$(eval $(generic-package))
