#include "CCStdC.h"
#include "cocos2d.h"
#include "jni/JniHelper.h"

#include "GateKeeper.h"
#include "CCLuaJava.h"
#include "apiforlua.h"

USING_NS_CC;
extern "C" void Java_org_cocos2dx_lib_LoginJNI_deviceLoginSuccess(JNIEnv * env,
		jobject thiz, jstring status, jstring session, jstring uin,
		jstring userId, jstring serverId, jstring serverIP, jstring serverPort) {

	std::string loginStatus = JniHelper::jstring2string(status);
	std::string loginSession = JniHelper::jstring2string(session);
	std::string loginUin = JniHelper::jstring2string(uin);
	std::string loginuserId = JniHelper::jstring2string(userId);
	std::string loginServerId = JniHelper::jstring2string(serverId);
	std::string loginServerIP = JniHelper::jstring2string(serverIP);
	std::string loginServerPort = JniHelper::jstring2string(serverPort);

	CCLog(
			"Java Device Login Response: status->%s, session->%s, uin->%s, userId->%s, serverId->%s, serverIP->%s, serverPort->%s",
			loginStatus.c_str(), loginSession.c_str(), loginUin.c_str(),
			loginuserId.c_str(), loginServerId.c_str(), loginServerIP.c_str(),
			loginServerPort.c_str());

	int isOk = 0;

	// see LoginDataStorage.java
	if ("1" == loginStatus || "2" == loginStatus ) {
		// network problems
//		return;
	} else if ("5" == loginStatus) {
		isOk = 1;
	}

	CCLog("isOk is : %d", isOk);
	setUserID(isOk, loginSession.c_str(), loginUin.c_str(), loginuserId.c_str(),
			loginServerId.c_str(), loginServerIP.c_str(),
			loginServerPort.c_str());
}

/**
 * google play connect state need update button state
 */
extern "C" void Java_org_cocos2dx_lib_LoginJNI_googlePlayLoginSuccess(
		JNIEnv * env, jobject thiz, jstring linkStatus) {

	std::string loginLinkStatus = JniHelper::jstring2string(linkStatus);
	CCLog("Java Google Play Login Response: %s ", loginLinkStatus.c_str());

	doGoogleConnectResponse(loginLinkStatus.c_str());
}

extern "C" void Java_org_cocos2dx_lib_LoginJNI_restartGame(
		JNIEnv * env, jobject thiz) {

	CCLog("Google Play Restart Game");
	restartGame();
}

void callJni(const char * funcName, const char * data) {
	JniMethodInfo minfo;
	const char * jniClass = "org/cocos2dx/lib/LoginJNI";/*类的路径*/
	bool isHave = JniHelper::getStaticMethodInfo(minfo, jniClass, funcName,
			"(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");/*函数类型简写*/

	jobject activityObj;
	if (isHave) {
		CCLog("jni->%s.%s exists", jniClass, funcName);
		jstring jdata1 = minfo.env->NewStringUTF(GK_DEVICE_LOGIN_URL);
		jstring jdata2 = minfo.env->NewStringUTF(GK_GAMECENTER_LOGIN_CHECK);
		jstring jdata3 = minfo.env->NewStringUTF(GK_GAMECENTER_BING_NEW);

		minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID, jdata1,
				jdata2, jdata3);

		minfo.env->DeleteLocalRef(jdata1);
		minfo.env->DeleteLocalRef(jdata2);
		minfo.env->DeleteLocalRef(jdata3);
		minfo.env->DeleteLocalRef(minfo.classID);
	} else {
		CCLog("jni->%s.%s not exists", jniClass, funcName);
	}
}

// -- device login
void androidDoLogin() {
	std::string loginUrl= GK_DEVICE_LOGIN_URL;
	loginUrl+=CCUserDefault::sharedUserDefault()->getStringForKey("current-version");

	callJni("onDologin", loginUrl.c_str());
}

// -- called when google connect button clicked
void androidDoGooglePlayLogin() {
	callJni("onDoGooglePlayLogin", "");
}

// -- when enter game call this to initialize google play service
void initGooglePlay() {
	callJni("onDoInitGooglePlay", "");
}
