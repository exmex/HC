#include <stdlib.h>
#include <jni.h>
#include <android/log.h>
#include <string>
#include "JniHelper.h"
#include "cocoa/CCString.h"
#include "Java_org_cocos2dx_lib_Cocos2dxHelper.h"
#include "libPlatform.h"
#include "libOS.h"
#include "SeverConsts.h"

#define  LOG_TAG    "Java_org_cocos2dx_lib_Cocos2dxHelper.cpp"
#define  LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG,LOG_TAG,__VA_ARGS__)

#define  CLASS_NAME "org/cocos2dx/lib/Cocos2dxHelper"

static EditTextCallback s_pfEditTextCallback = NULL;
static EditTextCallbackWithCancelFlag s_pfEditTextCallbackWithCancelFlag = NULL;
static DialogOkCallback s_pfDialogOkCallback = NULL;
static void* s_ctx = NULL;

using namespace cocos2d;
using namespace std;

string g_apkPath;
string g_appExternalStoragePath;//add by xinzheng 2013-05-18

extern "C" {

    JNIEXPORT void JNICALL Java_org_cocos2dx_lib_Cocos2dxHelper_nativeSetApkPath(JNIEnv*  env, jobject thiz, jstring apkPath, jstring appExternalStoragePath) {
        g_apkPath = JniHelper::jstring2string(apkPath);
		g_appExternalStoragePath = JniHelper::jstring2string(appExternalStoragePath);
    }

    JNIEXPORT void JNICALL Java_org_cocos2dx_lib_Cocos2dxHelper_nativeSetEditTextDialogResult(JNIEnv * env, jobject obj, jbyteArray text) {
        jsize  size = env->GetArrayLength(text);

        if (size > 0) {
            jbyte * data = (jbyte*)env->GetByteArrayElements(text, 0);
            char* pBuf = (char*)malloc(size+1);
            if (pBuf != NULL) {
                memcpy(pBuf, data, size);
                pBuf[size] = '\0';
                // pass data to edittext's delegate
                if (s_pfEditTextCallbackWithCancelFlag) s_pfEditTextCallbackWithCancelFlag(pBuf, s_ctx, false);
                free(pBuf);
            }
            env->ReleaseByteArrayElements(text, data, 0);
        } else {
            if (s_pfEditTextCallbackWithCancelFlag) s_pfEditTextCallbackWithCancelFlag("", s_ctx, false);
        }
    }

	JNIEXPORT void JNICALL Java_org_cocos2dx_lib_Cocos2dxHelper_nativeSetEditTextDialogCancelResult(JNIEnv * env, jobject obj, jbyteArray text) {
		jsize  size = env->GetArrayLength(text);

		if (size > 0) {
			jbyte * data = (jbyte*)env->GetByteArrayElements(text, 0);
			char* pBuf = (char*)malloc(size+1);
			if (pBuf != NULL) {
				memcpy(pBuf, data, size);
				pBuf[size] = '\0';
				// pass data to edittext's delegate
				if (s_pfEditTextCallbackWithCancelFlag) s_pfEditTextCallbackWithCancelFlag(pBuf, s_ctx, true);
				free(pBuf);
			}
			env->ReleaseByteArrayElements(text, data, 0);
		} else {
			if (s_pfEditTextCallbackWithCancelFlag) s_pfEditTextCallbackWithCancelFlag("", s_ctx, true);
		}
	}

    JNIEXPORT void JNICALL Java_org_cocos2dx_lib_Cocos2dxHelper_nativeDialogOkCallback(JNIEnv * env, jobject obj, jint tag) {

    	if (s_pfDialogOkCallback) {
    		s_pfDialogOkCallback(tag, s_ctx);
    	}

    }

	/*
		xinzheng 2013-06-20
		应用程序启动、更新检测、更新流程：
		apk和ipa程序入口相当于一个loader程序，应在loader拉起Game.so（AppDelegate被创建）的时候，准备好二者的衔接；
		而且只是State(LoadingFrame)这个状态需要与loader通信；
		以下顺序执行，为了减少麻烦，不并行：
		0、apk入口，显示公司&游戏logo、动画，这个过程不宜过长；检测网络、存储条件；
		0a、隔离平台的版本更新检测和实现；因为有些平台强制在初始化使用其版本更新功能；
		1、初始化平台SDK，显示平台logo，如果平台不需显示logo，可以延长0步的显示界面；如果不接入平台SDK，直接跳到第2步；
		2、版本更检测，a、自有版本更新实现，需要区别是否使用平台提供的更新检测；b、调用平台SDK提供的更新实现；更新检测结果为可选或无时，进入第3步；
		3、初始化OpenGL ES Context、纹理、音频、输入等与系统相关的必须组件；这个过程会黑屏，需要在loader层保持最上层logo界面或者另外的logo、动画界面；
		4、初始化Game.so，创建AppDelegate，指定集成的登录&支付平台，准备好与loader的衔接，进入State(LoadingFrame)，通知可以发起内更新检测；移除loader层多余的界面，真正开始显示Game.so渲染的界面；
		5、内更新检测返回无需更新，发起调用平台账号登录；或者，内更新进行更新，成功完毕后，发起调用平台账号登录；
		6、停留在State(LoadingFrame)，直到平台账号登录成功通知Game.so，解除与loader的衔接，允许进入游戏State(MainFrame）；
		7、目前进入State(MainFrame）后不允许再切换账号返回State(LoadingFrame)，只得重启；
	*/

	JNIEXPORT void JNICALL Java_org_cocos2dx_lib_Cocos2dxHelper_nativeNotifyPlatformInitResult(JNIEnv*  env, jobject thiz, 
		jint result) {

			bool bret = result == 0 ? true : false;
			//
			//LOGD("libPlatformManager::getPlatform()->_boardcastInitDone(true)");
			//libPlatformManager::getPlatform()->_boardcastInitDone(bret, "please upgrade your app");
			//
	}

	JNIEXPORT void JNICALL Java_org_cocos2dx_lib_Cocos2dxHelper_nativeNotifyPlatformGameUpdateResult(JNIEnv*  env, jobject thiz, 
		jint result, jint max_version, jint local_version, jstring down_url) {

			if (result < 2)//2强制更新1建议更新0无更新或错误
			{
				LOGD("libPlatformManager::getPlatform()->_boardcastNeedUpdateApp(true)");
				libPlatformManager::getPlatform()->_boardcastUpdateCheckDone(true, JniHelper::jstring2string(down_url));
			}


	}

	JNIEXPORT void JNICALL Java_org_cocos2dx_lib_Cocos2dxHelper_nativeNotifyPlatformLoginResult(JNIEnv*  env, jobject thiz, 
		jint result, jstring uin, jstring sessionid, jstring nickname) {
		
		if (result == 0)
		{
			LOGD("libPlatformManager::getPlatform()->_boardcastLoginResult(true)");
			libPlatformManager::getPlatform()->_boardcastLoginResult(true, "");
		}
		

	}

	JNIEXPORT void JNICALL Java_org_cocos2dx_lib_Cocos2dxHelper_nativeNotifyPlatformPayResult(JNIEnv*  env, jobject thiz, 
		jint result, jstring serial, jstring productId, jstring productName, 
		jfloat price, jfloat orignalPrice, jint count, jstring description) {

		BUYINFO buyinfo;
		buyinfo.cooOrderSerial = JniHelper::jstring2string(serial);
		buyinfo.productId = JniHelper::jstring2string(productId);
		buyinfo.productName = JniHelper::jstring2string(productName);
		buyinfo.description = JniHelper::jstring2string(description);
		buyinfo.productPrice = price;
		buyinfo.productOrignalPrice = orignalPrice;
		buyinfo.productCount = count;
		//
		if (result == 0)
		{
			LOGD("libPlatformManager::getPlatform()->_boardcastBuyinfoSent(true)");
			libPlatformManager::getPlatform()->_boardcastBuyinfoSent(true, buyinfo, "");
		}
		else
		{
			LOGD("libPlatformManager::getPlatform()->_boardcastBuyinfoSent(false,%d)", result);
			libPlatformManager::getPlatform()->_boardcastBuyinfoSent(false, buyinfo, "");
		}
	}

	JNIEXPORT jboolean JNICALL Java_org_cocos2dx_lib_Cocos2dxHelper_nativeHasEnterMainFrame(JNIEnv * env, jobject obj)
	{
		LOGD("libPlatformManager::getPlatform()->nativeHasEnterMainFrame(%d)",!SeverConsts::Get()->GetIsInLoading());
		return (!SeverConsts::Get()->GetIsInLoading());
	}

}

const char * getApkPath() {
    return g_apkPath.c_str();
}

const char * getAppExternalStoragePath() {
	return g_appExternalStoragePath.c_str();
}

void showDialogJNI(const char * pszMsg, const char * pszTitle, DialogOkCallback pDialogCallback, void* ctx, int tag) {
    if (!pszMsg) {
        return;
    }

    s_pfDialogOkCallback = pDialogCallback;
    s_ctx = ctx;

    JniMethodInfo t;
    if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "showDialog", "(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)V")) {
        jstring stringArg1;

        if (!pszTitle) {
            stringArg1 = t.env->NewStringUTF("");
        } else {
            stringArg1 = t.env->NewStringUTF(pszTitle);
        }

        jstring stringArg2 = t.env->NewStringUTF(pszMsg);
        jint msgId = tag;
        jstring strPositiveCallback = t.env->NewStringUTF("");//not use now

        t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg1, stringArg2, msgId, strPositiveCallback);

        t.env->DeleteLocalRef(stringArg1);
        t.env->DeleteLocalRef(stringArg2);
        t.env->DeleteLocalRef(t.classID);
    }
}

void showEditTextDialogJNI(const char* pszTitle, const char* pszMessage, int nInputMode, int nInputFlag, int nReturnType, int nMaxLength, EditTextCallbackWithCancelFlag pfEditTextCallback, void* ctx) {
    if (pszMessage == NULL) {
        return;
    }

    s_pfEditTextCallbackWithCancelFlag = pfEditTextCallback;
    s_ctx = ctx;

    JniMethodInfo t;
    if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "showEditTextDialog", "(Ljava/lang/String;Ljava/lang/String;IIII)V")) {
        jstring stringArg1;

        if (!pszTitle) {
            stringArg1 = t.env->NewStringUTF("");
        } else {
            stringArg1 = t.env->NewStringUTF(pszTitle);
        }

        jstring stringArg2 = t.env->NewStringUTF(pszMessage);

        t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg1, stringArg2, nInputMode, nInputFlag, nReturnType, nMaxLength);

        t.env->DeleteLocalRef(stringArg1);
        t.env->DeleteLocalRef(stringArg2);
        t.env->DeleteLocalRef(t.classID);
    }
}

void terminateProcessJNI() {
    JniMethodInfo t;

    if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "terminateProcess", "()V")) {
        t.env->CallStaticVoidMethod(t.classID, t.methodID);
        t.env->DeleteLocalRef(t.classID);
    }
}

std::string getPackageNameJNI() {
    JniMethodInfo t;
    std::string ret("");

    if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "getCocos2dxPackageName", "()Ljava/lang/String;")) {
        jstring str = (jstring)t.env->CallStaticObjectMethod(t.classID, t.methodID);
        t.env->DeleteLocalRef(t.classID);
        ret = JniHelper::jstring2string(str);
        t.env->DeleteLocalRef(str);
    }
    return ret;
}

std::string getFileDirectoryJNI() {//set to CCFileUtilsAndroid::getWritablePath
    JniMethodInfo t;
    std::string ret("");

    if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "getCocos2dxWritablePath", "()Ljava/lang/String;")) {
        jstring str = (jstring)t.env->CallStaticObjectMethod(t.classID, t.methodID);
        t.env->DeleteLocalRef(t.classID);
        ret = JniHelper::jstring2string(str);
        t.env->DeleteLocalRef(str);
    }
    
    return ret;
}

std::string getCurrentLanguageJNI() {
    JniMethodInfo t;
    std::string ret("");
    
    if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "getCurrentLanguage", "()Ljava/lang/String;")) {
        jstring str = (jstring)t.env->CallStaticObjectMethod(t.classID, t.methodID);
        t.env->DeleteLocalRef(t.classID);
        ret = JniHelper::jstring2string(str);
        t.env->DeleteLocalRef(str);
    }

    return ret;
}

void enableAccelerometerJNI() {
    JniMethodInfo t;

    if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "enableAccelerometer", "()V")) {
        t.env->CallStaticVoidMethod(t.classID, t.methodID);
        t.env->DeleteLocalRef(t.classID);
    }
}

void setAccelerometerIntervalJNI(float interval) {
    JniMethodInfo t;

    if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "setAccelerometerInterval", "(F)V")) {
        t.env->CallStaticVoidMethod(t.classID, t.methodID, interval);
        t.env->DeleteLocalRef(t.classID);
    }
}

void disableAccelerometerJNI() {
    JniMethodInfo t;

    if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "disableAccelerometer", "()V")) {
        t.env->CallStaticVoidMethod(t.classID, t.methodID);
        t.env->DeleteLocalRef(t.classID);
    }
}

// functions for CCUserDefault
bool getBoolForKeyJNI(const char* pKey, bool defaultValue)
{
    JniMethodInfo t;
    
    if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "getBoolForKey", "(Ljava/lang/String;Z)Z")) {
        jstring stringArg = t.env->NewStringUTF(pKey);
        jboolean ret = t.env->CallStaticBooleanMethod(t.classID, t.methodID, stringArg, defaultValue);
        
        t.env->DeleteLocalRef(t.classID);
        t.env->DeleteLocalRef(stringArg);
        
        return ret;
    }
    
    return defaultValue;
}

int getIntegerForKeyJNI(const char* pKey, int defaultValue)
{
    JniMethodInfo t;
    
    if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "getIntegerForKey", "(Ljava/lang/String;I)I")) {
        jstring stringArg = t.env->NewStringUTF(pKey);
        jint ret = t.env->CallStaticIntMethod(t.classID, t.methodID, stringArg, defaultValue);
        
        t.env->DeleteLocalRef(t.classID);
        t.env->DeleteLocalRef(stringArg);
        
        return ret;
    }
    
    return defaultValue;
}

float getFloatForKeyJNI(const char* pKey, float defaultValue)
{
    JniMethodInfo t;
    
    if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "getFloatForKey", "(Ljava/lang/String;F)F")) {
        jstring stringArg = t.env->NewStringUTF(pKey);
        jfloat ret = t.env->CallStaticFloatMethod(t.classID, t.methodID, stringArg, defaultValue);
        
        t.env->DeleteLocalRef(t.classID);
        t.env->DeleteLocalRef(stringArg);
        
        return ret;
    }
    
    return defaultValue;
}

double getDoubleForKeyJNI(const char* pKey, double defaultValue)
{
    JniMethodInfo t;
    
    if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "getDoubleForKey", "(Ljava/lang/String;D)D")) {
        jstring stringArg = t.env->NewStringUTF(pKey);
        jdouble ret = t.env->CallStaticDoubleMethod(t.classID, t.methodID, stringArg);
        
        t.env->DeleteLocalRef(t.classID);
        t.env->DeleteLocalRef(stringArg);
        
        return ret;
    }
    
    return defaultValue;
}

std::string getStringForKeyJNI(const char* pKey, const char* defaultValue)
{
    JniMethodInfo t;
    std::string ret("");

    if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "getStringForKey", "(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;")) {
        jstring stringArg1 = t.env->NewStringUTF(pKey);
        jstring stringArg2 = t.env->NewStringUTF(defaultValue);
        jstring str = (jstring)t.env->CallStaticObjectMethod(t.classID, t.methodID, stringArg1, stringArg2);
        ret = JniHelper::jstring2string(str);
        
        t.env->DeleteLocalRef(t.classID);
        t.env->DeleteLocalRef(stringArg1);
        t.env->DeleteLocalRef(stringArg2);
        t.env->DeleteLocalRef(str);
        
        return ret;
    }
    
    return defaultValue;
}

void setBoolForKeyJNI(const char* pKey, bool value)
{
    JniMethodInfo t;
    
    if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "setBoolForKey", "(Ljava/lang/String;Z)V")) {
        jstring stringArg = t.env->NewStringUTF(pKey);
        t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg, value);
        
        t.env->DeleteLocalRef(t.classID);
        t.env->DeleteLocalRef(stringArg);
    }
}

void setIntegerForKeyJNI(const char* pKey, int value)
{
    JniMethodInfo t;
    
    if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "setIntegerForKey", "(Ljava/lang/String;I)V")) {
        jstring stringArg = t.env->NewStringUTF(pKey);
        t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg, value);
        
        t.env->DeleteLocalRef(t.classID);
        t.env->DeleteLocalRef(stringArg);
    }
}

void setFloatForKeyJNI(const char* pKey, float value)
{
    JniMethodInfo t;
    
    if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "setFloatForKey", "(Ljava/lang/String;F)V")) {
        jstring stringArg = t.env->NewStringUTF(pKey);
        t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg, value);
        
        t.env->DeleteLocalRef(t.classID);
        t.env->DeleteLocalRef(stringArg);
    }
}

void setDoubleForKeyJNI(const char* pKey, double value)
{
    JniMethodInfo t;
    
    if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "setDoubleForKey", "(Ljava/lang/String;D)V")) {
        jstring stringArg = t.env->NewStringUTF(pKey);
        t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg, value);
        
        t.env->DeleteLocalRef(t.classID);
        t.env->DeleteLocalRef(stringArg);
    }
}

void setStringForKeyJNI(const char* pKey, const char* value)
{
    JniMethodInfo t;
    
    if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "setStringForKey", "(Ljava/lang/String;Ljava/lang/String;)V")) {
        jstring stringArg1 = t.env->NewStringUTF(pKey);
        jstring stringArg2 = t.env->NewStringUTF(value);
        t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg1, stringArg2);
        
        t.env->DeleteLocalRef(t.classID);
        t.env->DeleteLocalRef(stringArg1);
        t.env->DeleteLocalRef(stringArg2);
    }
}

//
void callPlatformLoginJNI()
{
	JniMethodInfo t;

	if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "callPlatformLogin", "()V")) {
		t.env->CallStaticVoidMethod(t.classID, t.methodID);
		t.env->DeleteLocalRef(t.classID);
	}
}

void callPlatformLogoutJNI()
{
	JniMethodInfo t;

	if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "callPlatformLogout", "()V")) {
		t.env->CallStaticVoidMethod(t.classID, t.methodID);
		t.env->DeleteLocalRef(t.classID);
	}
}

void callPlatformAccountManageJNI()
{
	JniMethodInfo t;

	if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "callPlatformAccountManage", "()V")) {
		t.env->CallStaticVoidMethod(t.classID, t.methodID);
		t.env->DeleteLocalRef(t.classID);
	}
}

void callPlatformPayRechargeJNI(const char* serial, const char* productId, const char* productName, float price, 
	float orignalPrice, int count, const char* description)
{
	JniMethodInfo t;

	if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "callPlatformPayRecharge", 
		"(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;FFILjava/lang/String;)V"))
	{
		//LOGD("callPlatformPayRechargeJNI");
		jstring strSerial = t.env->NewStringUTF(serial);
		jstring strProductId = t.env->NewStringUTF(productId);
		jstring strProductName = t.env->NewStringUTF(productName);
		jstring strDescription = t.env->NewStringUTF(description);

		//std::string str1 = JniHelper::jstring2string(strSerial);
		//std::string str2 = JniHelper::jstring2string(strProductId);
		//std::string str3 = JniHelper::jstring2string(strProductName);
		//std::string str4 = JniHelper::jstring2string(strDescription);
		
		//LOGD("callPlatformPayRechargeJNI %s,%s,%s,%s", str1.c_str(), str2.c_str(),str3.c_str(),str4.c_str());

		t.env->CallStaticVoidMethod(t.classID, t.methodID, strSerial, strProductId, 
			strProductName, price, orignalPrice, count, strDescription);

		t.env->DeleteLocalRef(t.classID);
		t.env->DeleteLocalRef(strDescription);
		t.env->DeleteLocalRef(strProductName);
		t.env->DeleteLocalRef(strProductId);
		t.env->DeleteLocalRef(strSerial);
	}
}

bool getPlatformLoginStatusJNI()
{
	JniMethodInfo t;

	if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "getPlatformLoginStatus", "()Z")) {
		jboolean ret = t.env->CallStaticBooleanMethod(t.classID, t.methodID);
		t.env->DeleteLocalRef(t.classID);
		
		return ret;
	}

	return false;
}

std::string getPlatformLoginUinJNI()
{
	JniMethodInfo t;

	if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "getPlatformLoginUin", "()Ljava/lang/String;")) {
		jstring str = (jstring)t.env->CallStaticObjectMethod(t.classID, t.methodID);
		t.env->DeleteLocalRef(t.classID);

		return JniHelper::jstring2string(str);
	}

	return "";
}

std::string getPlatformLoginSessionIdJNI()
{
	JniMethodInfo t;

	if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "getPlatformLoginSessionId", "()Ljava/lang/String;")) {
		jstring str = (jstring)t.env->CallStaticObjectMethod(t.classID, t.methodID);
		t.env->DeleteLocalRef(t.classID);

		return JniHelper::jstring2string(str);
	}

	return "PLoginSession";
}

std::string getPlatformUserNickNameJNI()
{
	JniMethodInfo t;

	if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "getPlatformUserNickName", "()Ljava/lang/String;")) {
		jstring str = (jstring)t.env->CallStaticObjectMethod(t.classID, t.methodID);
		t.env->DeleteLocalRef(t.classID);

		return JniHelper::jstring2string(str);
	}

	return "PUNickName";
}

std::string generateNewOrderSerialJNI()
{
	JniMethodInfo t;

	if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "generateNewOrderSerial", "()Ljava/lang/String;")) {
		jstring str = (jstring)t.env->CallStaticObjectMethod(t.classID, t.methodID);
		t.env->DeleteLocalRef(t.classID);

		return JniHelper::jstring2string(str);
	}

	return "";
}

void callPlatformFeedbackJNI()
{
	JniMethodInfo t;

	if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "callPlatformFeedback", "()V")) {
		t.env->CallStaticVoidMethod(t.classID, t.methodID);
		t.env->DeleteLocalRef(t.classID);
	}
}

void callPlatformSupportThirdShareJNI(const char* content, const char* imgPath)
{
	JniMethodInfo t;

	if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "callPlatformSupportThirdShare", "(Ljava/lang/String;Ljava/lang/String;)V")) {
		jstring stringArg1 = t.env->NewStringUTF(content);
		jstring stringArg2 = t.env->NewStringUTF(imgPath);
		t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg1, stringArg2);
		
		t.env->DeleteLocalRef(t.classID);
		t.env->DeleteLocalRef(stringArg1);
		t.env->DeleteLocalRef(stringArg2);
	}
}

bool getIsOnTempShortPauseJNI()
{
	JniMethodInfo t;

	if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "getIsOnTempShortPause", "()Z")) {
		jboolean ret = t.env->CallStaticBooleanMethod(t.classID, t.methodID);
		t.env->DeleteLocalRef(t.classID);

		return ret;
	}

	return false;
}

void openUrlOutsideJNI(std::string url)
{
	JniMethodInfo t;

	if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "openUrlOutside", "(Ljava/lang/String;)V")) {
		jstring stringArg1 = t.env->NewStringUTF(url.c_str());
		t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg1);

		t.env->DeleteLocalRef(t.classID);
		t.env->DeleteLocalRef(stringArg1);
	}
}

int getNetworkStatusJNI()
{
	JniMethodInfo t;

	if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "getNetworkStatus", "()I")) {
		jint ret = t.env->CallStaticIntMethod(t.classID, t.methodID);
		t.env->DeleteLocalRef(t.classID);

		return ret;
	}

	return NotReachable;
}

void callPlatformGameBBSJNI( const char* url )
{
	JniMethodInfo t;

	if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "callPlatformGameBBS", "(Ljava/lang/String;)V")) {
		jstring stringArg1 = t.env->NewStringUTF(url);
		t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg1);

		t.env->DeleteLocalRef(t.classID);
		t.env->DeleteLocalRef(stringArg1);
	}
}

void showWaitingViewJNI( bool show, int progress, const char* text )
{
	JniMethodInfo t;

	if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "showWaitingView", "(ZILjava/lang/String;)V")) {
		jstring stringArg = t.env->NewStringUTF(text);
		t.env->CallStaticVoidMethod(t.classID, t.methodID, show, progress, stringArg);

		t.env->DeleteLocalRef(t.classID);
		t.env->DeleteLocalRef(stringArg);
	}
}

std::string getPlatformInfoJNI()
{
	JniMethodInfo t;

	if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "getPlatformInfo", "()Ljava/lang/String;")) {
		jstring str = (jstring)t.env->CallStaticObjectMethod(t.classID, t.methodID);
		t.env->DeleteLocalRef(t.classID);

		return JniHelper::jstring2string(str);
	}

	return "AndroidPlatformInfo";
}

std::string getDeviceInfoJNI()
{
	JniMethodInfo t;

	if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "getDeviceInfo", "()Ljava/lang/String;")) {
		jstring str = (jstring)t.env->CallStaticObjectMethod(t.classID, t.methodID);
		t.env->DeleteLocalRef(t.classID);

		return JniHelper::jstring2string(str);
	}

	return "AndroidDeviceInfo";
}

std::string getDeviceIDJNI()
{
	JniMethodInfo t;

	if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "getDeviceID", "()Ljava/lang/String;")) {
		jstring str = (jstring)t.env->CallStaticObjectMethod(t.classID, t.methodID);
		t.env->DeleteLocalRef(t.classID);

		return JniHelper::jstring2string(str);
	}

	return "AndroidDeviceID";
}

std::string getClientChannelJNI()
{
	JniMethodInfo t;

	if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "getClientChannel", "()Ljava/lang/String;")) {
		jstring str = (jstring)t.env->CallStaticObjectMethod(t.classID, t.methodID);
		t.env->DeleteLocalRef(t.classID);

		return JniHelper::jstring2string(str);
	}

	return "Android";
}

int getPlatformIdJNI()
{
	JniMethodInfo t;

	if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "getPlatformId", "()I")) {
		jint ret = t.env->CallStaticIntMethod(t.classID, t.methodID);
		t.env->DeleteLocalRef(t.classID);
		return ret;
	}

	return 0;
}

 void showAnnouncement(const char* pAnnounceUrl)
 {
	 JniMethodInfo t;

	 if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "showGameAnnounce", "(Ljava/lang/String;)V")) {
		 jstring stringArg1 = t.env->NewStringUTF(pAnnounceUrl);
		
		 t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg1);

		 t.env->DeleteLocalRef(t.classID);
		 t.env->DeleteLocalRef(stringArg1);
	 }

 }

 void pushSysNotification(const char* pTitle,const char* pMessage ,int pInstantMinite )
 {
 
	 JniMethodInfo t;

	 if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "showNotification", "(Ljava/lang/String;Ljava/lang/String;I)V")) {
		 
		 jstring stringArg1 = t.env->NewStringUTF(pTitle);
		 jstring stringArg2 = t.env->NewStringUTF(pMessage);
		 		 
		 t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg1,stringArg2,pInstantMinite);

		 t.env->DeleteLocalRef(t.classID);
		 t.env->DeleteLocalRef(stringArg1);
		 t.env->DeleteLocalRef(stringArg2);
	 }


 }

 void clearSysNotification()
 {
	 JniMethodInfo t;

	 if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "clearNotification", "()V")) {
		 
		 t.env->CallStaticVoidMethod(t.classID, t.methodID);
		 
		 t.env->DeleteLocalRef(t.classID);
	 }
 }

 void notifyEnterGameJNI()
 {
	 JniMethodInfo t;

	 if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "notifyEnterGame", "()V")) {
		 
		 t.env->CallStaticVoidMethod(t.classID, t.methodID);

		 t.env->DeleteLocalRef(t.classID);
	 }

 }
//
