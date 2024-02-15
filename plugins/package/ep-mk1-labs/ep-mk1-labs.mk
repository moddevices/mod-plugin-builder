###################################################
#
# EP-MK1 (https://github.com/MikeMorenoDSP/EP-MK1)
# based on camomile (cf. camomile-examples-labs)
#
###################################################

EP_MK1_LABS_VERSION = 5ec5a1c5a281f18e73a52e4c05cad0acf7b36e76
EP_MK1_LABS_SITE = $(call github,MikeMorenoDSP,EP-MK1,$(EP_MK1_LABS_VERSION))
EP_MK1_LABS_DEPENDENCIES = camomile
EP_MK1_LABS_BUNDLES = EP-MK1.lv2

define EP_MK1_LABS_BUILD_CMDS
        # Copy Camomile so file
        install -m 644 $(CAMOMILE_SO_FILE) $(@D)/EP-MK1-Plugins/EP-MK1-Linux64/EP-MK1/EP-MK1.so

        # Generate TTL
        (cd $(@D)/EP-MK1-Plugins/EP-MK1-Linux64/EP-MK1 && $(CAMOMILE_SO_GEN) ./EP-MK1.so)
endef

define EP_MK1_LABS_INSTALL_TARGET_CMDS
        install -d $(TARGET_DIR)/usr/lib/lv2

        rm -rf $(TARGET_DIR)/usr/lib/lv2/EP-MK1.lv2
        cp -r $(@D)/EP-MK1-Plugins/EP-MK1-Linux64/EP-MK1 $(TARGET_DIR)/usr/lib/lv2/EP-MK1.lv2
endef

$(eval $(generic-package))
