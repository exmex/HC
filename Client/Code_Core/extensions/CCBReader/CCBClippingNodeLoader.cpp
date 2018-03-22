//
//  CCBClippingNodeLoader.cpp
//  ccx
//
//  Created by Higgx on 12/14/13.
//
//

#define PROPERTY_MASK "mask"
#define PROPERTY_AT "alphaThreshold"
#define PROPERTY_I "inverted"
#define PROPERTY_HTAG "htag"

#include "CCBClippingNodeLoader.h"

void CCBClippingNodeLoader::onHandlePropTypeSpriteFrame(cocos2d::CCNode *pNode, cocos2d::CCNode *pParent, const char *pPropertyName, cocos2d::CCSpriteFrame *pCCSpriteFrame, cocos2d::extension::CCBReader *pCCBReader){
    if (strcmp(PROPERTY_MASK, pPropertyName) == 0) {
        ((CCBClippingNode*)pNode)->setStencil(CCSprite::createWithSpriteFrame(pCCSpriteFrame));
    }
}

void CCBClippingNodeLoader::onHandlePropTypeCheck(cocos2d::CCNode *pNode, cocos2d::CCNode *pParent, const char *pPropertyName, bool pCheck, cocos2d::extension::CCBReader *pCCBReader){
    if (strcmp(PROPERTY_I, pPropertyName) == 0) {
        ((CCBClippingNode*)pNode)->setInverted(pCheck);
    }
}

void CCBClippingNodeLoader::onHandlePropTypeFloat(cocos2d::CCNode *pNode, cocos2d::CCNode *pParent, const char *pPropertyName, float pFloat, cocos2d::extension::CCBReader *pCCBReader){
    if (strcmp(PROPERTY_AT, pPropertyName) == 0) {
        ((CCBClippingNode*)pNode)->setAlphaThreshold(pFloat);
    }
}

void CCBClippingNodeLoader::onHandlePropTypeInteger(cocos2d::CCNode *pNode, cocos2d::CCNode *pParent, const char *pPropertyName, int pInteger, cocos2d::extension::CCBReader *pCCBReader){
    if (strcmp(PROPERTY_HTAG, pPropertyName) == 0) {
        ((CCBClippingNode*)pNode)->htag = pInteger;
    }
}