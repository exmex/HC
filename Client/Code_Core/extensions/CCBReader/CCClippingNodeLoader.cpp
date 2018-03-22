//
//  CCClippingNodeLoader.cpp
//  ccx
//
//  Created by Higgx on 12/14/13.
//
//

#define PROPERTY_MASK "mask"
#define PROPERTY_AT "alphaThreshold"
#define PROPERTY_I "inverted"

#include "CCClippingNodeLoader.h"

void CCClippingNodeLoader::onHandlePropTypeSpriteFrame(cocos2d::CCNode *pNode, cocos2d::CCNode *pParent, const char *pPropertyName, cocos2d::CCSpriteFrame *pCCSpriteFrame, cocos2d::extension::CCBReader *pCCBReader){
    if (strcmp(PROPERTY_MASK, pPropertyName) == 0) {
        ((CCClippingNode*)pNode)->setStencil(CCSprite::createWithSpriteFrame(pCCSpriteFrame));
    }
}

void CCClippingNodeLoader::onHandlePropTypeCheck(cocos2d::CCNode *pNode, cocos2d::CCNode *pParent, const char *pPropertyName, bool pCheck, cocos2d::extension::CCBReader *pCCBReader){
    if (strcmp(PROPERTY_I, pPropertyName) == 0) {
        ((CCClippingNode*)pNode)->setInverted(pCheck);
    }
}

void CCClippingNodeLoader::onHandlePropTypeFloat(cocos2d::CCNode *pNode, cocos2d::CCNode *pParent, const char *pPropertyName, float pFloat, cocos2d::extension::CCBReader *pCCBReader){
    if (strcmp(PROPERTY_AT, pPropertyName) == 0) {
        ((CCClippingNode*)pNode)->setAlphaThreshold(pFloat);
    }
}