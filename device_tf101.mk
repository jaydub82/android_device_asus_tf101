# Copyright (C) 2011 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# The gps config appropriate for this device
$(call inherit-product, device/common/gps/gps_us_supl.mk)

$(call inherit-product-if-exists, vendor/asus/tf101/tf101-vendor.mk)

# Prebuilt kernel location
ifeq ($(TARGET_3G), true)
	DEVICE_PACKAGE_OVERLAYS += device/asus/tf101/overlay3g
else
	DEVICE_PACKAGE_OVERLAYS += device/asus/tf101/overlay
endif


# Prebuilt kernel location
ifeq ($(TARGET_PREBUILT_KERNEL),)
	LOCAL_KERNEL := device/asus/tf101/kernel
else
	LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

# Files needed for boot image
PRODUCT_COPY_FILES += \
    $(LOCAL_KERNEL):kernel \
    $(LOCAL_PATH)/ramdisk/init:root/init \
    $(LOCAL_PATH)/ramdisk/init.ventana.rc:root/init.ventana.rc\
    $(LOCAL_PATH)/ramdisk/init.ventana.usb.rc:root/init.ventana.usb.rc \
    $(LOCAL_PATH)/ramdisk/ueventd.ventana.rc:root/ueventd.ventana.rc

# Prebuilt configeration files
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/prebuilt/asound.conf:system/etc/asound.conf \
    $(LOCAL_PATH)/prebuilt/media_profiles.xml:system/etc/media_profiles.xml \
    $(LOCAL_PATH)/prebuilt/vold.fstab:system/etc/vold.fstab \
    $(LOCAL_PATH)/prebuilt/gps.conf:system/etc/gps.conf \
    $(LOCAL_PATH)/prebuilt/gpsconfig.xml:system/etc/gps/gpsconfig.xml

# Input device configeration files
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/usr/idc/atmel-maxtouch.idc:system/usr/idc/atmel-maxtouch.idc \
    $(LOCAL_PATH)/usr/idc/elantech_touchscreen.idc:system/usr/idc/elantech_touchscreen.idc \
    $(LOCAL_PATH)/usr/idc/panjit_touch.idc:system/usr/idc/panjit_touch.idc \
    $(LOCAL_PATH)/usr/keychars/asusec.kcm:system/usr/keychars/asusec.kcm \
    $(LOCAL_PATH)/usr/keylayout/asusec.kl:system/usr/keylayout/asusec.kl \
    $(LOCAL_PATH)/usr/keylayout/gpio-keys.kl:system/usr/keylayout/gpio-keys.kl

# Any prebuilt kernel modules
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/modules/bcm4329.ko:system/lib/modules/bcm4329.ko \
    $(LOCAL_PATH)/modules/battery_rvsd.ko:system/lib/modules/battery_rvsd.ko \
    $(LOCAL_PATH)/modules/bcmdhd.ko:system/lib/modules/bcmdhd.ko \
    $(LOCAL_PATH)/modules/scsi_wait_scan.ko:system/lib/modules/scsi_wait_scan.ko

# Camera/WiFi/BT Firmware
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/prebuilt/nvram_nh615.txt:system/etc/nvram_nh615.txt \
    $(LOCAL_PATH)/prebuilt/firmware/BCM4329B1_002.002.023.0797.0863.hcd:system/etc/firmware/BCM4329B1_002.002.023.0797.0863.hcd \
    $(LOCAL_PATH)/prebuilt/firmware/fw_bcm4329.bin:system/vendor/firmware/fw_bcm4329.bin \
    $(LOCAL_PATH)/prebuilt/firmware/fw_bcm4329_apsta.bin:system/vendor/firmware/fw_bcm4329_apsta.bin

# These are the hardware-specific features
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/permissions/android.hardware.tf101.xml:system/etc/permissions/android.hardware.tf101.xml \
    frameworks/base/data/etc/tablet_core_hardware.xml:system/etc/permissions/tablet_core_hardware.xml \
    frameworks/base/data/etc/android.hardware.camera.xml:system/etc/permissions/android.hardware.camera.xml \
    frameworks/base/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
    frameworks/base/data/etc/android.hardware.location.xml:system/etc/permissions/android.hardware.location.xml \
    frameworks/base/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/base/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/base/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/base/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/base/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/base/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/base/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/base/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/base/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
    frameworks/base/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/base/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    packages/wallpapers/LivePicker/android.software.live_wallpaper.xml:system/etc/permissions/android.software.live_wallpaper.xml

# Build characteristics setting 
PRODUCT_CHARACTERISTICS := tablet

# This device have enough room for precise davick
PRODUCT_TAGS += dalvik.gc.type-precise

# Extra packages to build for this device
PRODUCT_PACKAGES += \
    	librs_jni \
	com.android.future.usb.accessory \
	make_ext4fs \
	setup_fs \
        audio.a2dp.default \
        libaudioutils \
	libinvensense_mpl \
        blobpack_tf

# Propertys spacific for this device
#ro.build.branch and ro.build.modversion is for system update (still in dev)(timbit123)
PRODUCT_PROPERTY_OVERRIDES := \
	ro.wifi.country=GB \
        ro.build.branch=tf101 \
	ro.build.modversion=1.0.0 \
        ro.ethernet.interface=eth0 \
        ro.ethernet.autoEnable=yes \
    	wifi.interface=wlan0 \
    	wifi.supplicant_scan_interval=15 \
    	ro.opengles.version=131072 \
	persist.sys.usb.config=mtp,adb \
	dalvik.vm.dexopt-data-only=1

# Inherit tablet dalvik settings
$(call inherit-product, frameworks/base/build/tablet-dalvik-heap.mk)

# Call the vendor to setup propiatory files
$(call inherit-product-if-exists, vendor/asus/tf101/tf101-vendor.mk)
PRODUCT_MANUFACTURER := Asus
