
#ifndef __LUACOCOS2D_H_
#define __LUACOCOS2D_H_

extern "C" {
#include "tolua++.h"
#include "tolua_fix.h"
}

#include <map>
#include <string>
#include "tolua_fix.h"
#include "cocos2d.h"
#include "cocos-ext.h"
#include "LegendAnimation.h"
#include "LegendAminationEffect.h"
#include "LoadResources.h"
#include "CCLuaEngine.h"
#include "SimpleAudioEngine.h"
#include "CCMultiSprite.h"
#include "shaders/CCShaderCache.h"
#include "../../protocol/game_idl.h"
using namespace cocos2d;
using namespace CocosDenshion;
using namespace cocos2d::extension;
using namespace Legend;
using namespace dfont;
TOLUA_API int tolua_Cocos2d_open(lua_State* tolua_S);

#endif // __LUACOCOS2D_H_
