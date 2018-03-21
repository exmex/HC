#ifndef _H_PAYFORPLATFORM_H_
#define _H_PAYFORPLATFORM_H_
#include "cocos2d.h"
#include "libOS.h"
#include "apiforlua.h"
#include "Singleton.h"
#include "libPlatform.h"
USING_NS_CC;
class PayForPlatform :public CCObject, public platformListener, public Singleton<PayForPlatform>
{
public:
	PayForPlatform();
	void doUpdate(float dt);
	virtual void onBuyinfoSent(libPlatform*, bool success, const BUYINFO&, const std::string& log);
	bool mIsPayed;
	bool mLogined;
	bool init();
	virtual void onLogin(libPlatform*, bool success, const std::string& log);
};
#endif //_H_PAYFORPLATFORM_H_