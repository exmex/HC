

#include <string>
#include <map>

#include <jni.h>
#include "jni/JniHelper.h"


#include "libOSHelpJni.h"

#define  CLASS_A_NAME "com/nuclear/dota/AnalyticsToolHelp"
#define  CLASS_B_NAME "com/nuclear/dota/GameActivity"

using namespace cocos2d;

void requestRestartAppJni()
{
	JniMethodInfo t;

	if (JniHelper::getStaticMethodInfo(t, CLASS_B_NAME, "requestRestart",  "()V")) {

		t.env->CallStaticVoidMethod(t.classID, t.methodID);
		t.env->DeleteLocalRef(t.classID);

	}
}

void initAnalyticsJni( const std::string& appid )
{
	JniMethodInfo t;

	if (JniHelper::getStaticMethodInfo(t, CLASS_A_NAME, "initAnalytics","(Ljava/lang/String;)V")) {

		jstring stringArg1 = t.env->NewStringUTF(appid.c_str());

		t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg1);

		t.env->DeleteLocalRef(stringArg1);
		t.env->DeleteLocalRef(t.classID);
	}
}

void initAnalyticsUserIDJni( const std::string userid )
{
	JniMethodInfo t;

	if (JniHelper::getStaticMethodInfo(t, CLASS_A_NAME, "initAnalyticsUserID","(Ljava/lang/String;)V")) {

		jstring stringArg1 = t.env->NewStringUTF(userid.c_str());

		t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg1);

		t.env->DeleteLocalRef(stringArg1);
		t.env->DeleteLocalRef(t.classID);
	}
}

void analyticsLogEventJni( const std::string& event )
{
	JniMethodInfo t;

	if (JniHelper::getStaticMethodInfo(t, CLASS_A_NAME, "analyticsLogEvent","(Ljava/lang/String;)V")) {

		jstring stringArg1 = t.env->NewStringUTF(event.c_str());

		t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg1);

		t.env->DeleteLocalRef(stringArg1);
		t.env->DeleteLocalRef(t.classID);
	}
}

void analyticsLogEventJni( const std::string& event, const std::map<std::string, std::string>& dictionary, bool timed )
{
	JniMethodInfo t;
	if (JniHelper::getStaticMethodInfo(t, CLASS_A_NAME, "clearParamsMap","()V"))
		t.env->CallStaticVoidMethod(t.classID, t.methodID);
	else
		return;
	//
	JniMethodInfo t2;
	if (JniHelper::getStaticMethodInfo(t2, CLASS_A_NAME, "addParamsMapOnePair","(Ljava/lang/String;Ljava/lang/String;)V"))
	{
		std::map<std::string, std::string>::const_iterator it = dictionary.begin();
		for (; it != dictionary.end(); ++it)
		{
			jstring stringArg1 = t2.env->NewStringUTF(it->first.c_str());
			jstring stringArg2 = t2.env->NewStringUTF(it->second.c_str());

			t2.env->CallStaticVoidMethod(t2.classID, t2.methodID, stringArg1, stringArg2);

			t2.env->DeleteLocalRef(stringArg1);
			t2.env->DeleteLocalRef(stringArg2);
		}
		t2.env->DeleteLocalRef(t2.classID);
	}
	else
		return;
	//
	JniMethodInfo t3;
	if (JniHelper::getStaticMethodInfo(t3, CLASS_A_NAME, "analyticsLogMapParamsEvent","(Ljava/lang/String;Z)V"))
	{
		jstring stringArg1 = t3.env->NewStringUTF(event.c_str());

		t3.env->CallStaticVoidMethod(t3.classID, t3.methodID, stringArg1, timed);

		t3.env->DeleteLocalRef(stringArg1);
		t3.env->DeleteLocalRef(t3.classID);
	}
}

void analyticsLogEndTimeEventJni( const std::string& event )
{
	JniMethodInfo t3;
	if (JniHelper::getStaticMethodInfo(t3, CLASS_A_NAME, "analyticsLogEndTimeEvent","(Ljava/lang/String;)V"))
	{
		jstring stringArg1 = t3.env->NewStringUTF(event.c_str());

		t3.env->CallStaticVoidMethod(t3.classID, t3.methodID, stringArg1);

		t3.env->DeleteLocalRef(stringArg1);
		t3.env->DeleteLocalRef(t3.classID);
	}
}

void weChatOpenJni()
{
	JniMethodInfo t;

	if (JniHelper::getStaticMethodInfo(t, CLASS_B_NAME, "openWeChat",  "()V")) {

		t.env->CallStaticVoidMethod(t.classID, t.methodID);
		t.env->DeleteLocalRef(t.classID);

	}
}
void weChatShareFriendsJni(const std::string& shareContent)
{
	JniMethodInfo t;

	  if (JniHelper::getStaticMethodInfo(t, CLASS_B_NAME, "shareToFriends",  "(Ljava/lang/String;)V")) {
		jstring stringArg1 = t.env->NewStringUTF(shareContent.c_str());
		t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg1);
		t.env->DeleteLocalRef(t.classID);

	}
}
void weChatShareFriendsJni(const std::string& shareImgPath,const std::string& shareContent)
{
	JniMethodInfo t;

	  if (JniHelper::getStaticMethodInfo(t, CLASS_B_NAME, "shareToFriends",  "(Ljava/lang/String;Ljava/lang/String;)V")) {
		jstring stringArg1 = t.env->NewStringUTF(shareImgPath.c_str());
		jstring stringArg2 = t.env->NewStringUTF(shareContent.c_str());
		t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg1,stringArg2);
		t.env->DeleteLocalRef(t.classID);

	}
}

void weChatSharePersonJni(const std::string& shareContent)
{
	JniMethodInfo t;

	  if (JniHelper::getStaticMethodInfo(t, CLASS_B_NAME, "shareToPerson",  "(Ljava/lang/String;)V")) {
		jstring stringArg1 = t.env->NewStringUTF(shareContent.c_str());
		t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg1);
		t.env->DeleteLocalRef(t.classID);

	}
}
	
void weChatSharePersonJni(const std::string& shareImgPath,const std::string& shareContent)
{
	JniMethodInfo t;

	  if (JniHelper::getStaticMethodInfo(t, CLASS_B_NAME, "shareToPerson",  "(Ljava/lang/String;Ljava/lang/String;)V")) {
		jstring stringArg1 = t.env->NewStringUTF(shareImgPath.c_str());
		jstring stringArg2 = t.env->NewStringUTF(shareContent.c_str());
		t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg1,stringArg2);
		t.env->DeleteLocalRef(t.classID);

	}
}

void fbAttentionJni()
{
    JniMethodInfo t;
	if (JniHelper::getMethodInfo(t, CLASS_B_NAME, "fbAttention",  "()V")) {
		t.env->CallStaticVoidMethod(t.classID, t.methodID);
		t.env->DeleteLocalRef(t.classID);
    }
}

void playMovieJni(const std::string filename, int needSkip /*= true*/)
{
	JniMethodInfo t;

	if (JniHelper::getStaticMethodInfo(t, CLASS_B_NAME, "playMovie","(Ljava/lang/String;I)V")) 
	{
		jstring stringArg1 = t.env->NewStringUTF(filename.c_str());
		t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg1,needSkip);
		t.env->DeleteLocalRef(t.classID);

	}
}

void stopMovieJni()
{
	JniMethodInfo t;

	if (JniHelper::getStaticMethodInfo(t, CLASS_B_NAME, "stopMovie",  "()V")) {
		t.env->CallStaticVoidMethod(t.classID, t.methodID);
		t.env->DeleteLocalRef(t.classID);

	}
}

int getSecondsFromGMTJni()
{
	JniMethodInfo t;
	jint value=0;
	if (JniHelper::getStaticMethodInfo(t, CLASS_B_NAME, "getSecondsFromGMT",  "()I")) {
		value=t.env->CallStaticIntMethod(t.classID, t.methodID);
		t.env->DeleteLocalRef(t.classID);
	}
	return value;
}

