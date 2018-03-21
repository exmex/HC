#include "libPlatform.h"
#include "libOS.h"
#include <assert.h>
#include <string>

#if !defined(WIN32) && !defined(ANDROID)
#include <sys/sysctl.h>
#include <mach/mach.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#endif

libPlatformManager * libPlatformManager::m_sInstance = 0;

libPlatformManager* libPlatformManager::getInstance()
{
    //add by dylan for weixin share AppController Override handle callback by 20140125, bad implement!
//    libOS::getInstance()->setShareWeChatCallBackDisabled();
	if(!m_sInstance)m_sInstance = new libPlatformManager;
	return m_sInstance;
}


void libPlatformManager::setPlatform( std::string name )
{
	if (mPlatforms.find(name) != mPlatforms.end())
	{
		m_sPlatform = mPlatforms.find(name)->second;
	}
}

bool libPlatformManager::registerPlatform( std::string name, libPlatform* platform )
{
	if (mPlatforms.find(name) == mPlatforms.end())
	{
		mPlatforms.insert(std::make_pair(name, platform));
	}
	return true;
}

void libPlatform::logout()
{

}

void libPlatform::final()
{

}

void libPlatform::switchUsers()
{

}

void libPlatform::buyGoods( BUYINFO& )
{

}

void libPlatform::openBBS()
{

}

void libPlatform::userFeedBack()
{

}

void libPlatform::gamePause()
{

}


const std::string libPlatform::getPlatformInfo()
{
	return libOS::getInstance()->getPlatformInfo() + "#" + getClientChannel();
}

const std::string& libPlatform::sessionID()
{
	static std::string ret = "";
	return ret;
}

const std::string& libPlatform::nickName()
{
	static std::string ret = "";
	return ret;
}

const unsigned int libPlatform::getPlatformId()
{
	return 0u;
}

bool libPlatform::getIsTryUser()
{
	return false;
}

void libPlatform::callPlatformBindUser()
{

}

void libPlatform::notifyGameSvrBindTryUserToOkUserResult( int result )
{

}

void libPlatform::notifyEnterGame()
{

}

const float libPlatform::getPlatformChangeRate()
{
	return 1.0f;
}

void libPlatform::setToolBarVisible( bool isShow )
{

}
void libPlatform::onShareEngineMessage(bool _result,std::string _resultStr)
{
	 libOS::getInstance()->boardcastMessageShareEngine(_result,_resultStr.c_str());
}
void libPlatform::onPlayMovieEnd()
{
	 libOS::getInstance()->boardcastMessageOnPlayEnd();
}
void libPlatform::onMotionShake()
{
	libOS::getInstance()->boardcastMotionShakeMessage();
}

