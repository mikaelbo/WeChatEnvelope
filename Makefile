include $(THEOS)/makefiles/common.mk

TWEAK_NAME = WeChatEnvelope
ADDITIONAL_OBJCFLAGS = -fobjc-arc
WeChatEnvelope_FILES = $(wildcard *.m *.mm *.x *.xm)

BUNDLE_NAME = WeChatEnvelopeBundle
WeChatEnvelopeBundle_INSTALL_PATH = /Library/Application Support/WeChatEnvelope

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS)/makefiles/bundle.mk
