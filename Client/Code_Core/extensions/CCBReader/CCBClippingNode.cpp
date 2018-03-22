//
//  CCBClippingNode.cpp
//  ccx
//
//  Created by Higgx on 12/17/13.
//
//

#include "CCBClippingNode.h"

void CCBClippingNode::visit(){
    
    CCNode* hock = this->getChildByTag(htag);
    if (hock==NULL) {
        getStencil()->setPosition(0, 0);
        getStencil()->setScaleX(1);
        getStencil()->setScaleY(1);
        getStencil()->setRotationX(0);
        getStencil()->setRotationY(0);
        getStencil()->setSkewX(0);
        getStencil()->setSkewY(0);
        getStencil()->setAnchorPoint(ccp(0.5, 0.5));
    }else{
        getStencil()->setPosition(hock->getPositionX(),hock->getPositionY());
        getStencil()->setScaleX(hock->getScaleX());
        getStencil()->setScaleY(hock->getScaleY());
        getStencil()->setRotationX(hock->getRotationX());
        getStencil()->setRotationY(hock->getRotationY());
        getStencil()->setSkewX(hock->getSkewX());
        getStencil()->setSkewY(hock->getSkewY());
        getStencil()->setAnchorPoint(hock->getAnchorPoint());
    }
    
    CCClippingNode::visit();
}