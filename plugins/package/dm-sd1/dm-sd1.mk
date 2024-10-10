######################################
#
# dm-sd1
#
######################################

DM_SD1_VERSION = 1afa503f81a0b8f834e481dc2c4acb7726a0b4d5
DM_SD1_SITE = https://github.com/davemollen/dm-SD1.git
DM_SD1_SITE_METHOD = git
DM_SD1_BUNDLES = dm-SD1.lv2

define DM_SD1_BUILD_CMDS
	~/.cargo/bin/rustup default nightly

	rm -f $(@D)/lv2/dm-SD1.lv2/libdm_sd1.so
	(cd $(@D)/lv2 && \
		~/.cargo/bin/cargo build $(MOD_PLUGIN_BUILDER_RUST_BUILD_FLAGS))

	~/.cargo/bin/rustup default stable
endef

define DM_SD1_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/usr/lib/lv2
	cp -rv $(@D)/lv2/dm-SD1.lv2 $(TARGET_DIR)/usr/lib/lv2/
	$(INSTALL) -m 644 $(@D)/lv2/target/$(MOD_PLUGIN_BUILDER_RUST_TARGET)/release/libdm_sd1.so $(TARGET_DIR)/usr/lib/lv2/dm-SD1.lv2/
endef

$(eval $(generic-package))
