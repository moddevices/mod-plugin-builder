######################################
#
# gxslowgear
#
######################################

GXSLOWGEAR_VERSION = e9cb4f0c4d25fecd1f15f84ece19e92766d51b07
GXSLOWGEAR_SITE = $(call github,brummer10,GxSlowGear.lv2,$(GXSLOWGEAR_VERSION))
GXSLOWGEAR_BUNDLES = gx_slowgear.lv2

ifdef BR2_cortex_a7
GXSLOWGEAR_SSE_CFLAGS = -mfpu=vfpv3
endif

GXSLOWGEAR_TARGET_MAKE = $(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) SSE_CFLAGS="$(GXSLOWGEAR_SSE_CFLAGS)" -C $(@D)

define GXSLOWGEAR_BUILD_CMDS
	$(GXSLOWGEAR_TARGET_MAKE) mod
endef

define GXSLOWGEAR_INSTALL_TARGET_CMDS
	$(GXSLOWGEAR_TARGET_MAKE) install DESTDIR=$(TARGET_DIR) INSTALL_DIR=/usr/lib/lv2
	cp -rL $($(PKG)_PKGDIR)/gx_slowgear.lv2/* $(TARGET_DIR)/usr/lib/lv2/gx_slowgear.lv2/
endef

$(eval $(generic-package))
