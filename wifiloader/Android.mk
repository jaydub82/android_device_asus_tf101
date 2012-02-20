LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := wifiloader.c
LOCAL_CFLAGS := -O2 -Wall -Wno-unused-parameter -Werror
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := wifiloader
LOCAL_SHARED_LIBRARIES := libcutils

include $(BUILD_EXECUTABLE)
