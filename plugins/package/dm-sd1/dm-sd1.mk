######################################
#
# dm-sd1
#
######################################

DM_SD1_VERSION = 5408a74d44248f96e556a7c542a9f77b25eceead
DM_SD1_SITE = https://github.com/davemollen/dm-SD1.git
DM_SD1_SITE_METHOD = git
DM_SD1_BUNDLES = dm-SD1.lv2

# Nightly toolchain is needed to enable simd
define DM_SD1_CONFIGURE_CMDS
	~/.cargo/bin/rustup toolchain install nightly-2024-08-07
	~/.cargo/bin/rustup default nightly-2024-08-07
	~/.cargo/bin/rustup target add $(MOD_PLUGIN_BUILDER_RUST_TARGET)
endef

define DM_SD1_BUILD_CMDS
	rm -f $(@D)/lv2/dm-SD1.lv2/libdm_sd1.so
	(cd $(@D)/lv2 && \
		~/.cargo/bin/cargo build $(MOD_PLUGIN_BUILDER_RUST_BUILD_FLAGS))
endef

define DM_SD1_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/usr/lib/lv2
	cp -rv $(@D)/lv2/dm-SD1.lv2 $(TARGET_DIR)/usr/lib/lv2/
	$(INSTALL) -m 644 $(@D)/lv2/target/$(MOD_PLUGIN_BUILDER_RUST_TARGET)/release/libdm_sd1.so $(TARGET_DIR)/usr/lib/lv2/dm-SD1.lv2/
endef

$(eval $(generic-package))
