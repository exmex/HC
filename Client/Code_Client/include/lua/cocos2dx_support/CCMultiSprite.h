
//
//  Created by dany on 14-5-2.
//


#ifndef __HelloLua__CCMultiSprite__
#define __HelloLua__CCMultiSprite__

#include <iostream>
#include "cocos2d.h"
#include "HGAnimation.h"
namespace cocos2d {

class CCMultiSprite :public CCSprite
{
public:
	CCMultiSprite();
	virtual ~CCMultiSprite();
	void setBackgroundScale(float scale);
	void updateMultiTexture(void);
	void setMultiSprite(CCDictionary * dict);
	static CCMultiSprite *createWithSpriteFrame(CCSpriteFrame * frame);
	static CCMultiSprite * create(const char * name);
	static CCMultiSprite * create(void);
    
protected:
    
    
    int    _x1;//+0xF0
    
    int    _x2;//+0x100
    
                //+134
    CCDictionary *_mSpriteDic; //+0x1C0
    CCRenderTexture *_renderTexture;//+0x1c4;
    float  _backgroundScaleFactor; //+0x1c8
};
}
#endif /* defined(__HelloLua__CCMultiSprite__) */
