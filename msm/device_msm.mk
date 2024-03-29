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
	recovery

# Libraries
PRODUCT_PACKAGES += \
	libWnnEngDic \
	libWnnJpnDic \
	libwnndict \
	libOmxCore \
	libmm-omxcore \
	libqcomm_omx \
	libstagefrighthw

ifeq ($(BUILD_LIB_HTC_ACOUSTIC_WINCE),true)
PRODUCT_PACKAGES += \
	libhtc_acoustic
endif

# Drivers
PRODUCT_PACKAGES += \
	libcamera \
	libhtcgeneric-ril \
	sensors.xdandroid \
	gps.xdandroid \
	copybit.msm7k \
	gralloc.msm7k \
	lights.msm7k

ifeq ($(BUILD_LIB_HTC_ACOUSTIC_WINCE),true)
PRODUCT_PACKAGES += \
	libhtc_acoustic
endif

# Pull in the Superuser package and associated su binary.
PRODUCT_PACKAGES += \
	Superuser \
	su

# Prebuilt
PRODUCT_PACKAGES += \
	.keep

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
	ro.opengles.version=65537

# media configuration xml file
PRODUCT_COPY_FILES += \
	device/xdandroid/msm/prebuilt/etc/media_profiles.xml:/system/etc/media_profiles.xml

# XDAndroid-specific configs and directories
PRODUCT_COPY_FILES += \
	device/xdandroid/msm/prebuilt/etc/dhcpcd/dhcpcd.conf:/system/etc/dhcpcd/dhcpcd.conf \
	device/xdandroid/msm/prebuilt/etc/wifi/wpa_supplicant.conf:/system/etc/wifi/wpa_supplicant.conf \
	device/xdandroid/msm/prebuilt/etc/wifi/loadit:/system/etc/wifi/loadit \
	device/xdandroid/msm/prebuilt/etc/wifi/bcm432x/bcm4325-rtecdc.bin:/system/etc/wifi/bcm432x/bcm4325-rtecdc.bin \
	device/xdandroid/msm/prebuilt/etc/wifi/Fw1251r1c.bin:/system/etc/wifi/Fw1251r1c.bin \
	device/xdandroid/msm/prebuilt/etc/wifi/tiwlan.ini:/system/etc/wifi/tiwlan.ini

# XDAndroid-specific prebuilt media codecs
PRODUCT_COPY_FILES += \
	device/xdandroid/msm/prebuilt/lib/libOmxH264Dec.so:/system/lib/libOmxH264Dec.so \
	device/xdandroid/msm/prebuilt/lib/libOmxMpeg4Dec.so:/system/lib/libOmxMpeg4Dec.so

# Firmware
PRODUCT_COPY_FILES += \
	device/xdandroid/msm/prebuilt/etc/firmware/brf6350.bin:/system/etc/firmware/brf6350.bin \
	device/xdandroid/msm/prebuilt/etc/firmware/bcm4325.hcd:/system/etc/firmware/bcm4325.hcd \
	device/xdandroid/msm/prebuilt/etc/firmware/BCM4325_apsta.bin:/system/etc/firmware/BCM4325_apsta.bin \
	device/xdandroid/msm/prebuilt/etc/firmware/brf6300.bin:/system/etc/firmware/brf6300.bin

# XDAndroid-specific: APNs list, boot animation, vold config
PRODUCT_COPY_FILES += \
	device/xdandroid/msm/prebuilt/etc/apns-conf.xml:system/etc/apns-conf.xml \
	device/xdandroid/msm/prebuilt/etc/vold.fstab:system/etc/vold.fstab \
	device/xdandroid/msm/prebuilt/media/bootanimation.zip:system/media/bootanimation.zip

# XDAndroid-specific: kexec
PRODUCT_COPY_FILES += \
	device/xdandroid/msm/prebuilt/xbin/kexec:system/xbin/kexec \
	device/xdandroid/msm/prebuilt/xbin/kexec.sh:system/xbin/kexec.sh

# This is a high density device with more memory, so larger vm heaps for it.
PRODUCT_PROPERTY_OVERRIDES += \
	dalvik.vm.heapsize=32m

# XDAndroid-specific: build identifier used by rootfs
PRODUCT_COPY_FILES += \
	device/xdandroid/msm/prebuilt/gingerbread.build:system/gingerbread.build

PRODUCT_MANUFACTURER := XDAndroid

# proprietary side of the device
$(call inherit-product-if-exists, vendor/xdandroid/msm/device_msm-vendor.mk)
