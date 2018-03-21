#pragma once
#include <string>
#include <set>
#include <map>

typedef enum {
	NotReachable = 0,
	ReachableViaWiFi,
	ReachableViaWWAN
} NetworkStatus;

class libOSListener
{
public:
	virtual void onInputboxEnter(const std::string& content){}
	virtual void onInputboxCancel(const std::string& content){}
	virtual void onMessageboxEnter(int tag){}
    virtual void onShareEngineMessage(bool _result,std::string _resultStr){}
	virtual void onPlayMovieEndMessage(){}
	virtual void onMotionShakeMessage() {}
};

class libOS
{
public:

	libOS()
	{
		mAnalyticsOpen = false;
        mIsShareWeChat=false;
        mIsInPlayMovie = false;
	}

	void requestRestart();

	long avalibleMemory();
	void rmdir(const char* path);

	const std::string& generateSerial();

	void showInputbox(bool multiline, std::string content = "");
	void showMessagebox(const std::string& msg, int tag = 0);
	void fbAttention();
	void openURL(const std::string& url);
    void openURLHttps(const std::string& url);
	void emailTo(const std::string& mailto, const std::string & cc , const std::string& title, const std::string & body);

	void setWaiting(bool);

	long long getFreeSpace();

	NetworkStatus getNetWork();
	
	void clearNotification();
    void addNotification(const std::string& msg, int secondsdelay,bool daily = false);
	
	const std::string getDeviceID();
	const std::string getPlatformInfo();

	std::string getDeviceInfo();

	void initAnalytics(const std::string& appid);
	void initUserID(const std::string userid);
	void analyticsLogEvent(const std::string& event);
	void analyticsLogEvent(const std::string& event, const std::map<std::string, std::string>& dictionary, bool timed = false);
	void analyticsLogEndTimeEvent(const std::string& event);
    
	//WeChat(WeXin) initialize
    void WeChatInit(const std::string& appID);
	//whether wechat is install on this device
    bool WeChatIsInstalled();
	//install wechat
    void WeChatInstall();
	//open wechat in device
    void WeChatOpen();
    
    //share to wechat
    void weChatShareFriends(const std::string& shareContent);
    void weChatShareFriends(const std::string& shareImgPath,const std::string& shareContent);
    	
    void weChatSharePerson(const std::string& shareContent);
    void weChatSharePerson(const std::string& shareImgPath,const std::string& shareContent);
    
    void playMovie(const char * fileName, int needSkip = 0);
    
    void stopMovie();
    
    void setShareWeChatCallBackEnabled() { mIsShareWeChat=true;};
    
    void setShareWeChatCallBackDisabled() { mIsShareWeChat=false;};
    
    bool getShareWeChatCallBack() { return mIsShareWeChat;};
    
    bool IsInPlayMovie() {return mIsInPlayMovie; };
    
    void setIsInPlayMovie(bool state) { mIsInPlayMovie = state; };

	//回去当前时区与世界时区的时间差，单位s
	int getSecondsFromGMT();
private:
    
    bool mIsShareWeChat;

	bool mAnalyticsOpen;
    
    bool mIsInPlayMovie;

	std::set<libOSListener*> mListeners;
	static libOS *m_sInstance;
public:
	static libOS* getInstance()
	{
		if(!m_sInstance)
		{
			m_sInstance = new libOS();
		}
		return m_sInstance;
	}


	void registerListener(libOSListener* listerner)
	{
		mListeners.insert(listerner);
	}
	void removeListener(libOSListener* listener)
	{
		mListeners.erase(listener);
	}
	void _boardcastInputBoxOK(const std::string& content)
	{
        setShareWeChatCallBackDisabled();
		std::set<libOSListener*> listeners;
		listeners.insert(mListeners.begin(),mListeners.end());

		std::set<libOSListener*>::iterator it = listeners.begin();
		for(;it!=listeners.end();++it)
		{
			(*it)->onInputboxEnter(content);
		}
	}
	void _boardcastInputBoxCancel(const std::string& content)
	{
		setShareWeChatCallBackDisabled();
		std::set<libOSListener*> listeners;
		listeners.insert(mListeners.begin(),mListeners.end());

		std::set<libOSListener*>::iterator it = listeners.begin();
		for(;it!=listeners.end();++it)
		{
			(*it)->onInputboxCancel(content);
		}
	}
    void _boardcastMessageboxOK(int tag)
	{
        setShareWeChatCallBackDisabled();
		std::set<libOSListener*> listeners;
		listeners.insert(mListeners.begin(),mListeners.end());
        
		std::set<libOSListener*>::iterator it = listeners.begin();
		for(;it!=listeners.end();++it)
		{
			(*it)->onMessageboxEnter(tag);
		}
	}
	void boardcastMessageShareEngine(bool _result,std::string _resultStr)
	{
        setShareWeChatCallBackDisabled();
		std::set<libOSListener*> listeners;
		listeners.insert(mListeners.begin(),mListeners.end());

		std::set<libOSListener*>::iterator it = listeners.begin();
		for(;it!=listeners.end();++it)
		{
			(*it)->onShareEngineMessage(_result,_resultStr.c_str());
		}
	}

	void boardcastMessageOnPlayEnd()
	{
		std::set<libOSListener*> listeners;
		listeners.insert(mListeners.begin(),mListeners.end());

		std::set<libOSListener*>::iterator it = listeners.begin();
		for(;it!=listeners.end();++it)
		{
			(*it)->onPlayMovieEndMessage();
		}
	}
	void boardcastMotionShakeMessage()
	{
		std::set<libOSListener*> listeners;
		listeners.insert(mListeners.begin(),mListeners.end());

		std::set<libOSListener*>::iterator it = listeners.begin();
		for(;it!=listeners.end();++it)
		{
			(*it)->onMotionShakeMessage();
		}
	}
};

