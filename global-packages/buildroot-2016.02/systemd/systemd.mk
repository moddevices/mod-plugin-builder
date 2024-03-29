################################################################################
#
# systemd
#
################################################################################

SYSTEMD_VERSION = 219
SYSTEMD_SITE = http://www.freedesktop.org/software/systemd
SYSTEMD_SOURCE = systemd-$(SYSTEMD_VERSION).tar.xz
SYSTEMD_LICENSE = LGPLv2.1+, GPLv2+ (udev), Public Domain (few source files, see README)
SYSTEMD_LICENSE_FILES = LICENSE.GPL2 LICENSE.LGPL2.1 README
SYSTEMD_INSTALL_STAGING = YES
SYSTEMD_DEPENDENCIES = \
	host-intltool \
	libcap \
	util-linux \
	kmod \
	host-gperf

SYSTEMD_PROVIDES = udev
SYSTEMD_AUTORECONF = YES

# Make sure that systemd will always be built after busybox so that we have
# a consistent init setup between two builds
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
SYSTEMD_DEPENDENCIES += busybox
endif

SYSTEMD_CONF_OPTS += \
	--with-rootprefix= \
	--enable-static=no \
	--disable-manpages \
	--disable-selinux \
	--disable-pam \
	--disable-libcryptsetup \
	--with-dbuspolicydir=/etc/dbus-1/system.d \
	--with-dbussessionservicedir=/usr/share/dbus-1/services \
	--with-dbussystemservicedir=/usr/share/dbus-1/system-services \
	--disable-efi \
	--disable-gnuefi \
	--disable-ldconfig \
	--disable-tests \
	--disable-dbus \
	--without-python

SYSTEMD_CFLAGS = $(TARGET_CFLAGS) -fno-lto

# Override path to kmod, used in kmod-static-nodes.service
SYSTEMD_CONF_ENV = \
	CFLAGS="$(SYSTEMD_CFLAGS)" \
	ac_cv_path_KMOD=/usr/bin/kmod

ifeq ($(BR2_PACKAGE_SYSTEMD_COMPAT),y)
SYSTEMD_CONF_OPTS += --enable-compat-libs
else
SYSTEMD_CONF_OPTS += --disable-compat-libs
endif

ifeq ($(BR2_PACKAGE_ACL),y)
SYSTEMD_CONF_OPTS += --enable-acl
SYSTEMD_DEPENDENCIES += acl
else
SYSTEMD_CONF_OPTS += --disable-acl
endif

ifeq ($(BR2_PACKAGE_LIBGLIB2),y)
SYSTEMD_CONF_OPTS += --enable-gudev
SYSTEMD_DEPENDENCIES += libglib2
else
SYSTEMD_CONF_OPTS += --disable-gudev
endif

ifeq ($(BR2_PACKAGE_LIBSECCOMP),y)
SYSTEMD_CONF_OPTS += --enable-seccomp
SYSTEMD_DEPENDENCIES += libseccomp
else
SYSTEMD_CONF_OPTS += --disable-seccomp
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_ALL_EXTRAS),y)
SYSTEMD_DEPENDENCIES += xz libgcrypt
SYSTEMD_CONF_OPTS += \
	--enable-xz \
	--enable-gcrypt \
	--with-libgcrypt-prefix=$(STAGING_DIR)/usr
else
SYSTEMD_CONF_OPTS += \
	--disable-xz \
	--disable-gcrypt
endif

SYSTEMD_CONF_OPTS += --disable-microhttpd

# MOD: disable some libs, in case systemd gets rebuilt (so we never enable them)
SYSTEMD_CONF_OPTS += --disable-libcurl
SYSTEMD_CONF_OPTS += --disable-libidn
SYSTEMD_CONF_OPTS += --disable-libiptc
SYSTEMD_CONF_OPTS += --disable-gnutls

# MOD: disable all useless stuff
SYSTEMD_CONF_OPTS += --disable-backlight
SYSTEMD_CONF_OPTS += --disable-binfmt
SYSTEMD_CONF_OPTS += --disable-coredump
SYSTEMD_CONF_OPTS += --disable-firstboot
SYSTEMD_CONF_OPTS += --disable-hostnamed
SYSTEMD_CONF_OPTS += --disable-hibernate
SYSTEMD_CONF_OPTS += --disable-hwdb
SYSTEMD_CONF_OPTS += --disable-ima
SYSTEMD_CONF_OPTS += --disable-importd
SYSTEMD_CONF_OPTS += --disable-localed
SYSTEMD_CONF_OPTS += --disable-resolved
SYSTEMD_CONF_OPTS += --disable-machined
SYSTEMD_CONF_OPTS += --disable-quotacheck
SYSTEMD_CONF_OPTS += --disable-randomseed
SYSTEMD_CONF_OPTS += --disable-rfkill
SYSTEMD_CONF_OPTS += --disable-timedated
SYSTEMD_CONF_OPTS += --disable-utmp
SYSTEMD_CONF_OPTS += --disable-vconsole

# MOD: fake servers
SYSTEMD_CONF_OPTS += --with-dns-servers="127.0.0.1"
SYSTEMD_CONF_OPTS += --with-ntp-servers="127.0.0.1"

ifeq ($(BR2_PACKAGE_SYSTEMD_NETWORKD),y)
SYSTEMD_CONF_OPTS += --enable-networkd
define SYSTEMD_INSTALL_RESOLVCONF_HOOK
	ln -sf ../run/systemd/resolve/resolv.conf \
		$(TARGET_DIR)/etc/resolv.conf
endef
else
SYSTEMD_CONF_OPTS += --disable-networkd
define SYSTEMD_INSTALL_SERVICE_NETWORK
	$(INSTALL) -D -m 644 package/systemd/network.service \
		$(TARGET_DIR)/etc/systemd/system/network.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../network.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/network.service
endef
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_TIMESYNCD),y)
SYSTEMD_CONF_OPTS += --enable-timesyncd
define SYSTEMD_INSTALL_SERVICE_TIMESYNC
	mkdir -p $(TARGET_DIR)/etc/systemd/system/sysinit.target.wants
	ln -sf ../../../../lib/systemd/system/systemd-timesyncd.service \
		$(TARGET_DIR)/etc/systemd/system/sysinit.target.wants/systemd-timesyncd.service
endef
else
SYSTEMD_CONF_OPTS += --disable-timesyncd
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_SMACK_SUPPORT),y)
SYSTEMD_CONF_OPTS += --enable-smack
else
SYSTEMD_CONF_OPTS += --disable-smack
endif

ifeq ($(BR2_PACKAGE_BASH),)
SYSTEMD_CONF_OPTS += --with-bashcompletiondir=
endif

ifeq ($(BR2_PACKAGE_ZSH),)
SYSTEMD_CONF_OPTS += --with-zshcompletiondir=
endif

# mq_getattr needs -lrt
SYSTEMD_MAKE_OPTS += LIBS=-lrt
SYSTEMD_MAKE_OPTS += LDFLAGS+=-ldl

define SYSTEMD_INSTALL_INIT_HOOK
	ln -fs ../lib/systemd/systemd $(TARGET_DIR)/sbin/init
	ln -fs ../bin/systemctl $(TARGET_DIR)/sbin/halt
	ln -fs ../bin/systemctl $(TARGET_DIR)/sbin/poweroff
	ln -fs ../bin/systemctl $(TARGET_DIR)/sbin/reboot

	ln -fs ../../../lib/systemd/system/multi-user.target \
		$(TARGET_DIR)/etc/systemd/system/default.target
endef

define SYSTEMD_INSTALL_MACHINEID_HOOK
	touch $(TARGET_DIR)/etc/machine-id
endef

define SYSTEMD_SANITIZE_PATH_IN_UNITS
	find $(TARGET_DIR)/lib/systemd/system -name '*.service' \
		-exec $(SED) 's,$(HOST_DIR),,g' {} \;
endef

# Disable ldconfig.service, as /sbin/ldconfig is not available when the
# target is built with a glibc-based toolchain.
define SYSTEMD_DISABLE_LDCONFIG_SERVICE_HOOK
	rm -f $(TARGET_DIR)/lib/systemd/system/sysinit.target.wants/ldconfig.service
endef

SYSTEMD_POST_INSTALL_TARGET_HOOKS += \
	SYSTEMD_INSTALL_INIT_HOOK \
	SYSTEMD_INSTALL_MACHINEID_HOOK \
	SYSTEMD_INSTALL_RESOLVCONF_HOOK \
	SYSTEMD_DISABLE_LDCONFIG_SERVICE_HOOK \
	SYSTEMD_SANITIZE_PATH_IN_UNITS

define SYSTEMD_USERS
	systemd-bus-proxy -1 systemd-bus-proxy -1 * - - - Proxy D-Bus messages to/from a bus
	- - input -1 * - - - Input device group
endef

define SYSTEMD_DISABLE_SERVICE_TTY1
	rm -f $(TARGET_DIR)/etc/systemd/system/getty.target.wants/getty@tty1.service
endef

ifneq ($(call qstrip,$(BR2_TARGET_GENERIC_GETTY_PORT)),)
# systemd needs getty.service for VTs and serial-getty.service for serial ttys
define SYSTEMD_INSTALL_SERVICE_TTY
	if echo $(BR2_TARGET_GENERIC_GETTY_PORT) | egrep -q 'tty[0-9]*$$'; \
	then \
		SERVICE="getty"; \
	else \
		SERVICE="serial-getty"; \
	fi; \
	ln -fs ../../../../lib/systemd/system/$${SERVICE}@.service \
		$(TARGET_DIR)/etc/systemd/system/getty.target.wants/$${SERVICE}@$(BR2_TARGET_GENERIC_GETTY_PORT).service
endef
endif

ifeq ($(BR2_cortex_a7),y)
# Get rid of journald completely. (MOD Duo only)
define SYSTEMD_KILL_JOURNALD_WITH_FIRE
	rm -f $(TARGET_DIR)/lib/systemd/system/sockets.target.wants/systemd-journald-audit.socket
	rm -f $(TARGET_DIR)/lib/systemd/system/sockets.target.wants/systemd-journald-dev-log.socket
	rm -f $(TARGET_DIR)/lib/systemd/system/sockets.target.wants/systemd-journald.socket
	rm -f $(TARGET_DIR)/lib/systemd/system/sysinit.target.wants/systemd-journal-catalog-update.service
	rm -f $(TARGET_DIR)/lib/systemd/system/sysinit.target.wants/systemd-journal-flush.service
	rm -f $(TARGET_DIR)/lib/systemd/system/sysinit.target.wants/systemd-journald.service
	rm -f $(TARGET_DIR)/lib/systemd/system/systemd-journal-catalog-update.service
	rm -f $(TARGET_DIR)/lib/systemd/system/systemd-journal-flush.service
	rm -f $(TARGET_DIR)/lib/systemd/system/systemd-journald-audit.socket
	rm -f $(TARGET_DIR)/lib/systemd/system/systemd-journald-dev-log.socket
	rm -f $(TARGET_DIR)/lib/systemd/system/systemd-journald.service
	rm -f $(TARGET_DIR)/lib/systemd/system/systemd-journald.socket
	rm -f $(TARGET_DIR)/lib/systemd/systemd-journald
endef
endif

define SYSTEMD_DISABLE_USELESS_SERVICES
	rm -f $(TARGET_DIR)/lib/systemd/system/sysinit.target.wants/systemd-machine-id-commit.service
	rm -f $(TARGET_DIR)/lib/systemd/system/sysinit.target.wants/sys-fs-fuse-connections.mount
	rm -f $(TARGET_DIR)/lib/systemd/system/sysinit.target.wants/sys-kernel-debug.mount
endef

define SYSTEMD_INSTALL_INIT_SYSTEMD
	$(SYSTEMD_DISABLE_SERVICE_TTY1)
	$(SYSTEMD_INSTALL_SERVICE_TTY)
	$(SYSTEMD_INSTALL_SERVICE_NETWORK)
	$(SYSTEMD_INSTALL_SERVICE_TIMESYNC)
	$(SYSTEMD_KILL_JOURNALD_WITH_FIRE)
	$(SYSTEMD_DISABLE_USELESS_SERVICES)
endef

$(eval $(autotools-package))
