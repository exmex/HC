#include "CCBFileNew.h"
#include "CCNodeLoaderLibrary.h"
#include "CCBAnimationManager.h"
#include "CCBBehavior.h"
#include "GUI/CCScrollView/CCScrollView.h"
#include "GUI/CCMenuCCBFile.h"
#include "HeroFileUtils.h"
#include <algorithm>
NS_CC_EXT_BEGIN;

CCBFileNew::CCBFileNew( void )
{
	init();
}

CCBFileNew::~CCBFileNew(void)
{
	unregisterFunctionHandler();
	unload();
}

bool CCBFileNew::init()
{
	mScriptTableHandler = 0;
	mCCBFileListener = 0;
	mCCBTag = 0;
	mLoadCCBFile = "";
	mActionManager = 0;
	mParentCCBFileNode = 0;
	mParentScrollView = 0;
	mIsInSchedule = false;
	mIsInPool = false;
	unload();
	return true;
}

CCBFileNew* CCBFileNew::create()
{
	CCBFileNew* pRet = new CCBFileNew();
	if (pRet && pRet->init())
	{
		pRet->autorelease();
	}
	else
	{
		CC_SAFE_DELETE(pRet);
	}
	return pRet;
}

void CCBFileNew::setCCBFileName( const std::string& filename )
{
	mLoadCCBFile = filename;
}


const std::string& CCBFileNew::getCCBFileName()
{
	return mLoadCCBFile;
}



bool CCBFileNew::getLoaded()
{
	return getChildrenCount()>0;
}

void CCBFileNew::unload()
{
	if(mActionManager)
	{
		mActionManager->release();
		mActionManager = 0;
	}
	VARIABLE_MAP::iterator it = mVariables.begin();
	for(;it!=mVariables.end();++it)
		if(it->second)it->second->release();
	mVariables.clear();
	mMenus.clear();

	if(mIsInPool)
		removeAllChildrenWithCleanup(false);
	else
		removeAllChildren();

	mLoadCCBFileNode = 0;
}

void CCBFileNew::load( bool froceLoad/* = false*/ )
{
	if(getLoaded())
	{
		if(froceLoad)
			unload();
		else
			return;
	}

	if(mLoadCCBFile.empty())
		return;
	CCLOG("[CCBFileNew|load] load ccbi file: %s", mLoadCCBFile.c_str());

	/* Create an autorelease CCNodeLoaderLibrary. */
	CCNodeLoaderLibrary * ccNodeLoaderLibrary = CCNodeLoaderLibrary::sharedCCNodeLoaderLibrary();
	/* Create an autorelease CCBReader. */
	CCBReader * ccbReader = new CCBReader(ccNodeLoaderLibrary,this);

	/* Read a ccbi file. */
	//mLoadCCBFile = "ccbi/" + mLoadCCBFile;
	std::string fullPathCcbiFile = LegendFindFileCpp(mLoadCCBFile.c_str());
	if (fullPathCcbiFile.empty())
	{
		CCLOG("[CCBFileNew|load] ccbi file not found: %s", mLoadCCBFile.c_str());
		return;
	}

	mLoadCCBFileNode = ccbReader->readNodeGraphFromFile(fullPathCcbiFile.c_str(),this);
	mActionManager = ccbReader->getAnimationManager();
	mActionManager->retain();
	mActionManager->setAnimationCompletedCallback(this,callfunc_selector(CCBFileNew::_animationDone));
	ccbReader->release();

	addChild(mLoadCCBFileNode);
	setContentSize(mLoadCCBFileNode->getContentSize());
}

void CCBFileNew::setParentCCBFileNode(CCBFileNew* parent)
{
	mParentCCBFileNode = parent;
}

CCBFileNew* CCBFileNew::getParentCCBFileNode()
{
	return mParentCCBFileNode;
}

void CCBFileNew::setListener( CCBFileListener* listener , int tag)
{
	mCCBFileListener = listener;
	mCCBTag = tag;
}

void CCBFileNew::runAnimation( const std::string& actionname,bool hasEffect/*=false*/ )
{
	if(mActionManager)
		mActionManager->runAnimationsForSequenceNamed(actionname.c_str());
	

	/*if(actionname == "GetIn" || actionname == "GetOut")
	{
	if(hasAnimation(actionname))
	Run_Script_Fun("Animation_Delay_unLock");
	hasEffect = true;
	}
	if (hasEffect)
	{
	CCBSoundBehavior soundBehavior(CCB_PLAY_SOUND,mLoadCCBFile+"$"+actionname,CCBSoundBehavior::TIMELINE);
	CCBBehaviorManager::sharedCCBBehaviorManager()->pushCCBBehavior(&soundBehavior);
	}*/
}

void CCBFileNew::playAutoPlaySequence()
{
	if (mActionManager && mActionManager->getAutoPlaySequenceId() != -1 && !mActionManager->jsControlled)
	{
		mActionManager->runAnimationsForSequenceIdTweenDuration(mActionManager->getAutoPlaySequenceId(), 0);
	}
}

bool CCBFileNew::hasAnimation( const std::string& animation )
{
	if(mActionManager)
		return mActionManager->hasAnimation(animation.c_str());
	
	return false;
}


float CCBFileNew::getAnimationLength( const std::string& animation )
{
	if(mActionManager)
		return mActionManager->getAnimationLength(animation.c_str());
	return 0;
}

CCObject* CCBFileNew::getVariable( const std::string& variablename )
{
	std::string var(variablename);
	std::transform(var.begin(),var.end(),var.begin(),tolower);
	if(!mVariables.empty())
    {
        VARIABLE_MAP::iterator it = mVariables.find(var);
        if(it!=mVariables.end())
            return it->second;
        else
        {
            CCLog("Failed to get variable:%s",var.c_str());
            return NULL;
        }
    }
    CCLog("ERROR!!Illegal empty CCBFileNew:%s",getCCBFileName().c_str());
    return NULL;
}
//
//#define getVariableAs(_type_) \
//_type_* CCBFileNew::get##_type_##FromCCB( const std::string& _var_ ) \
//{ \
//	CCObject* __obj__ = getVariable(_var_);\
//	_type_* __node__ = __obj__?dynamic_cast<_type_*>(__obj__):0; \
//	return __node__; \
//};
//
//getVariableAs(CCNode);
//getVariableAs(CCSprite);
//getVariableAs(CCLabelBMFont);
//getVariableAs(CCLabelTTF);
//getVariableAs(CCBFileNew);
//getVariableAs(CCMenuItemImage);
//getVariableAs(CCScrollView);
//getVariableAs(CCMenuItemCCBFile);

CCNode* CCBFileNew::getCCBFileNode()
{
	return mLoadCCBFileNode;
}

bool CCBFileNew::onAssignCCBMemberVariable( CCObject* pTarget, const char* pMemberVariableName, CCNode* pNode )
{
	if(pTarget!=this) return false;

	std::string var = pMemberVariableName;

	std::transform(var.begin(),var.end(),var.begin(),tolower);
	VARIABLE_MAP::iterator it = mVariables.find(var);

	if(it!=mVariables.end())
	{
		if(it->second!=pNode)
		{
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

SEL_MenuHandler CCBFileNew::onResolveCCBCCMenuItemSelectorWithSender( CCObject * pTarget, const char* pSelectorName, CCNode* sender )
{
	if(pTarget!=this)
		return NULL;
	std::string name = pSelectorName;
	MENUITEM_MAP::iterator it = mMenus.find(sender);
	if(it!=mMenus.end())
		it->second = name;
	else
		mMenus.insert(std::make_pair(sender,name));

	return menu_selector(CCBFileNew::_menuItemClicked);
}

void CCBFileNew::_menuItemClicked( CCObject * pSender )
{
	MENUITEM_MAP::iterator it = mMenus.find(pSender);
	if(it!=mMenus.end())
	{
		CCLOG("CCBFileNew:Button pressed! ccb:%s, func:%s, tag:%d",mLoadCCBFile.c_str(),it->second.c_str(),mCCBTag);
		onMenuItemAction(it->second,pSender);
	}
}

int CCBFileNew::Run_Script_Fun(const std::string& funname)
{
	/*int ret = 0;
	if(mScriptTableHandler)
	{ 
		ret = CCLuaEngine::defaultEngine()->executeClassFunc(mScriptTableHandler,funname.c_str(),this,"CCBFileNew");
	}
	return ret;*/
	return 0;
}

void CCBFileNew::onMenuItemAction( const std::string& itemName, CCObject* sender )
{
	if(!Run_Script_Fun(itemName))
	{
	/*	CCBSoundBehavior soundBehavior(CCB_PLAY_SOUND,mLoadCCBFile+"#"+itemName,CCBSoundBehavior::PRESS);
		CCBBehaviorManager::sharedCCBBehaviorManager()->pushCCBBehavior(&soundBehavior);*/

		if(mCCBFileListener)
			mCCBFileListener->onMenuItemAction(itemName, sender, mCCBTag);
		if(mParentCCBFileNode)
			mParentCCBFileNode->onMenuItemAction(itemName,sender );
	}
}

void CCBFileNew::_animationDone()
{
	const std::string& animationName = mActionManager->getLastCompletedSequenceName();
	
	mAnimationDoneList.push_back(animationName);
	
	scheduleOnce(schedule_selector(CCBFileNew::_animationDoneDelay),0);
	mIsInSchedule = true;
	
}


void CCBFileNew::_animationDoneDelay(float)
{
	std::list<std::string>::iterator it = mAnimationDoneList.begin();
	if(it!=mAnimationDoneList.end())
	{
		onAnimationDone(*it);
		/*if(!Run_Script_Fun("OnAnimationDone"))

		if(*it == "GetIn" || *it == "GetOut")
		{
		Run_Script_Fun("Animation_unLock");
		}*/
	}
	mAnimationDoneList.pop_front();
	mIsInSchedule = false;
}


std::string CCBFileNew::getCompletedAnimationName()
{
	std::list<std::string>::iterator it = mAnimationDoneList.begin();
	if(it!=mAnimationDoneList.end())
		return *it;
	return "";
}

void CCBFileNew::onAnimationDone( const std::string& animationName )
{
	if(mCCBFileListener)
		mCCBFileListener->onAnimationDone(animationName,this);
	if(mParentCCBFileNode)
		mParentCCBFileNode->onAnimationDone(animationName);
}

void CCBFileNew::registerFunctionHandler(int nHandler)
{
	unregisterFunctionHandler();
	mScriptTableHandler = nHandler;
}

void CCBFileNew::unregisterFunctionHandler(void)
{
	if (mScriptTableHandler)
	{
		CCScriptEngineManager::sharedManager()->getScriptEngine()->removeScriptHandler(mScriptTableHandler);
		mScriptTableHandler = 0;
	}
}

std::string CCBFileNew::dumpInfo()
{
	std::string info;
	info = "CCBFileNew variables name info :\n";
	VARIABLE_MAP::iterator it = mVariables.begin();
	for(;it!=mVariables.end();++it)
	{
		info += it->first + "  " + typeid(*(it->second)).name();
		info += "\n";
	}

	info += "CCBFileNew menuitems name info :\n";
	MENUITEM_MAP::iterator itr = mMenus.begin();
	for(;itr!=mMenus.end();++itr)
	{
		info += itr->second;
		info += "\n";
	}

	return info;
}
//
//CCBFileNew* CCBFileNew::CreateInPool( const std::string& CCBFileNew)
//{
//	CCBFileNew* pRet = 0;
//
//	std::map<std::string,std::list<CCBFileNew*> >::iterator mapit = ccbsPool.find(CCBFileNew);
//	if(mapit==ccbsPool.end())
//	{
//		pRet = new CCBFileNew();
//		pRet->mLoadCCBFile = CCBFileNew;
//		std::list<CCBFileNew*> ccbclist;
//		ccbclist.push_back(pRet);
//		pRet->mIsInPool = true;
//		pRet->load();
//		ccbsPool.insert(std::make_pair(CCBFileNew,ccbclist));
//		return pRet;
//	}
//	else
//	{
//		std::list<CCBFileNew*>::iterator listit = mapit->second.begin();
//		for(;listit!=mapit->second.end();++listit)
//		{
//			pRet = *listit;
//			if(pRet->isSingleReference())
//			{
//				pRet->unregisterFunctionHandler();
//				pRet->setListener(0);
//				pRet->setParentCCBFileNode(0);
//				return pRet;
//			}
//		}
//        CCLog("new ccbi %s loaded:%d",CCBFileNew.c_str(),mapit->second.size());
//		pRet = new CCBFileNew();
//		pRet->mLoadCCBFile = CCBFileNew;
//		mapit->second.push_back(pRet);
//		pRet->mIsInPool = true;
//		pRet->load();
//		return pRet;
//	}
//}

void CCBFileNew::purgeCachedData( void )
{
	std::map<std::string,std::list<CCBFileNew*> >::iterator mapit = ccbsPool.begin();
	for(;mapit!=ccbsPool.end();++mapit)
	{
		std::list<CCBFileNew*> listSwap;
		listSwap.swap(mapit->second);
		std::list<CCBFileNew*>::iterator listit = listSwap.begin();
		for(;listit!=listSwap.end();++listit)
		{
			CCBFileNew* pRet = *listit;
			if(pRet->isSingleReference())
			{
				pRet->mIsInPool = false;
				pRet->release();
			}
			else
				mapit->second.push_back(pRet);
		}
	}
}
//
//void CCBFileNew::setCCScrollViewChild( CCScrollView* parent )
//{
//	if(mParentScrollView != parent)
//	{
//		mParentScrollView = parent;
//		mParentScrollView->_setChildMenu(this);
//	}
//}

void CCBFileNew::cleanup( void )
{
	if(mIsInSchedule)
	{
		this->unscheduleAllSelectors();
		mIsInSchedule = false;
	}

	if(mIsInPool)
		return;

	CCNode::cleanup();
}


std::map<std::string,std::list<CCBFileNew*> > CCBFileNew::ccbsPool;




NS_CC_EXT_END