


#include "..\include\lib91.h"
#include <string.h>
#include <time.h>
//
#include <sys/statfs.h>//for statfs
#include <sys/sysinfo.h>//for sysinfo
#include <unistd.h>//for rmdir
//
#include "jni/Java_org_cocos2dx_lib_Cocos2dxHelper.h"
#include "jni.h"
#include <android/log.h>
//
#include "libPlatformHelpJni.h"
//
#define  LOG_TAG    "lib91.cpp"
#define  LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG,LOG_TAG,__VA_ARGS__)
//

unsigned int timeGetTime()  
{  
	unsigned int uptime = 0;  
	struct timespec on;  
	if(clock_gettime(CLOCK_MONOTONIC, &on) == 0)  
		uptime = on.tv_sec*1000 + on.tv_nsec/1000000;  
	return uptime;  
}  

typedef unsigned long DWORD;
typedef wchar_t TCHAR;

//lib91* lib91::m_sInstance = 0;
bool lib91_mLogined = false;
DWORD lib91_mLoginTime = 0;

int enc_unicode_to_utf8_one(wchar_t unic, std::string& outstr)  
{  

	if ( unic <= 0x0000007F )  
	{  
		// * U-00000000 - U-0000007F:  0xxxxxxx  
		outstr.push_back(unic & 0x7F);  
		return 1;  
	}  
	else if ( unic >= 0x00000080 && unic <= 0x000007FF )  
	{  
		// * U-00000080 - U-000007FF:  110xxxxx 10xxxxxx  
		outstr.push_back(((unic >> 6) & 0x1F) | 0xC0); 
		outstr.push_back((unic & 0x3F) | 0x80);  
		return 2;  
	}  
	else if ( unic >= 0x00000800 && unic <= 0x0000FFFF )  
	{  
		// * U-00000800 - U-0000FFFF:  1110xxxx 10xxxxxx 10xxxxxx  
		outstr.push_back( ((unic >> 12) & 0x0F) | 0xE0);  
		outstr.push_back(((unic >>  6) & 0x3F) | 0x80);  
		outstr.push_back( (unic & 0x3F) | 0x80);  
		return 3;  
	}  
	else if ( unic >= 0x00010000 && unic <= 0x001FFFFF )  
	{  
		// * U-00010000 - U-001FFFFF:  11110xxx 10xxxxxx 10xxxxxx 10xxxxxx  
		outstr.push_back( ((unic >> 18) & 0x07) | 0xF0); 
		outstr.push_back( ((unic >> 12) & 0x3F) | 0x80);
		outstr.push_back( ((unic >>  6) & 0x3F) | 0x80);
		outstr.push_back( (unic & 0x3F) | 0x80);
		return 4;  
	}  
	else if ( unic >= 0x00200000 && unic <= 0x03FFFFFF )  
	{  
		// * U-00200000 - U-03FFFFFF:  111110xx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx  

		outstr.push_back( ((unic >> 24) & 0x03) | 0xF8); 
		outstr.push_back( ((unic >> 18) & 0x3F) | 0x80);
		outstr.push_back( ((unic >> 12) & 0x3F) | 0x80);
		outstr.push_back( ((unic >>  6) & 0x3F) | 0x80);  
		outstr.push_back( (unic & 0x3F) | 0x80);  
		return 5;  
	}  
	else if ( unic >= 0x04000000 && unic <= 0x7FFFFFFF )  
	{  
		// * U-04000000 - U-7FFFFFFF:  1111110x 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx  
		outstr.push_back( ((unic >> 30) & 0x01) | 0xFC);
		outstr.push_back( ((unic >> 24) & 0x3F) | 0x80); 
		outstr.push_back( ((unic >> 18) & 0x3F) | 0x80);
		outstr.push_back( ((unic >> 12) & 0x3F) | 0x80);  
		outstr.push_back( ((unic >>  6) & 0x3F) | 0x80);  
		outstr.push_back( (unic & 0x3F) | 0x80); 
		return 6;  
	}  

	return 0;  
}  

void lib91::init(bool privateLogin/* = false*/)
{
	lib91_mLogined = false;
	//
	//平台支持的游戏版本更新已经在前面检查了，可以同步等其结果回来再发起内更新检测，或异步
}

void lib91::updateApp()
{

}

static std::string loginName = "";
static std::string sessionId = "";
static std::string userNickName = "";

void lib91::login()
{
	//
	lib91_mLoginTime = timeGetTime();
	if(loginName == "")
	{
		//

		//
		//_boardcastLoginResult(true,"");
	}
	callPlatformLoginJNI();//call java
	//
}

void lib91::logout()
{
	callPlatformLogoutJNI();
}

void lib91::final()
{

}

bool lib91::getLogined()
{
	if(lib91_mLoginTime > 0 && (timeGetTime()-lib91_mLoginTime) > 5000)
	{
		//lib91_mLogined = true;
		//
	}
	lib91_mLogined = getPlatformLoginStatusJNI();
	return lib91_mLogined;
}

const std::string& lib91::loginUin()
{
	loginName = getPlatformLoginUinJNI();
	return loginName;
}

const std::string& lib91::sessionID()
{
	sessionId = getPlatformLoginSessionIdJNI();
	return sessionId;
}

const std::string& lib91::nickName()
{
	userNickName = getPlatformUserNickNameJNI();
	return userNickName;
}

void lib91::switchUsers()
{
	//不提供切换平台账号
	//不提供应用内注销
	//平台账号管理页面的注销：
	//1、用户还未携账号进入游戏，允许注销重返平台账号登录界面
	//2、用户已进入游戏，此时注销直接退出游戏，要求用户手动重启
	/*loginName="";
	sessionId="";
	userNickName="";
	lib91_mLogined = false;
	*/
	//已登录情况下调出账号管理界面，未登录情况下调出登录界面
	callPlatformAccountManageJNI();
}


void lib91::buyGoods( BUYINFO& info)
{
	//BUYINFO的productCount是总价：单价*个数
	//这个数值还有除以91豆兑换我们钻石的比例1:10
	int iCount = 1;//info.productCount / (int)info.productPrice / 10;
	//LOGD("lib91::buyGoods %s,%s,%s,%f,%f,%d,%s", info.cooOrderSerial.c_str(), info.productId.c_str(),
	//	info.productName.c_str(), info.productPrice, info.productOrignalPrice,
	//	iCount, info.description.c_str());

	callPlatformPayRechargeJNI(info.cooOrderSerial.c_str(), info.productId.c_str(),
		info.productName.c_str(), info.productPrice, info.productOrignalPrice, 
		iCount, info.description.c_str());
	//
	//_boardcastBuyinfoSent(true, info, "success");
}

void lib91::openBBS()
{
	callPlatformGameBBSJNI("");
}

void lib91::userFeedBack()
{
	callPlatformFeedbackJNI();
}

void lib91::gamePause()
{

}

void lib91::_enableLogin()
{

}

const std::string lib91::getClientChannel()
{
	return getClientChannelJNI();
}

const unsigned int lib91::getPlatformId()
{
	return getPlatformIdJNI();
}

std::string lib91::getPlatformMoneyName()
{
	return "";
}

void lib91::notifyEnterGame()
{
	notifyEnterGameJNI();
}

void lib91::setToolBarVisible(bool isShow)
{
	callPlatToolsJni(isShow);
}

bool lib91::getIsTryUser()
{
	return isTryUserJni();
}

void lib91::callPlatformBindUser()
{
	callPlatformBindUserJni();
}

void lib91::notifyGameSvrBindTryUserToOkUserResult( int result )
{
	notifyGameSvrBindTryUserToOkUserResultJni(result);
}
