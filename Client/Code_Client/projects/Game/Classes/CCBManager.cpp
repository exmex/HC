
#include "stdafx.h"

#include "CCBManager.h"
#include "cocos2d.h"

USING_NS_CC;

#define  CHECK_TIME 15.0f

CCBManager::CCBManager()
{
	CCDirector::sharedDirector()->getScheduler()->scheduleUpdateForTarget(this,0,false);
}

CCBManager::~CCBManager(void)
{
	CCDirector::sharedDirector()->getScheduler()->unscheduleUpdateForTarget(this);
}

CCBContainer* CCBManager::loadCCbi( const std::string & ccbfile )
{
	CCBContainer * ccb = CCBContainer::create();
	ccb->loadCcbiFile(ccbfile);

	return ccb;
}





void CCBManager::update(float dt)
{

}

CCBManager* CCBManager::getInstance()
{
	return CCBManager::Get();
}








