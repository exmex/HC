#pragma once

#include "cocos2d.h"
#include "cocos-ext.h"
#include <spine/spine-cocos2dx.h>
#include <string>
#include <map>
#include "GameAnimation.h"

using namespace spine;
USING_NS_CC;
USING_NS_CC_EXT;

class SpineEventListener
{
public:
	virtual void onSpineAnimationStart(int trackIndex,const char* animationName){};
	virtual void onSpineAnimationEnd(int trackIndex,const char* animationName){};
	virtual void onSpineAnimationComplete(int trackIndex,const char* animationName,int loopCount){};
	virtual void onSpineAnimationEvent(int trackIndex,const char* animationName,spEvent* event) {};
};

class SpineContainer: public SkeletonAnimation, public GameAnimation
{
public:
	SpineContainer(const char* skeletonDataFile, const char* atlasFile, float scale = 1.0f)
		: SkeletonAnimation(skeletonDataFile, atlasFile, scale)
		, GameAnimation(Type_Spine)
		, m_pEventListener(NULL)
		, m_iLuaListener(0)
		, m_bIsLoop(false)
		, m_sCurrAniName("")
		, m_iCurrEffectTag(0)
	{
		m_mapTrack.clear();
		_actionQueue = CCArray::create();
		_actionQueue->retain();
		_effectArray = CCArray::create();
		_effectArray->retain();
	};
	~SpineContainer()
	{
		m_mapTrack.clear();
		CC_SAFE_RELEASE(_actionQueue);
		CC_SAFE_RELEASE(_effectArray);
	};

	static SpineContainer* create(const char* path, const char* name, float scale = 1.0f);
	void runAnimation(int trackIndex,const char* name, int loopTimes=1,float delay=0);

	void setListener(SpineEventListener* eventListener);
	void registerLuaListener(int listener);
	void unregisterLuaListener();

	void stopAllAnimations();

	void stopAnimationByIndex(int trackIndex);

	bool setAction(const char  * name, bool bRemoveQueue);

	int addEffect(const char* resName);
	int addEffect(const char* resName, CCAffineTransform  const& mat, int zorder);
	int addEffect(const char* resName, CCPoint pos, int zorder);
	int addEffect(const char *name, int zorder);
	void clearActionSequence(void);
	void interruptSound(void);
	void onActionFinished(void);
	void removeEffectWithID(int eid);
	void removeEffectWithName(const char  * effectName);
	void setColor(_ccColor3B clr);

	bool setComponent(const char* param1, const char* param2) { return true; };
	bool setComponent(int index, const char* lpszName) { return true; };
	void setNextAction(const char* actionName);
	void setOpacity(unsigned char param1);
	void tint(float r, float g, float b);
	void update(float dt, bool isAuto = true);
	void useDefaultShader(void);
	void useShader(const char* shaderName);
	void setActionElapsed(float elapsed) {};
	void setActionSpeeder(float speeder) {};
	void setLoop(bool val) { m_bIsLoop = val; };

protected:
	struct SAnimationInfo
	{
		const char*		aniName;
		unsigned int	trackIndex;
		int				loopTimes;

		SAnimationInfo(const char* name, unsigned int index, int times)
			: aniName(name)
			, trackIndex(index)
			, loopTimes(times)
		{};
	};

	void onReceiveStartEventListener(int trackIndex,const char* animationName);
	void onReceiveEndEventListener(int trackIndex,const char* animationName);
	void onReceiveCompleteEventListener(int trackIndex,const char* animationName, int loopCount);
	void onReceiveEventListener(int trackIndex,const char* animationName,spEvent* event);

	typedef std::map<const char*, SAnimationInfo> AnimationTrackMap;
	void onAnimationStateEvent (int trackIndex, const char* animationName,spEventType type, spEvent* event, int loopCount);
	SAnimationInfo* getAnimationInfo(unsigned int trackIndex)
	{
		AnimationTrackMap::iterator it = m_mapTrack.begin(), itEnd = m_mapTrack.end();
		while ( it != itEnd )
		{
			if ( it->second.trackIndex == trackIndex )
			{
				return &(it->second);
			}
			++it;
		}
		return NULL;
	};

	SpineEventListener* m_pEventListener;
	int m_iLuaListener;

	AnimationTrackMap	m_mapTrack; 
    CCArray				*_effectArray;
    CCArray				*_actionQueue;
    bool				m_bIsLoop;
	std::string			m_sCurrAniName;
    int					_curSoundId;
	bool				_isSoundPlay;
    int					m_iCurrEffectTag;
};

