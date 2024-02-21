####################################################
#
# LIRA-8  (https://github.com/MikeMorenoDSP/LIRA-8)
# based on camomile (cf. camomile-examples-labs)
#
####################################################

LIRA_8_LABS_VERSION = 5e8fd8eea2c115c5ca560c7456226c8993b4fa9f
LIRA_8_LABS_SITE = $(call github,MikeMorenoDSP,LIRA-8,$(LIRA_8_LABS_VERSION))
LIRA_8_LABS_DEPENDENCIES = camomile
LIRA_8_LABS_BUNDLES = LIRA-8.lv2

define LIRA_8_LABS_BUILD_CMDS
	# Copy Camomile so file 
	install -m 644 $(CAMOMILE_SO_FILE) $(@D)/LIRA-8_Plugin/LIRA-8-LV2-Linux64/LIRA-8/LIRA-8.so

	# Generate TTL
	(cd $(@D)/LIRA-8_Plugin/LIRA-8-LV2-Linux64/LIRA-8 && $(CAMOMILE_SO_GEN) ./LIRA-8.so)
endef

define LIRA_8_LABS_INSTALL_TARGET_CMDS
	install -d $(TARGET_DIR)/usr/lib/lv2

	rm -rf $(TARGET_DIR)/usr/lib/lv2/LIRA-8.lv2
	cp -r $(@D)/LIRA-8_Plugin/LIRA-8-LV2-Linux64/LIRA-8 $(TARGET_DIR)/usr/lib/lv2/LIRA-8.lv2
endef

$(eval $(generic-package))
