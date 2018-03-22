/****************************************************************************
 Copyright (c) 2011 cocos2d-x.org

 http://www.cocos2d-x.org

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

#include "CCLuaEngine.h"
#include "cocos2d.h"
#include "cocoa/CCArray.h"
#include "CCScheduler.h"
#include "lauxlib.h"
void luaopen_LegendLuaInterface(lua_State *L);
int   g_restartFlag=0;

NS_CC_BEGIN

CCLuaEngine* CCLuaEngine::m_defaultEngine = NULL;


CCLuaEngine* CCLuaEngine::defaultEngine(void)
{
    if (!m_defaultEngine)
    {
        m_defaultEngine = new CCLuaEngine();
        m_defaultEngine->init();
    }
    return m_defaultEngine;
}

void CCLuaEngine::cleanupDefaultEngine()
{
    m_defaultEngine = NULL;
}


CCLuaEngine::~CCLuaEngine(void)
{
    CC_SAFE_RELEASE(m_stack);
    m_stack = NULL;
    m_defaultEngine = NULL;
}

bool CCLuaEngine::init(void)
{
    m_stack = CCLuaStack::create();
    m_stack->retain();
    return true;
}

void CCLuaEngine::addSearchPath(const char* path)
{
    m_stack->addSearchPath(path);
}

void CCLuaEngine::addLuaLoader(lua_CFunction func)
{
    m_stack->addLuaLoader(func);
}

void CCLuaEngine::removeScriptObjectByCCObject(CCObject* pObj)
{
    m_stack->removeScriptObjectByCCObject(pObj);
}

void CCLuaEngine::removeScriptHandler(int nHandler)
{
    m_stack->removeScriptHandler(nHandler);
}

int CCLuaEngine::executeString(const char *codes)
{
    return m_stack->executeString(codes);
}

int CCLuaEngine::executeScriptFile(const char* filename)
{
    return m_stack->executeScriptFile(filename);
}

int CCLuaEngine::executeGlobalFunction(const char* functionName)
{
    return m_stack->executeGlobalFunction(functionName);
}

int CCLuaEngine::executeGlobalFunctionByName(const char* functionName, CCObject* pEventSource, const char* pEventSourceClassName)
{
	int ret = 0;
	if (m_stack->getGlobalFunction(functionName))
	{
		if (pEventSource)
		{
			m_stack->pushCCObject(pEventSource, pEventSourceClassName ? pEventSourceClassName : "CCObject");
		}
		ret = m_stack->executeFunction(pEventSource ? 1 : 0);
	}

	m_stack->clean();
	return ret;
}

int CCLuaEngine::executeNodeEvent(CCNode* pNode, int nAction)
{
    int nHandler = pNode->getScriptHandler();
    if (!nHandler) return 0;
    
    switch (nAction)
    {
        case kCCNodeOnEnter:
            m_stack->pushString("enter");
            break;
            
        case kCCNodeOnExit:
            m_stack->pushString("exit");
            break;
            
        case kCCNodeOnEnterTransitionDidFinish:
            m_stack->pushString("enterTransitionFinish");
            break;
            
        case kCCNodeOnExitTransitionDidStart:
            m_stack->pushString("exitTransitionStart");
            break;

		case kCCNodeOnCleanup:
			m_stack->pushString("cleanup");
			break;

        default:
            return 0;
    }
    return m_stack->executeFunctionByHandler(nHandler, 1);
}

int CCLuaEngine::executeMenuItemEvent(CCMenuItem* pMenuItem)
{
    int nHandler = pMenuItem->getScriptTapHandler();
    if (!nHandler) return 0;
    
    m_stack->pushInt(pMenuItem->getTag());
    m_stack->pushCCObject(pMenuItem, "CCMenuItem");
    return m_stack->executeFunctionByHandler(nHandler, 2);
}

int CCLuaEngine::executeNotificationEvent(CCNotificationCenter* pNotificationCenter, const char* pszName)
{
    int nHandler = pNotificationCenter->getScriptHandler();
    if (!nHandler) return 0;
    
    m_stack->pushString(pszName);
    return m_stack->executeFunctionByHandler(nHandler, 1);
}

int CCLuaEngine::executeCallFuncActionEvent(CCCallFunc* pAction, CCObject* pTarget/* = NULL*/)
{
    int nHandler = pAction->getScriptHandler();
    if (!nHandler) return 0;
    
    if (pTarget)
    {
        m_stack->pushCCObject(pTarget, "CCNode");
    }
    return m_stack->executeFunctionByHandler(nHandler, pTarget ? 1 : 0);
}

int CCLuaEngine::executeSchedule(int nHandler, float dt, CCNode* pNode/* = NULL*/)
{
    if (!nHandler) return 0;
    m_stack->pushFloat(dt);
    return m_stack->executeFunctionByHandler(nHandler, 1);
}

int CCLuaEngine::executeLayerTouchEvent(CCLayer* pLayer, int eventType, CCTouch *pTouch)
{
    CCTouchScriptHandlerEntry* pScriptHandlerEntry = pLayer->getScriptTouchHandlerEntry();
    int nHandler = pScriptHandlerEntry->getHandler();
    if (!nHandler) return 0;
    
    switch (eventType)
    {
        case CCTOUCHBEGAN:
            m_stack->pushString("began");
            break;
            
        case CCTOUCHMOVED:
            m_stack->pushString("moved");
            break;
            
        case CCTOUCHENDED:
            m_stack->pushString("ended");
            break;
            
        case CCTOUCHCANCELLED:
            m_stack->pushString("cancelled");
            break;
            
        default:
            return 0;
    }
    
    const CCPoint pt = CCDirector::sharedDirector()->convertToGL(pTouch->getLocationInView());
    m_stack->pushFloat(pt.x);
    m_stack->pushFloat(pt.y);
    return m_stack->executeFunctionByHandler(nHandler, 3);
}


void printluacallstack(lua_State *L)
{
    lua_getglobal(L, "debug");
    lua_getfield(L, -1, "traceback");
    lua_pcall( L,//VMachine
              0,//Argument Count
              1,//Return Value Count
              0);
    const char* sz = lua_tostring(L, -1);
    
    printf("call stack %s\n",sz);
}


int LegendGetResourcePath(lua_State *L)
{
    std::string path = CCFileUtils::sharedFileUtils()->getResourcePath();
    lua_pushlstring(L, path.c_str(), path.size());
    return 1;
}

int CCLuaEngine::executeLayerTouchesEvent(CCLayer* pLayer, int eventType, CCSet *pTouches)
{
    CCTouchScriptHandlerEntry* pScriptHandlerEntry = pLayer->getScriptTouchHandlerEntry();
    
    if(pScriptHandlerEntry==NULL)
    {
        return 0;
    }
    
    int nHandler = pScriptHandlerEntry->getHandler();
    if (!nHandler) return 0;
    
    switch (eventType)
    {
        case CCTOUCHBEGAN:
            m_stack->pushString("began");
            break;
            
        case CCTOUCHMOVED:
            m_stack->pushString("moved");
            break;
            
        case CCTOUCHENDED:
            m_stack->pushString("ended");
            break;
            
        case CCTOUCHCANCELLED:
            m_stack->pushString("cancelled");
            break;
            
        default:
            return 0;
    }

    CCDirector* pDirector = CCDirector::sharedDirector();
    lua_State *L = m_stack->getLuaState();
    lua_newtable(L);
    int i = 1;
    for (CCSetIterator it = pTouches->begin(); it != pTouches->end(); ++it)
    {
        CCTouch* pTouch = (CCTouch*)*it;
        CCPoint pt = pDirector->convertToGL(pTouch->getLocationInView());
        lua_pushnumber(L, pt.x);
        lua_rawseti(L, -2, i++);
        lua_pushnumber(L, pt.y);
        lua_rawseti(L, -2, i++);
    }
    return m_stack->executeFunctionByHandler(nHandler, 2);
}

int CCLuaEngine::executeLayerKeypadEvent(CCLayer* pLayer, int eventType)
{
    CCScriptHandlerEntry* pScriptHandlerEntry = pLayer->getScriptKeypadHandlerEntry();
    int nHandler = pScriptHandlerEntry->getHandler();
    if (!nHandler) return 0;
    
    switch (eventType)
    {
        case kTypeBackClicked:
            m_stack->pushString("backClicked");
            break;
            
        case kTypeMenuClicked:
            m_stack->pushString("menuClicked");
            break;
            
        default:
            return 0;
    }
    return m_stack->executeFunctionByHandler(nHandler, 1);
}

int CCLuaEngine::executeAccelerometerEvent(CCLayer* pLayer, CCAcceleration* pAccelerationValue)
{
    CCScriptHandlerEntry* pScriptHandlerEntry = pLayer->getScriptAccelerateHandlerEntry();
    int nHandler = pScriptHandlerEntry->getHandler();
    if (!nHandler) return 0;
    
    m_stack->pushFloat(pAccelerationValue->x);
    m_stack->pushFloat(pAccelerationValue->y);
    m_stack->pushFloat(pAccelerationValue->z);
    m_stack->pushFloat(pAccelerationValue->timestamp);
    return m_stack->executeFunctionByHandler(nHandler, 4);
}

int CCLuaEngine::executeEvent(int nHandler, const char* pEventName, CCObject* pEventSource /* = NULL*/, const char* pEventSourceClassName /* = NULL*/)
{
    m_stack->pushString(pEventName);
    if (pEventSource)
    {
        m_stack->pushCCObject(pEventSource, pEventSourceClassName ? pEventSourceClassName : "CCObject");
    }
    return m_stack->executeFunctionByHandler(nHandler, pEventSource ? 2 : 1);
}

bool CCLuaEngine::executeAssert(bool cond, const char *msg/* = NULL */)
{
    return m_stack->executeAssert(cond, msg);
}

void CCLuaEngine::reset()
{
    if(m_stack!=NULL)
    {
        m_stack->release();
        m_stack = NULL;
    }
    CCLuaStack * lst = CCLuaStack::create();
     lst->retain();
    this->m_stack = lst;
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#else
    std::string path = CCFileUtils::sharedFileUtils()->fullPathForFilename("data/hello.lua",false);
    std::string datapath = path.substr(0, path.find_last_of("/"));
    this->addSearchPath(datapath.c_str());
#endif
 
}

int CCLuaEngine::requirex(const char *modName)
{
	CCLog("[CCLuaEngine|requirex] load lua file,name:%s", modName);
    CCString *xx = CCString::createWithFormat("require \"%s\"\n", modName);
    int ret = this->executeString(xx->getCString());
    xx->release();
    return ret;
}

void CCLuaEngine::start()
{
    lua_State *L = this->getLuaStack()->getLuaState();
    //step 1.
    luaopen_LegendLuaInterface(L);
    
    //step 2
    lua_pushinteger(L,g_restartFlag);
    lua_setfield(L, LUA_GLOBALSINDEX, "LegendLuaReset");
    
	lua_pushinteger(L, CC_TARGET_PLATFORM);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendPlatformFLAG");
    this->requirex("hello");
//#endif
}

NS_CC_END
