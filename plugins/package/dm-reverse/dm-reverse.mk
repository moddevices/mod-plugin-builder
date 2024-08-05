######################################
#
# dm-reverse
#
######################################

DM_REVERSE_VERSION = 498b07042e7596cd27e18770d064631222f47bea
DM_REVERSE_SITE = https://github.com/davemollen/dm-Reverse.git
DM_REVERSE_SITE_METHOD = git
DM_REVERSE_BUNDLES = dm-Reverse.lv2

define DM_REVERSE_CONFIGURE_CMDS
	~/.cargo/bin/rustup default stable
endef

define DM_REVERSE_BUILD_CMDS
	rm -f $(@D)/lv2/dm-Reverse.lv2/libdm_reverse.so
	(cd $(@D)/lv2 && \
		~/.cargo/bin/cargo build $(MOD_PLUGIN_BUILDER_RUST_BUILD_FLAGS))
endef

define DM_REVERSE_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/usr/lib/lv2
	cp -rv $(@D)/lv2/dm-Reverse.lv2 $(TARGET_DIR)/usr/lib/lv2/
	$(INSTALL) -m 644 $(@D)/lv2/target/$(MOD_PLUGIN_BUILDER_RUST_TARGET)/release/libdm_reverse.so $(TARGET_DIR)/usr/lib/lv2/dm-Reverse.lv2/
endef

$(eval $(generic-package))
