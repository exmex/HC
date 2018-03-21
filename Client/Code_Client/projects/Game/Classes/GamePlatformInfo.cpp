#include "GamePlatformInfo.h"
#include "libPlatform.h"
#include "platform/CCPlatformConfig.h"

GamePlatformInfo * GamePlatformInfo::m_sInstance = 0;

GamePlatformInfo* GamePlatformInfo::getInstance()
{
	if(!m_sInstance)
	{
		m_sInstance = new GamePlatformInfo;
		m_sInstance->init();
	}
	return m_sInstance;
}

void GamePlatformInfo::init(bool isRegPlat)
{
#ifdef PROJECT_EXPERIENCE_IOS
		zif(isRegPlat) AUTO_REGISTER_PLATFORM(lib91);
		platVersionName="version_experience_ios.cfg";
		platFormName="lib91";
#else
#ifdef PROJECTPP
	{
		if(isRegPlat) AUTO_REGISTER_PLATFORM(libPP);
		platVersionName="version_ios_all.cfg";
		platFormName="libPP";
	}
#endif

#ifdef PROJECTUC
	{
		if(isRegPlat) AUTO_REGISTER_PLATFORM(libUC);
		platVersionName="version_ios_all.cfg";
		platFormName="libUC";
	}
#endif

#ifdef PROJECT37WANWAN
	{
		if(isRegPlat) AUTO_REGISTER_PLATFORM(lib37wanwan);
		platVersionName="version_ios_all.cfg";
		platFormName="lib37wanwan";
	}
#endif

#ifdef PROJECTAG
	{
		if(isRegPlat) AUTO_REGISTER_PLATFORM(libAG);
		platVersionName="version_ios_all.cfg";
		platFormName="libAG";
	}
#endif

#ifdef PROJECT91
	{
		if(isRegPlat) AUTO_REGISTER_PLATFORM(lib91);
		platVersionName="version_ios_all.cfg";
		platFormName="lib91";
	}
#endif

#ifdef PROJECTTB
	{
		if(isRegPlat) AUTO_REGISTER_PLATFORM(libTB);
		platVersionName="version_ios_all.cfg";
		platFormName="libTB";
	}
#endif

#ifdef PROJECTITools
	{
		if(isRegPlat) AUTO_REGISTER_PLATFORM(libITools);
		platVersionName="version_ios_all.cfg";
		platFormName="libITools";
	}
#endif

#ifdef PROJECT91Debug
	{
		if(isRegPlat) AUTO_REGISTER_PLATFORM(lib91Debug);
		platVersionName="version_debug.cfg";
		platFormName="lib91Debug";
	}
#endif

#ifdef PROJECT91Quasi
	{
		if(isRegPlat) AUTO_REGISTER_PLATFORM(lib91Quasi);
		platVersionName="version_quasi.cfg";
		platFormName="lib91Quasi";
	}
#endif

#ifdef PROJECTAPPSTORE
	{
		if(isRegPlat) AUTO_REGISTER_PLATFORM(libAppStore);
		platVersionName="version_ios_appstore.cfg";
		platFormName="libAppStore";
	}
#endif

#ifdef PROJECTAPPSTORETW
	{
		if(isRegPlat) AUTO_REGISTER_PLATFORM(libAppStore);
		platVersionName="version_ios_appstore_tw.cfg";
		platFormName="libAppStore";
	}
#endif

#ifdef PROJECTCMGE
	{
		if(isRegPlat) AUTO_REGISTER_PLATFORM(libCmge);
		platVersionName="version_ios_all.cfg";
		platFormName="libCmge";
	}
#endif

#ifdef PROJECTYOUAI
	{
		if(isRegPlat) AUTO_REGISTER_PLATFORM(libYouai);
		platVersionName="version_ios_all.cfg";
		platFormName="libYouai";
	}
#endif


#ifdef PROJECTYOUAIKY
	{
		if(isRegPlat) AUTO_REGISTER_PLATFORM(libKuaiyong);
		platVersionName="version_ios_all.cfg";
		platFormName="libKuaiyong";
	}
#endif

#ifdef PROJECTDownJoy
	{
		if(isRegPlat) AUTO_REGISTER_PLATFORM(libDownJoy);
		platVersionName="version_ios_all.cfg";
		platFormName="libDownJoy";
	}
#endif


#ifdef PROJECTAPPSTOREDEBUG
	{
		if(isRegPlat) AUTO_REGISTER_PLATFORM(libAppStore);
		platVersionName="version_ios_appstore_debug.cfg";
		platFormName="libAppStore";
	}
#endif

#ifdef PROJECT49APP
	{
		 if(isRegPlat) AUTO_REGISTER_PLATFORM(lib49app);
		 platVersionName="version_ios_all.cfg";
		 platFormName="lib49app";
	}
#endif

#ifdef WIN32
	{
		if(isRegPlat) AUTO_REGISTER_PLATFORM(lib91);
		platVersionName="version_win32.cfg";
		platFormName="lib91";
	}
#endif
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	{
		 if(isRegPlat) AUTO_REGISTER_PLATFORM(lib91);
		 platVersionName="version_android.cfg";
		 platFormName="lib91";
	}
#endif
#endif

	if(isRegPlat)
	{
		libPlatformManager::getInstance()->setPlatform(platFormName);
	}
}

void GamePlatformInfo::registerPlatform()
{
	init(true);
}