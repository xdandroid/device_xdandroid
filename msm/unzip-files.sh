#!/bin/sh

DEVICE=msm

ANDROID_ROOT=../../..

ZIP=signed-dream_devphone_userdebug-ota-14721.zip
GAPPSZIP=gapps-hdpi-20101020.1-signed.zip
GAPPSMIRROR="http://www.tap3w0rm.com/hosted/android/gapps"
HW3DZIP=hw3d.zip

DESTDIR=vendor/xdandroid/$DEVICE/proprietary

if [ "$1" = "-g" ]
then
	wget --tries=5 -O "${ANDROID_ROOT}"/$GAPPSZIP $GAPPSMIRROR/$GAPPSZIP
	if [ $? != 0 ]
	then
		echo "Error downloading Google apps package $GAPPSMIRROR/$GAPPSZIP. Exiting." >/dev/stderr
		exit 1
	fi
fi

mkdir -p "${ANDROID_ROOT}"/$DESTDIR

# Extract proprietary bits from dream rom
unzip -j -o "${ANDROID_ROOT}"/$ZIP system/bin/akmd system/etc/01_qcomm_omx.cfg system/etc/AudioFilter.csv system/etc/AudioPara4.csv system/etc/AudioPreProcess.csv system/etc/firmware/brf6300.bin system/etc/wifi/Fw1251r1c.bin system/lib/egl/libGLES_qcom.so system/lib/libaudioeq.so system/lib/libgps.so system/lib/libhtc_acoustic.so system/lib/libhtc_ril.so system/lib/liblvmxipc.so system/lib/libmm-adspsvc.so system/lib/libqcamera.so system/lib/libOmxCore.so system/lib/libOmxH264Dec.so system/lib/libOmxMpeg4Dec.so system/lib/libOmxVidEnc.so system/lib/libopencorehw.so system/lib/libqcomm_omx.so system/lib/libstagefrighthw.so -d "${ANDROID_ROOT}"/$DESTDIR

# Extract Google apps
[ -f "${ANDROID_ROOT}"/$GAPPSZIP ] && unzip -j -o "${ANDROID_ROOT}"/$GAPPSZIP 'system/*' -d "${ANDROID_ROOT}"/$DESTDIR

# Extract eclair hardware 3D driver
[ -f "${ANDROID_ROOT}"/$HW3DZIP ] && unzip -j -o "${ANDROID_ROOT}"/$HW3DZIP 'system/*' -d "${ANDROID_ROOT}"/$DESTDIR

(cat << EOF) | sed s:__DESTDIR__:$DESTDIR:g > ../../../vendor/xdandroid/$DEVICE/device_$DEVICE-vendor-blobs.mk
# Copyright (C) 2010 The Android Open Source Project
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

# This file is generated by device/xdandroid/msm/extract-files.sh

PRODUCT_COPY_FILES := \\
    __DESTDIR__/libgps.so:obj/lib/libgps.so

PRODUCT_COPY_FILES += \\
    __DESTDIR__/akmd:system/bin/akmd \\
    __DESTDIR__/01_qcomm_omx.cfg:system/etc/01_qcomm_omx.cfg \\
    __DESTDIR__/AudioFilter.csv:system/etc/AudioFilter.csv \\
    __DESTDIR__/AudioPara4.csv:system/etc/AudioPara4.csv \\
    __DESTDIR__/AudioPreProcess.csv:system/etc/AudioPreProcess.csv \\
    __DESTDIR__/brf6300.bin:system/etc/firmware/brf6300.bin \\
    __DESTDIR__/Fw1251r1c.bin:system/etc/wifi/Fw1251r1c.bin \\
    __DESTDIR__/libaudioeq.so:system/lib/libaudioeq.so \\
    __DESTDIR__/libqcamera.so:system/lib/liboemcamera.so \\
    __DESTDIR__/libhtc_acoustic.so:system/lib/libhtc_acoustic.so \\
    __DESTDIR__/libmm-adspsvc.so:system/lib/libmm-adspsvc.so

EOF

# The PRODUCT_COPY_FILES below is generated (and hand-edited afterwards) via...
# $ for I in `unzip -l ../../../gapps-mdpi-tiny-$VERSION-signed.zip system/* | grep system/ | sed -e 's:^.*system:system:'` ; do echo "    __DESTDIR__/${I##*/}:${I} \\\\" ; done
if [ -f "${ANDROID_ROOT}"/$GAPPSZIP ]
then
	(cat << EOF) | sed s:__DESTDIR__:$DESTDIR:g >> ../../../vendor/xdandroid/$DEVICE/device_$DEVICE-vendor-blobs.mk
PRODUCT_COPY_FILES += \\
    __DESTDIR__/CarHomeGoogle.apk:system/app/CarHomeGoogle.apk \\
    __DESTDIR__/CarHomeLauncher.apk:system/app/CarHomeLauncher.apk \\
    __DESTDIR__/GenieWidget.apk:system/app/GenieWidget.apk \\
    __DESTDIR__/Gmail.apk:system/app/Gmail.apk \\
    __DESTDIR__/GoogleBackupTransport.apk:system/app/GoogleBackupTransport.apk \\
    __DESTDIR__/GoogleCalendarSyncAdapter.apk:system/app/GoogleCalendarSyncAdapter.apk \\
    __DESTDIR__/GoogleContactsSyncAdapter.apk:system/app/GoogleContactsSyncAdapter.apk \\
    __DESTDIR__/GoogleFeedback.apk:system/app/GoogleFeedback.apk \\
    __DESTDIR__/GooglePartnerSetup.apk:system/app/GooglePartnerSetup.apk \\
    __DESTDIR__/GoogleQuickSearchBox.apk:system/app/GoogleQuickSearchBox.apk \\
    __DESTDIR__/GoogleServicesFramework.apk:system/app/GoogleServicesFramework.apk \\
    __DESTDIR__/HtcCopyright.apk:system/app/HtcCopyright.apk \\
    __DESTDIR__/HtcEmailPolicy.apk:system/app/HtcEmailPolicy.apk \\
    __DESTDIR__/HtcSettings.apk:system/app/HtcSettings.apk \\
    __DESTDIR__/LatinImeTutorial.apk:system/app/LatinImeTutorial.apk \\
    __DESTDIR__/Maps.apk:system/app/Maps.apk \\
    __DESTDIR__/MarketUpdater.apk:system/app/MarketUpdater.apk \\
    __DESTDIR__/MediaUploader.apk:system/app/MediaUploader.apk \\
    __DESTDIR__/NetworkLocation.apk:system/app/NetworkLocation.apk \\
    __DESTDIR__/OneTimeInitializer.apk:system/app/OneTimeInitializer.apk \\
    __DESTDIR__/PassionQuickOffice.apk:system/app/PassionQuickOffice.apk \\
    __DESTDIR__/Street.apk:system/app/Street.apk \\
    __DESTDIR__/Talk.apk:system/app/Talk.apk \\
    __DESTDIR__/Vending.apk:system/app/Vending.apk \\
    __DESTDIR__/VoiceSearch.apk:system/app/VoiceSearch.apk \\
    __DESTDIR__/YouTube.apk:system/app/YouTube.apk \\
    __DESTDIR__/googlevoice.apk:system/app/googlevoice.apk \\
    __DESTDIR__/kickback.apk:system/app/kickback.apk \\
    __DESTDIR__/soundback.apk:system/app/soundback.apk \\
    __DESTDIR__/talkback.apk:system/app/talkback.apk \\
    __DESTDIR__/com.google.android.maps.xml:system/etc/permissions/com.google.android.maps.xml \\
    __DESTDIR__/features.xml:system/etc/permissions/features.xml \\
    __DESTDIR__/com.google.android.maps.jar:system/framework/com.google.android.maps.jar \\
    __DESTDIR__/libspeech.so:system/lib/libspeech.so \\
    __DESTDIR__/libvoicesearch.so:system/lib/libvoicesearch.so

EOF
fi

if [ -f "${ANDROID_ROOT}"/$HW3DZIP ]
then
	(cat << EOF) | sed s:__DESTDIR__:$DESTDIR:g >> ../../../vendor/xdandroid/$DEVICE/device_$DEVICE-vendor-blobs.mk
PRODUCT_COPY_FILES += \\
    __DESTDIR__/libGLES_qcom.so:system/lib/egl/libGLES_qcom.so

EOF
fi

./setup-makefiles.sh

# Remove zipfile comments (ie. those added by SignApk) from extracted packages
# We do this because the comments break `make dist`
cd "${ANDROID_ROOT}"/$DESTDIR
for I in *.apk
do
	echo "Removing zipfile comment from ${I}"
	zip -z ${I} <<__EOF__
__EOF__
done

