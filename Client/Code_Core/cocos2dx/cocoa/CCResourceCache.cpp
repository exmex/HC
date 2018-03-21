#include "CCDictionary.h"
#include "CCResourceCache.h"
#include "CCResourceObject.h"
#include <list>

NS_CC_BEGIN


CCResourceCache::CCResourceCache()
: CCDictionary() ,
m_dGcTime(0)
{
}

CCResourceCache::CCResourceCache(double fTime)
: CCDictionary(),
m_dGcTime(fTime)
{
}


CCResourceCache::~CCResourceCache()
{
}

void CCResourceCache::gc(double passTime, unsigned int type)
{
	CCDictElement* pElement = NULL;
	if (this->count() > 0)
	{
		// find elements to be removed
		CCDictElement* pElement = NULL;
		std::list<CCDictElement*> elementToRemove;

		CCDICT_FOREACH(this, pElement)
		{
			CCResourceObject *pObject = (CCResourceObject*)pElement->getObject();
			pObject->updateLastDrawTime(passTime);

			if (pObject->getLastDrawTime() > m_dGcTime)
			{
				elementToRemove.push_back(pElement); 
				//delete pObject;
			}
		}
		// remove elements
		for (std::list<CCDictElement*>::iterator iter = elementToRemove.begin(); iter != elementToRemove.end(); ++iter)
		{
#if WIN32
			//CCLog("cocos2d: CCResourceCache: gc unused resource: %d - (%d)%s", type, (*iter)->getObject()->m_uID, (*iter)->getStrKey());
#endif
			this->removeObjectForElememt(*iter);
		}
	}
}
void CCResourceCache::setGCTime(double time)
{
	m_dGcTime = time;
}

NS_CC_END