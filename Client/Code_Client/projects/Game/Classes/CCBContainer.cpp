
#include "stdafx.h"

#include "CCBContainer.h"
#include "Language.h"
#include "script_support/CCScriptSupport.h"
#include "CCLuaEngine.h"
#include "HeroFileUtils.h"
#include <algorithm>
USING_NS_CC;
USING_NS_CC_EXT;

#define RUN_SCRIPT_FUN(funname) \
if (mScriptFunHandler) \
{ \
	cocos2d::CCLuaEngine* pEngine = cocos2d::CCLuaEngine::defaultEngine(); \
	pEngine->executeEvent(mScriptFunHandler, funname, this, "CCBContainer"); \
}

CCBContainer::CCBContainer(CCBContainerListener* ccContainerListener, int tag)
	:mActionManager(0)
	,mCCBContainerListener(ccContainerListener)
	,mCCBTag(tag)
{
	
}

CCBContainer::CCBContainer( void )
	:mActionManager(0)
	,mCCBContainerListener(0)
	,mCCBTag(0)
{
	
}


void CCBContainer::setListener( CCBContainerListener* listener , int tag)
{
	mCCBContainerListener = listener;
	mCCBTag = tag;
}

void CCBContainer::setAllChildColor(unsigned char r, unsigned char g, unsigned char b)
{
	//
	ccColor3B c;
	c.r = r;
	c.g = g;
	c.b = b;
	for (VARIABLE_MAP::iterator it = mVariables.begin(); it != mVariables.end(); it++)
	{
		CCNodeRGBA *pSpr = dynamic_cast<CCNodeRGBA*>(it->second);
		if (!pSpr)
			continue;

		//
		pSpr->setColor(c);	
	}// end for
}

CCBContainer::~CCBContainer(void)
{
	unload();
}

void CCBContainer::loadCcbiFile( const std::string& filename, bool froceLoad/* = false*/ )
{
	clock_t start,end;
	start = clock();
	if(getLoaded())
	{
		if(froceLoad)
		{
			unload();
		}
		else
		{
			return;
		}
	}
	mLoadedCCBFile = filename;
	/* Create an autorelease CCNodeLoaderLibrary. */
	cocos2d::extension::CCNodeLoaderLibrary * ccNodeLoaderLibrary = cocos2d::extension::CCNodeLoaderLibrary::newDefaultCCNodeLoaderLibrary();
	/* Create an autorelease CCBReader. */
	cocos2d::extension::CCBReader * ccbReader = new cocos2d::extension::CCBReader(ccNodeLoaderLibrary,this);
	ccbReader->setCCBFilePath(CCBContainer::s_ccbFilePath.c_str());

	/* Read a ccbi file. */
	std::string fullPath = LegendFindFileCpp(filename.c_str());
	if (fullPath.empty())
	{
		cocos2d::CCMessageBox(filename.c_str(), "ccbi file missing");
		return;
	}
	cocos2d::CCNode *node = ccbReader->readNodeGraphFromFile(fullPath.c_str(),this);

	mActionManager = ccbReader->getAnimationManager();
	//mActionManager->runAnimations("Default");
	mActionManager->retain();
	mActionManager->setAnimationCompletedCallback(this,callfunc_selector(CCBContainer::_animationDone));
	ccbReader->release();
	if(node)
	{
		this->replaceStringKey(node);
		addChild(node);
		setContentSize(node->getContentSize());
	}
	else
	{
		char msgStr[512]={0};
		sprintf(msgStr,"CCBContainer.loadCcbiFile %s Failed",filename.c_str());
		//MSG_BOX(msgStr);
		cocos2d::CCMessageBox(msgStr, "loadccbifile failed");
	}
	end = clock();
	CCLOG("[CCBContainer] CCBContainer::loadCcbiFile| completed load ccbi file: %s,use Times:%d ms!", mLoadedCCBFile.c_str(),(int)(end-start));
}

void CCBContainer::playAutoPlaySequence()
{
	if (mActionManager && mActionManager->getAutoPlaySequenceId() != -1 && !mActionManager->jsControlled)
	{
		mActionManager->runAnimationsForSequenceIdTweenDuration(mActionManager->getAutoPlaySequenceId(), 0);
	}
}

bool CCBContainer::hasAnimation(const std::string& actionname)
{
	if (!mActionManager)
	{
		return false;
	}

	int seqId = mActionManager->getSequenceId(actionname.c_str());
	if (seqId >= 0)
	{
		return true;
	}

	return false;
}

void CCBContainer::runAnimation( const std::string& actionname )
{
	if(mActionManager)
	{
		int seqId = mActionManager->getSequenceId(actionname.c_str());
		if(seqId<0)
		{
			char outStr[256];
			sprintf(outStr,"Faild to run animation:%s",actionname.c_str());
			CCMessageBox(outStr,"error!");
			onAnimationDone(actionname);
			if(mCCBContainerListener)
				mCCBContainerListener->onAnimationDone(actionname);
		}
		else
		{
			mActionManager->runAnimations(actionname.c_str());
		}
	}
		
}

bool CCBContainer::onAssignCCBMemberVariable( cocos2d::CCObject* pTarget, const char* pMemberVariableName, cocos2d::CCNode* pNode )
{
	if(pTarget!=this) return false;
	//
	std::string var = pMemberVariableName;
	//CCBI文件自身保证不重名节点
	std::transform(var.begin(),var.end(),var.begin(),tolower);//xinzheng 2013-05-27 重做的一版资源 存在命名大小写出入，程序处理以支持
	VARIABLE_MAP::iterator it = mVariables.find(var);
	
	if(it!=mVariables.end())
	{
		if(it->second!=pNode)
		{
#ifdef _WIN32
			//检查在ccbi中是否有重名的变量 by zhenhui
			if (var != "")
			{
				char outStr[256];
				sprintf(outStr,"Multiple variable found in %s, variable name is :%s, please check ccbi resource",mLoadedCCBFile.c_str(),var.c_str());
				CCLOG(outStr);
				CCMessageBox(outStr,"Multiple variable found in ccbi");
			}		
#endif
			
			it->second->release();
			it->second = pNode;
			pNode->retain();
			return true;
		}
		else
			return true;
	}

	pNode->retain();
	mVariables.insert(std::make_pair(var,pNode));
	return true;
}

cocos2d::CCObject* CCBContainer::getVariable( const std::string& variablename )
{
	std::string var(variablename);
	std::transform(var.begin(),var.end(),var.begin(),tolower);//xinzheng 2013-05-27 重做的一版资源 存在命名大小写出入，程序处理以支持
	VARIABLE_MAP::iterator it = mVariables.find(var);
	if(it!=mVariables.end())
		return it->second;
	else
	{
#ifdef _DEBUG
		//add by zhenhui to check whether the variable is in the specific ccbi.
		/*char msg[256];
		sprintf(msg,"variable %s is not find in the ccbi %s!",variablename.c_str(),mLoadedCCBFile.c_str());
		cocos2d::CCMessageBox(msg,Language::Get()->getString("@ShowMsgBoxTitle").c_str());*/
#endif // _DEBUG
		return NULL;
	}
}

#define getVariableAs(_type_) \
	_type_* CCBContainer::get##_type_##FromCCB( const std::string& _var_ ) \
{ \
	CCObject* __obj__ = getVariable(_var_);\
	_type_* __node__ = __obj__?dynamic_cast<_type_*>(__obj__):0; \
	return __node__; \
};

getVariableAs(CCNode);
getVariableAs(CCSprite);
getVariableAs(CCScale9Sprite);
getVariableAs(CCLabelBMFont);
getVariableAs(CCLabelTTF);
//getVariableAs(CCBFileNew);
getVariableAs(CCMenuItemImage);
getVariableAs(CCScrollView);
getVariableAs(CCMenuItemCCBFile);


cocos2d::SEL_MenuHandler CCBContainer::onResolveCCBCCMenuItemSelectorWithSender( cocos2d::CCObject * pTarget, const char* pSelectorName, cocos2d::CCNode* sender )
{
	if(pTarget!=this)
		return NULL;
	std::string name = pSelectorName;
	MENUITEM_MAP::iterator it = mMenus.find(sender);
	if(it!=mMenus.end())
		it->second = name;
	else
		mMenus.insert(std::make_pair(sender,name));

	return menu_selector(CCBContainer::_menuItemClicked);
}

cocos2d::extension::SEL_CCControlHandler CCBContainer::onResolveCCBCCControlSelector(cocos2d::CCObject * pSender, const char* pSelectorName)
{
	return cccontrol_selector(CCBContainer::_onControlEvent);
}

void CCBContainer::registerTouchDispatcherSelf(int priority)
{
	CCDirector::sharedDirector()->getTouchDispatcher()->addTargetedDelegate(this, priority, true);
}

bool CCBContainer::ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent)
{
	return true;
}

void CCBContainer::_menuItemClicked( cocos2d::CCObject * pSender )
{
	
	MENUITEM_MAP::iterator it = mMenus.find(pSender);
	if(it!=mMenus.end())
	{
		CCMenuItem* menu = dynamic_cast<CCMenuItem*>(pSender);
		if (menu)
		{
			CCLOG("CCB:Button pressed! ccb:%s, func:%s, tag:%d", mLoadedCCBFile.c_str(), it->second.c_str(), menu->getTag());
		}
		else
		{
			CCLOG("CCB:Button pressed! ccb:%s, func:%s, tag:%d", mLoadedCCBFile.c_str(), it->second.c_str(), mCCBTag);
		}
		int ret = 0;
		if(CCScriptEngineManager::sharedManager()->getScriptEngine())
		{
			/*std::string luaName = mLoadedCCBFile;
			size_t lastdot = mLoadedCCBFile.find_last_of('.');
			if(lastdot!=std::string::npos)
			luaName = mLoadedCCBFile.substr(0,lastdot);
			std::string funname = luaName + "_"+ it->second;
			ret = CCScriptEngineManager::sharedManager()->getScriptEngine()->executeGlobalFunctionByName(funname.c_str(), this, "CCBContainer");*/
			std::string funcname = it->second;
			RUN_SCRIPT_FUN(funcname.c_str());
		}

		if(!ret)
		{
            if(pSender)
            {
                onMenuItemAction(it->second,pSender);
                if(mCCBContainerListener)
                    mCCBContainerListener->onMenuItemAction(it->second, pSender, mCCBTag);
            }
		}
	}
}

void CCBContainer::_onControlEvent(cocos2d::CCObject* pSender, CCControlEvent eventId)
{
	CCLog("eventID...........%u", eventId);
}

bool CCBContainer::getLoaded()
{
	return getChildrenCount()>0;
}

void CCBContainer::unload()
{

	if(mActionManager)mActionManager->release();
	mActionManager = 0;
	VARIABLE_MAP::iterator it = mVariables.begin();
	for(;it!=mVariables.end();++it)
		if(it->second)it->second->release();

	mVariables.clear();
	mMenus.clear();
	mCCBContainerListener = 0;
	removeAllChildren();
}


void CCBContainer::unregisterTouchDispatcherSelf()
{
	CCDirector::sharedDirector()->getTouchDispatcher()->removeDelegate(this);
}

void CCBContainer::onAnimationDone(const std::string& animationName)
{
	mCurAnimDoneName = animationName;
	RUN_SCRIPT_FUN("luaOnAnimationDone");
}

void CCBContainer::_animationDone()
{
	onAnimationDone(mActionManager->getLastCompletedSequenceName());
	if(mCCBContainerListener)
		mCCBContainerListener->onAnimationDone(mActionManager->getLastCompletedSequenceName());
}

bool CCBContainer::init()
{
	mCCBContainerListener = 0;;
	mCCBTag = 0;
	mLoadedCCBFile = "";
	mScriptFunHandler = NULL;
	return true;
}

std::string CCBContainer::dumpInfo()
{
	std::string info;
	info = "CCBContainer variables name info :\n";
	VARIABLE_MAP::iterator it = mVariables.begin();
	for(;it!=mVariables.end();++it)
	{
		info += it->first + "  " + typeid(*(it->second)).name();
		info += "\n";
	}

	info += "CCBContainer menuitems name info :\n";
	MENUITEM_MAP::iterator itr = mMenus.begin();
	for(;itr!=mMenus.end();++itr)
	{
		info += itr->second;
		info += "\n";
	}

	return info;
}

void CCBContainer::updateRichTextNode(cocos2d::CCNode* node)
{
	
}

void CCBContainer::registerFunctionHandler(int nHandler)
{
	unregisterFunctionHandler();
	mScriptFunHandler = nHandler;
}

void CCBContainer::unregisterFunctionHandler(void)
{
	if (mScriptFunHandler)
	{
		CCScriptEngineManager::sharedManager()->getScriptEngine()->removeScriptHandler(mScriptFunHandler);
		mScriptFunHandler = 0;
	}
}

std::string CCBContainer::getStringByKey(const char* key)
{
	lua_State* ls = CCLuaEngine::defaultEngine()->getLuaStack()->getLuaState();
	
	lua_settop(ls, 0);
	lua_getglobal(ls, "LSTR");
	lua_pushstring(ls, key);

	lua_call(ls, 1, 1);

	const char* result = lua_tostring(ls, -1);

	return result;
}

void CCBContainer::replaceStringKey(CCNode* root)
{
	cocos2d::CCLabelBMFont* bmf = dynamic_cast<cocos2d::CCLabelBMFont*>(root);
	if (bmf)
	{
		std::string key = bmf->getString();
		std::string val = this->getStringByKey(key.c_str());
		bmf->setString(val.c_str());		
	}
	cocos2d::CCLabelTTF *ttf = dynamic_cast<cocos2d::CCLabelTTF*>(root);
	if (ttf)
	{
		std::string key = ttf->getString();
		std::string val = this->getStringByKey(key.c_str());
		ttf->setString(val.c_str());		
	}

	cocos2d::CCObject* pObj = NULL;
	CCARRAY_FOREACH(root->getChildren(), pObj)
	{
		cocos2d::CCNode* subnode = dynamic_cast<cocos2d::CCNode*>(pObj);
		if (subnode)
		{
			this->replaceStringKey(subnode);
		}
	}
}

unsigned long CCBContainer::containterCount = 0;
std::string CCBContainer::s_ccbFilePath = "";
