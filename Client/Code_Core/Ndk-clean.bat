rd /s /q .\obj
rd /s /q .\libs
ndk-build -C ./ clean NDK_DEBUG=0 "APP_OPTIM=release" "NDK_MODULE_PATH=../Code_Client;./;./cocos2dx/platform/third_party/android/prebuilt"