#pragma once
#include "lib91.h"
#include "libPP.h"
#include "libAG.h"
#include "libTB.h"
#include "libITools.h"
#include "lib91Debug.h"
#include "lib91Quasi.h"
#include "libAppStore.h"
#include "libYouai.h"
#include "libKuaiyong.h"
#include "libCmge.h"
#include "lib37wanwan.h"
#include "libUC.h"
#include "lib49app.h"
#include "libDownJoy.h"

class GamePlatformInfo
{
	static GamePlatformInfo *m_sInstance;
	std::string platFormName;
	std::string platVersionName;
public:
	
	void init(bool isRegPlat=false);
	void registerPlatform();
	std::string getPlatFormName() { return platFormName;};
	std::string getPlatVersionName() { return platVersionName;}
	static GamePlatformInfo* getInstance();
};