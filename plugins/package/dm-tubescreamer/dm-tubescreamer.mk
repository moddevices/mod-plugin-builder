######################################
#
# dm-tubescreamer
#
######################################

DM_TUBESCREAMER_VERSION = 6a2f3f0b0b8f3e867bd483875439b41ae31a6600
DM_TUBESCREAMER_SITE = https://github.com/davemollen/dm-TubeScreamer.git
DM_TUBESCREAMER_SITE_METHOD = git
DM_TUBESCREAMER_BUNDLES = dm-TubeScreamer.lv2

define DM_TUBESCREAMER_BUILD_CMDS
	~/.cargo/bin/rustup default nightly

	rm -f $(@D)/lv2/dm-TubeScreamer.lv2/libdm_tube_screamer.so
	(cd $(@D)/lv2 && \
		~/.cargo/bin/cargo build $(MOD_PLUGIN_BUILDER_RUST_BUILD_FLAGS))

	~/.cargo/bin/rustup default stable
endef

define DM_TUBESCREAMER_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/usr/lib/lv2
	cp -rv $(@D)/lv2/dm-TubeScreamer.lv2 $(TARGET_DIR)/usr/lib/lv2/
	$(INSTALL) -m 644 $(@D)/lv2/target/$(MOD_PLUGIN_BUILDER_RUST_TARGET)/release/libdm_tube_screamer.so $(TARGET_DIR)/usr/lib/lv2/dm-TubeScreamer.lv2/
endef

$(eval $(generic-package))
