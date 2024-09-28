#!/bin/sh

cd device/tecno/CK8n

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

cd /tmp/src/android

export TARGET_RELEASE=ap2a
. build/envsetup.sh

lunch lineage_CK8n-userdebug

mka everest -j$(nproc --all)
