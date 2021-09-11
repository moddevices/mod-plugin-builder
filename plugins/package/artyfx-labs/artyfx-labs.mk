######################################
#
# artyfx-labs
#
######################################

ARTYFX_LABS_VERSION = 9b147f25c5b0e45e52c10d9b148ff04e7cc24951
ARTYFX_LABS_SITE = $(call github,harryhaaren,openAV-ArtyFX,$(ARTYFX_LABS_VERSION))
ARTYFX_LABS_DEPENDENCIES = libsndfile
ARTYFX_LABS_CONF_OPTS = -DBUILD_GUI=OFF -DBUILD_SSE=OFF
ARTYFX_LABS_BUNDLES = artyfx-labs.lv2

define ARTYFX_LABS_POST_INSTALL_TARGET_TTLFILES
	mv $(TARGET_DIR)/usr/lib/lv2/artyfx.lv2 $(TARGET_DIR)/usr/lib/lv2/artyfx-labs.lv2
	cp -rL $($(PKG)_PKGDIR)/artyfx-labs.lv2/* $(TARGET_DIR)/usr/lib/lv2/artyfx-labs.lv2/
	# unused plugin
	rm $(TARGET_DIR)/usr/lib/lv2/artyfx.lv2/driva.ttl
endef

ARTYFX_LABS_POST_INSTALL_TARGET_HOOKS += ARTYFX_LABS_POST_INSTALL_TARGET_TTLFILES

$(eval $(cmake-package))
