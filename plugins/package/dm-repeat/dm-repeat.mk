######################################
#
# dm-repeat
#
######################################

DM_REPEAT_VERSION = 6fe63959fac232baee6b64164e37a475c217ecd0
DM_REPEAT_SITE = https://github.com/davemollen/dm-Repeat.git
DM_REPEAT_SITE_METHOD = git
DM_REPEAT_BUNDLES = dm-Repeat.lv2

define DM_REPEAT_CONFIGURE_CMDS
	~/.cargo/bin/rustup default stable
endef

define DM_REPEAT_BUILD_CMDS
	rm -f $(@D)/lv2/dm-Repeat.lv2/libdm_repeat.so
	(cd $(@D)/lv2 && \
		~/.cargo/bin/cargo build $(MOD_PLUGIN_BUILDER_RUST_BUILD_FLAGS))
endef

define DM_REPEAT_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/usr/lib/lv2
	cp -rv $(@D)/lv2/dm-Repeat.lv2 $(TARGET_DIR)/usr/lib/lv2/
	$(INSTALL) -m 644 $(@D)/lv2/target/$(MOD_PLUGIN_BUILDER_RUST_TARGET)/release/libdm_repeat.so $(TARGET_DIR)/usr/lib/lv2/dm-Repeat.lv2/
endef

$(eval $(generic-package))
