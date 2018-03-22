#include "CCBBehavior.h"

static CCBBehaviorManager* mPCCBBehaviorManager = NULL;
CCBBehaviorManager::CCBBehaviorManager( void )
{
	clearBehavierMap();
}

CCBBehaviorManager::~CCBBehaviorManager( void )
{
	clearBehavierMap();
}

void CCBBehaviorManager::addBehaviorHandler(const BEHAVIOR behavior,CCBBhaviorHandler* pHandler )
{
	BEHAVIORHANDLERMAP::iterator iter = mHandlerMap.find(behavior);
	if (iter == mHandlerMap.end())
	{
		mHandlerMap.insert(std::make_pair(behavior,pHandler));
	}
}
void CCBBehaviorManager::removeBehaviorHandler(CCBBhaviorHandler* pHandler)
{
	if (pHandler)
	{
		BEHAVIORHANDLERMAP::iterator iter = mHandlerMap.begin();
		for (;iter!=mHandlerMap.end();++iter)
		{
			if (iter->second == pHandler)
			{
				mHandlerMap.erase(iter);
				break;
			}
		}
	}
}
void CCBBehaviorManager::pushCCBBehavior( CCBBehavior* pBehavior )
{
	BEHAVIOR behavior = pBehavior->getBehavior();
	BEHAVIORHANDLERMAP::iterator iter = mHandlerMap.find(behavior);
	if (iter != mHandlerMap.end())
	{
		iter->second->handlerBehavior(pBehavior);
	}
}

CCBBehaviorManager* CCBBehaviorManager::sharedCCBBehaviorManager( void )
{
	if(mPCCBBehaviorManager == NULL)
	{
		mPCCBBehaviorManager = new CCBBehaviorManager();
	}
	return mPCCBBehaviorManager;
}

void CCBBehaviorManager::clearBehavierMap( void )
{
	mHandlerMap.clear();
}
