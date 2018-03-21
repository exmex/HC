//
//  HGAnimation.h
//  HelloLua
//
//  Created by dany on 14-4-28.
//
//

#ifndef __HelloLua__HGAnimation__
#define __HelloLua__HGAnimation__

#include <iostream>
#include "HGAnimationFileInfo.h"
namespace cocos2d{



class HGAnimation : public CCSprite
{
public:
    static HGAnimation * create(const char* resource, double scale = 1.0);
    static void releaseAnimationFileInfo();
    static void gc(double gcPassTime);
    static void setgcTime(double gctime);

	HGAnimation(const char* resName);
	virtual  ~HGAnimation();
	int addEffect(const char* resName);
	int addEffect(const char* resName, CCAffineTransform  const& mat, int zorder);
	int addEffect(const char* resName, CCPoint pos, int zorder);
	int addEffect(const char *name, int zorder);
	void addToActionSequence(const char* actionName);
	void clearActionSequence(void);
	CCArray * getActionSequence(void);
	void interruptSound(void);
	virtual void onActionFinished(void);
	void removeEffectWithID(int eid);
	void removeEffectWithName(const char  * effectName);
	bool setAction(const char  * name, bool bRemoveQueue);
	void setColor(_ccColor3B clr);
    
	bool setComponent(const char* param1, const char* param2);
	bool setComponent(int index, const char* lpszName);
	void setNextAction(const char* actionName);
	void setOpacity(unsigned char param1);
	void tint(float r, float g, float b);
	void update(float dt);
	void useDefaultShader(void);
	void useShader(const char* shaderName);
	void setActionElapsed(float elapsed);
	void setActionSpeeder(float speeder);
	void setLoop(bool val);

protected:
	
	HGAnimationFileInfo *         _aniFileInfo;  //+0x1C0 0xE0 * 2
    CCSpriteBatchNode * _batchNode ; // +0x1C4  0xE2 *2
    CCArray  *_elementArray; //+0x1C8 0xE4 * 2
    CCArray   *_effectArray; //0x1CC  0xE6 * 2
    std::string   _currentActionName;//0x1D0  0xe8 *2
    HGAnimationAction *   _currentAction; //+0x1d4 0xea << 1
    CCArray   *_actionQueue;//0x1D8  0xec
    float     _curActionElapsed; //+0x1dc 0xee << 1
    int     _currentFrame; //+0x1e0 0xf0
    bool    _isLoop; //+0x1e4  0xf2
    float   _speeder;//+0x1e8  0xf4
    int     _curSoundId; //+0x1ec 0xf6
	bool     _isSoundPlay; //0x1F0 0xf8 <<1
    int     _curEffectTag; //0x1F4 0xfa <<1
	

    
};


}

#endif /* defined(__HelloLua__HGAnimation__) */

