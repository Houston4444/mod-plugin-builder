######################################
#
# zeroconvo
#
######################################

ZEROCONVO_VERSION = e0afc4139d1c410e5153b901c3539410ce548a8c
ZEROCONVO_SITE = git://gareus.org/zeroconvo.lv2
ZEROCONVO_SITE_METHOD = git
ZEROCONVO_BUNDLES = zeroconvo.lv2

# extra IR files not present in source code
ZEROCONVO_IRS_TARBALL = sisel4-ir.tar.xz
ZEROCONVO_IRS_URL = https://x42-plugins.com/tmp/$(ZEROCONVO_IRS_TARBALL)

ZEROCONVO_TARGET_MAKE = $(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) STATICZITA=yes OPTIMIZATIONS="-fno-finite-math-only -DNDEBUG" -C $(@D)


define ZEROCONVO_BUILD_CMDS
	$(ZEROCONVO_TARGET_MAKE)

	# Download and import IRs
	(cd $(@D) && \
		wget $(ZEROCONVO_IRS_URL) && \
		tar xf $(ZEROCONVO_IRS_TARBALL) && \
		mv sisel4-ir.lv2/*.wav build/ir/ && \
		cat sisel4-ir.lv2/manifest.ttl | tail -n +7 >> build/manifest.ttl && \
		cat sisel4-ir.lv2/presets.ttl | tail -n +10 >> build/presets.ttl && \
		rm -r $(ZEROCONVO_IRS_TARBALL) sisel4-ir.lv2 \
	)
endef

define ZEROCONVO_INSTALL_TARGET_CMDS
	$(ZEROCONVO_TARGET_MAKE) install DESTDIR=$(TARGET_DIR) PREFIX=/usr

	# Tweak path in presets
	sed -e "s|#ir> <|#ir> <ir/|" -i $(TARGET_DIR)/usr/lib/lv2/zeroconvo.lv2/presets.ttl
endef

$(eval $(generic-package))
