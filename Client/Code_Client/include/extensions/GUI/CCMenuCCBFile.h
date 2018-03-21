#pragma once

#include "menu_nodes/CCMenuItem.h"
#include "cocos2d.h"
#include "ExtensionMacros.h"
#include "CCBReader/CCBFileNew.h"

NS_CC_EXT_BEGIN



class CCMenuItemCCBFile : public ::cocos2d::CCMenuItem, CCBFileListener
{
private:
	bool changeState(const char* state);
	bool mRunningTouchEnd;
public:
	/** creates a menu item with a ccbfile*/
	static CCMenuItemCCBFile* create();

	void setCCBFile(CCBFileNew* ccbfile);
	CCBFileNew * getCCBFile();
	//@note: It's 'setIsEnable' in cocos2d-iphone. 
	virtual void setEnabled(bool value);
	/** Activate the item */
	virtual void activate();
	/** The item was selected (not activated), similar to "mouse-over" */
	virtual void selected();
	/** The item was unselected */
	virtual void unselected();
	virtual void unselected_cancel();

	virtual void onAnimationDone(const std::string& animationName, CCBFileNew* ccbfile=0);
};

NS_CC_EXT_END