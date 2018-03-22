LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE    := cocos_lua_static

LOCAL_MODULE_FILENAME := liblua

LOCAL_SRC_FILES :=../../lua/lapi.c \
                  ../../lua/lauxlib.c \
          ../../lua/lbaselib.c \
          ../../lua/lcode.c \
          ../../lua/ldblib.c \
          ../../lua/ldebug.c \
          ../../lua/ldo.c \
          ../../lua/ldump.c \
          ../../lua/lfunc.c \
          ../../lua/lgc.c \
          ../../lua/linit.c \
          ../../lua/liolib.c \
          ../../lua/llex.c \
          ../../lua/lmathlib.c \
          ../../lua/lmem.c \
          ../../lua/loadlib.c \
          ../../lua/lobject.c \
          ../../lua/lopcodes.c \
          ../../lua/loslib.c \
          ../../lua/lparser.c \
          ../../lua/lstate.c \
          ../../lua/lstring.c \
          ../../lua/lstrlib.c \
          ../../lua/ltable.c \
          ../../lua/ltablib.c \
          ../../lua/ltm.c \
          ../../lua/lua.c \
          ../../lua/lundump.c \
          ../../lua/lvm.c \
          ../../lua/lzio.c \
          ../../lua/print.c \
          ../../tolua/tolua_event.c \
          ../../tolua/tolua_is.c \
          ../../tolua/tolua_map.c \
          ../../tolua/tolua_push.c \
          ../../tolua/tolua_to.c \
          ../../cocos2dx_support/CCLuaBridge.cpp \
          ../../cocos2dx_support/CCLuaEngine.cpp \
          ../../cocos2dx_support/CCLuaStack.cpp \
          ../../cocos2dx_support/CCLuaValue.cpp \
          ../../cocos2dx_support/Cocos2dxLuaLoader.cpp \
          ../../cocos2dx_support/LuaCocos2d.cpp \
          ../../cocos2dx_support/tolua_fix.c \
          ../../cocos2dx_support/platform/android/CCLuaJava.cpp \
          ../../gzio/lgziolib.c \
          ../../lpeg/lpcap.c \
          ../../lpeg/lpcode.c \
          ../../lpeg/lpprint.c \
          ../../lpeg/lptree.c \
          ../../lpeg/lpvm.c \
          ../../LuaBitOp/bit.c \
          ../../luasocket/auxiliar.c \
          ../../luasocket/buffer.c \
          ../../luasocket/except.c \
          ../../luasocket/inet.c \
          ../../luasocket/io.c \
          ../../luasocket/luasocket.c \
          ../../luasocket/mime.c \
          ../../luasocket/options.c \
          ../../luasocket/select.c \
          ../../luasocket/tcp.c \
          ../../luasocket/timeout.c \
          ../../luasocket/udp.c \
          ../../luasocket/unix.c \
          ../../luasocket/usocket.c \
          ../../luastruct/struct.c \
	 ../../md5/md5lib.c \
 	 ../../../../protocol/StringHlp.cpp  \
	 ../../../../protocol/game_idl.cpp  \
	 ../../../../protocol/xproto.cpp 	\
	 ../../../../../Code_Client/projects/Game/Classes/apiforlua.cpp
	 
	 
#../../../../../Code_Client/projects/Game/Classes/GateKeeper.cpp  	 
#../../cocos2dx_support/HGAminationEffect.cpp \
#../../cocos2dx_support/HGAnimation.cpp \
#../../cocos2dx_support/HGAnimationFileInfo.cpp \
 
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/../../lua \
                           $(LOCAL_PATH)/../../tolua \
                           $(LOCAL_PATH)/../../cocos2dx_support 
          
          
LOCAL_C_INCLUDES := $(LOCAL_PATH)/ \
                    $(LOCAL_PATH)/../../lua \
                    $(LOCAL_PATH)/../../tolua \
					$(LOCAL_PATH)/../../cocos2dx_support \
                    $(LOCAL_PATH)/../../../../cocos2dx \
					$(LOCAL_PATH)/../../../../core/include \
                    $(LOCAL_PATH)/../../../../cocos2dx/include \
                    $(LOCAL_PATH)/../../../../cocos2dx/platform \
                    $(LOCAL_PATH)/../../../../cocos2dx/platform/android \
                    $(LOCAL_PATH)/../../../../cocos2dx/kazmath/include \
                    $(LOCAL_PATH)/../../../../CocosDenshion/include  \
                    $(LOCAL_PATH)/../../../../extensions \
                    $(LOCAL_PATH)/../../../../extensions/AssetsManager \
					$(LOCAL_PATH)/../../../../cocos2dx/platform/third_party/android/prebuilt/libcurl/include \
                    $(LOCAL_PATH)/../../../../cocos2dx/platform/third_party/android/prebuilt/libopenssl/include \
					$(LOCAL_PATH)/../../../../../Code_Client/projects/Game/Classes	\
                    $(LOCAL_PATH)/../../../../../Code_Client/libOS/include	\
					$(LOCAL_PATH)/../../../../../Code_Client/com4lovesSDK/com4lovesSDK
LOCAL_CFLAGS += -Wno-psabi
LOCAL_EXPORT_CFLAGS += -Wno-psabi

include $(BUILD_STATIC_LIBRARY)
