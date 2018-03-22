LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE := core

LOCAL_MODULE_FILENAME := libcore

LOCAL_SRC_FILES := ../platform/GamePlatform.cpp \
../src/AES.cpp	\
../src/AsyncSocket.cpp	\
../src/Base64.cpp \
../src/Concurrency.cpp	\
../src/CurlDownload.cpp	\
../src/GameEncryptKey.cpp \
../src/GameMaths.cpp \
../src/inifile.cpp	\
../src/IoSocket.cpp	\
../src/Language.cpp	\
../src/MD5.cpp	\
../src/PacketBase.cpp	\
../src/PacketManager.cpp	\
../src/rc4.cpp	\
../src/SeverConsts.cpp	\
../src/SocketBase.cpp	\
../src/stdafx.cpp	\
../src/StringConverter.cpp	\
../src/TableReader.cpp	\
../src/CurlUpload.cpp	\
../src/HeroFileUtils.cpp	\
../src/LegendAminationEffect.cpp	\
../src/LegendAnimation.cpp	\
../src/LegendAnimationFileInfo.cpp	\
../src/GameAnimation.cpp	\
../src/CCMultiSprite.cpp	\
../src/LoadResources.cpp	\
../src/GateKeeper.cpp	\
../src/ThreadSocket.cpp

#../src/tinyxml2.cpp


#../src/AsyncSprite.cpp	\
#../src/LoadingUnit.cpp	\

#LOCAL_SRC_FILES \这种写法 不能在中间 直接注释掉某行

LOCAL_WHOLE_STATIC_LIBRARIES := cocos_curl_static

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/../include

LOCAL_C_INCLUDES := $(LOCAL_PATH)/../include \
					$(LOCAL_PATH)/../src \
                    $(LOCAL_PATH)/../../cocos2dx \
                    $(LOCAL_PATH)/../../cocos2dx/include \
                    $(LOCAL_PATH)/../../cocos2dx/kazmath/include \
                    $(LOCAL_PATH)/../../cocos2dx/platform/android	\
					$(LOCAL_PATH)/../../cocos2dx/platform/android	\
					$(LOCAL_PATH)/../../CocosDenshion/include	\
					$(LOCAL_PATH)/../../jsoncpp-src-0.5.0/include	\
					$(LOCAL_PATH)/../../../Code_Client/projects/Game/Classes	\
					$(LOCAL_PATH)/../../../Code_Client/libOS/include	\
					$(LOCAL_PATH)/../../../Code_Client/91lib/include	\
					$(LOCAL_PATH)/../../scripting/lua/cocos2dx_support	\
					$(LOCAL_PATH)/../../scripting/lua/lua	\
					$(LOCAL_PATH)/../../scripting/lua/tolua	\
					$(LOCAL_PATH)/../../extensions \
					$(LOCAL_PATH)/../../extensions/AssetsManager

#$(LOCAL_PATH)/../../protobuf-2.5.0rc1/src	\
					
LOCAL_CFLAGS += -Wno-psabi
LOCAL_EXPORT_CFLAGS += -Wno-psabi

include $(BUILD_STATIC_LIBRARY)

$(call import-module,libcurl)
