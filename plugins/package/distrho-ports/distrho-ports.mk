######################################
#
# distrho-ports
#
######################################

DISTRHO_PORTS_VERSION = d19e3eb1b79df52250e233329e3d31cdbc922cb4
DISTRHO_PORTS_SITE = $(call github,DISTRHO,DISTRHO-Ports,$(DISTRHO_PORTS_VERSION))
DISTRHO_PORTS_BUNDLES = Vex.lv2

DISTRHO_PORTS_TARGET_MAKE = $(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) LINUX_EMBED=true -C $(@D)

define DISTRHO_PORTS_CONFIGURE_CMDS
       (cd $(@D); LINUX_EMBED=1 ./scripts/premake-update.sh linux)
endef

define DISTRHO_PORTS_BUILD_CMDS
	$(DISTRHO_PORTS_TARGET_MAKE) lv2_nogen
endef

define DISTRHO_PORTS_INSTALL_TARGET_CMDS
	install -d $(TARGET_DIR)/usr/lib/lv2/
	cp -r $(@D)/bin/lv2/*.lv2/    $(TARGET_DIR)/usr/lib/lv2/
	cp -rL $($(PKG)_PKGDIR)/*.lv2 $(TARGET_DIR)/usr/lib/lv2/
endef

$(eval $(generic-package))
