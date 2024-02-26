######################################
#
# vintageac30
#
######################################

VINTAGEAC30_VERSION = ecec14b21ee698b20686d7bb542dfa1207aa6bbe
VINTAGEAC30_SITE = $(call github,brummer10,VintageAC30.lv2,$(VINTAGEAC30_VERSION))
VINTAGEAC30_BUNDLES = VintageAC30.lv2

VINTAGEAC30_TARGET_MAKE = $(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) SSE_CFLAGS="-O3 -mfpu=vfpv3" -C $(@D)

define VINTAGEAC30_BUILD_CMDS
	$(VINTAGEAC30_TARGET_MAKE) mod
endef

define VINTAGEAC30_INSTALL_TARGET_CMDS
	$(VINTAGEAC30_TARGET_MAKE) install DESTDIR=$(TARGET_DIR) INSTALL_DIR=/usr/lib/lv2
endef

$(eval $(generic-package))
