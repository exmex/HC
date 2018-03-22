//
//  LegendAminationEffect.cpp
//  HelloLua
//
//  Created by eboz on 14-5-2.
//
//
#include "cocos2d.h"
#include "LegendAminationEffect.h"

USING_NS_CC;

 LegendAminationEffect * LegendAminationEffect::create(const char*resName)
{
	// printf("LegendAminationEffect::create called %s\n", resName);
    std::string resourceName = "effect/";
    resourceName+=resName;

	 LegendAminationEffect * obj = new LegendAminationEffect(resourceName.c_str());
	 obj->autorelease();
	 return obj;
}


 LegendAminationEffect::LegendAminationEffect(const char*resource) 
	 :LegendAnimation(resource)
{
    _isTerminted = false;
    _startActionName  ="Start";
    for(size_t i=0;i<_aniFileInfo->_actions.size();i++)
    {
        if(_aniFileInfo->_actions[i].name.compare("Loop")==0)
        {
            _loopActionName = "Loop";
        }
    }
}

LegendAminationEffect::~LegendAminationEffect()
{

}


void LegendAminationEffect::setLoopAction(const char *loopAction)
{
    this->_loopActionName = loopAction;
}


void LegendAminationEffect::setStartAction(const char *actionName)
{
    this->_startActionName = actionName;
}


bool LegendAminationEffect::isTerminated()
{
    return _isTerminted;
}

void LegendAminationEffect::onEnter(void)
{
    setAction(_startActionName.c_str(),true);
}

void LegendAminationEffect::onActionFinished(void)
{
    if(_loopActionName.length()==0)
    {
        _isTerminted = true;
        return;
    }
    
    setAction(_loopActionName.c_str(),true);
}
