######################################
#
# gxknightfuzz
#
######################################

GXKNIGHTFUZZ_VERSION = 5b0ed24c4e7c3eb601815703af31f0f658ce3e1b
GXKNIGHTFUZZ_SITE = $(call github,brummer10,GxKnightFuzz.lv2,$(GXKNIGHTFUZZ_VERSION))
GXKNIGHTFUZZ_BUNDLES = gx_KnightFuzz.lv2

ifdef BR2_cortex_a7
GXKNIGHTFUZZ_SSE_CFLAGS = -mfpu=vfpv3
endif

GXKNIGHTFUZZ_TARGET_MAKE = $(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) SSE_CFLAGS="$(GXKNIGHTFUZZ_SSE_CFLAGS)" -C $(@D)

define GXKNIGHTFUZZ_BUILD_CMDS
	$(GXKNIGHTFUZZ_TARGET_MAKE) mod
endef

define GXKNIGHTFUZZ_INSTALL_TARGET_CMDS
	$(GXKNIGHTFUZZ_TARGET_MAKE) install DESTDIR=$(TARGET_DIR) INSTALL_DIR=/usr/lib/lv2
	cp -rL $($(PKG)_PKGDIR)/gx_KnightFuzz.lv2/* $(TARGET_DIR)/usr/lib/lv2/gx_KnightFuzz.lv2/
endef

$(eval $(generic-package))
