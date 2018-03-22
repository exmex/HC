//
//  LegendAnimation.cpp
//
#include "cocos2d.h"
#include "LegendAnimation.h"
#include "SimpleAudioEngine.h"
#include "LegendAminationEffect.h"
#include "apiforlua.h"
USING_NS_CC;

LegendAnimation * LegendAnimation::create(const char* resource, double scale)
{
	 LegendAnimation *obj =  new LegendAnimation(resource);
     obj->setScale(scale *  obj->getScale());
	 obj->autorelease();
	 return obj;
}


 void LegendAnimation::gc(double gcPassTime)
{
	 LegendAnimationFileInfo::_cacheAniFileInfo.gc(gcPassTime,3);
}

void LegendAnimation::setgcTime(double gctime)
{
	LegendAnimationFileInfo::_cacheAniFileInfo.setGCTime(gctime);
}

LegendAnimation::LegendAnimation(const char* resName)
	: GameAnimation(Type_LegendAnimation)
{
	init();
	mAniFileName = resName;
	this->_aniFileInfo = LegendAnimationFileInfo::getAniFileInfo(mAniFileName);
	this->_aniFileInfo->retain();
    this->_currentAction = NULL;
    
    _batchNode =NULL;
	_curActionElapsed = 0.0;
    _currentFrame = -1;
	_isLoop = false;
    _speeder =1.0;
    _curSoundId =0;
    _isSoundPlay =false;
    _curEffectTag=0;
    
    
    
    _elementArray =  CCArray::createWithCapacity(_aniFileInfo->_elements.size());
    _elementArray->retain();
    _actionQueue  = CCArray::create();
    _actionQueue->retain();
    _effectArray  = CCArray::create();
    _effectArray->retain();
    
    for(size_t i=0;i<_aniFileInfo->_elements.size();i++)
    {
        setComponent(i, _aniFileInfo->_elements[i].resouceName.c_str());
    }
    
}

LegendAnimation::~LegendAnimation()
{
   CC_SAFE_RELEASE(_elementArray);
   CC_SAFE_RELEASE(_actionQueue);
   CC_SAFE_RELEASE(_effectArray);
   CC_SAFE_RELEASE(_batchNode);
   CC_SAFE_RELEASE(_aniFileInfo);
}

int LegendAnimation::addEffect(const char* resName)
{
	return addEffect(resName,CCAffineTransformMakeIdentity(),1);
}

int LegendAnimation::addEffect(const char* resName, CCAffineTransform  const& mat, int zorder)
{
    LegendAminationEffect *eff = LegendAminationEffect::create(resName);
    eff->setTransform(mat);
    this->addChild(eff,zorder);
    this->_effectArray->addObject(eff);
    eff->setTag(this->_curEffectTag++);
	return eff->getTag();
}

int LegendAnimation::addEffect(const char* resName, CCPoint pos, int zorder)
{
	CCAffineTransform mt =  CCAffineTransformMakeIdentity();
    mt.tx = pos.x;
    mt.ty  = pos.y;
	return addEffect(resName,mt,zorder);
}

int LegendAnimation::addEffect(const char *resName, int zorder)
{
	CCAffineTransform mt =  CCAffineTransformMakeIdentity();
	return addEffect(resName,mt,zorder);
}

void LegendAnimation::addToActionSequence(const char* action)
{
    std::string strAction = action;
    CCString *str = CCString::create(strAction);
    this->_actionQueue->addObject(str);
}

void LegendAnimation::clearActionSequence(void)
{
    this->_actionQueue->removeAllObjects();
}

CCArray * LegendAnimation::getActionSequence(void)
{
	return _actionQueue;
}

void LegendAnimation::interruptSound()
{
	if (_isSoundPlay)
    {
        CocosDenshion::SimpleAudioEngine::sharedEngine()->stopEffect(_curSoundId);
        _curSoundId=0;
		_isSoundPlay = false;
    }
}


void LegendAnimation::onActionFinished(void)
{
	if (this->_actionQueue->count() > 0)
	{
		CCString *str = (CCString *) this->_actionQueue->objectAtIndex(0);
		setAction(str->getCString(),false);
		this->_actionQueue->removeObjectAtIndex(0, true);
	}

	if (this->_isLoop)
	{
		this->_curActionElapsed = 0.0;
		this->_currentFrame = -1;
	}
}

void LegendAnimation::releaseAnimationFileInfo(void)
{
	LegendAnimationFileInfo::removeUnusedInfo();
    printf("LegendAnimation::releaseAnimationFileInfo \n");
}

void LegendAnimation::removeEffectWithID(int eid)
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

void LegendAnimation::removeEffectWithName(const char* eff)
{
	CCObject *spr = NULL;
	CCARRAY_FOREACH(this->_effectArray, spr)
	{
		if (((LegendAnimation*)spr)->_aniFileInfo->_name.compare(eff)==0)
		{
			this->_effectArray->removeObject(spr);
			this->removeChild((LegendAnimation*)spr, true);
			return;
		}
	}

}

bool LegendAnimation::setAction(const char *action, bool isClearActionQueue)
{
	
    if(action==NULL)
    {
        if(_aniFileInfo->_name.compare("TB")==0)
            printf("LegendAnimation::setAction %s->%s\n", _aniFileInfo->_name.c_str(), "action is null");
        return false;
    }
    if(_aniFileInfo->_name.compare("TB")==0)
        printf("LegendAnimation::setAction %s->%s\n", _aniFileInfo->_name.c_str(), action);
    
    for(size_t i=0;i<_aniFileInfo->_actions.size();i++)
    {
        if(_aniFileInfo->_actions[i].name.compare(action)==0)
        {
            this->_currentAction = &_aniFileInfo->_actions[i];
            break;
        }
    }
    
    if(this->_currentAction)
    {
        
        this->_currentActionName = action;
		this->_curActionElapsed = 0;
        this->_currentFrame=-1;
        if(isClearActionQueue)
        {
            this->clearActionSequence();
        }
        return true;
    }
    return false;
}


void LegendAnimation::setColor(cocos2d::_ccColor3B color)
{
    CCObject *spr=NULL;
    CCARRAY_FOREACH(this->_effectArray, spr)
    {
        ((CCSprite*)spr)->setColor(color);
    }
    
    CCARRAY_FOREACH(this->_elementArray, spr)
    {
        ((CCSprite*)spr)->setColor(color);
    }
}

bool LegendAnimation::setComponent(const char* resourceName, const char* lpszName)
{
    for(size_t i=0;i<_aniFileInfo->_elements.size();i++)
    {
        if(_aniFileInfo->_elements[i].resouceName.compare(resourceName)==0)
        {
            return setComponent(_aniFileInfo->_elements[i].index-1,lpszName);
        }
    }

    return false;
}

bool LegendAnimation::setComponent(int index, const char* lpszName)
{
    
    CCSpriteFrame *frm = _aniFileInfo->getSpriteFrame(lpszName);
    if(frm==NULL)
    {
		CCLog("[LegendAnimation|setComponent] aniFileName:%s,Component %i not exsits in charater '%s", mAniFileName.c_str(), index, lpszName);
        return false;
    }
    
    CCSprite *spr=CCSprite::createWithSpriteFrame(frm);
    spr->setTag(index);
    if(this->_batchNode==NULL)
    {
        CCTexture2D *texture = frm->getTexture();
        this->_batchNode = CCSpriteBatchNode::createWithTexture(texture, this->_aniFileInfo->_elements.size());
        this->_batchNode->retain();
        
        this->_batchNode->setTag(0);
        this->_batchNode->setScale(this->_aniFileInfo->_scalefactor);
        this->addChild(this->_batchNode,0);
    }

    if((CCSprite *)this->_batchNode->getChildByTag(index))
    {
        this->_batchNode->removeChildByTag(index);
    }
    
    this->_batchNode->addChild(spr);
    
    if(index == this->_elementArray->count())
    {
        this->_elementArray->addObject(spr);
       
    }
    else if(index<this->_elementArray->count())
    {
        this->_elementArray->replaceObjectAtIndex(index, spr,true);
    }
    else
	{
		CCLog("[LegendAnimation|setComponent] aniFileName:%s,Component %i index is wrong, at charater %s", mAniFileName.c_str(),index, lpszName);
    }
    
    return true;
    
}
void LegendAnimation::setNextAction(const char* actionName)
{
	if (_aniFileInfo->_name.compare("TB") == 0)
	{
		printf("LegendAnimation::setNextAction %s %s \n", _aniFileInfo->_name.c_str(), actionName);
	}
	std::string strAction = actionName;
	CCString *str = CCString::create(strAction);
	this->_actionQueue->insertObject(str, 0);
}

void LegendAnimation::setOpacity(unsigned char bval)
{
	CCObject *spr = NULL;
	CCARRAY_FOREACH(this->_effectArray, spr)
	{
		((CCSprite*)spr)->setOpacity(bval);
	}

	CCARRAY_FOREACH(this->_elementArray, spr)
	{
		((CCSprite*)spr)->setOpacity(bval);
	}
}

void LegendAnimation::tint(float r, float g, float b)
{
	ccColor3B clr;
	CCObject *spr = NULL;
	bool isGetColor = false;

	CCARRAY_FOREACH(this->_elementArray, spr)
	{
		clr = ((CCSprite*)spr)->getColor();
		isGetColor = true;
		break;
	}
	if (!isGetColor)
	{
		CCARRAY_FOREACH(this->_effectArray, spr)
		{
			clr = ((CCSprite*)spr)->getColor();
			isGetColor = true;
			break;
		}
	}


	if (!isGetColor)
	{
		clr = this->getColor();
	}
	
    clr.r = clr.r * r;
    clr.g = clr.g * g;
    clr.b = clr.b * b;
    this->setColor(clr);
}


void LegendAnimation::update(float dt, bool isAuto)
{
    CCObject* pObj = NULL;
	this->_curActionElapsed += dt * _speeder;
    if(_currentAction!=NULL)
    {
		int calcFrame =this->_curActionElapsed * _currentAction->fps;
        if(calcFrame>this->_currentFrame)
        {
            if(calcFrame >= _currentAction->frames.size())
            {
                this->onActionFinished();
            }
            else
            {
                this->_currentFrame++;
                
                for(int i=this->_currentFrame;i<=calcFrame; i++)
                {
                   LegendAnimationFrame &frame = _currentAction->frames[i];
                    for(size_t j=0;j<frame.events.size();j++)
                    {
                        LegendAnimationEvent &evt = frame.events[j];
                        if(evt.type==LegendAnimationEvent::EVENT_SOUND)
                        {
                            if(g_soundSwitch)
                            {
                                std::string soundFile = "sound/"+evt.arg;
                                _curSoundId  = CocosDenshion::SimpleAudioEngine::sharedEngine()->playEffect(soundFile.c_str(),false);
								_isSoundPlay = true;
							}
                        }
                        else if(evt.type == LegendAnimationEvent::EVENT_ADD_EFFECT)
                        {
                            addEffect(evt.arg.c_str(), evt.transform, evt.zorder);
                        }
                        else if(evt.type == LegendAnimationEvent::EVENT_REMOVE_EFFECT)
                        {
                            removeEffectWithName(evt.arg.c_str());
                        }
                    }
                    
                }
                
                
                this->_currentFrame =calcFrame;
                
              
                CCARRAY_FOREACH(this->_elementArray, pObj)
                {
                    CCSprite* pSpr = (CCSprite*) pObj;
                    pSpr->setVisible(false);
                }
                
                LegendAnimationFrame &frame = _currentAction->frames[calcFrame];
				bool needReorder = false;
				int _elementCount = this->_elementArray->count();
                for(size_t i=0;i<frame.elements.size();i++)
                {
                    LegendAnimationFrameElement &felem = frame.elements[i];
                    int index = felem.index-1;
					if (index>_elementCount)
					{
#ifdef _WIN32||DEBUG
						CCLog("[LegendAnimation|update] Error.Components is not configured,actionFile:%s,actionName:%s,Only:%d,Reality:%d", mAniFileName.c_str(), _currentAction->name.c_str(), _elementCount, index);
#endif // _WIN32||_DEBUG
						continue;
					}
					else
					{
						pObj = this->_elementArray->objectAtIndex(index);
						if (pObj == NULL)
						{
							continue;
						}
					}
                    
                    
                    CCSprite* pSpr = (CCSprite*) pObj;
                    
                    pSpr->setVisible(true);
					if (pSpr->getZOrder() != i)
						needReorder = true;
                    pSpr->setZOrder(i);
                    pSpr->setTransform(felem.transform);
                    pSpr->setOpacity(felem.alpha);
                }
				this->_batchNode->reorderBatch(needReorder);
                
            }
        }
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

void LegendAnimation::useDefaultShader()
{
    useShader("ShaderPositionTextureColor");
}

void LegendAnimation::useShader(const char *shader)
{
	
    CCGLProgram*  prg = CCShaderCache::sharedShaderCache()->programForKey(shader);
    if(prg==NULL)
    {
        printf("LegendAnimation::useShader %s is NULL\n", shader);
        return ;
    }
	this->_batchNode->setShaderProgram(prg);
}

void LegendAnimation::setActionElapsed(float elapsed)
{
	this->_curActionElapsed = elapsed;
}

void LegendAnimation::setActionSpeeder(float speeder)
{
	this->_speeder = speeder;
}


void LegendAnimation::setLoop(bool val)
{
	this->_isLoop = val;
}

std::string LegendAnimation::getAniFileName()
{
	std::string name;
	if ( _aniFileInfo )
	{
		name = _aniFileInfo->_name;
	}
	return name;
}
