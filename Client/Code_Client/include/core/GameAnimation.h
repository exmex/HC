#pragma once

#include "cocos2d.h"
USING_NS_CC;

enum AnimationTye
{
	Type_LegendAnimation,
	Type_Spine,
	Type_DragonBone
};

class GameAnimation
{
public:
	GameAnimation(AnimationTye aniType = Type_LegendAnimation);
	virtual ~GameAnimation();

	static GameAnimation* create(const char* resource, double scale = 1.0, AnimationTye aniType = Type_LegendAnimation);
	/*
	virtual int addEffect(const char* resName) { return 0; };
	virtual int addEffect(const char* resName, CCAffineTransform  const& mat, int zorder) { return 0; };
	virtual int addEffect(const char* resName, CCPoint pos, int zorder) { return 0; };
	virtual int addEffect(const char *name, int zorder) { return 0; };
	virtual void addToActionSequence(const char* actionName) {};
	virtual void clearActionSequence(void) {};
	virtual CCArray * getActionSequence(void) { return NULL; };
	virtual void interruptSound(void) {};
	virtual void onActionFinished(void) {};
	virtual void removeEffectWithID(int eid) {};
	virtual void removeEffectWithName(const char  * effectName) {};
	virtual bool setAction(const char  * name, bool bRemoveQueue) = 0;
	virtual void setColor(_ccColor3B clr) {};

	virtual bool setComponent(const char* param1, const char* param2) { return true; };
	virtual bool setComponent(int index, const char* lpszName) { return true; };
	virtual void setNextAction(const char* actionName) {};
	virtual void setOpacity(unsigned char param1) {};
	virtual void tint(float r, float g, float b) {};
	virtual void update(float dt) {};
	virtual void useDefaultShader(void) {};
	virtual void useShader(const char* shaderName) {};
	virtual void setActionElapsed(float elapsed) {};
	virtual void setActionSpeeder(float speeder) {};
	virtual void setLoop(bool val) {};
	*/
	AnimationTye mAniType;
};

