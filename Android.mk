LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := superunpack.arm64_pie
LOCAL_CFLAGS += -Iinclude
LOCAL_SRC_FILES := superunpack.c version.h

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_MODULE := superrepack.arm64_pie
LOCAL_CFLAGS += -Iinclude
LOCAL_SRC_FILES := superrepack.c version.h

include $(BUILD_EXECUTABLE)
