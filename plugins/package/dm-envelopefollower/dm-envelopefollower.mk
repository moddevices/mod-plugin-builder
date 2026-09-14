######################################
#
# dm-envelopefollower
#
######################################

DM_ENVELOPEFOLLOWER_VERSION = 508d1f5c9ad6062445c99396c686fc90d1b43ce6
DM_ENVELOPEFOLLOWER_SITE = https://github.com/davemollen/dm-EnvelopeFollower.git
DM_ENVELOPEFOLLOWER_SITE_METHOD = git
DM_ENVELOPEFOLLOWER_BUNDLES = dm-EnvelopeFollower.lv2

define DM_ENVELOPEFOLLOWER_BUILD_CMDS
	rm -f $(@D)/lv2/dm-EnvelopeFollower.lv2/libdm_envelope_follower.so
	(cd $(@D)/lv2 && \
		~/.cargo/bin/cargo build $(MOD_PLUGIN_BUILDER_RUST_BUILD_FLAGS))
endef

define DM_ENVELOPEFOLLOWER_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/usr/lib/lv2
	cp -rv $(@D)/lv2/dm-EnvelopeFollower.lv2 $(TARGET_DIR)/usr/lib/lv2/
	$(INSTALL) -m 644 $(@D)/lv2/target/$(MOD_PLUGIN_BUILDER_RUST_TARGET)/release/libdm_envelope_follower.so $(TARGET_DIR)/usr/lib/lv2/dm-EnvelopeFollower.lv2/
endef

$(eval $(generic-package))
