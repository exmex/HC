#pragma once

#include <map>
#include <string>

enum BEHAVIOR
{
	INVALID,
	CCB_PLAY_SOUND,
};

class CCBBehavior
{
public:
	CCBBehavior(void){}
	~CCBBehavior(void){}
	virtual BEHAVIOR getBehavior(){return INVALID;}
};

class CCBSoundBehavior : public CCBBehavior
{
public:
	enum SOUNDSTYPE
	{
		PRESS,
		TIMELINE,
	};
	CCBSoundBehavior(BEHAVIOR behavior,std::string name,SOUNDSTYPE soundType)
	: mBehavior(behavior)
	, mMenuName(name) 
	, mSoundType(soundType)
	{}
	~CCBSoundBehavior(void){}
	virtual BEHAVIOR getBehavior(){return CCB_PLAY_SOUND;}
	const std::string &getMenuName(void){return mMenuName;}
	const SOUNDSTYPE getSoundType(void){return mSoundType;}
private:
	BEHAVIOR mBehavior;
	std::string mMenuName;
	SOUNDSTYPE		mSoundType;
};
class CCBBhaviorHandler
{
public:
	virtual void handlerBehavior(CCBBehavior* pBehavior)=0;
};

class CCBBehaviorManager
{
public:
	CCBBehaviorManager(void);
	~CCBBehaviorManager(void);

	void	addBehaviorHandler(const BEHAVIOR behavior,CCBBhaviorHandler* pHandler);
	void	removeBehaviorHandler(CCBBhaviorHandler* pHandler);
	void	pushCCBBehavior(CCBBehavior* pBehavior);

	static CCBBehaviorManager* sharedCCBBehaviorManager(void);
private:
	void	clearBehavierMap(void);
	typedef std::map<BEHAVIOR,CCBBhaviorHandler*> BEHAVIORHANDLERMAP;
	BEHAVIORHANDLERMAP mHandlerMap;
};