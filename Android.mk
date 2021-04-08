LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := superunpack.arm64_pie
LOCAL_SRC_FILES := superunpack.c
LOCAL_CFLAGS += -Iinclude
include $(BUILD_EXECUTABLE)
