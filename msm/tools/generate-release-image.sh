#!/bin/bash

# This script requires release keys in vendor/xdandroid/security/msm
# See http://pdk.android.com/online-pdk/guide/release_keys.html for release key procedure.

# Run this script from the root of the AOSP tree.

# Do this for a target_files zip: PATH="${PATH}:/sbin" make -j4 dist

PRESIGNED="$(build/tools/releasetools/sign_target_files_apks -d vendor/xdandroid/security/msm out/dist/full_msm-target_files-eng.${USER}.zip out/dist/signed-full_msm-target_files-eng.${USER}.zip | grep \\.apk | sed -e 's:^ *:-e :' -e 's:$:=:')"

build/tools/releasetools/sign_target_files_apks ${PRESIGNED} -d vendor/xdandroid/security/msm out/dist/full_msm-target_files-eng.${USER}.zip out/dist/signed-full_msm-target_files-eng.${USER}.zip

mkdir .tmp
cd .tmp
unzip ../out/dist/signed-full_msm-target_files-eng.${USER}.zip
# The following is needed for Android's genext2fs to set proper permissions (-a argument)
ln -s SYSTEM system
cd ..

num_blocks=`du -sk .tmp/SYSTEM | tail -n1 | awk '{print $1;}'`

if [ $num_blocks -lt 20480 ]
then
	extra_blocks=3072
else
	extra_blocks=20480
fi

num_blocks=`expr $num_blocks + $extra_blocks`
num_inodes=`find .tmp/SYSTEM | wc -l` ; num_inodes=`expr $num_inodes + 500`

out/host/linux-x86/bin/genext2fs -a -d .tmp/system -b $num_blocks -N $num_inodes -m 0 system.ext2
/sbin/tune2fs -L system system.ext2
/sbin/tune2fs -C 1 system.ext2
/sbin/e2fsck -fy system.ext2

rm -Rf .tmp
