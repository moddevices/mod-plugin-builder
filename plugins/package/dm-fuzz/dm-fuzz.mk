######################################
#
# dm-fuzz
#
######################################

DM_FUZZ_VERSION = 3f0c5a7e61023aa72ef56b2781a330f1e1e890de
DM_FUZZ_SITE = https://github.com/davemollen/dm-Fuzz.git
DM_FUZZ_SITE_METHOD = git
DM_FUZZ_BUNDLES = dm-Fuzz.lv2

define DM_FUZZ_BUILD_CMDS
	~/.cargo/bin/rustup default nightly

	rm -f $(@D)/lv2/dm-Fuzz.lv2/libdm_fuzz.so
	(cd $(@D)/lv2 && \
		~/.cargo/bin/cargo build $(MOD_PLUGIN_BUILDER_RUST_BUILD_FLAGS))
	
	~/.cargo/bin/rustup default stable
endef

define DM_FUZZ_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/usr/lib/lv2
	cp -rv $(@D)/lv2/dm-Fuzz.lv2 $(TARGET_DIR)/usr/lib/lv2/
	$(INSTALL) -m 644 $(@D)/lv2/target/$(MOD_PLUGIN_BUILDER_RUST_TARGET)/release/libdm_fuzz.so $(TARGET_DIR)/usr/lib/lv2/dm-Fuzz.lv2/
endef

$(eval $(generic-package))
