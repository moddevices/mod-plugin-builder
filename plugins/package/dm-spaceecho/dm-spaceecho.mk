######################################
#
# dm-spaceecho
#
######################################

DM_SPACEECHO_VERSION = af0beb1962230714c86adf3ce5a3c40b6c3ff75c
DM_SPACEECHO_SITE = https://github.com/davemollen/dm-SpaceEcho.git
DM_SPACEECHO_SITE_METHOD = git
DM_SPACEECHO_BUNDLES = dm-SpaceEcho.lv2

# Nightly toolchain is needed to enable simd
define DM_SPACEECHO_CONFIGURE_CMDS
	~/.cargo/bin/rustup toolchain install nightly-2024-08-07
	~/.cargo/bin/rustup default nightly-2024-08-07
	~/.cargo/bin/rustup target add $(MOD_PLUGIN_BUILDER_RUST_TARGET)
endef

define DM_SPACEECHO_BUILD_CMDS
	rm -f $(@D)/lv2/dm-SpaceEcho.lv2/libdm_space_echo.so
	(cd $(@D)/lv2 && \
		~/.cargo/bin/cargo build $(MOD_PLUGIN_BUILDER_RUST_BUILD_FLAGS))
endef

define DM_SPACEECHO_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/usr/lib/lv2
	cp -rv $(@D)/lv2/dm-SpaceEcho.lv2 $(TARGET_DIR)/usr/lib/lv2/
	$(INSTALL) -m 644 $(@D)/lv2/target/$(MOD_PLUGIN_BUILDER_RUST_TARGET)/release/libdm_space_echo.so $(TARGET_DIR)/usr/lib/lv2/dm-SpaceEcho.lv2/
endef

$(eval $(generic-package))
