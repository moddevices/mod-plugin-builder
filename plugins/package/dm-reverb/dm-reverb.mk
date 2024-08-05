######################################
#
# dm-reverb
#
######################################

DM_REVERB_VERSION = 7cfd6e713e7aa9633094d32eca4b04fb1d9cf1ad
DM_REVERB_SITE = https://github.com/davemollen/dm-Reverb.git
DM_REVERB_SITE_METHOD = git
DM_REVERB_BUNDLES = dm-Reverb.lv2

# Nightly toolchain is needed to enable simd
define DM_REVERB_CONFIGURE_CMDS
	~/.cargo/bin/rustup toolchain install nightly-2024-08-07
	~/.cargo/bin/rustup default nightly-2024-08-07
	~/.cargo/bin/rustup target add $(MOD_PLUGIN_BUILDER_RUST_TARGET)
endef

define DM_REVERB_BUILD_CMDS
	rm -f $(@D)/lv2/dm-Reverb.lv2/libdm_reverb.so
	(cd $(@D)/lv2 && \
		~/.cargo/bin/cargo build $(MOD_PLUGIN_BUILDER_RUST_BUILD_FLAGS))
endef

define DM_REVERB_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/usr/lib/lv2
	cp -rv $(@D)/lv2/dm-Reverb.lv2 $(TARGET_DIR)/usr/lib/lv2/
	$(INSTALL) -m 644 $(@D)/lv2/target/$(MOD_PLUGIN_BUILDER_RUST_TARGET)/release/libdm_reverb.so $(TARGET_DIR)/usr/lib/lv2/dm-Reverb.lv2/
endef

$(eval $(generic-package))
