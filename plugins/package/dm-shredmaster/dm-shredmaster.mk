######################################
#
# dm-shredmaster
#
######################################

DM_SHREDMASTER_VERSION = 9e48c36ed75556c59535694284b7c6a620a79070
DM_SHREDMASTER_SITE = https://github.com/davemollen/dm-Shredmaster.git
DM_SHREDMASTER_SITE_METHOD = git
DM_SHREDMASTER_BUNDLES = dm-Shredmaster.lv2

define DM_SHREDMASTER_BUILD_CMDS
	~/.cargo/bin/rustup default nightly

	rm -f $(@D)/lv2/dm-Shredmaster.lv2/libdm_shredmaster.so
	(cd $(@D)/lv2 && \
		~/.cargo/bin/cargo build $(MOD_PLUGIN_BUILDER_RUST_BUILD_FLAGS))

	~/.cargo/bin/rustup default stable
endef

define DM_SHREDMASTER_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/usr/lib/lv2
	cp -rv $(@D)/lv2/dm-Shredmaster.lv2 $(TARGET_DIR)/usr/lib/lv2/
	$(INSTALL) -m 644 $(@D)/lv2/target/$(MOD_PLUGIN_BUILDER_RUST_TARGET)/release/libdm_shredmaster.so $(TARGET_DIR)/usr/lib/lv2/dm-Shredmaster.lv2/
endef

$(eval $(generic-package))
