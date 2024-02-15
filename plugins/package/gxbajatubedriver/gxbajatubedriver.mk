######################################
#
# gxbajatubedriver
#
######################################

GXBAJATUBEDRIVER_VERSION = 640c90254c6a162bcceebfd0234d5c11767311b9
GXBAJATUBEDRIVER_SITE = $(call github,brummer10,GxBaJaTubeDriver.lv2,$(GXBAJATUBEDRIVER_VERSION))
GXBAJATUBEDRIVER_BUNDLES = gx_bajatubedriver.lv2

ifdef BR2_cortex_a7
GXBAJATUBEDRIVER_SSE_CFLAGS = -mfpu=vfpv3
endif

GXBAJATUBEDRIVER_TARGET_MAKE = $(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE)  SSE_CFLAGS="$(GXBAJATUBEDRIVER_SSE_CFLAGS)" -C $(@D)

define GXBAJATUBEDRIVER_BUILD_CMDS
	$(GXBAJATUBEDRIVER_TARGET_MAKE) mod
endef

define GXBAJATUBEDRIVER_INSTALL_TARGET_CMDS
	$(GXBAJATUBEDRIVER_TARGET_MAKE) install DESTDIR=$(TARGET_DIR) INSTALL_DIR=/usr/lib/lv2
	cp -rL $($(PKG)_PKGDIR)/gx_bajatubedriver.lv2/* $(TARGET_DIR)/usr/lib/lv2/gx_bajatubedriver.lv2/
endef

$(eval $(generic-package))
