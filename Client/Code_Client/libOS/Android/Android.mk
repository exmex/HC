LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE := OS_static

LOCAL_MODULE_FILENAME := libOS

LOCAL_SRC_FILES := libOS.cpp \
libOSHelpJni.cpp

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/../include

LOCAL_C_INCLUDES := $(LOCAL_PATH)/../include
LOCAL_C_INCLUDES += $(LOCAL_PATH)
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../../include/cocos2dx/platform/android
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../../include/cocos2dx
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../../include/cocos2dx/include
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../../include/cocos2dx/kazmath/include


include $(BUILD_STATIC_LIBRARY)
