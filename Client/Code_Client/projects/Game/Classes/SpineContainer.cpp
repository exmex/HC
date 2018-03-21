#include "SpineContainer.h"
#include "CCLuaEngine.h"
#include "LegendAminationEffect.h"
#include "SimpleAudioEngine.h"
#include "apiforlua.h"

USING_NS_CC;
#define TIMES_SPINE_LOOP -1

SpineContainer* SpineContainer::create(const char* path, const char* name, float scale /* = 0.0f */)
{
	const char* filePath	= CCString::createWithFormat("%s/%s", path, name)->getCString();
	const char* configFile	= CCString::createWithFormat("%s.json", filePath)->getCString(),
		* atlasFile		= CCString::createWithFormat("%s.atlas", filePath)->getCString();
	SpineContainer* spineContainer = new SpineContainer(configFile, atlasFile, scale);
	if ( !spineContainer )
	{
		return NULL;
	}
	spineContainer->autorelease();
	return spineContainer;
}

void SpineContainer::runAnimation(int trackIndex,const char* name, int loopTimes,float delay)
{
	CC_RETURN_IF(loopTimes == 0 || loopTimes < TIMES_SPINE_LOOP)
	--loopTimes;

	AnimationTrackMap::iterator it = m_mapTrack.find(name);
	if ( it == m_mapTrack.end() )
	{
		m_mapTrack.insert(std::make_pair(name, SAnimationInfo(name, trackIndex, loopTimes)));
	}
	else
	{
		trackIndex = it->second.trackIndex;
		it->second.loopTimes = loopTimes;
	}

	spTrackEntry* aniEntry=NULL;
	if(delay!=0.0f)
	{
		aniEntry=addAnimation(trackIndex, name, loopTimes != 0,delay);
	}
	else
	{
		aniEntry=setAnimation(trackIndex, name, loopTimes != 0);
		m_sCurrAniName = name;
	}

	if ( aniEntry )
	{
		//if ( m_pEventListener || m_iLuaListener )
		{
			this->setStartListener(this,aniEntry,SpineStartEvent_selector(SpineContainer::onReceiveStartEventListener));
			this->setEndListener(this,aniEntry,SpineEndEvent_selector(SpineContainer::onReceiveEndEventListener));
			this->setCompleteListener(this,aniEntry,SpineCompleteEvent_selector(SpineContainer::onReceiveCompleteEventListener));
			this->setEventListener(this,aniEntry,SpineEvent_selector(SpineContainer::onReceiveEventListener));
		}
	}
}


void SpineContainer::setListener(SpineEventListener* eventListener)
{
	m_pEventListener = eventListener;
}

void SpineContainer::registerLuaListener(int listener)
{
	m_iLuaListener = listener;
}

void SpineContainer::unregisterLuaListener()
{
	m_iLuaListener = 0;
}



void SpineContainer::stopAllAnimations() 
{ 
	clearTracks();
}

void SpineContainer::stopAnimationByIndex(int trackIndex)
{
	clearTrack(trackIndex);
}


void SpineContainer::onAnimationStateEvent (int trackIndex, const char* animationName,spEventType type, spEvent* _event, int loopCount)
{
	CC_RETURN_IF(!m_pEventListener && !m_iLuaListener)

	std::string eventName("");
	switch ( type )
	{
	case SP_ANIMATION_COMPLETE:
		{
			SAnimationInfo* ctrlInfo = getAnimationInfo(trackIndex);
			if ( ctrlInfo->loopTimes > 0 )
			{
				runAnimation(trackIndex,ctrlInfo->aniName, ctrlInfo->loopTimes);
			}
			else if ( ctrlInfo->loopTimes == 0 )
			{
				if ( m_pEventListener )
				{
					m_pEventListener->onSpineAnimationComplete(trackIndex,animationName,loopCount);
				}
				eventName = "Complete";
			}
		}
		break;
	case SP_ANIMATION_START:
		if ( m_pEventListener )
		{
			m_pEventListener->onSpineAnimationStart(trackIndex,animationName);
		}
		eventName = "Start";
		break;
	case SP_ANIMATION_END:
		if ( m_pEventListener )
		{
			m_pEventListener->onSpineAnimationEnd(trackIndex,animationName);
		}
		eventName = "End";
		break;
	case SP_ANIMATION_EVENT:
		if ( m_pEventListener )
		{
			m_pEventListener->onSpineAnimationEvent(trackIndex,animationName, _event);
		}
		eventName = "Event";
		break;
	default:
		break;
	}

	if ( m_iLuaListener && !eventName.empty() )
	{
		CCLuaStack* stack = CCLuaEngine::defaultEngine()->getLuaStack();
		stack->pushString(eventName.c_str(), eventName.size());
		stack->pushInt(trackIndex);
		stack->pushString(animationName, strlen(animationName));
		stack->pushInt(loopCount);
		stack->executeFunctionByHandler(m_iLuaListener, 4);
	}
}


void SpineContainer::onReceiveStartEventListener(int trackIndex,const char* animationName)
{
	if ( m_pEventListener )
	{
		m_pEventListener->onSpineAnimationStart(trackIndex,animationName);
	}
}

void SpineContainer::onReceiveEndEventListener(int trackIndex,const char* animationName)
{
	if ( m_pEventListener )
	{
		m_pEventListener->onSpineAnimationEnd(trackIndex,animationName);
	}
}

void SpineContainer::onReceiveCompleteEventListener(int trackIndex, const char* animationName,int loopCount)
{
	if ( m_pEventListener )
	{
		m_pEventListener->onSpineAnimationComplete(trackIndex,animationName,loopCount);
	}
	onActionFinished();
}

void SpineContainer::onReceiveEventListener(int trackIndex,const char* animationName,spEvent* event)
{
	if ( m_pEventListener )
	{
		m_pEventListener->onSpineAnimationEvent(trackIndex,animationName, event);
	}
	if ( event )
	{
		if ( event->intValue == 1 )
		{
			if (g_soundSwitch)
			{
				std::string soundFile = "sound/" + std::string(event->stringValue);
				_curSoundId = CocosDenshion::SimpleAudioEngine::sharedEngine()->playEffect(soundFile.c_str(), false);
				_isSoundPlay = true;
			}
		}
	}
}

bool SpineContainer::setAction(const char * name, bool bRemoveQueue)
{
	CC_RETURN_VAL_IF(!name, false)
	runAnimation(0, name, 1);
	if ( bRemoveQueue )
	{
		this->clearActionSequence();
	}
	return true;
}

void SpineContainer::setNextAction(const char* actionName)
{
	CC_RETURN_IF(!actionName)
	std::string strAction = actionName;
	CCString *str = CCString::create(strAction);
	this->_actionQueue->insertObject(str, 0);
}

void SpineContainer::onActionFinished(void)
{
	if (this->_actionQueue->count() > 0)
	{
		CCString *str = (CCString *) this->_actionQueue->objectAtIndex(0);
		setAction(str->getCString(),false);
		this->_actionQueue->removeObjectAtIndex(0, true);
	}
	else if ( m_bIsLoop && !m_sCurrAniName.empty() )
	{
		runAnimation(0, m_sCurrAniName.c_str(), TIMES_SPINE_LOOP);
	}
	else
	{
		m_sCurrAniName = "";
	}
}

void SpineContainer::clearActionSequence(void)
{
    this->_actionQueue->removeAllObjects();
}

int SpineContainer::addEffect(const char* resName)
{
	return addEffect(resName,CCAffineTransformMakeIdentity(),1);
}

int SpineContainer::addEffect(const char* resName, CCAffineTransform  const& mat, int zorder)
{
    LegendAminationEffect *eff = LegendAminationEffect::create(resName);
    eff->setTransform(mat);
    this->addChild(eff,zorder);
    this->_effectArray->addObject(eff);
    eff->setTag(this->m_iCurrEffectTag++);
	return eff->getTag();
}

int SpineContainer::addEffect(const char* resName, CCPoint pos, int zorder)
{
	CCAffineTransform mt =  CCAffineTransformMakeIdentity();
    mt.tx = pos.x;
    mt.ty  = pos.y;
	return addEffect(resName,mt,zorder);
}

int SpineContainer::addEffect(const char *resName, int zorder)
{
	CCAffineTransform mt =  CCAffineTransformMakeIdentity();
	return addEffect(resName,mt,zorder);
}

void SpineContainer::removeEffectWithID(int eid)
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

void SpineContainer::removeEffectWithName(const char* eff)
{
	CCObject *spr = NULL;
	CCARRAY_FOREACH(this->_effectArray, spr)
	{
		if (((LegendAnimation*)spr)->getAniFileName().compare(eff)==0)
		{
			this->_effectArray->removeObject(spr);
			this->removeChild((LegendAnimation*)spr, true);
			return;
		}
	}

}

void SpineContainer::update(float dt, bool isAuto)
{
	if (isAuto)
	{
		SkeletonAnimation::update(dt);
		return;
	}

    int kk=0;
    for(kk = this->_effectArray->count()-1; kk>=0;kk--)
    {
        
        LegendAminationEffect *pactor = (LegendAminationEffect *)this->_effectArray->objectAtIndex((unsigned int )kk);
        pactor->update(dt);
        if(pactor->isTerminated())
        {
            this->_effectArray->removeObjectAtIndex((unsigned int )kk,true);
            this->removeChild(pactor, true);
        }
    }
}

void SpineContainer::tint(float r, float g, float b)
{
	SkeletonAnimation::tint(r, g, b);
	setColor(getColor());
}

void SpineContainer::setColor(_ccColor3B clr)
{
	SkeletonAnimation::setColor(clr);

    CCObject *spr=NULL;
    CCARRAY_FOREACH(this->_effectArray, spr)
    {
        ((CCSprite*)spr)->setColor(clr);
    }
}

void SpineContainer::setOpacity(unsigned char param1)
{
	SkeletonAnimation::setOpacity(param1);

	CCObject *spr = NULL;
	CCARRAY_FOREACH(this->_effectArray, spr)
	{
		((CCSprite*)spr)->setOpacity(param1);
	}
}

void SpineContainer::useDefaultShader(void)
{
	useShader("ShaderPositionTextureColor");
}

void SpineContainer::useShader(const char* shaderName)
{
    CCGLProgram*  prg = CCShaderCache::sharedShaderCache()->programForKey(shaderName);
	if (prg == NULL)
	{
		printf("SpineContainer::useShader %s is NULL\n", shaderName);
		return;
	}
	setShaderProgram(prg);
}

void SpineContainer::interruptSound()
{
	if (_isSoundPlay)
    {
        CocosDenshion::SimpleAudioEngine::sharedEngine()->stopEffect(_curSoundId);
        _curSoundId=0;
		_isSoundPlay = false;
    }
}