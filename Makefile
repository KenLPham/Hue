TARGET = iphone:clang:12.1
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Hue
Hue_FILES = Tweak.xm $(wildcard Themes/*.m) Hue.m

Hue_FRAMEWORKS = UIKit MessageUI
Hue_PRIVATE_FRAMEWORKS = LinkPresentation ChatKit
Hue_LDFLAGS += -lCSColorPicker
Hue_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/tweak.mk

after-install::
	install.exec "killall -9 MobileSMS Preferences"

SUBPROJECTS += hueprefs

include $(THEOS_MAKE_PATH)/aggregate.mk