######################################
#
# Pedal Pi Plugins
#
######################################
PEDAL_PI_PLUGINS_VERSION = f806113

PEDAL_PI_PLUGINS_SITE_METHOD = git
PEDAL_PI_PLUGINS_SITE = https://github.com/SrMouraSilva/plugins-lv2.git
PEDAL_PI_PLUGINS_DEPENDENCIES = 
PEDAL_PI_PLUGINS_BUNDLES = gossiper.lv2 tetr4-switch.lv2 
PEDAL_PI_PLUGINS_CONF_ENV = DESTDIR="$(TARGET_DIR)"

PEDAL_PI_PLUGINS_TARGET_MAKE = $(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/plugins

# build command
define PEDAL_PI_PLUGINS_BUILD_CMDS
	$(PEDAL_PI_PLUGINS_TARGET_MAKE)
endef

# install command
define PEDAL_PI_PLUGINS_INSTALL_TARGET_CMDS
	$(PEDAL_PI_PLUGINS_TARGET_MAKE) install DESTDIR=$(TARGET_DIR)
endef


# import everything else from the buildroot generic package
$(eval $(generic-package))
