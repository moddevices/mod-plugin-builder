#####################################
#
# rumor
#
######################################

RUMOR_VERSION = 5ad260520f118960c51123ecc6890afba7d81f61
RUMOR_SITE = $(call github,brummer10,Rumor,$(RUMOR_VERSION))
RUMOR_BUNDLES = Rumor.lv2

ifdef BR2_cortex_a7
RUMOR_SSE_CFLAGS = -mfpu=vfpv3
else
RUMOR_SSE_CFLAGS = ""
endif

RUMOR_TARGET_MAKE = $(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) SSE_CFLAGS="$(RUMOR_SSE_CFLAGS)" -C $(@D)

define RUMOR_BUILD_CMDS
	$(RUMOR_TARGET_MAKE) mod
endef

define RUMOR_INSTALL_TARGET_CMDS
	$(RUMOR_TARGET_MAKE) install DESTDIR=$(TARGET_DIR) INSTALL_DIR=/usr/lib/lv2
endef

$(eval $(generic-package))
