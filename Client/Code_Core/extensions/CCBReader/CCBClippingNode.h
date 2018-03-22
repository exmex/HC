//
//  CCBClippingNode.h
//  ccx
//
//  Created by Higgx on 12/17/13.
//
//

#ifndef __ccx__CCBClippingNode__
#define __ccx__CCBClippingNode__

#include "cocos2d.h"
#include "cocos-ext.h"
//#include "CCB.h"


USING_NS_CC;
USING_NS_CC_EXT;

class CCBClippingNode
: public CCClippingNode
{
public:
    
    CCBClippingNode()
		: CCClippingNode()
		, htag(0){}
    
    int htag;
    virtual void visit();
    CCB_STATIC_NEW_AUTORELEASE_OBJECT_WITH_INIT_METHOD(CCBClippingNode, create);
};

#endif /* defined(__ccx__CCBClippingNode__) */
