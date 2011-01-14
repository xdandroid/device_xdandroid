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
$(file) : $(LOCAL_PATH)/h2w_headset.kl | $(ACP)
	$(transform-prebuilt-to-target)

file := $(TARGET_ROOT_OUT)/init.xdandroid.rc
ALL_PREBUILT += $(file)
$(file) : $(LOCAL_PATH)/init.xdandroid.rc | $(ACP)
	$(transform-prebuilt-to-target)

PRODUCT_PROPERTY_OVERRIDES := \
    ro.com.android.dataroaming=false

-include vendor/xdandroid/msm/AndroidBoardVendor.mk

