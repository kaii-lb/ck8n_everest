#!/bin/sh

rm -rf .repo/local_manifests && echo "Removed Local Manifests"
mkdir -p .repo/local_manifests

repo init -u https://github.com/ProjectEverest/manifest -b 14 --git-lfs --depth=1

curl https://raw.githubusercontent.com/kaii-lb/ck8n_everest/refs/heads/main/manifest.xml -o .repo/local_manifests/manifest.xml

cd device/tecno/CK8n

echo "" >> lineage_CK8n.mk
echo "# Boot Animation Resolution" >> lineage_CK8n.mk
echo "TARGET_BOOT_ANIMATION_RES := 1080" >> lineage_CK8n.mk
echo "" >> lineage_CK8n.mk
echo "# Everest Specific Build Flags" >> lineage_CK8n.mk
echo "EVEREST_MAINTAINER := kaii-lb" >> lineage_CK8n.mk
echo "EVEREST_BUILD_TYPE := OFFICIAL" >> lineage_CK8n.mk
echo "TARGET_SUPPORTS_BLUR := true" >> lineage_CK8n.mk
echo "TARGET_HAS_UDFPS := true" >> lineage_CK8n.mk
echo "EXTRA_UDFPS_ANIMATIONS := true" >> lineage_CK8n.mk
echo "TARGET_PREBUILT_LAWNCHAIR_LAUNCHER := true" >> lineage_CK8n.mk
echo "" >> lineage_CK8n.mk
echo "# Freeform Multiwindow" >> lineage_CK8n.mk
echo "PRODUCT_COPY_FILES += \\" >> lineage_CK8n.mk
echo "   frameworks/native/data/etc/android.software.freeform_window_management.xml:\$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.freeform_window_management.xml" >> lineage_CK8n.mk
echo "" >> lineage_CK8n.mk
echo "# Gapps things" >> lineage_CK8n.mk
echo "WITH_GAPPS := true" >> lineage_CK8n.mk
echo "" >> lineage_CK8n.mk

grep -v "\$(call inherit-product, frameworks/native/build/phone-xhdpi-8192-dalvik-heap.mk)" device.mk > removed.mk
mv removed.mk device.mk

echo "" >> BoardConfig.mk
echo "# Set selinux to permissive cuz DT isn't done" >> BoardConfig.mk
echo "BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive" >> BoardConfig.mk
echo "" >> BoardConfig.mk

cd /tmp/src/android

export WITH_AFLTO=false
export WITH_AFDO=false

echo -e "--> Starting resync at $(date)."
/opt/crave/resync.sh
echo -e "--> Resync done at $(date)."

cd build/make
git reset --hard FETCH_HEAD
curl https://raw.githubusercontent.com/kaii-lb/ck8n_everest/refs/heads/main/0001-nuke-any-ability-to-release-trunk_staging.patch -o ap2a.patch
git am ap2a.patch
cd ../../

. build/envsetup.sh

export WITH_AFLTO=false
export WITH_AFDO=false

lunch lineage_CK8n-userdebug

mka everest -j$(nproc --all)
