/****************************************************************************
Copyright (c) 2010 cocos2d-x.org

http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/
#ifndef __Java_org_cocos2dx_lib_Cocos2dxHelper_H__
#define __Java_org_cocos2dx_lib_Cocos2dxHelper_H__

#include <string>

typedef void (*EditTextCallback)(const char* pText, void* ctx);
typedef void (*EditTextCallbackWithCancelFlag)(const char* pText, void* ctx, bool cancelPress);
typedef void (*DialogOkCallback)(int tag, void* ctx);

extern const char * getApkPath();//where the android save our apk zip package,CCFileUtilsAndroid will read this zip file for assets as default resources
extern const char * getAppExternalStoragePath();//get the top external storage path that our app use, see cocos2dxActivity's mAppDataExternalStorageFullPath
extern void showDialogJNI(const char * pszMsg, const char * pszTitle, DialogOkCallback pDialogCallback, void* ctx, int tag);
extern void showEditTextDialogJNI(const char* pszTitle, const char* pszContent, int nInputMode, int nInputFlag, int nReturnType, int nMaxLength, EditTextCallbackWithCancelFlag pfEditTextCallback, void* ctx);
extern void terminateProcessJNI();
extern std::string getCurrentLanguageJNI();
extern std::string getPackageNameJNI();
extern std::string getFileDirectoryJNI();//set to CCFileUtilsAndroid::getWritablePath
extern void enableAccelerometerJNI();
extern void disableAccelerometerJNI();
extern void setAccelerometerIntervalJNI(float interval);
// functions for CCUserDefault
extern bool getBoolForKeyJNI(const char* pKey, bool defaultValue);
extern int getIntegerForKeyJNI(const char* pKey, int defaultValue);
extern float getFloatForKeyJNI(const char* pKey, float defaultValue);
extern double getDoubleForKeyJNI(const char* pKey, double defaultValue);
extern std::string getStringForKeyJNI(const char* pKey, const char* defaultValue);
extern void setBoolForKeyJNI(const char* pKey, bool value);
extern void setIntegerForKeyJNI(const char* pKey, int value);
extern void setFloatForKeyJNI(const char* pKey, float value);
extern void setDoubleForKeyJNI(const char* pKey, double value);
extern void setStringForKeyJNI(const char* pKey, const char* value);
//
extern void callPlatformLoginJNI();
extern void callPlatformLogoutJNI();
extern void callPlatformAccountManageJNI();
extern void callPlatformPayRechargeJNI(const char* serial, const char* productId, const char* productName, float price, 
	float orignalPrice, int count, const char* description);
extern bool getPlatformLoginStatusJNI();
extern std::string getPlatformLoginUinJNI();
extern std::string getPlatformLoginSessionIdJNI();
extern std::string getPlatformUserNickNameJNI();
extern std::string generateNewOrderSerialJNI();
extern void callPlatformFeedbackJNI();
extern void callPlatformSupportThirdShareJNI(const char* content, const char* imgPath);
extern void callPlatformGameBBSJNI(const char* url);
extern bool getIsOnTempShortPauseJNI();
extern void openUrlOutsideJNI(std::string url);
extern int getNetworkStatusJNI();
extern void showWaitingViewJNI(bool show, int progress, const char* text);
extern std::string getPlatformInfoJNI();
extern std::string getDeviceInfoJNI();
extern std::string getDeviceIDJNI();
extern std::string getClientChannelJNI();
extern int getPlatformIdJNI();
extern void notifyEnterGameJNI();

extern void showAnnouncement(const char* pAnnounceUrl);

extern void pushSysNotification(const char* pTitle,const char* pMessage ,int pInstantMinite );
extern void clearSysNotification();
//
#endif /* __Java_org_cocos2dx_lib_Cocos2dxHelper_H__ */
