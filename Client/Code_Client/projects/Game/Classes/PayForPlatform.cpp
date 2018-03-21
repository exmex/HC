#include "PayForPlatform.h"
PayForPlatform::PayForPlatform()
{
	
}
bool PayForPlatform::init()
{
	mIsPayed = false;
	mLogined = false;
	libPlatformManager::getPlatform()->registerListener(this);
	CCDirector::sharedDirector()->getScheduler()->scheduleSelector(schedule_selector(PayForPlatform::doUpdate), this, 0.3f, false);
	return true;
}
void PayForPlatform::doUpdate(float dt)
{
	if (mIsPayed)
	{
		mIsPayed = false;
		OnPayResult();
	}
	if (mLogined)
	{
		mLogined = false;
		setUserID(1, "", "", "", "", "", "");
	}
}
void PayForPlatform::onBuyinfoSent(libPlatform*, bool success, const BUYINFO&, const std::string& log)
{
	mIsPayed = true;
}
void PayForPlatform::onLogin(libPlatform *lib, bool success, const std::string& log)
{
	//平台登录回来
	if (success)
	{
		std::string uin = lib->loginUin();
		libOS::getInstance()->initUserID(uin);

		std::string sPuidKey = "LastLoginPUID";
		std::string sLoginName = libPlatformManager::getPlatform()->loginUin();

		if (sLoginName.length() > 0)
		{
			cocos2d::CCUserDefault::sharedUserDefault()->setStringForKey(sPuidKey.c_str(), sLoginName);
		}
		mLogined = true;
	}
}