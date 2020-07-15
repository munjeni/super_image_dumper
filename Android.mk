LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := superunpack.arm64_pie
LOCAL_CFLAGS += -Iinclude
LOCAL_SRC_FILES := superunpack.c

include $(BUILD_EXECUTABLE)
