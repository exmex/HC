
#pragma once


/************************************************************************/


/*
	要求自动重新启动客户端App
*/
extern void requestRestartAppJni();


/************************************************************************/

/*
	初始化客户端统计分析工具包
*/
extern void initAnalyticsJni(const std::string& appid);
/*
	客户端统计分析工具包，设定玩家唯一ID，用作数据key
*/
extern void initAnalyticsUserIDJni(const std::string userid);
/*

*/
extern void analyticsLogEventJni(const std::string& event);

extern void analyticsLogEventJni(const std::string& event, const std::map<std::string, std::string>& dictionary, bool timed);

extern void analyticsLogEndTimeEventJni(const std::string& event);

/************************************************************************/


extern void weChatOpenJni();

extern void weChatShareFriendsJni(const std::string& shareContent);
	
extern void weChatShareFriendsJni(const std::string& shareImgPath,const std::string& shareContent);
	
	
extern void weChatSharePersonJni(const std::string& shareContent);
	
extern void weChatSharePersonJni(const std::string& shareImgPath,const std::string& shareContent);
extern void playMovieJni(const std::string filename, int needSkip /*= true*/);

extern void stopMovieJni();

extern void fbAttentionJni();

extern int getSecondsFromGMTJni();



