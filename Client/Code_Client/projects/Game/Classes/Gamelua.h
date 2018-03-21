
extern "C" {
#include "tolua++.h"
#include "tolua_fix.h"
}

#include <map>
#include <string>
#include "tolua_fix.h"
#include "cocos2d.h"
#include "cocos-ext.h"
#include "CCLuaEngine.h"
#include "SimpleAudioEngine.h"

TOLUA_API int tolua_Gamelua_open (lua_State* tolua_S);