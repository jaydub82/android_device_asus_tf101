LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	audio_hw.c
LOCAL_C_INCLUDES += \
	external/tinyalsa/include \
	system/media/audio_effects/include \
	system/media/audio_utils/include
LOCAL_SHARED_LIBRARIES:= \
	liblog \
	libcutils \
	libhardware_legacy \
	libtinyalsa \
	libaudioutils \
	libdl

LOCAL_MODULE := audio.primary.ventana
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw

include $(BUILD_SHARED_LIBRARY)
