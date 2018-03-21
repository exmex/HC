#include "UpdateLoader.h"
#include "SeverConsts.h"
#include "GamePlatformInfo.h"
#include "DataTableManager.h"
#include "Language.h"
#include "AssetsManager.h"
#include "GateKeeper.h"
#include "script_support/CCScriptSupport.h"
#include "CCLuaEngine.h"
#include "StringConverter.h"
#include "GameMaths.h"
#include "Gamelua.h"
#include "apiforlua.h"
#include <math.h>
#include "HeroFileUtils.h"
#include "CCBContainer.h"


USING_NS_CC;
USING_NS_CC_EXT;

#define Z_ORDER_PROGRESS_TIMER 1000
#define Z_ORDER_BG	50


CUpdateLoader::CUpdateLoader() :m_b91Checked(false), m_pProgressTimer(NULL), m_pPersentageTTF(NULL), mIsUpdateDown(false), mLogined(false), m_pUpdateProgress(NULL), m_pLightLayer(NULL), m_pLightSprite(NULL)
{
	spineCount = 0;
	dragonCount = 0;
	m_pArmature = NULL;
	spineContainer = NULL;
	s_htmlLabel=NULL;
	libOS::getInstance()->registerListener(this);
	libPlatformManager::getPlatform()->registerListener(this);
	SeverConsts::Get()->init(GamePlatformInfo::getInstance()->getPlatVersionName());
}


CUpdateLoader::~CUpdateLoader()
{
	libOS::getInstance()->removeListener(this);
	libPlatformManager::getPlatform()->removeListener(this);
}

bool CUpdateLoader::init()
{
	return CCNode::init();
}

void CUpdateLoader::onEnter()
{
	CCNode::onEnter();
	mNetWorkNotWorkMsgShown = false;
	CCSize size = CCDirector::sharedDirector()->getVisibleSize();
	//progressTimer
	m_pSprite = CCSprite::create(VaribleManager::Get()->getSetting("UpdateProgressBG", "", "installer/loading_bar_bg.png").c_str());
	m_pUpdateProgress = CCSprite::create(VaribleManager::Get()->getSetting("UpdateProgressBar", "", "installer/loading_bar.png").c_str());

	if (m_pSprite && m_pUpdateProgress)
	{
		m_pSprite->setPosition(ccp(400, 60));
		this->addChild(m_pSprite, Z_ORDER_PROGRESS_TIMER + 1);

		m_pUpdateProgress->setAnchorPoint(ccp(0, 0));
		m_pUpdateProgress->setPosition(ccp(0, 8));
		m_pSprite->addChild(m_pUpdateProgress);
		m_pUpdateProgress->setTextureRect(CCRectMake(0, 0, 0, 25));


		m_pLightLayer = CCLayer::create();
		m_pLightLayer->setClipRect(CCRectMake(15, -240, 400, 480));
		m_pSprite->addChild(m_pLightLayer);

		m_pLightSprite = CCSprite::create("installer/loading_bar_light.png");
		m_pLightSprite->setAnchorPoint(ccp(0.9, 0));
		m_pLightSprite->setPosition(ccp(0, 0));
		m_pLightLayer->addChild(m_pLightSprite);
	}

	//
	m_pPersentageTTF = CCLabelTTF::create();
	if (m_pPersentageTTF)
	{
		m_pPersentageTTF->setFontSize(20.0f);
		m_pPersentageTTF->setColor(ccWHITE);
		m_pPersentageTTF->setPosition(ccpAdd(m_pSprite->getPosition(), ccp(0, 30)));
		this->addChild(m_pPersentageTTF, Z_ORDER_PROGRESS_TIMER + 1);
	}
	std::string loadText = Language::getInstance()->getString("@LoadText");
	m_pPersentageTTF->setString(loadText.c_str());
	//

	CCSprite* bgSprite = CCSprite::create("installer/splash.jpg");
	if (bgSprite)
	{
		bgSprite->setPosition(ccp(size.width / 2, size.height / 2));
		this->addChild(bgSprite, Z_ORDER_BG);
	}

	//进行updateloader的UI初始化以及内更新的检测
	//UI可直接使用原生的创建方法，不一类第三方UI文件，例如ccbi,ccc等



	std::string privateLogin = VaribleManager::Get()->getSetting("privateLogin", "", "false");
	if (privateLogin != "true")
	{
		libPlatformManager::getPlatform()->init();
	}
	else
	{
		libPlatformManager::getPlatform()->init(true);
	}
	scheduleUpdate();
}

void CUpdateLoader::onExit()
{

	if (s_htmlLabel)
	{
		s_htmlLabel->removeFromParentAndCleanup(true);
	}

	CCNode::onExit();
	if (m_pProgressTimer)
	{
		m_pProgressTimer->removeFromParentAndCleanup(true);
		m_pProgressTimer = NULL;
	}
	if (m_pLightSprite)
	{
		m_pLightSprite->removeFromParentAndCleanup(true);
		m_pLightSprite = NULL;
	}
	if (m_pLightLayer)
	{
		m_pLightLayer->removeFromParentAndCleanup(true);
		m_pLightLayer = NULL;
	}
	if (m_pUpdateProgress)
	{
		m_pUpdateProgress->removeFromParentAndCleanup(true);
		m_pUpdateProgress = NULL;
	}
	if (m_pSprite)
	{
		m_pSprite->removeAllChildrenWithCleanup(true);
		m_pSprite->removeFromParentAndCleanup(true);
		m_pSprite = NULL;
	}
	if (m_pPersentageTTF)
	{
		m_pPersentageTTF->removeFromParentAndCleanup(true);
		m_pPersentageTTF = NULL;
	}
	if (m_pArmature)
	{
		std::string resourcePath = m_pArmature ? m_pArmature->getResourcePath() : "";
		ArmatureContainer::clearResource(resourcePath);
		m_pArmature->removeFromParent();
		m_pArmature = NULL;
	}
	if (spineContainer)
	{
		spineContainer->removeFromParent();
		spineContainer = NULL;
	}
	
	unscheduleUpdate();
}

void CUpdateLoader::update(float delta)
{
	CCNode::update(delta);

	SeverConsts::Get()->update(delta);

	static SeverConsts::CHECK_STATE checkState = SeverConsts::CS_NOT_STARTED;

	if (checkState != SeverConsts::Get()->checkUpdateInfo())
	{
		checkState = SeverConsts::Get()->checkUpdateInfo();

		if (checkState == SeverConsts::CS_NEED_UPDATE &&
			SeverConsts::Get()->checkUpdateState() == SeverConsts::US_NOT_STARTED)
		{
			if (m_pSprite)
			{
				m_pSprite->setVisible(true);
			}
			std::string strMsg;
			float fsizem = SeverConsts::Get()->getNeedUpdateTotalBytes();
			char szTmp[256] = { 0 };
			if (fsizem < 1024u)
				sprintf(szTmp, "(1Kb)");
			else if (fsizem < 1024u * 1024u)
				sprintf(szTmp, "(%dKb)", (int)fsizem / 1024);
			else
				sprintf(szTmp, "(%fM)", fsizem / 1024.f / 1024.f);

			if (libOS::getInstance()->getNetWork() == ReachableViaWWAN)
			{
				strMsg = Language::Get()->getString("@LOADINGFRAME_NeedUpdate3G");
			}
			else
			{
				strMsg = Language::Get()->getString("@LOADINGFRAME_NeedUpdate");
			}

			std::string strUpdateMsg = SeverConsts::Get()->getNeedUpdateMsg();

			if (!strUpdateMsg.empty())
			{
				strUpdateMsg.append("\n");
				strUpdateMsg.append(strMsg);
			}
			else
			{
				strUpdateMsg = strMsg;
			}

			libOS::getInstance()->showMessagebox(strUpdateMsg, 100);

		}
		else if (checkState == SeverConsts::CS_NEED_STORE_UPDATE)
		{
			unsigned int isUsePrivateBigVersionUpdate = 1;

#ifdef WIN32
			isUsePrivateBigVersionUpdate = 1;
#else
			const PlatformRoleItem* item = PlatformRoleTableManager::Get()->getPlatformRoleByName(libPlatformManager::getPlatform()->getClientChannel());
			if (item)
			{
				isUsePrivateBigVersionUpdate = item->isUsePrivateBigVersionUpdate;
			}
#endif
			if (isUsePrivateBigVersionUpdate == 1)
			{
				std::string strMsg = SeverConsts::Get()->getDirectDownloadMsg();
				strMsg.append("\n");
				if (libOS::getInstance()->getNetWork() == ReachableViaWWAN)
				{
					strMsg.append(Language::Get()->getString("@LOADINGFRAME_NeedUpdate3G"));
				}
				libOS::getInstance()->showMessagebox(strMsg, 110);
			}
			else
			{
#ifdef PROJECTYOUAIKY
				libPlatformManager::getPlatform()->login();
#endif
			}
			SeverConsts::Get()->clearVersion();
		}
		else if (checkState == SeverConsts::CS_FAILED)
		{
			//todo:update failed
		}
	}

	static SeverConsts::UPDATE_STATE updatestate = SeverConsts::US_NOT_STARTED;

	if (updatestate != SeverConsts::Get()->checkUpdateState())
	{
		updatestate = SeverConsts::Get()->checkUpdateState();
		if (updatestate == SeverConsts::US_CHECKING)
		{
			//todo: update checking
		}else if (updatestate == SeverConsts::US_DOWNLOADING)
		{
			//todo: updating
		}else if (updatestate ==SeverConsts::US_FAILED)
		{
			//todo: update failed
		}
	}
	bool restartGame = CCUserDefault::sharedUserDefault()->getBoolForKey("restartGame", false);

	if (checkState == SeverConsts::CS_OK && (m_b91Checked || restartGame) && !mIsUpdateDown)
	{
		if (updatestate == SeverConsts::US_OK)
		{

			//做完内更新再次加载PlatformRole.txt
			PlatformRoleTableManager::Get()->init("txt/PlatformRoleConfig.txt");
			std::string loadingSceneMsg = Language::Get()->getString("@loading2");
			const PlatformRoleItem* item = PlatformRoleTableManager::Get()->getPlatformRoleByName(libPlatformManager::getPlatform()->getClientChannel());
			if (item)
			{
				loadingSceneMsg = item->loadinScenceMsg;
			}
		}
		m_pUpdateProgress->setTextureRect(CCRectMake(0, 0, 376, 25));
		m_pLightSprite->setPosition(ccp(318, 0));
		showUpdateDone();
		//EnterGame();
	}

	if (updatestate == SeverConsts::US_DOWNLOADING)
	{
		unsigned long total = SeverConsts::Get()->getUpdateTotalCount();
		unsigned long done = SeverConsts::Get()->getUpdatedCount();
		if (total > 0)
		{
			float per = (float)done / (float)total;
			std::string _sizeTip = "";
			if (m_pUpdateProgress)
			{
				/*m_pUpdateProgress->setScaleX(per);
				m_pUpdateProgress->setPositionX(20 * (1 - per));*/

				float width = 376;
				float height = 25;
				width = width * per;
				m_pUpdateProgress->setTextureRect(CCRectMake(0, 0, width, height));
				m_pLightSprite->setPosition(ccp(width-2, 1));
			}
			std::list<std::string> replaceList;
			replaceList.push_back(StringConverter::toString(done / 1024));
			replaceList.push_back(StringConverter::toString(total / 1024));
			std::string s = GameMaths::replaceStringWithStringList(Language::Get()->getString("@UpdateSizeInfo"), &replaceList);
			if (m_pPersentageTTF)
			{
				m_pPersentageTTF->setString(s.c_str());
			}
		}
	}

}

void CUpdateLoader::showUpdateDone()
{
	
	CCUserDefault::sharedUserDefault()->setBoolForKey("restartGame", false);

	if (!mIsUpdateDown)
	{
		libOS::getInstance()->setWaiting(false);
	}
	mIsUpdateDown = true;

	if (!mLogined)
	{
//#ifdef WIN32
//		std::string puidKey = "LastLoginPUID";
//		std::string strPuid = CCUserDefault::sharedUserDefault()->getStringForKey(puidKey.c_str(), "");
//		//EnterGame();
//
//		libPlatformManager::getPlatform()->_boardcastLoginResult(true, "");
//
//		if (strPuid.length()>0)
//		{
//			lib91::setLoginName(strPuid);
//		}
//#else
//		libPlatformManager::getPlatform()->login();
//#endif
		EnterGame();
		//_initRichFont();
	}
}

void CUpdateLoader::onUpdate(libPlatform*, bool ok, std::string msg)
{
	if (!ok)
	{
		m_b91Checked = false;
		libOS::getInstance()->showMessagebox(msg);
	}
	else
	{
		if (!m_b91Checked)
		{
			m_b91Checked = true;
			SeverConsts::Get()->start();
		}
	}
}





void CUpdateLoader::onInputboxEnter(const std::string& content)
{
	gPuid = content;
}

void CUpdateLoader::onMessageboxEnter(int tag)
{
	//cocos2d::CCLog("CUpdateLoader::onMessageboxEnter @@@@@@@@@@@@@@@ %d",tag);
	if (tag == 100)
	{
		//cocos2d::CCLog("tag == 100 @@@@@@@@@@@@@@@ true");
		SeverConsts::Get()->updateResources();
	}
	else if (tag == 110)
	{
#if defined(ANDROID)
		//cocos2d::CCLog("#if defined(ANDROID) @@@@@@@@@@@@@@@ true");
		libOS::getInstance()->openURL(SeverConsts::Get()->getDirectDownloadUrl());
#else
		if (VaribleManager::Get()->getSetting("useInsideAppUpdate") != "true")
		{
			if (!SeverConsts::Get()->getDirectDownloadUrl().empty() && SeverConsts::Get()->getDirectDownloadUrl().length() > 5)
			{
				libOS::getInstance()->openURL(SeverConsts::Get()->getDirectDownloadUrl());
			}
			else
			{
#if defined(PROJECTAPPSTORE)
                libOS::getInstance()->openURLHttps(SeverConsts::Get()->getInStoreUpdateAddress());
#else
                libOS::getInstance()->openURL(SeverConsts::Get()->getInStoreUpdateAddress());
#endif
				
			}
		}
		else
		{
			libPlatformManager::getInstance()->getPlatform()->updateApp();
		}
#endif
	}
	else if (tag == Err_CheckingFailed)
	{
		exit(0);
	}
	else if (tag == Err_UpdateFailed)
	{
		exit(0);
	}
	else if (tag == Err_ConnectFailed)
	{
	}
	else if (tag == Err_ErrMsgReport)
	{
		
	}
	else if (tag == 120)
	{
		mNetWorkNotWorkMsgShown = false;
	}
}

void CUpdateLoader::initSpine(void)
{
	spineContainer = SpineContainer::create("spine/MonthCard", "MonthCardSpine");
	spineContainer->setListener(this);
	spineContainer->runAnimation(0, "TheThirdStage", 1);
	CCSize size = CCDirector::sharedDirector()->getVisibleSize();
	spineContainer->setPosition(600, 100);
	spineContainer->setScale(1.0f);
	this->addChild(spineContainer,1000);

	m_pArmature = ArmatureContainer::create("dragonBone/levelUp", "levelUp", NULL);
	m_pArmature->setListener(this);
	m_pArmature->setScale(0.5f);
	CCSize winSize = CCDirector::sharedDirector()->getVisibleSize();
	m_pArmature->setPosition(200.0f,300.0f);
	this->addChild(m_pArmature, 1000);
	//CCDirector::sharedDirector()->setAnimationInterval(1.0 / 12);
	if (m_pArmature)m_pArmature->runAnimation("Upgrade", 1000);
}

void CUpdateLoader::onSpineAnimationComplete(int trackIndex, const char* animationName, int loopCount)
{
	spineCount++;
	if (spineContainer)
	{
		spineContainer->runAnimation(0, (spineCount % 2 == 1) ? "MilkShake" : "TheThirdStage", 1); CCLog("CUpdateLoader:onSpineAnimationComplete|%d event: %s, %d", trackIndex, animationName, loopCount);
	}
}

void CUpdateLoader::onSpineAnimationEvent(int trackIndex, const char* animationName, spEvent* event)
{
	if (event)
	{
		CCLog("CUpdateLoader:onSpineAnimationEvent|%d event: %s, %d, %f, %s", trackIndex, event->data->name, event->intValue, event->floatValue, event->stringValue);
	}
}

void CUpdateLoader::removeSpine(void)
{

}

void CUpdateLoader::onArmatureAnimationDone(const char* animationName, bool isLoop)
{
	if (!isLoop)
	{
		//MSG_BOX(CCString::createWithFormat("complete moveId: %s", animationName)->m_sString);
	}
	else
	{
		//MSG_BOX(CCString::createWithFormat("loop complete movdId: %s", animationName)->m_sString);
	}
}

void CUpdateLoader::onFrameEvent(std::string eventName, CCBone* bone)
{
	dragonCount++;
	CCLog("on Frame Event: %s", eventName.c_str());
	if (eventName == "BeforeLevel")
	{
		CCLabelTTF* beforeLabel = CCLabelTTF::create("23", "Helvetica", 28);
		m_pArmature->changeSkin(bone, beforeLabel);
	}
	else if (eventName == "ResultLevel")
	{
		CCLabelTTF* resultLabel = CCLabelTTF::create("24", "Helvetica", 28);
		m_pArmature->changeSkin(bone, resultLabel);
	}
}

void CUpdateLoader::onHTMLClicked(
	IRichNode* root, IRichElement* ele, int _id)
{
	CCLog("[On Clicked] id=%d", _id);

	if (!s_htmlLabel)
	{
		return;
	}
	else if (_id == 1002) // close
	{
		s_htmlLabel->setVisible(false);
		EnterGame();
	}
	else if (_id == 2000) //reload
	{
		CCString* str_utf8 = CCString::createWithContentsOfFile(LegendFindFileCpp("html/html.htm").c_str());
		if (str_utf8)
		{
			s_htmlLabel->setString(str_utf8->getCString());
		}
	}
}

void CUpdateLoader::onHTMLMoved(
	IRichNode* root, IRichElement* ele, int _id,
	const CCPoint& location, const CCPoint& delta)
{
	CCLog("[On Moved] id=%d", _id);

	if (!s_htmlLabel)
	{
		return;
	}
	else if (_id == 1001)
	{
		s_htmlLabel->setPosition(ccpAdd(delta, s_htmlLabel->getPosition()));
	}
}


bool CUpdateLoader::ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent)
{
	return true;
}

void CUpdateLoader::ccTouchMoved(CCTouch *pTouch, CCEvent *pEvent)
{
}


bool CUpdateLoader::_initRichFont()
{
	using namespace dfont;

	CCSize vsize = CCDirector::sharedDirector()->getVisibleSize();
	CCString* str_utf8 = CCString::createWithContentsOfFile(LegendFindFileCpp("html/html.htm").c_str());
	if (str_utf8)
	{
		std::string str(str_utf8->getCString());
		s_htmlLabel = CCHTMLLabel::createWithString(str.c_str(), CCSize(vsize.width*0.8f, vsize.height));
		s_htmlLabel->setAnchorPoint(ccp(0.5f, 0.5f));
		s_htmlLabel->setPosition(ccp(vsize.width*0.5f, vsize.height*0.5f));

		addChild(s_htmlLabel, 10001,10001);
		s_htmlLabel->registerListener(this, &CUpdateLoader::onHTMLClicked, &CUpdateLoader::onHTMLMoved);
	}
	return true;
}

void CUpdateLoader::EnterGame()
{
	CCBContainer::setCCBFilePath(std::string("ccbi/"));

	CCScriptEngineManager::purgeSharedManager();
	CCLuaEngine* pEngine = CCLuaEngine::defaultEngine();
	CCScriptEngineManager::sharedManager()->setScriptEngine(pEngine);
	pEngine->reset();
	lua_State *L = pEngine->getLuaStack()->getLuaState();
	lua_getfield(L, LUA_GLOBALSINDEX, "patch_servers");
	size_t osize = lua_objlen(L, -1);
	std::vector<std::string> serverdirs;
	for (int i = 1; i <= osize; i++)
	{
		lua_pushinteger(L, i);
		lua_gettable(L, -2);
		const char* url = lua_tostring(L, -1);
		lua_settop(L, -2);
		serverdirs.push_back(url);
	}

	tolua_Gamelua_open(pEngine->getLuaStack()->getLuaState());

	pEngine->start();
}

