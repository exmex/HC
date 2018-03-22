//
//  CCClippingNodeLoader.h
//  ccx
//
//  Created by Higgx on 12/14/13.
//
//

#ifndef __ccx__CCClippingNodeLoader__
#define __ccx__CCClippingNodeLoader__

#include "cocos2d.h"
#include "CCNodeLoader.h"

USING_NS_CC;
USING_NS_CC_EXT;

class CCClippingNodeLoader : public CCNodeLoader
{
public:
    CCB_STATIC_NEW_AUTORELEASE_OBJECT_METHOD(CCClippingNodeLoader, loader);
    
protected:
    CCB_VIRTUAL_NEW_AUTORELEASE_CREATECCNODE_METHOD(CCClippingNode);
    
    virtual void onHandlePropTypeSpriteFrame(CCNode * pNode, CCNode * pParent, const char* pPropertyName, CCSpriteFrame * pCCSpriteFrame, CCBReader * pCCBReader);
    virtual void onHandlePropTypeFloat(CCNode * pNode, CCNode * pParent, const char* pPropertyName, float pFloat, CCBReader * pCCBReader);
    virtual void onHandlePropTypeCheck(CCNode * pNode, CCNode * pParent, const char* pPropertyName, bool pCheck, CCBReader * pCCBReader);
};

#endif /* defined(__ccx__CCClippingNodeLoader__) */
