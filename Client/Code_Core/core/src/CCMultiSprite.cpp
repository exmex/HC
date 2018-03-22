
//
//  Created by eboz on 14-5-2.
//


#include "CCMultiSprite.h"


USING_NS_CC;

CCMultiSprite::~CCMultiSprite()
{
    CC_SAFE_RELEASE(_mSpriteDic);
    CC_SAFE_RELEASE(_renderTexture);
}



void CCMultiSprite::setBackgroundScale(float val)
{
    _backgroundScaleFactor = val;
}

void CCMultiSprite::updateMultiTexture(void)
{
    CCTexture2D *texture = getTexture();
    CCSize sz = texture->getContentSize();
   
    CC_SAFE_RELEASE(_renderTexture);
    
    sz.width *= _backgroundScaleFactor;
    sz.height *= _backgroundScaleFactor;
    
    _renderTexture = CCRenderTexture::create(sz.width,sz.height);
    _renderTexture->retain();
    _renderTexture->begin();
    
    CCSprite *sprite =  CCSprite::createWithTexture(texture);
    sprite->setAnchorPoint(CCPoint(0,0));
    sprite->setPosition(CCPoint(0,0));
    sprite->setFlipY(true);
    sprite->setScale(_backgroundScaleFactor);
    sprite->visit();
    CCDictElement* pElement=NULL;
    CCSprite *spr=NULL;
    CCDICT_FOREACH(_mSpriteDic, pElement)
    {
        spr = (CCSprite *)pElement->getObject();
        spr->setFlipY(true);
        spr->visit();
    }
    
    //CCDictionary::~CCDictionary
    spr = _renderTexture->getSprite();
    texture = spr->getTexture();
    
    this->setTexture(texture);
    
    sz = texture->getContentSize();
    CCRect rect(0,0,sz.width,sz.height);
    cocos2d::CCSprite::setTextureRect(rect);
    _renderTexture->end();
    
}

void CCMultiSprite::setMultiSprite(CCDictionary *dict)
{
    CC_SAFE_RELEASE(_mSpriteDic);
    _mSpriteDic = dict;
    _mSpriteDic->retain();
    
    updateMultiTexture();
}

CCMultiSprite::CCMultiSprite(void)
{
    _mSpriteDic = NULL;
    _renderTexture =NULL;
    _x1  = 536;
    _x2  = 600;
    _backgroundScaleFactor  = 1.0f;
}

CCMultiSprite * CCMultiSprite::createWithSpriteFrame(CCSpriteFrame * frame)
{
	CCMultiSprite *obj = new CCMultiSprite();
    obj->initWithSpriteFrame(frame);
	obj->autorelease();
	return obj;
}
CCMultiSprite *  CCMultiSprite::create(const char * name)
{
	CCMultiSprite *obj = new CCMultiSprite();
    CCSpriteFrame *pFrame = CCSpriteFrameCache::sharedSpriteFrameCache()->spriteFrameByName(name);
    obj->initWithSpriteFrame(pFrame);
    obj->autorelease();
	return obj;
}

CCMultiSprite * CCMultiSprite::create(void)
{
	CCMultiSprite *obj = new CCMultiSprite();
	obj->autorelease();
	return obj;
}
