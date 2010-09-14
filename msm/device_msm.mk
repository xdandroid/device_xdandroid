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

# Gallery3D doesn't work so well for us.
PRODUCT_PACKAGES += \
	Gallery \
	OpenWnn \
	PinyinIME

# Install the features available on this device.
PRODUCT_COPY_FILES := \
	frameworks/base/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
	frameworks/base/data/etc/android.hardware.camera.autofocus.xml:system/etc/permissions/android.hardware.camera.autofocus.xml \
	frameworks/base/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
	frameworks/base/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
	frameworks/base/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml

# The OpenGL ES API level that is natively supported by this device.
# This is a 16.16 fixed point number
PRODUCT_PROPERTY_OVERRIDES += \
	ro.opengles.version=65536

# media configuration xml file
PRODUCT_COPY_FILES += \
	device/xdandroid/msm/media_profiles.xml:/system/etc/media_profiles.xml

# XDAndroid-specific: APNs list and boot animation
PRODUCT_COPY_FILES += \
	device/xdandroid/msm/apns-conf.xml:system/etc/apns-conf.xml \
	device/xdandroid/msm/bootanimation.zip:system/media/bootanimation.zip

PRODUCT_MANUFACTURER := XDAndroid

# proprietary side of the device
$(call inherit-product-if-exists, vendor/xdandroid/msm/device_msm-vendor.mk)

