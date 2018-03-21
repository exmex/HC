
#include <set>
#include <string>
#include <map>
#ifndef __LIBPLATFORM_H__
#define __LIBPLATFORM_H__

#define AUTO_REGISTER_PLATFORM(classtype) \
	bool ret_##classtype = libPlatformManager::getInstance()->registerPlatform(#classtype,new classtype);

class libPlatform;

struct BUYINFO
{
	BUYINFO()
		:cooOrderSerial(""),productId(""),productName("")
		,productPrice(1),productOrignalPrice(1),productCount(1),description(""){}
	std::string cooOrderSerial;
	std::string productId;
	std::string productName;//display on dev.91.com
	float productPrice;
	float productOrignalPrice;
	unsigned int productCount;
	std::string description;
};

class platformListener
{
public:
	virtual void onInit(libPlatform*, bool success, const std::string& log){};
	virtual void onUpdate(libPlatform*, bool ok, std::string msg){};
	virtual void onLogin(libPlatform*, bool success, const std::string& log){};
	virtual void onPlatformLogout(libPlatform*){};
	virtual void onBuyinfoSent(libPlatform*, bool success, const BUYINFO&, const std::string& log){};
	virtual void onRequestBindTryUserToOkUser(const char* tyrUin, const char* okUin){};
	virtual void onTryUserRegistSuccess(){};
	virtual void onShareEngineMessage(bool result,std::string _resultStr){};
	virtual void onPlayMovieEnd(){};
	virtual void onMotionShake(){};
};


class libPlatform
{
	std::set<platformListener*> mListeners;

public:
/**
	call this function first of all.
	NOTICE: Platform should call _boardcastInitDone to notify client logic WHEN initialization is done.
	*/
	virtual void init(bool privateLogin = false) = 0;

	/**
	MUST call this function AFTER initialization is done(after call back function).
	NOTICE: Platform should call _boardcastUpdateCheckDone to notify client logic WHEN update checking is done.
	*/
    virtual void updateApp() = 0;

	/**
	MUST call this function AFTER updating is done(after call back function).
	NOTICE: Platform should call _boardcastLoginResult to notify client logic WHEN login is done.
	*/
	virtual void login() = 0;

	/** check whether is logined */
	virtual bool getLogined() = 0;

	/** IMPORTANT: get the only ID for game. MUST be unique! */
	virtual const std::string& loginUin() = 0;

	virtual const std::string getClientChannel() = 0;

	virtual std::string getPlatformMoneyName() = 0;

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
	/*
		if the login uin is try user of this platform
	*/
	virtual bool getIsTryUser();
	/*
		
	*/
	virtual void callPlatformBindUser();
	/*
		-1£ºthe ok user puid alread has one player in this serverid
		0:failed, pls retry
		1:success, pls change to platform sdk client and server
	*/
	virtual void notifyGameSvrBindTryUserToOkUserResult(int result);

	/** optional: get the session ID.*/
	virtual const std::string& sessionID();
	/** optional: get the nick name. which is shown on the loading scene */
	virtual const std::string& nickName();

	virtual const unsigned int getPlatformId();
	
	virtual void notifyEnterGame();;
	
	virtual const float getPlatformChangeRate();
    
    virtual void setToolBarVisible(bool isShow);

	virtual void onShareEngineMessage(bool result,std::string _resultStr);

	virtual void onPlayMovieEnd();

	virtual void onMotionShake();
	
	/////////////////////////////////////////////////////////////

	const std::string getPlatformInfo();

	void registerListener(platformListener* listerner)
	{
		mListeners.insert(listerner);
	}

public:
	

	void removeListener(platformListener* listener)
	{
		mListeners.erase(listener);
	}
    void _boardcastInitDone(bool success, const std::string& log)
    {
        std::set<platformListener*>::iterator it = mListeners.begin();
        for(;it!=mListeners.end();++it)
        {
            (*it)->onInit(this, success, log);
        }
    }
    void _boardcastLoginResult(bool success, const std::string& log)
    {
        std::set<platformListener*>::iterator it = mListeners.begin();
        for(;it!=mListeners.end();++it)
        {
            (*it)->onLogin(this, success, log);
        }
    }
    void _boardcastBuyinfoSent(bool success, const BUYINFO& info, const std::string& log)
    {
        std::set<platformListener*>::iterator it = mListeners.begin();
        for(;it!=mListeners.end();++it)
        {
            (*it)->onBuyinfoSent(this, success, info,log);
        }
    }
   
    void _boardcastUpdateCheckDone(bool ok, std::string msg)
    {
        std::set<platformListener*>::iterator it = mListeners.begin();
        for(;it!=mListeners.end();++it)
        {
            (*it)->onUpdate(this, ok, msg);
        }
    }
    void _boardcastPlatformLogout()
    {
        std::set<platformListener*>::iterator it = mListeners.begin();
        for(;it!=mListeners.end();++it)
        {
            (*it)->onPlatformLogout(this);
        }
    }
	/*
		if the login uin is try user, could ask GameServer to change the try user's player to the ok user in this serverid first
	*/
	void _boardcastRequestBindTryUserToOkUser(const char* tyrUin, const char* okUin)
	{
		std::set<platformListener*>::iterator it = mListeners.begin();
		for(;it!=mListeners.end();++it)
		{
			(*it)->onRequestBindTryUserToOkUser(tyrUin, okUin);
		}
	}
	/*
	
	*/
	void _boardcastOnTryUserRegistSuccess()
	{
		std::set<platformListener*>::iterator it = mListeners.begin();
		for(;it!=mListeners.end();++it)
		{
			(*it)->onTryUserRegistSuccess();
		}
	}
	
	void _boardcastOnShareEngineMessage(bool _result,std::string _resultStr)
	{
		std::set<platformListener*> listeners;
		listeners.insert(mListeners.begin(),mListeners.end());

		std::set<platformListener*>::iterator it = listeners.begin();
		for(;it!=listeners.end();++it)
		{
			(*it)->onShareEngineMessage(_result,_resultStr.c_str());
		}
/*
		std::set<platformListener*>::iterator it = mListeners.begin();
		for(;it!=mListeners.end();++it)
		{
			(*it)->onShareEngineMessage(_result);
		}
*/	
	}
	
	void _boardcastOnPlayMovieEnd()
	{
		std::set<platformListener*> listeners;
		listeners.insert(mListeners.begin(),mListeners.end());

		std::set<platformListener*>::iterator it = listeners.begin();
		for(;it!=listeners.end();++it)
		{
			(*it)->onPlayMovieEnd();
		}
/*
		std::set<platformListener*>::iterator it = mListeners.begin();
		for(;it!=mListeners.end();++it)
		{
			(*it)->onPlayMovieEnd();
		}
*/	
	}
	
	void _boardcastOnMotionShake()
	{
		std::set<platformListener*>::iterator it = mListeners.begin();
		for(;it!=mListeners.end();++it)
		{
			(*it)->onMotionShake();
		}

	}
};


class libPlatformManager
{
	libPlatform *m_sPlatform;
	static libPlatformManager *m_sInstance;
	std::map<std::string,libPlatform *> mPlatforms;
public:
	void setPlatform(std::string name);
	bool registerPlatform(std::string name, libPlatform* platform);
	static libPlatform* getPlatform(){return getInstance()->m_sPlatform;}
	static libPlatformManager* getInstance();

};

#endif