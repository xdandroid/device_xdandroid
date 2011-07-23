LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_PREBUILT_KERNEL),)
TARGET_PREBUILT_KERNEL := $(LOCAL_PATH)/kernel
endif

file := $(INSTALLED_KERNEL_TARGET)
ALL_PREBUILT += $(file)
$(file): $(TARGET_PREBUILT_KERNEL) | $(ACP)
	$(transform-prebuilt-to-target)

file := $(TARGET_OUT_KEYLAYOUT)/h2w_headset.kl
ALL_PREBUILT += $(file)
$(file) : $(LOCAL_PATH)/prebuilt/h2w_headset.kl | $(ACP)
	$(transform-prebuilt-to-target)

file := $(TARGET_ROOT_OUT)/init.xdandroid.rc
ALL_PREBUILT += $(file)
$(file) : $(LOCAL_PATH)/init.xdandroid.rc | $(ACP)
	$(transform-prebuilt-to-target)

# This will install the file in /system/etc
#
include $(CLEAR_VARS)
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE := vold.fstab
LOCAL_SRC_FILES := $(LOCAL_MODULE)
include $(BUILD_PREBUILT)

# TODO: Look at this when we stop using haret+sd
#include $(CLEAR_VARS)
#LOCAL_MODULE := wlan.ko
#LOCAL_MODULE_TAGS := user
#LOCAL_MODULE_CLASS := ETC
#LOCAL_MODULE_PATH := $(TARGET_OUT)/lib/modules
#LOCAL_SRC_FILES := $(LOCAL_MODULE)
#include $(BUILD_PREBUILT)

# XDANDROID rootfs will mount bind over /system/lib/modules
include $(CLEAR_VARS)
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE := .keep
LOCAL_MODULE_PATH := $(TARGET_OUT)/lib/modules
LOCAL_SRC_FILES := prebuilt/system/lib/modules/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

PRODUCT_PROPERTY_OVERRIDES := \
    ro.com.android.dataroaming=false

-include vendor/xdandroid/msm/AndroidBoardVendor.mk

