LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := cocos2dlua_shared

LOCAL_MODULE_FILENAME := libcocos2dlua

LOCAL_CPP_EXTENSION := .cc .cpp

#源文件Source file
LOCAL_SRC_FILES += GameMain.cpp
LOCAL_SRC_FILES += ../../Classes/AppDelegate.cpp
LOCAL_SRC_FILES += ../../Classes/DataTableManager.cpp
LOCAL_SRC_FILES += ../../Classes/GamePlatformInfo.cpp
LOCAL_SRC_FILES += ../../Classes/UpdateLoader.cpp
LOCAL_SRC_FILES += ../../Classes/Gamelua.cpp

#LOCAL_SRC_FILES += ../../Classes/apiforlua.cpp

		
#头文件目录 the header file directory		
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../Classes
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../../../../extensions/AssetsManager
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../../../../include/lua
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../../../../include/lua/cocos2dx_support
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../../../../include/core
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../../../../libOS/include
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../../../../91lib/include

LOCAL_C_INCLUDES += $(LOCAL_PATH)/../../../../extensions
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../../../../com4lovesSDK/com4lovesSDK
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../../../../../Code_Core/jsoncpp-src-0.5.0/include
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../../../../../Code_Core/core/include
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../../../../../Code_Core/core/src

					
LOCAL_STATIC_LIBRARIES := curl_static_prebuilt


LOCAL_WHOLE_STATIC_LIBRARIES := core
LOCAL_WHOLE_STATIC_LIBRARIES += cocos2dx_static
LOCAL_WHOLE_STATIC_LIBRARIES += cocosdenshion_static
LOCAL_WHOLE_STATIC_LIBRARIES += cocos_extension_static
LOCAL_WHOLE_STATIC_LIBRARIES += protobuf_static
LOCAL_WHOLE_STATIC_LIBRARIES += jsoncpp_static
LOCAL_WHOLE_STATIC_LIBRARIES += tinyxml_static
LOCAL_WHOLE_STATIC_LIBRARIES += OS_static
LOCAL_WHOLE_STATIC_LIBRARIES += lp91_static
LOCAL_WHOLE_STATIC_LIBRARIES += cocos_lua_static
LOCAL_WHOLE_STATIC_LIBRARIES += box2d_static
LOCAL_WHOLE_STATIC_LIBRARIES += chipmunk_static

LOCAL_CFLAGS += -DANDROID
LOCAL_CPPFLAGS += -DANDROID
LOCAL_CPPFLAGS += -std=gnu++0x

include $(BUILD_SHARED_LIBRARY)


$(call import-module,cocos2dx)
$(call import-module,CocosDenshion/android)
$(call import-module,extensions)
$(call import-module,jsoncpp-src-0.5.0/makefiles)
$(call import-module,external/Box2D)
$(call import-module,external/chipmunk)
$(call import-module,core/proj.android)
$(call import-module,scripting/lua/proj.android/jni)
$(call import-module,libOS/android)
$(call import-module,91Lib/android)
#$(call import-module,protobuf-2.5.0rc1/proj.android)
