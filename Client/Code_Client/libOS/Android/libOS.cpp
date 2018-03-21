
#include "libOS.h"
//
#include <string.h>
#include <time.h>
//
#include <sys/statfs.h>//for statfs
#include <sys/sysinfo.h>//for sysinfo
#include <unistd.h>//for rmdir
#include <stdio.h>//for remove
//
#include "jni/Java_org_cocos2dx_lib_Cocos2dxHelper.h"
#include "jni.h"
#include <android/log.h>

#include "libOSHelpJni.h"
//
#define  LOG_TAG    "libOS.cpp"
#define  LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG,LOG_TAG,__VA_ARGS__)

//
libOS * libOS::m_sInstance = NULL;
//
void libOS::requestRestart()
{
	requestRestartAppJni();
}
//
NetworkStatus libOS::getNetWork()
{
	return (NetworkStatus)getNetworkStatusJNI();
}

const std::string& libOS::generateSerial()
{
	static std::string orderSerial("");
	orderSerial = generateNewOrderSerialJNI();
	return orderSerial;
}

void TheEditTextCallback(const char* pText, void* ctx, bool cancelPress)
{
	libOS* pLib = (libOS*)ctx;
	//pText已经是utf8的
	std::string content(pText);
	if (!cancelPress)
	{
		pLib->_boardcastInputBoxOK(content);
	}
	else
	{
		pLib->_boardcastInputBoxCancel(content);
	}
}

void libOS::showInputbox(bool multiline, const std::string content /*= ""*/)
{

	showEditTextDialogJNI("", content.c_str(), 0, 1, 1, 256, TheEditTextCallback, this);

}

void libOS::openURL( const std::string& url )
{
	//
	openUrlOutsideJNI(url);
}

void libOS::setWaiting( bool show )
{
	showWaitingViewJNI(show, -1, "");
}

void libOS::emailTo( const std::string& mailto,const std::string & cc ,  const std::string& title, const std::string & body )
{
	//std::string out = "mailto:"+mailto+",title:"+title+"\nbody:\n"+body;
	//MessageBox(0,L"send a mail",L"send email",MB_OK);
	
	//
}

void TheDialogOkCallback(int tag, void* ctx)
{
	libOS* pLib = (libOS*)ctx;
	//
	pLib->_boardcastMessageboxOK(tag);
}

void libOS::showMessagebox( const std::string& msg, int tag /*= 0*/ )
{
	//
//#ifdef _DEBUG
	long freeram = avalibleMemory();
	char szTemp[32] = {0};
	sprintf(szTemp, "%d", freeram);
	std::string temp = msg + "\nmagicnum: ";//freeram//没显示了
	temp.append(szTemp);
	showDialogJNI(msg.c_str(), "", TheDialogOkCallback, this, tag);
	return;
//#endif
	//
	//showDialogJNI(msg.c_str(), "", TheDialogOkCallback, this, tag);
}

long libOS::avalibleMemory()
{
	struct sysinfo info = {0};

	int err = ::sysinfo(&info);
	LOGD("avalibleMemory (freeram,totalram,freehigh,totalhigh,mem_unit):(%d,%d,%d,%d,%d)", 
		info.freeram/1048576,info.totalram/1048576,info.freehigh/1048576,info.totalhigh/1048576,info.mem_unit);
	if (err == 0)
		return info.freeram/**info.mem_unit*//1048576;
	return 150;
	//
}

void libOS::rmdir( const char* path )
{
	int err = ::remove(path);
}

long long libOS::getFreeSpace()
{
	long long freespace = 0;     
	struct statfs disk_statfs;
	long long totalspace = 0;
	float freeSpacePercent = 0 ;
	if( statfs(getAppExternalStoragePath(), &disk_statfs) >= 0 )
	{
		freespace = (((long long)disk_statfs.f_bsize  * (long long)disk_statfs.f_bfree));///(long long)1024	//Kb
		totalspace = (((long long)disk_statfs.f_bsize * (long long)disk_statfs.f_blocks) );///(long long)1024
	}     
	//freeSpacePercent = ((float)freespace/(float)totalspace)*100 ;
	return freespace;//bytes
}

void libOS::clearNotification()
{
	clearSysNotification();
}


void libOS::fbAttention()
{
	fbAttentionJni();
}


void libOS::addNotification(const std::string& msg, int secondsdelay,bool daily /*= false*/)
{
	LOGD("libOS::addNotification(%s,%d,%d)", msg.c_str(), secondsdelay/60, daily ? 1:0);
	//
	const char *_title = "超级七龙珠";
	const char *_message = msg.c_str();
	int  _minite = secondsdelay/60;
	pushSysNotification(_title,_message,_minite);
}

const std::string libOS::getDeviceID()
{
#ifdef _DEBUG
	//std::string device_str = getDeviceIDJNI();
	//std::string show_str = "DeviceID:" + device_str;
	//addNotification(show_str, 60, false);
	//return device_str;
#endif
	return getDeviceIDJNI();
}

const std::string libOS::getPlatformInfo()
{
	return getPlatformInfoJNI();
}

std::string libOS::getDeviceInfo()
{
	return getDeviceInfoJNI();
}

void libOS::initAnalytics(const std::string& appid)
{
	std::string android_appid = "YX6FC4XSBCNB3JNVKV4B";
	initAnalyticsJni(android_appid);

	mAnalyticsOpen = true;
}

void libOS::initUserID(const std::string userid)
{
	initAnalyticsUserIDJni(userid);
}

void libOS::analyticsLogEvent(const std::string& event)
{
	if (!mAnalyticsOpen)
		return;
	analyticsLogEventJni(event);
}

void libOS::analyticsLogEvent(const std::string& event, const std::map<std::string, std::string>& dictionary, bool timed)
{
	if (!mAnalyticsOpen)
		return;
	analyticsLogEventJni(event, dictionary, timed);
}

void libOS::analyticsLogEndTimeEvent(const std::string& event)
{
	if (!mAnalyticsOpen)
		return;
	analyticsLogEndTimeEventJni(event);
}

//WeChat(WeXin) initialize
void libOS::WeChatInit(const std::string& appID)
{

}
//whether wechat is install on this device
bool libOS::WeChatIsInstalled()
{
	return true;
}
//install wechat
void libOS::WeChatInstall()
{

}
//open wechat in device
void libOS::WeChatOpen()
{
	weChatOpenJni();
}
//share String with wechat to Circle of friends
void libOS::weChatShareFriends(const std::string& shareContent)
{
	weChatShareFriendsJni(shareContent);
}

//share String and ImagePath with wechat to Circle of friends
void libOS::weChatShareFriends(const std::string& shareImgPath,const std::string& shareContent)
{
	weChatShareFriendsJni(shareImgPath,shareContent);
}

//share String with wechat to one person
void libOS::weChatSharePerson(const std::string& shareContent)
{
	weChatSharePersonJni(shareContent);
}

//share String and ImagePath with wechat to one person
void libOS::weChatSharePerson(const std::string& shareImgPath,const std::string& shareContent)
{
	weChatSharePersonJni(shareImgPath,shareContent);
}

void libOS::playMovie(const char * fileName, int needSkip /*= true*/)
{		
		const std::string file = fileName;
		playMovieJni(file, needSkip);
}

void libOS::stopMovie()
{		
	stopMovieJni();
}

int libOS::getSecondsFromGMT()
{		
	return getSecondsFromGMTJni();
}
