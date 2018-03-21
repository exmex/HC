rd /s /q .\obj
rd /s /q .\libs
ndk-build -C ./ clean NDK_DEBUG=1 "NDK_MODULE_PATH=../Code_Client;./;./cocos2dx/platform/third_party/android/prebuilt" "APP_OPTIM=debug"