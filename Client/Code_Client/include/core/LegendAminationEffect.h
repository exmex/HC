//
//  LegendAminationEffect.h
//  HelloLua
//
//  Created by eboz on 14-5-2.
//
//

#ifndef __HelloLua__LegendAminationEffect__
#define __HelloLua__LegendAminationEffect__

#include <iostream>
#include "LegendAnimation.h"
namespace cocos2d {

class LegendAminationEffect :public LegendAnimation
{
public:
    static LegendAminationEffect * create(const char*resource);
	LegendAminationEffect(const char* resource);
	virtual ~LegendAminationEffect();

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
#endif /* defined(__HelloLua__LegendAminationEffect__) */
