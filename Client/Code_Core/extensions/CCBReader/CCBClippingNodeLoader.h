//
//  CCBClippingNodeLoader.h
//  ccx
//
//  Created by Higgx on 12/14/13.
//
//

#ifndef __ccx__CCBClippingNodeLoader__
#define __ccx__CCBClippingNodeLoader__

#include "cocos2d.h"
#include "CCNodeLoader.h"
#include "CCBClippingNode.h"

USING_NS_CC;
USING_NS_CC_EXT;

class CCBClippingNodeLoader : public CCNodeLoader
{
public:
    CCB_STATIC_NEW_AUTORELEASE_OBJECT_METHOD(CCBClippingNodeLoader, loader);
    
protected:
    CCB_VIRTUAL_NEW_AUTORELEASE_CREATECCNODE_METHOD(CCBClippingNode);
    
    virtual void onHandlePropTypeSpriteFrame(CCNode * pNode, CCNode * pParent, const char* pPropertyName, CCSpriteFrame * pCCSpriteFrame, CCBReader * pCCBReader);
    virtual void onHandlePropTypeFloat(CCNode * pNode, CCNode * pParent, const char* pPropertyName, float pFloat, CCBReader * pCCBReader);
    virtual void onHandlePropTypeCheck(CCNode * pNode, CCNode * pParent, const char* pPropertyName, bool pCheck, CCBReader * pCCBReader);
    virtual void onHandlePropTypeInteger(CCNode * pNode, CCNode * pParent, const char* pPropertyName, int pInteger, CCBReader * pCCBReader);
};

#endif /* defined(__ccx__CCBClippingNodeLoader__) */
