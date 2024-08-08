######################################
#
# dm-shredmaster
#
######################################

DM_SHREDMASTER_VERSION = 308b24379461606efbeea79c4186b1ba514e940f
DM_SHREDMASTER_SITE = https://github.com/davemollen/dm-Shredmaster.git
DM_SHREDMASTER_SITE_METHOD = git
DM_SHREDMASTER_BUNDLES = dm-Shredmaster.lv2

# Nightly toolchain is needed to enable simd
define DM_SHREDMASTER_CONFIGURE_CMDS
	~/.cargo/bin/rustup toolchain install nightly-2024-08-07
	~/.cargo/bin/rustup default nightly-2024-08-07
	~/.cargo/bin/rustup target add $(MOD_PLUGIN_BUILDER_RUST_TARGET)
endef

define DM_SHREDMASTER_BUILD_CMDS
	rm -f $(@D)/lv2/dm-Shredmaster.lv2/libdm_shredmaster.so
	(cd $(@D)/lv2 && \
		~/.cargo/bin/cargo build $(MOD_PLUGIN_BUILDER_RUST_BUILD_FLAGS))
endef

define DM_SHREDMASTER_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/usr/lib/lv2
	cp -rv $(@D)/lv2/dm-Shredmaster.lv2 $(TARGET_DIR)/usr/lib/lv2/
	$(INSTALL) -m 644 $(@D)/lv2/target/$(MOD_PLUGIN_BUILDER_RUST_TARGET)/release/libdm_shredmaster.so $(TARGET_DIR)/usr/lib/lv2/dm-Shredmaster.lv2/
endef

$(eval $(generic-package))
