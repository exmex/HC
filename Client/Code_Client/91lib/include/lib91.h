#pragma once

#include "libPlatform.h"

class lib91 : public libPlatform
{
public:
	void _enableLogin();
	/**
	call this function first of all.
	NOTICE: Platform should call _boardcastInitDone to notify client logic WHEN initialization is done.
	*/
	virtual void init(bool privateLogin = false);

	/**
	MUST call this function AFTER initialization is done(after call back function).
	NOTICE: Platform should call _boardcastUpdateCheckDone to notify client logic WHEN update checking is done.
	*/
    virtual void updateApp();

	/**
	MUST call this function AFTER updating is done(after call back function).
	NOTICE: Platform should call _boardcastLoginResult to notify client logic WHEN login is done.
	*/
	virtual void login();

	/** logout platform*/
	virtual void logout();

	/** optional: finalize the platform*/
	virtual void final();

	/** show the platform window to switch users */
	virtual void switchUsers();

	/** buy platform RMB*/
	virtual void buyGoods(BUYINFO&);
	
	/** call platform open bbs function. if the platform doesn't have this usage, just open an url! */
	virtual void openBBS();
	/** call platform open feedback function. if the platform doesn't have this usage, just open an email link! */
	virtual void userFeedBack();
	/** optional: call platform open game pause function.*/
	virtual void gamePause();

#ifdef WIN32
	//方便win32下调试，记录下上次登录成功的puid，下次进游戏默认为上次登录的puid, by zhenhui 2014/5/20
	static void lib91::setLoginName(const std::string content);
#endif

	/** check whether is logined */
	virtual bool getLogined();

	/** IMPORTANT: get the only ID for game. MUST be unique! */
	virtual const std::string& loginUin();
	/** optional: get the session ID.*/
	virtual const std::string& sessionID();
	/** optional: get the nick name. which is shown on the loading scene */
	virtual const std::string& nickName();

	virtual const std::string getClientChannel();

	virtual const unsigned int getPlatformId();

	virtual void notifyEnterGame();
    
    virtual std::string getPlatformMoneyName();

    virtual void setToolBarVisible(bool isShow);

	virtual bool getIsTryUser();

	virtual void callPlatformBindUser();
	
	virtual void notifyGameSvrBindTryUserToOkUserResult(int result);
};


