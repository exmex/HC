#include "ArmatureContainer.h"
#include "CocoStudio/Armature/utils/CCArmatureDataManager.h"
#include "CocoStudio/Armature/display/CCSkin.h"
#include "CCLuaEngine.h"
#include "LegendAminationEffect.h"
USING_NS_CC;
USING_NS_CC_EXT;

ArmatureContainer::ArmatureContainer()
	: CCArmature()
	, m_pEventListener(NULL)
	, m_iLuaListener(0)
	, m_pResourcePath("")
	, m_iRemainLoopTimes(0)
	, m_sCurrAniName("")
	, m_bIsLoop(false)
	, m_iCurrEffectTag(0)
{
	_actionQueue = CCArray::create();
	_actionQueue->retain();
	_effectArray = CCArray::create();
	_effectArray->retain();
}

void ArmatureContainer::update(float dt, bool value)
{
	CCArmature::update(dt);
	int kk = 0;
	for (kk = this->_effectArray->count() - 1; kk >= 0; kk--)
	{

		LegendAminationEffect *pactor = (LegendAminationEffect *)this->_effectArray->objectAtIndex((unsigned int)kk);
		pactor->update(dt);
		if (pactor->isTerminated())
		{
			this->_effectArray->removeObjectAtIndex((unsigned int)kk, true);
			this->removeChild(pactor, true);
		}
	}
}

void ArmatureContainer::setColor(const ccColor3B& color)
{
	CCArmature::setColor(color);
	CCObject *spr = NULL;
	CCARRAY_FOREACH(this->_effectArray, spr)
	{
		((CCSprite*)spr)->setColor(color);
	}
}

void ArmatureContainer::tint(float r, float g, float b)
{
	setColor(ccc3(r,g,b));
}

bool ArmatureContainer::setAction(const char  * name, bool bRemoveQueue)
{
	if (name == 0)
	{
		return true;
	}
	runAnimation(name);
	//CCAssert(name != 0, "name can't be null");
	
	m_bIsLoop = false;
	if (bRemoveQueue)
	{
		_actionQueue->removeAllObjects();
	}
	return true;
}

ArmatureContainer::~ArmatureContainer()
{
	CC_SAFE_RELEASE_NULL(_actionQueue);
	CC_SAFE_RELEASE_NULL(_effectArray);
}

ArmatureContainer* ArmatureContainer::create(const char* path, const char* name, CCNode* parent /* = NULL */)
{
	CC_RETURN_VAL_IF(!path || !name, NULL)
	ArmatureContainer* armatureContainer = new ArmatureContainer();
	if ( armatureContainer )
	{
		const char* filePath	= CCString::createWithFormat("%s/%s", path, name)->getCString();
		const char* imgFile		= CCString::createWithFormat("%s.png", filePath)->getCString(),
				* plistFile		= CCString::createWithFormat("%s.plist", filePath)->getCString(),
				* configFile	= CCString::createWithFormat("%s.xml", filePath)->getCString();
		CCArmatureDataManager::sharedArmatureDataManager()->addArmatureFileInfo(imgFile, plistFile, configFile);
		if ( armatureContainer->init(name) )
		{
			armatureContainer->setResourcePath(filePath);
			armatureContainer->autorelease();
			if ( parent )
			{
				parent->addChild(armatureContainer);
			}
			return armatureContainer;
		}
		delete armatureContainer;
	}
	return NULL;
}
void ArmatureContainer::setNextAction(const char* actionName)
{
	CC_RETURN_IF(!actionName)
	std::string strAction = actionName;
	CCString *str = CCString::create(strAction);
	this->_actionQueue->insertObject(str, 0);
}
void ArmatureContainer::runAnimation(const char* name, unsigned int loopTimes)
{

	CCArmatureAnimation * ani = getAnimation();
	if ( ani )
	{
		m_iRemainLoopTimes = 0;
		if ( loopTimes > 1 )
		{
			m_iRemainLoopTimes = loopTimes - 1;
			if ( !m_pEventListener )
			{
				ani->setMovementEventCallFunc(this, movementEvent_selector(ArmatureContainer::onReceiveMovementEvent));
			}
		}
		m_sCurrAniName = name;
		ani->play(name);
	}
}

void ArmatureContainer::changeSkin(CCBone* bone, CCNode* node, bool force /* = true */)
{
	if ( bone && node )
	{
		int index = bone->addDisplay(node, -1);
		bone->changeDisplayWithIndex(index, force);
	}
}

void ArmatureContainer::changeSkin(const char* boneName, const char* skinName, bool force /* = true */)
{
	CC_RETURN_IF(!boneName || !skinName)
	CCBone * bone = getBone(boneName);
	if ( bone )
	{
		if ( !bone->getDisplayByName(skinName) )
		{
			CCSkin* skin = CCSkin::createWithSpriteFrameName(skinName);
			CC_RETURN_IF(!skin)
			bone->addDisplay((CCNode*)skin, -1);
		}
		bone->changeDisplayWithName(skinName, force);
	}
}

void ArmatureContainer::changeSkin(const char* boneName, CCLabelTTF* label, bool force /* = true */)
{
	CC_RETURN_IF(!boneName || !label)
	changeSkin(getBone(boneName), label, force);
}

void ArmatureContainer::changeSkin(const char* boneName, CCParticleSystem* particle, bool force /* = true */)
{
	CC_RETURN_IF(!boneName || !particle)
	changeSkin(getBone(boneName), particle, true);
}

void ArmatureContainer::setListener(ArmatureEventListener* eventListener)
{
	m_pEventListener = eventListener;
	
	_registerListener();
}

void ArmatureContainer::registerLuaListener(int listener)
{
	m_iLuaListener = listener;

	_registerListener();
}

void ArmatureContainer::unregisterLuaListener()
{
	m_iLuaListener = 0;

	_registerListener();
}

void ArmatureContainer::setResourcePath(const char* resourcePath)
{
	m_pResourcePath = resourcePath;
}

void ArmatureContainer::clearResource(std::string resourcePath)
{
	if ( !resourcePath.empty() )
	{
		const char* configFile	= CCString::createWithFormat("%s.xml", resourcePath.c_str())->getCString();
		CCArmatureDataManager::sharedArmatureDataManager()->removeArmatureFileInfo(configFile);
	}
}

void ArmatureContainer::_registerListener()
{
	CCArmatureAnimation* animation = getAnimation();
	if ( animation )
	{
		if ( m_pEventListener || m_iLuaListener )
		{
			animation->setMovementEventCallFunc(this, movementEvent_selector(ArmatureContainer::onReceiveMovementEvent));
			animation->setFrameEventCallFunc(this, frameEvent_selector(ArmatureContainer::onReceiveFrameEvent));
		}
		else
		{
			animation->setMovementEventCallFunc(this, NULL);
			animation->setFrameEventCallFunc(this, NULL);
		}
	}
}

void ArmatureContainer::onReceiveMovementEvent(CCArmature* armature, MovementEventType eventType, const char* animationName)
{
	CC_UNUSED_PARAM(armature);
	if ( eventType == COMPLETE || eventType == LOOP_COMPLETE )
	{
		if (m_bIsLoop)
		{
			CCLog("animation[%s] remain %d times", animationName, m_iRemainLoopTimes);
			runAnimation(animationName, m_iRemainLoopTimes);
			return;
		}
		else
		{
			if (m_iRemainLoopTimes)
			{
				CCLog("animation[%s] remain %d times", animationName, m_iRemainLoopTimes);
				runAnimation(animationName, m_iRemainLoopTimes);
				return;
			}
		}
		
		bool isLoop = eventType == LOOP_COMPLETE;
		CCLog("%s animation[name: %s] done", (isLoop ? "loop" : ""), animationName);
		m_sCurrAniName = "";
		if ( m_pEventListener )
		{
			m_pEventListener->onArmatureAnimationDone(animationName, isLoop);

		}
		if ( m_iLuaListener )
		{
			CCLuaStack* stack = CCLuaEngine::defaultEngine()->getLuaStack();
			std::string aniEventName = "AnimationDone";
			stack->pushString(aniEventName.c_str(), aniEventName.size());
			stack->pushString(animationName, strlen(animationName));
			stack->pushBoolean(isLoop);
			stack->executeFunctionByHandler(m_iLuaListener, 3);
		}


		if (this->_actionQueue->count() > 0)
		{
			CCString *str = (CCString *) this->_actionQueue->objectAtIndex(0);
			setAction(str->getCString(), false);
			this->_actionQueue->removeObjectAtIndex(0, true);
		}
	}
}

void ArmatureContainer::onReceiveFrameEvent(CCBone* bone, const char* eventName, int originalIndex, int currentIndex)
{
	if ( m_pEventListener )
	{
		m_pEventListener->onFrameEvent(eventName, bone);
	}
	if ( m_iLuaListener )
	{
		CCLuaStack* stack = CCLuaEngine::defaultEngine()->getLuaStack();
		std::string aniEventName = "FrameEvent";
		stack->pushString(aniEventName.c_str(), aniEventName.size());
		stack->pushString(eventName, strlen(eventName));
		stack->pushCCObject(bone, "CCBone");
		stack->executeFunctionByHandler(m_iLuaListener, 3);
	}
}
int ArmatureContainer::addEffect(const char* resName)
{
	return addEffect(resName, CCAffineTransformMakeIdentity(), 1);
}
int ArmatureContainer::addEffect(const char* resName, CCAffineTransform  const& mat, int zorder)
{
	LegendAminationEffect *eff = LegendAminationEffect::create(resName);
	eff->setTransform(mat);
	this->addChild(eff, zorder);
	this->_effectArray->addObject(eff);
	eff->setTag(this->m_iCurrEffectTag++);
	return eff->getTag();
}

int ArmatureContainer::addEffect(const char* resName, CCPoint pos, int zorder)
{
	CCAffineTransform mt = CCAffineTransformMakeIdentity();
	mt.tx = pos.x;
	mt.ty = pos.y;
	return addEffect(resName, mt, zorder);
}
int ArmatureContainer::addEffect(const char *name, int zorder)
{
	CCAffineTransform mt = CCAffineTransformMakeIdentity();
	return addEffect(name, mt, zorder);
}
void ArmatureContainer::removeEffectWithID(int eid)
{
	CCObject *spr = NULL;
	CCARRAY_FOREACH(this->_effectArray, spr)
	{
		if (((LegendAnimation*)spr)->getTag() == eid)
		{
			this->_effectArray->removeObject(spr);
			this->removeChild((LegendAnimation*)spr, true);
			return;
		}
	}
}
void ArmatureContainer::removeEffectWithName(const char  * effectName)
{
	CCObject *spr = NULL;
	CCARRAY_FOREACH(this->_effectArray, spr)
	{
		if (((LegendAnimation*)spr)->getAniFileName().compare(effectName) == 0)
		{
			this->_effectArray->removeObject(spr);
			this->removeChild((LegendAnimation*)spr, true);
			return;
		}
	}
}

void ArmatureContainer::useDefaultShader(void)
{
	useShader("ShaderPositionTextureColor");
}
void ArmatureContainer::useShader(const char* shaderName)
{
	CCGLProgram*  prg = CCShaderCache::sharedShaderCache()->programForKey(shaderName);
	if (prg == NULL)
	{
		printf("SpineContainer::useShader %s is NULL\n", shaderName);
		return;
	}
	setShaderProgram(prg);
}
void ArmatureContainer::setActionElapsed(float elapsed)
{

}
void ArmatureContainer::setActionSpeeder(float speeder)
{

}