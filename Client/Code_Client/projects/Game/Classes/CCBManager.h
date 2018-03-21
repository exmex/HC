#pragma once

#include "Singleton.h"
#include <string>
#include <map>
#include <list>
#include "cocos2d.h"
#include "CCBContainer.h"

USING_NS_CC;

class CCBManager :public Singleton<CCBManager>, public CCObject
{
public:
	CCBManager();
	~CCBManager(void);

	CCBContainer* createAndLoad(const std::string & ccbfile);
	//只加载，不缓存，不retain
	CCBContainer* loadCCbi( const std::string & ccbfile );

	void purgeCachedData(void);
	void update(float dt);
	static CCBManager* getInstance();
private:

};


#define REGISTER_PAGE(_NAME_,_CLASS_) \
	_CLASS_ *__page_##_CLASS_ = _CLASS_::create(); \
	bool __ret_##_CLASS_ = CCBManager::Get()->registerPage(_NAME_,__page_##_CLASS_);

void registerScriptPage(const std::string& ccbfile);