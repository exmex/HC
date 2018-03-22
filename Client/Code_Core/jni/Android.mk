
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE    := hello-jni
LOCAL_SRC_FILES := hello-jni.c

ifeq ($(APP_OPTIM),debug)
$(info debug build)
endif

ifeq ($(APP_OPTIM),release)
$(info release build)
endif

LOCAL_WHOLE_STATIC_LIBRARIES := cocos2dx_static
LOCAL_WHOLE_STATIC_LIBRARIES += cocosdenshion_static
LOCAL_WHOLE_STATIC_LIBRARIES += cocos_extension_static
LOCAL_WHOLE_STATIC_LIBRARIES += cocos_lua_static
LOCAL_WHOLE_STATIC_LIBRARIES += protobuf_static
LOCAL_WHOLE_STATIC_LIBRARIES += jsoncpp_static
LOCAL_WHOLE_STATIC_LIBRARIES += chipmunk_static
LOCAL_WHOLE_STATIC_LIBRARIES += core
LOCAL_WHOLE_STATIC_LIBRARIES += OS_static
LOCAL_WHOLE_STATIC_LIBRARIES += lp91_static

LOCAL_CFLAGS += -DANDROID
LOCAL_CPPFLAGS += -DANDROID

include $(BUILD_SHARED_LIBRARY)
#include $(BUILD_STATIC_LIBRARY)


$(call import-module,cocos2dx)
$(call import-module,CocosDenshion/android)
$(call import-module,extensions)
$(call import-module,jsoncpp-src-0.5.0/makefiles)
$(call import-module,external/chipmunk)
$(call import-module,core/proj.android)
$(call import-module,scripting/lua/proj.android/jni)
$(call import-module,libOS/Android)
$(call import-module,91lib/Android)

#$(call import-module,protobuf-2.5.0rc1/proj.android)
