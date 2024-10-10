######################################
#
# suloea-labs
#
######################################

SULOEA_LABS_VERSION = 16f2062709c2764e53c0cfdae2c49bdb1e64c411
SULOEA_LABS_SITE = https://github.com/paulfd/suloea.git
SULOEA_LABS_SITE_METHOD = git
SULOEA_LABS_DEPENDENCIES = host-cmake
SULOEA_LABS_BUNDLES = suloea.lv2

# needed for submodules support
SULOEA_LABS_PRE_DOWNLOAD_HOOKS += MOD_PLUGIN_BUILDER_DOWNLOAD_WITH_SUBMODULES

define SULOEA_LABS_POST_INSTALL_TARGET_TTLFILES
	cp -rL $($(PKG)_PKGDIR)/suloea.lv2/* $(TARGET_DIR)/usr/lib/lv2/suloea.lv2/
endef

$(eval $(cmake-package))
