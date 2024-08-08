######################################
#
# dm-fuzz
#
######################################

DM_FUZZ_VERSION = 36c53a118617e12176314a5d5876a3d7a856b963
DM_FUZZ_SITE = https://github.com/davemollen/dm-Fuzz.git
DM_FUZZ_SITE_METHOD = git
DM_FUZZ_BUNDLES = dm-Fuzz.lv2

# Nightly toolchain is needed to enable simd
define DM_FUZZ_CONFIGURE_CMDS
	~/.cargo/bin/rustup toolchain install nightly-2024-08-07
	~/.cargo/bin/rustup default nightly-2024-08-07
	~/.cargo/bin/rustup target add $(MOD_PLUGIN_BUILDER_RUST_TARGET)
endef

define DM_FUZZ_BUILD_CMDS
	rm -f $(@D)/lv2/dm-Fuzz.lv2/libdm_fuzz.so
	(cd $(@D)/lv2 && \
		~/.cargo/bin/cargo build $(MOD_PLUGIN_BUILDER_RUST_BUILD_FLAGS))
endef

define DM_FUZZ_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/usr/lib/lv2
	cp -rv $(@D)/lv2/dm-Fuzz.lv2 $(TARGET_DIR)/usr/lib/lv2/
	$(INSTALL) -m 644 $(@D)/lv2/target/$(MOD_PLUGIN_BUILDER_RUST_TARGET)/release/libdm_fuzz.so $(TARGET_DIR)/usr/lib/lv2/dm-Fuzz.lv2/
endef

$(eval $(generic-package))
