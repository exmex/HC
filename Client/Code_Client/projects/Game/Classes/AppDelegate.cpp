#include "cocos2d.h"
#include "AppDelegate.h"
#include "SimpleAudioEngine.h"
#include "script_support/CCScriptSupport.h"
#include "CCLuaEngine.h"
#include "AssetsManager.h"
#include "LegendAnimationFileInfo.h"
#include "apiforlua.h"
#include "GateKeeper.h"
#include "GamePlatformInfo.h"
#include "UpdateLoader.h"
#include "SeverConsts.h"
#include "PayForPlatform.h"
#include "Language.h"
#include "DataTableManager.h"
USING_NS_CC;
using namespace CocosDenshion;
USING_NS_CC_EXT;

#ifdef WIN32
void accelerometerKeyHook(UINT message, WPARAM wParam, LPARAM lParam)
{
	if (message == WM_KEYUP)
	{
		//Ctrl Pressed
		if (GetKeyState(VK_CONTROL) < 0)
		{
			//Ctrl + 'T' To Dump TextureCache
			if (wParam == 'T')
				CCTextureCache::sharedTextureCache()->dumpCachedTextureInfo();
			if (wParam == 'Q')
			{
				//g_AppDelegate->purgeCachedData();
			}
			//逐帧卸载
			//CreatAndLoad
			//Load
			//unload
			//奔溃，野指针，资源泄露
			if (wParam == 'U')
			{
				//load all ccbi in "ccbi" folder to check the ccbi's resource validation, for example, file lost, multiple name found and so on by zhenhui
				//ResManager::Get()->checkCCBIResource();
			}
			if (wParam == 'O')
			{
				//CCSpriteFrameCache::sharedSpriteFrameCache()->removeUnusedSpriteFramesPerFrame();
				//CCTextureCache::sharedTextureCache()->removeUnusedTexturesPerFrame();
			}
		}
	}
}
#endif

AppDelegate::AppDelegate()
{

}

AppDelegate::~AppDelegate()
{
    // end simple audio engine here, or it may crashed on win32
    SimpleAudioEngine::sharedEngine()->end();
}

bool AppDelegate::applicationDidFinishLaunching()
{

	g_time_factor = 1.0;

    // initialize director
    CCDirector *pDirector = CCDirector::sharedDirector();
    pDirector->setOpenGLView(CCEGLView::sharedOpenGLView());

	if (this->getTargetPlatform() == kTargetIpad)
	{
		CCEGLView::sharedOpenGLView()->setDesignResolutionSize(800, 480, kResolutionShowAll);
	}
	else
	{
		CCSize viewSize = CCEGLView::sharedOpenGLView()->getFrameSize();
		float rate = viewSize.width / viewSize.height;
		if (rate < 1.5)
		{
			CCEGLView::sharedOpenGLView()->setDesignResolutionSize(800, 480, kResolutionShowAll);
		}
		else
		{
			CCEGLView::sharedOpenGLView()->setDesignResolutionSize(800, 480, kResolutionNoBorder);
		}
	}

    // turn on display FPS
#if defined(_DEBUG) || (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
	// turn on display FPS
	pDirector->setDisplayStats(true);
#endif

    // set FPS. the default value is 1.0/60 if you don't call this
    pDirector->setAnimationInterval(1.0 / 60);
	//调度器优先更新
	//pDirector->getScheduler()->scheduleUpdateForTarget(this, -1, false);

#ifdef WIN32
	//设置键盘事件回调
	CCEGLView::sharedOpenGLView()->setAccelerometerKeyHook(accelerometerKeyHook);
#endif
	//add by xinghui
	SeverConsts::Get()->initSearchPath();
	SeverConsts::Get()->setOriginalSearchPath();
	SeverConsts::Get()->setAdditionalSearchPath();

	Language::Get()->clear();

	int languageIndex = (int)cocos2d::CCApplication::sharedApplication()->getCurrentLanguage();

	std::string langType = CCUserDefault::sharedUserDefault()->getStringForKey("client_language");
	if (langType == "")
	{
		if (languageIndex >= SeverConsts::languageTyoes->size())
		{
			langType = "en-US";
		}
		else
		{
			langType = SeverConsts::languageTyoes[languageIndex];
		}
	}
	if (langType == "zh-CN")
	{
		langType = "en-US";
	}
	
	std::string langFile = "Lang/language" + langType + ".lang";
	bool isFileExit = cocos2d::CCFileUtils::sharedFileUtils()->isFileExist(langFile);
	if (isFileExit)
	{
		Language::Get()->init(langFile.c_str());
	}
	else
	{
		Language::Get()->init("Lang/languageen-US.lang");
	}

	GamePlatformInfo::getInstance()->registerPlatform();

	PayForPlatform::Get()->init();
	CUpdateLoader* pUpdateLoader = CUpdateLoader::create();
	CCScene* pScene = CCScene::create();
	pScene->addChild(pUpdateLoader);
	CCDirector::sharedDirector()->runWithScene(pScene);

    //libOS::getInstance()->getSecondsFromGMT();
    return true;

}

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground()
{
    CCDirector::sharedDirector()->stopAnimation();
    SimpleAudioEngine::sharedEngine()->pauseBackgroundMusic();
	didEnterGround(1);
	//modify by xinghui:exit the app when enter background while updateing
	if (SeverConsts::Get()->checkUpdateState() == SeverConsts::US_DOWNLOADING)
	{
		exit(0);
	}
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    CCDirector::sharedDirector()->startAnimation();

	CCLOG("%s %d: applicationWillEnterForeground 1", __FILE__, __LINE__);
	std::string privateLogin = VaribleManager::Get()->getSetting("privatePause", "", "false");
	if (privateLogin != "true")
	{
		if (!SeverConsts::Get()->GetIsInLoading())
		{
			libPlatformManager::getPlatform()->gamePause();
		}
	}
	if (g_soundSwitch) {
				
		//CCTime::gettimeofdayCocos2d(&tv, NULL);
		
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
		SimpleAudioEngine::sharedEngine()->resumeBackgroundMusic();
#else
		SimpleAudioEngine::sharedEngine()->resumeBackgroundMusic();
#endif
		//SimpleAudioEngine::sharedEngine()->();
	}
	didEnterGround(2);
}

void AppDelegate::applicationWillGoToExit(void)
{
	CCLOG("AppDelegate::applicationWillGoToExit()");
}

void AppDelegate::purgeCachedData(void)
{
	CCLOG("AppDelegate::purgeCachedData()");
}
