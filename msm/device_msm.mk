#
# Copyright (C) 2009 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# To be included directly by a device_xdandroid_*.mk makefile;
# do not use inherit-product on this file.

DEVICE_PACKAGE_OVERLAYS := device/xdandroid/msm/overlay

# Use high-density artwork where available
PRODUCT_LOCALES := hdpi

# Applications
PRODUCT_PACKAGES += \
	Development \
	Gallery \
	PinyinIME \
	OpenWnn \
	SpareParts \
	Term \
	su

# Libraries
PRODUCT_PACKAGES += \
	libWnnEngDic \
	libWnnJpnDic \
	libwnndict \
	libOmxCore \
	libmm-omxcore \
	libqcomm_omx \
	libstagefrighthw

# Drivers
PRODUCT_PACKAGES += \
	sensors.xdandroid \
	gps.xdandroid \
	copybit.msm7k \
	gralloc.msm7k \
	lights.msm7k

# Install the features available on this device.
PRODUCT_COPY_FILES := \
	frameworks/base/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
	frameworks/base/data/etc/android.hardware.camera.autofocus.xml:system/etc/permissions/android.hardware.camera.autofocus.xml \
	frameworks/base/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
	frameworks/base/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
	frameworks/base/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
	frameworks/base/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml

# The OpenGL ES API level that is natively supported by this device.
# This is a 16.16 fixed point number
PRODUCT_PROPERTY_OVERRIDES += \
	ro.opengles.version=65536

# This is a high density device with more memory, so larger vm heaps for it.
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapsize=32m

# media configuration xml file
PRODUCT_COPY_FILES += \
	device/xdandroid/msm/media_profiles.xml:/system/etc/media_profiles.xml

# XDAndroid-specific configs and directories
PRODUCT_COPY_FILES += \
	device/xdandroid/msm/gingerbread.build:system/gingerbread.build \
	device/xdandroid/msm/vold.fstab:system/etc/vold.fstab \
	device/xdandroid/msm/.keep:/system/lib/modules/.keep

# XDAndroid-specific: APNs list and boot animation
PRODUCT_COPY_FILES += \
	device/xdandroid/msm/apns-conf.xml:system/etc/apns-conf.xml \
	device/xdandroid/msm/bootanimation.zip:system/media/bootanimation.zip

PRODUCT_MANUFACTURER := XDAndroid

# proprietary side of the device
$(call inherit-product-if-exists, vendor/xdandroid/msm/device_msm-vendor.mk)

