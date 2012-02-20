PRODUCT_LOCALES := en_US

# The gps config appropriate for this device
#$(call inherit-product, device/common/gps/gps_us_supl.mk)

$(call inherit-product-if-exists, frameworks/base/data/sounds/AllAudio.mk)
$(call inherit-product-if-exists, external/svox/pico/lang/all_pico_languages.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/locales_full.mk)
$(call inherit-product-if-exists, frameworks/base/data/fonts/fonts.mk)
$(call inherit-product-if-exists, external/lohit-fonts/fonts.mk)
$(call inherit-product-if-exists, frameworks/base/data/keyboards/keyboards.mk)
$(call inherit-product, build/target/product/core.mk)

$(call inherit-product-if-exists, vendor/asus/tf101/device-vendor.mk)

DEVICE_PACKAGE_OVERLAYS += device/asus/tf101/overlay

ifeq ($(TARGET_PREBUILT_KERNEL),)
	LOCAL_KERNEL := device/asus/tf101/kernel
else
	LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

PRODUCT_COPY_FILES += \
    $(LOCAL_KERNEL):kernel

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0
PRODUCT_NAME := full_tf101
PRODUCT_DEVICE := tf101
PRODUCT_BRAND := ASUS
PRODUCT_MODEL := Transformer TF101
PRODUCT_POLICY := android.policy_phone

PRODUCT_PACKAGES += \
    AlarmProvider \
    Bluetooth \
    Calculator \
    Camera \
    CertInstaller \
    DeskClock \
    DrmProvider \
    Email \
    Exchange \
    LatinIME \
    Launcher2 \
    Music \
    MusicFX \
    Phone \
    Settings \
    Sync \
    SyncProvider \
    SystemUI \
    Updater \
    VideoEditor \
    WAPPushManager \
    bluetooth-health \
    drmserver \
    hostapd \
    icu.dat \
    wpa_supplicant.conf \
    libdrmframework \
    libdrmframework_jni \
    libfwdlockengine \
    librs_jni \
    libvideoeditor_jni \
    libvideoeditorplayer \
    libvideoeditor_core \
    libWnnEngDic \
    libWnnJpnDic \
    libwnndict

ifeq ($(wildcard vendor/google),)
PRODUCT_PACKAGES += \
    Calendar \
    CalendarProvider \
    Gallery2 \
    OpenWnn \
    PinyinIME \
    Provision \
    QuickSearchBox
endif

PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.config.ringtone=Ring_Synth_04.ogg \
    ro.config.notification_sound=pixiedust.ogg

PRODUCT_COPY_FILES += \
    system/bluetooth/data/audio.conf:system/etc/bluetooth/audio.conf \
    system/bluetooth/data/auto_pairing.conf:system/etc/bluetooth/auto_pairing.conf \
    system/bluetooth/data/blacklist.conf:system/etc/bluetooth/blacklist.conf \
    system/bluetooth/data/input.conf:system/etc/bluetooth/input.conf \
    system/bluetooth/data/network.conf:system/etc/bluetooth/network.conf \
    frameworks/base/media/libeffects/data/audio_effects.conf:system/etc/audio_effects.conf

include frameworks/base/build/tablet-dalvik-heap.mk

PRODUCT_CHARACTERISTICS := tablet

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

PRODUCT_COPY_FILES += \
    device/asus/tf101/init.rc:root/init.rc \
    device/asus/tf101/init.ventana.rc:root/init.ventana.rc \
    device/asus/tf101/init.ventana.usb.rc:root/init.ventana.usb.rc \
    device/asus/tf101/ueventd.ventana.rc:root/ueventd.ventana.rc

PRODUCT_COPY_FILES += \
    device/asus/tf101/vold.fstab:system/etc/vold.fstab \
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
    device/asus/tf101/bdaddr:system/etc/bluetooth/bdaddr

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
    device/asus/tf101/mxt1386.idc:system/usr/idc/mxt1386.idc \
    device/asus/tf101/eGalax_Serial.idc:system/usr/idc/eGalax_Serial.idc \
    device/asus/tf101/elantech_touchscreen.idc:system/usr/idc/elantech_touchscreen.idc

PRODUCT_PACKAGES += \
    audio_policy.default \
    audio.primary.ventana \
    audio.a2dp.default

PRODUCT_PACKAGES += \
    hwcomposer.default \
    sensors.ventana \
    lights.ventana \
    com.android.future.usb.accessory \
    librs_jni \
    wifiloader \
    su \
    Superuser

PRODUCT_PACKAGES += \
    LiveWallpapers \
    HoloSpiralWallpaper \
    LiveWallpapersPicker \
    VisualizationWallpapers
