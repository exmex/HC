#pragma once

#include "cocos2d.h"
#include "cocos-ext.h"

#include <string>
#include <map>

USING_NS_CC;
USING_NS_CC_EXT;

class CCBContainer : public cocos2d::CCNode, public CCTouchDelegate
	, public cocos2d::extension::CCBSelectorResolver
	, public cocos2d::extension::CCBMemberVariableAssigner
{
private:
	static unsigned long containterCount;
	static std::string s_ccbFilePath;
public:
	class CCBContainerListener
	{
	public:
		virtual void onMenuItemAction(const std::string& itemName, cocos2d::CCObject* sender, int tag){};
		virtual void onAnimationDone(const std::string& animationName){};
	};

	CREATE_FUNC(CCBContainer);

	CCBContainer(void);
	CCBContainer(CCBContainerListener*, int tag = 0);
	virtual ~CCBContainer(void);

	virtual void onAnimationDone(const std::string& animationName);
	virtual void onMenuItemAction(const std::string& itemName, cocos2d::CCObject* sender){};
	virtual void unload();
	virtual bool getLoaded();

	void registerTouchDispatcherSelf(int priority = 0);
	void unregisterTouchDispatcherSelf();
	virtual bool ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent);

	virtual void loadCcbiFile(const std::string& filename, bool froceLoad = false);
	bool hasAnimation(const std::string& actionname);
	void runAnimation(const std::string& actionname);
	void playAutoPlaySequence();
	cocos2d::CCObject* getVariable(const std::string& variablename);
	void setListener(CCBContainerListener* listener, int tag = 0);
	void setAllChildColor(unsigned char r, unsigned char g, unsigned char b);
	
	
	CCNode* getCCNodeFromCCB(const std::string& variablename);
	CCSprite* getCCSpriteFromCCB(const std::string& variablename);
	CCScale9Sprite* getCCScale9SpriteFromCCB(const std::string& variablename);
	CCLabelBMFont* getCCLabelBMFontFromCCB(const std::string& variablename);
	CCLabelTTF* getCCLabelTTFFromCCB(const std::string& variablename);
	//CCBFileNew* getCCBFileFromCCB(const std::string& variablename);
	CCMenuItemImage* getCCMenuItemImageFromCCB(const std::string& variablename);
	CCScrollView* getCCScrollViewFromCCB(const std::string& variablename);
	CCMenuItemCCBFile* getCCMenuItemCCBFileFromCCB(const std::string& variablename);

	static void updateRichTextNode(cocos2d::CCNode* node);
	static void setCCBFilePath(std::string ccbFilePath)
	{
		s_ccbFilePath = ccbFilePath;
	}

	virtual bool init();

	virtual std::string dumpInfo();

	void registerFunctionHandler(int nHandler);
	void unregisterFunctionHandler();
	std::string getCurAnimationDoneName(){ return mCurAnimDoneName; }
	
	//从language中获取对应字符串
	std::string getStringByKey(const char* key);
	void replaceStringKey(CCNode* root);

	friend class cocos2d::extension::CCNodeLoader;
	friend class cocos2d::extension::CCBAnimationManager;
	int mIndex;
private:
	//Do NOT use the fellow functions
	/** use this to cancel the selector method*/
	virtual cocos2d::SEL_MenuHandler onResolveCCBCCMenuItemSelector(cocos2d::CCObject * pTarget, const char* pSelectorName){return NULL;}

	virtual bool onAssignCCBMemberVariable(cocos2d::CCObject* pTarget, const char* pMemberVariableName, cocos2d::CCNode* pNode) ;
	virtual cocos2d::SEL_MenuHandler onResolveCCBCCMenuItemSelectorWithSender(cocos2d::CCObject * pTarget, const char* pSelectorName, cocos2d::CCNode* sender);
	virtual cocos2d::extension::SEL_CCControlHandler onResolveCCBCCControlSelector(cocos2d::CCObject * pSender, const char* pSelectorName);
	void _animationDone();
	void _menuItemClicked(cocos2d::CCObject * pSender);
	void _onControlEvent(cocos2d::CCObject* pSender, CCControlEvent eventId);

private:
	cocos2d::extension::CCBAnimationManager *mActionManager;
	typedef std::map<std::string, cocos2d::CCObject*> VARIABLE_MAP;
	VARIABLE_MAP mVariables;

	typedef std::map<cocos2d::CCObject*, std::string> MENUITEM_MAP;
	MENUITEM_MAP mMenus;

	CCBContainerListener* mCCBContainerListener;


	int mCCBTag;
	std::string mLoadedCCBFile;
	int mScriptFunHandler;
	std::string mCurAnimDoneName;
};

/**
example : 
CCBContainer *page = some_ccb_file;
CCB_FUNC(page,"mSkillBig",CCNode,removeAllChildren());
*/
#define CCB_FUNC(_ccb_,_var_,_type_,_func_) { \
	CCObject* __obj__ = _ccb_->getVariable(_var_); \
	_type_* __node__ = __obj__?dynamic_cast<_type_*>(__obj__):0; \
	if(__node__) __node__-> _func_;}

#define CCB_FUNC_R(_ccb_,_var_,_type_,_func_) { \
	CCObject* __obj__ = _ccb_.getVariable(_var_); \
	_type_* __node__ = __obj__?dynamic_cast<_type_*>(__obj__):0; \
	if(__node__) __node__-> _func_;}

#define CCB_FUNC_RETURN(_ccb_,_var_,_type_,_func_,_ret_) { \
	CCObject* __obj__ = _ccb_->getVariable(_var_); \
	_type_* __node__ = __obj__?dynamic_cast<_type_*>(__obj__):0; \
	if(__node__) _ret_ = __node__-> _func_;}

