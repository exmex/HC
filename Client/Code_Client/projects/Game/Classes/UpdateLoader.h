#pragma once
#include "cocos2d.h"
#include "libPlatform.h"
#include "libOS.h"
#include "AssetsManager.h"
#include "SpineContainer.h"
#include "ArmatureContainer.h"

#include <renren-ext.h>

USING_NS_CC;

class CUpdateLoader : public CCNode, public platformListener, public libOSListener, public ArmatureEventListener, public SpineEventListener
{
public:
	CUpdateLoader();
	~CUpdateLoader();
	CREATE_FUNC(CUpdateLoader);

	virtual bool init();

	virtual void onEnter();

	virtual void onExit();

	virtual void update(float delta);

	virtual void onUpdate(libPlatform*, bool ok, std::string msg);

	

	virtual void onInputboxEnter(const std::string& content);

	virtual void onMessageboxEnter(int tag);

	void EnterGame();

	void initSpine(void);
	virtual void onSpineAnimationComplete(int trackIndex, const char* animationName, int loopCount);
	virtual void onSpineAnimationEvent(int trackIndex, const char* animationName, spEvent* event);
	void removeSpine(void);

	virtual void onArmatureAnimationDone(const char* animationName, bool isLoop);
	virtual void onFrameEvent(std::string eventName, CCBone* bone);


	// a selector callback
	void menuCloseCallback(CCObject* pSender);

	bool ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent);
	void ccTouchMoved(CCTouch* pTouch, CCEvent* pEvent);

	// HTML events
	void onHTMLClicked(
		IRichNode* root, IRichElement* ele, int _id);
	void onHTMLMoved(
		IRichNode* root, IRichElement* ele, int _id,
		const CCPoint& location, const CCPoint& delta);

	bool _initRichFont();
private:

	SpineContainer* spineContainer;
	ArmatureContainer* m_pArmature;
	CCHTMLLabel* s_htmlLabel;
	std::string tt;

	int spineCount;
	int dragonCount;

	bool m_b91Checked;
	std::string gPuid;
	enum MsgBoxErrCode
	{
		Err_CheckingFailed = 300,
		Err_UpdateFailed,
		Err_ConnectFailed,
		Err_ErrMsgReport,
	};
	bool mNetWorkNotWorkMsgShown;
	cocos2d::CCProgressTimer* m_pProgressTimer;
	cocos2d::CCSprite* m_pSprite;
	cocos2d::CCSprite* m_pUpdateProgress;
	cocos2d::CCLabelTTF* m_pPersentageTTF;
	cocos2d::CCLayer* m_pLightLayer;
	cocos2d::CCSprite* m_pLightSprite;
	void payUpdate(float dt);
	void showUpdateDone();
	bool mIsPayOver;
	bool mLogined;
	bool mIsUpdateDown;

};