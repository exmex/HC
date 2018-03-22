#ifndef _CCB_CCBFILE_H_
#define _CCB_CCBFILE_H_

#include "cocos2d.h"
#include "CCBSelectorResolver.h"
#include "CCBMemberVariableAssigner.h"

#include <string>
#include <map>
#include <list>
NS_CC_EXT_BEGIN

class CCMenuItemCCBFile;
class CCScrollView;
class CCBAnimationManager;
class CCBFileNew;
class CCBFileListener
{
public:
	virtual void onMenuItemAction(const std::string& itemName, CCObject* sender, int tag){};
	virtual void onAnimationDone(const std::string& animationName, CCBFileNew* CCBFileNew=0){};
};

class CCBFileNew : public CCNode
	, public CCBSelectorResolver
	, public CCBMemberVariableAssigner
{
public:
	
	static CCBFileNew* create();

	static CCBFileNew* CreateInPool(const std::string& CCBFileNew);
	static void purgeCachedData(void);

	CCBFileNew(void);
	virtual ~CCBFileNew(void);
	virtual bool init();

	void setCCBFileName(const std::string& filename);
	const std::string& getCCBFileName();
	virtual void load(bool froceLoad = false);
	virtual void unload();
	virtual bool getLoaded();

	void setParentCCBFileNode(CCBFileNew* parent);
	CCBFileNew* getParentCCBFileNode();
	void setListener(CCBFileListener* listener, int tag = 0);
	CCBFileListener* getListener(){return mCCBFileListener;};

	void runAnimation(const std::string& actionname,bool hasEffect=false);
	bool hasAnimation(const std::string& animation);
	float getAnimationLength(const std::string& animation);
	std::string getCompletedAnimationName();

	CCObject* getVariable(const std::string& variablename);
	CCNode* getCCNodeFromCCB(const std::string& variablename);
	CCSprite* getCCSpriteFromCCB(const std::string& variablename);
	CCLabelBMFont* getCCLabelBMFontFromCCB(const std::string& variablename);
	CCLabelTTF* getCCLabelTTFFromCCB(const std::string& variablename);
	CCBFileNew* getCCBFileFromCCB(const std::string& variablename);
	CCMenuItemImage* getCCMenuItemImageFromCCB(const std::string& variablename);
	CCScrollView* getCCScrollViewFromCCB(const std::string& variablename);
	CCMenuItemCCBFile* getCCMenuItemCCBFileFromCCB(const std::string& variablename);

	CCNode* getCCBFileNode();
	void playAutoPlaySequence();

	void registerFunctionHandler(int nHandler);
	void unregisterFunctionHandler();

	//void setCCScrollViewChild(CCScrollView* parent);

	virtual std::string dumpInfo();

	friend class CCNodeLoader;
	friend class CCBAnimationManager;

	virtual void cleanup(void);
private:
	//CCBSelectorResolver
	virtual SEL_MenuHandler onResolveCCBCCMenuItemSelector(CCObject * pTarget, const char* pSelectorName){return NULL;}
	virtual SEL_MenuHandler onResolveCCBCCMenuItemSelectorWithSender(CCObject * pTarget, const char* pSelectorName, CCNode* sender);
	virtual SEL_CCControlHandler onResolveCCBCCControlSelector(CCObject * pTarget, const char* pSelectorName){return NULL;}
	//CCBMemberVariableAssigner
	virtual bool onAssignCCBMemberVariable(CCObject* pTarget, const char* pMemberVariableName, CCNode* pNode) ;
	
	void _animationDone();
	void _animationDoneDelay(float);
	void _menuItemClicked(CCObject * pSender);

	virtual void onAnimationDone(const std::string& animationName);
	virtual void onMenuItemAction(const std::string& itemName, CCObject* sender);

	int Run_Script_Fun(const std::string& funname);

private:
	CCBAnimationManager *mActionManager;
	typedef std::map<std::string, CCObject*> VARIABLE_MAP;
	VARIABLE_MAP mVariables;

	typedef std::map<CCObject*, std::string> MENUITEM_MAP;
	MENUITEM_MAP mMenus;

	int mScriptTableHandler;
	CCBFileListener* mCCBFileListener;

	int mCCBTag;
	std::string mLoadCCBFile;
	CCNode* mLoadCCBFileNode;
	CCBFileNew* mParentCCBFileNode;

	CCScrollView* mParentScrollView;

	static std::map<std::string,std::list<CCBFileNew*> > ccbsPool;
	bool mIsInPool;
	bool mIsInSchedule;

	std::list<std::string> mAnimationDoneList;
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

NS_CC_EXT_END

#endif
