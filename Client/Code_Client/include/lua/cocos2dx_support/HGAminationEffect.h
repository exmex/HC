//
//  HGAminationEffect.h
//  HelloLua
//
//  Created by dany on 14-5-2.
//
//

#ifndef __HelloLua__HGAminationEffect__
#define __HelloLua__HGAminationEffect__

#include <iostream>
#include "HGAnimation.h"
namespace cocos2d {

class HGAminationEffect :public HGAnimation
{
public:
    static HGAminationEffect * create(const char*resource);
	HGAminationEffect(const char* resource);
	virtual ~HGAminationEffect();

    bool isTerminated();
	virtual void onEnter(void);
	virtual void onActionFinished(void);
    void setLoopAction(const char* actionName);
    
    void setStartAction(const char *actionName);
public:
    std::string _startActionName; ///0x1F8 fc
    std::string _loopActionName; //0x1FC  fe
    bool        _isTerminted;  //200    80
 
};
}
#endif /* defined(__HelloLua__HGAminationEffect__) */
