ARCHS = armv7 arm64

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = HuePrefs
HuePrefs_FILES = $(wildcard *.m) $(wildcard Cells/*.m) $(wildcard Headers/*.m) $(wildcard Controllers/*.m)
HuePrefs_INSTALL_PATH = /Library/PreferenceBundles

HuePrefs_FRAMEWORKS = UIKit
HuePrefs_PRIVATE_FRAMEWORKS = Preferences

HuePrefs_EXTRA_FRAMEWORKS = CepheiPrefs
HuePrefs_LDFLAGS = -lCSColorPicker

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/HuePrefs.plist$(ECHO_END)
