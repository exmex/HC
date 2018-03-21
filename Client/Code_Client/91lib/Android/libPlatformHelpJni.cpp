

#include <string>
#include <map>

#include <jni.h>
#include "jni/JniHelper.h"
#include "libPlatform.h"
#include "platform/CCCommon.h"

#include "libPlatformHelpJni.h"

#define  CLASS_B_NAME "com/nuclear/dota/GameActivity"

using namespace cocos2d;

extern "C" {

	JNIEXPORT void JNICALL Java_com_nuclear_dota_GameActivity_nativeRequestGameSvrBindTryToOkUser(JNIEnv* env, jobject thiz, jstring tryUin, jstring okUin) {
		
		std::string tryUser = JniHelper::jstring2string(tryUin);
		std::string okUser = JniHelper::jstring2string(okUin);
		
		libPlatformManager::getPlatform()->_boardcastRequestBindTryUserToOkUser(tryUser.c_str(), okUser.c_str());

	}


  JNIEXPORT void JNICALL Java_com_nuclear_dota_GameActivity_nativeNotifyTryUserRegistSuccess() {
    
    libPlatformManager::getPlatform()->_boardcastOnTryUserRegistSuccess();
    
  }

  JNIEXPORT void JNICALL Java_com_nuclear_dota_GameActivity_nativeOnPlayMovieEnd() {

	  libPlatformManager::getPlatform()->_boardcastOnPlayMovieEnd();

  }
  
  JNIEXPORT void JNICALL Java_com_nuclear_dota_GameActivity_nativeOnShareEngineMessage(JNIEnv* env,jobject thiz ,bool _result,jstring _resultStr) {
	//int length = env->GetStringLength(_resultStr);
    std::string resultStr = JniHelper::jstring2string(_resultStr);
	//CCLog("GameActivity_nativeOnShareEngineMessage=====¡·%d======¡·%s======",int(_result),resultStr.c_str());
    libPlatformManager::getPlatform()->_boardcastOnShareEngineMessage(_result,resultStr.c_str());
    
  }
  
  JNIEXPORT void JNICALL Java_com_nuclear_dota_GameActivity_nativeOnMotionShake() {
    
    libPlatformManager::getPlatform()->_boardcastOnMotionShake();
    
  }
}

bool isTryUserJni()
{
	JniMethodInfo t;

	if (JniHelper::getStaticMethodInfo(t, CLASS_B_NAME, "isPlatformTryUser",  "()Z")) {

		jboolean ret = t.env->CallStaticBooleanMethod(t.classID, t.methodID);
		t.env->DeleteLocalRef(t.classID);

		return ret;
	}

	return false;
}

void notifyGameSvrBindTryUserToOkUserResultJni( int result )
{
	JniMethodInfo t;

	if (JniHelper::getStaticMethodInfo(t, CLASS_B_NAME, "receiveGameSvrBindTryToOkUserResult","(I)V")) {

		t.env->CallStaticVoidMethod(t.classID, t.methodID, result);

		t.env->DeleteLocalRef(t.classID);
	}
}

void callPlatformBindUserJni()
{
	JniMethodInfo t;

	if (JniHelper::getStaticMethodInfo(t, CLASS_B_NAME, "callPlatformBindUser",  "()V")) {

		t.env->CallStaticVoidMethod(t.classID, t.methodID);
		t.env->DeleteLocalRef(t.classID);
	}
}

extern void callPlatToolsJni( bool visible )
{
	JniMethodInfo t;
	if(JniHelper::getStaticMethodInfo(t, CLASS_B_NAME, "callToolBar",  "(Z)V")){
		t.env->CallStaticVoidMethod(t.classID, t.methodID, visible);
		t.env->DeleteLocalRef(t.classID);
	}
}
