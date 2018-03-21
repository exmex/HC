#pragma once

#include "CocoStudio/Armature/CCArmature.h"

USING_NS_CC;
USING_NS_CC_EXT;

class ArmatureEventListener
{
public:
	virtual void onArmatureAnimationDone(const char* animationName, bool isLoop){};
	virtual void onFrameEvent(std::string eventName, CCBone* bone) {};
};

class ArmatureContainer
	: public CCArmature
{
public:
	ArmatureContainer();
	~ArmatureContainer();
	
	static ArmatureContainer* create(const char* path, const char* name, CCNode* parent = NULL);
	bool setAction(const char  * name, bool bRemoveQueue=true);
	void setNextAction(const char* actionName);
	void runAnimation(const char* name, unsigned int loopTimes = 1);
	void changeSkin(CCBone* bone, CCNode* node, bool force = true);
	void changeSkin(const char* boneName, const char* skinName, bool force = true);
	void changeSkin(const char* boneName, CCLabelTTF* label, bool force = true);
	void changeSkin(const char* boneName, CCParticleSystem* particle, bool force = true);
	void setListener(ArmatureEventListener* eventListener);
	void registerLuaListener(int listener);
	void unregisterLuaListener();
	virtual void setColor(const ccColor3B& color);
	void tint(float r, float g, float b);
	void setResourcePath(const char* resourcePath);
	std::string getResourcePath() { return m_pResourcePath; };
	static void clearResource(std::string resourcePath);
	void setLoop(bool val) { m_bIsLoop = val; };
	virtual void update(float dt,bool value=false);

	int addEffect(const char* resName);
	int addEffect(const char* resName, CCAffineTransform  const& mat, int zorder);
	int addEffect(const char* resName, CCPoint pos, int zorder);
	int addEffect(const char *name, int zorder);
	void removeEffectWithID(int eid);
	void removeEffectWithName(const char  * effectName);

	void useDefaultShader(void);
	void useShader(const char* shaderName);
	void setActionElapsed(float elapsed);
	void setActionSpeeder(float speeder);

private:
	void _registerListener();
	void onReceiveMovementEvent(CCArmature* armature, MovementEventType eventType, const char* animationName);
	void onReceiveFrameEvent(CCBone* bone, const char* eventName, int originalIndex, int currentIndex);

	ArmatureEventListener* m_pEventListener;
	CCArray				*_actionQueue;
	int m_iLuaListener;
	std::string m_pResourcePath;
	unsigned int m_iRemainLoopTimes;
	std::string			m_sCurrAniName;
	bool m_bIsLoop;
	CCArray				*_effectArray;
	int					m_iCurrEffectTag;
};

