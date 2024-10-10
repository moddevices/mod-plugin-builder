######################################
#
# dm-ds1
#
######################################

DM_DS1_VERSION = fc9ecdbb755ab5e4b2f6ac799ba353bcf26def53
DM_DS1_SITE = https://github.com/davemollen/dm-DS1.git
DM_DS1_SITE_METHOD = git
DM_DS1_BUNDLES = dm-DS1.lv2

define DM_DS1_BUILD_CMDS
	~/.cargo/bin/rustup default nightly

	rm -f $(@D)/lv2/dm-DS1.lv2/libdm_ds1.so
	(cd $(@D)/lv2 && \
		~/.cargo/bin/cargo build $(MOD_PLUGIN_BUILDER_RUST_BUILD_FLAGS))

	~/.cargo/bin/rustup default stable
endef

define DM_DS1_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/usr/lib/lv2
	cp -rv $(@D)/lv2/dm-DS1.lv2 $(TARGET_DIR)/usr/lib/lv2/
	$(INSTALL) -m 644 $(@D)/lv2/target/$(MOD_PLUGIN_BUILDER_RUST_TARGET)/release/libdm_ds1.so $(TARGET_DIR)/usr/lib/lv2/dm-DS1.lv2/
endef

$(eval $(generic-package))
