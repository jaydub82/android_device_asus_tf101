$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# The gps config appropriate for this device
#$(call inherit-product, device/common/gps/gps_us_supl.mk)

$(call inherit-product-if-exists, vendor/asus/tf101/device-vendor.mk)

DEVICE_PACKAGE_OVERLAYS += device/asus/tf101/overlay


ifeq ($(TARGET_PREBUILT_KERNEL),)
	LOCAL_KERNEL := device/asus/tf101/kernel
else
	LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

PRODUCT_COPY_FILES += \
    $(LOCAL_KERNEL):kernel

$(call inherit-product, build/target/product/full.mk)

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0
PRODUCT_NAME := full_tf101
PRODUCT_DEVICE := tf101
PRODUCT_BRAND := Android
PRODUCT_MODEL := Full Android on TF101

include frameworks/base/build/tablet-dalvik-heap.mk

PRODUCT_CHARACTERISTICS := tablet

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

PRODUCT_COPY_FILES += \
    device/asus/tf101/init.rc:root/init.rc \
    device/asus/tf101/init.ventana.rc:root/init.ventana.rc \
    device/asus/tf101/ueventd.ventana.rc:root/ueventd.ventana.rc

PRODUCT_COPY_FILES += \
    device/asus/tf101/asound.conf:system/etc/asound.conf \
    device/asus/tf101/gps.conf:system/etc/gps.conf \
    device/asus/tf101/asus.hardware.TF101.xml:system/etc/permissions/asus.hardware.TF101.xml \
    frameworks/base/data/etc/tablet_core_hardware.xml:system/etc/permissions/tablet_core_hardware.xml \
    frameworks/base/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/base/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/base/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/base/data/etc/android.hardware.sensor.barometer.xml:system/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/base/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/base/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
    frameworks/base/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/base/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
    frameworks/base/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    frameworks/base/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    packages/wallpapers/LivePicker/android.software.live_wallpaper.xml:system/etc/permissions/android.software.live_wallpaper.xml

# Set default USB interface
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=mtp

PRODUCT_PROPERTY_OVERRIDES += \
    wifi.interface=wlan0 \
    wifi.supplicant_scan_interval=15

PRODUCT_COPY_FILES += \
    device/asus/tf101/bcm4329.ko:system/lib/modules/bcm4329.ko \
    device/asus/tf101/nvram.txt:system/etc/wifi/nvram.txt \
    device/asus/tf101/nvram_a.txt:system/etc/wifi/nvram_a.txt \
    device/asus/tf101/nvram_a_sl101.txt:system/etc/wifi/nvram_a_sl101.txt

PRODUCT_COPY_FILES += \
    device/asus/tf101/asusec.kcm:system/usr/keychars/asusec.kcm \
    device/asus/tf101/asusec.kl:system/usr/keylayout/asusec.kl \
    device/asus/tf101/gpio-keys.kl:system/usr/keylayout/gpio-keys.kl

PRODUCT_COPY_FILES += \
    device/asus/tf101/atmel-maxtouch.idc:system/usr/idc/atmel-maxtouch.idc \
    device/asus/tf101/eGalax_Serial.idc:system/usr/idc/eGalax_Serial.idc \
    device/asus/tf101/elantech_touchscreen.idc:system/usr/idc/elantech_touchscreen.idc


PRODUCT_PACKAGES += \
    audio.primary.ventana \
    audio_policy.ventana \
    audio.a2dp.default \
    hwcomposer.default \
    sensors.default \
    com.android.future.usb.accessory \
    LiveWallpapers \
    LiveWallpapersPicker \
    VisualizationWallpapers \
    librs_jni \
    wifiloader

