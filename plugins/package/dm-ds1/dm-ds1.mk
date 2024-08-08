######################################
#
# dm-ds1
#
######################################

DM_DS1_VERSION = d7c79aa605167215b7737a3e844bb9ac08747bc3
DM_DS1_SITE = https://github.com/davemollen/dm-DS1.git
DM_DS1_SITE_METHOD = git
DM_DS1_BUNDLES = dm-DS1.lv2

# Nightly toolchain is needed to enable simd
define DM_DS1_CONFIGURE_CMDS
	~/.cargo/bin/rustup toolchain install nightly-2024-08-07
	~/.cargo/bin/rustup default nightly-2024-08-07
	~/.cargo/bin/rustup target add $(MOD_PLUGIN_BUILDER_RUST_TARGET)
endef

define DM_DS1_BUILD_CMDS
	rm -f $(@D)/lv2/dm-DS1.lv2/libdm_ds1.so
	(cd $(@D)/lv2 && \
		~/.cargo/bin/cargo build $(MOD_PLUGIN_BUILDER_RUST_BUILD_FLAGS))
endef

define DM_DS1_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/usr/lib/lv2
	cp -rv $(@D)/lv2/dm-DS1.lv2 $(TARGET_DIR)/usr/lib/lv2/
	$(INSTALL) -m 644 $(@D)/lv2/target/$(MOD_PLUGIN_BUILDER_RUST_TARGET)/release/libdm_ds1.so $(TARGET_DIR)/usr/lib/lv2/dm-DS1.lv2/
endef

$(eval $(generic-package))
