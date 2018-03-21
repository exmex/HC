#include "lib91Debug.h"
#include "libOS.h"
#include "lib91DebugObj.h"
#include <string>
#include <com4lovesSDK.h>


#import <NdComPlatform/NdComPlatform.h>
#import <NdComPlatform/NdComPlatformAPIResponse.h>
#import <NdComPlatform/NdCPNotifications.h>

lib91DebugObj* s_lib91DebugOjb = 0;


//char aaa[] = "lib91::getDeviceID:1111111111";
//AutoReleaseLog1::getInstance().Log(aaa);
class AutoReleaseLog1
{
	FILE *g_fpLog;
	static AutoReleaseLog1* sLog;
public:
	
	AutoReleaseLog1()
	{
        //std::string path = cocos2d::CCFileUtils::sharedFileUtils()->getWritablePath();
        // save to document folder
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        std::string strRet = [documentsDirectory UTF8String];
        strRet.append("/");

		g_fpLog = fopen((strRet+"/gamedebug.log").c_str(), "a+");
		fprintf(g_fpLog,"Game started!\n");
	}
	~AutoReleaseLog1()
	{
		fprintf(g_fpLog,"Game closed!\n\n");
		fclose(g_fpLog);
	}
	void Log(char* log)
	{
		//time_t t = time(0);
		//char tmp[64];
		//strftime( tmp, sizeof(tmp), "%Y/%m/%d %X",localtime(&t) );
		//fprintf(g_fpLog,"%s\t\t",tmp);
        
		fprintf(g_fpLog,"%s\n",log);
		fflush(g_fpLog);
	}
	static AutoReleaseLog1& getInstance(){
        if(sLog)
            return *sLog;
        else
        {
            sLog = new AutoReleaseLog1;
            return *sLog;
        }
    }
};

AutoReleaseLog1* AutoReleaseLog1::sLog = 0;

void lib91Debug::init( bool isPrivateLogin )
{
    [com4lovesSDK  setSDKAppID:@"1" SDKAPPKey:@"dragonball_ios" ChannelID:@"0" PlatformID:@"ios_91"];
    [com4lovesSDK  setAppId:@"dragonball"];
	int appID = 113310;
	std::string appKey = "8e010deb646f01d9d4301cc7aeb147a178b224f1053476fd";
    NSString *string_content = [[NSString alloc] initWithCString:(const char*)appKey.c_str() encoding:NSASCIIStringEncoding];

    if(isPrivateLogin)
    {
        //[[NdComPlatform defaultPlatform] setAppId:appID];
        //[[NdComPlatform defaultPlatform] setAppKey:string_content];

        s_lib91DebugOjb = [lib91DebugObj new];
        [s_lib91DebugOjb registerNotification];
        
        updateApp();
    }
    else
    {
        NdInitConfigure * cfg = [[NdInitConfigure alloc] init];
        cfg.appid = appID;
        cfg.appKey = string_content;
        cfg.versionCheckLevel=ND_VERSION_CHECK_LEVEL_STRICT;
        [[NdComPlatform defaultPlatform] NdInit:cfg];
   
        if (!s_lib91DebugOjb)
        {
            s_lib91DebugOjb = [lib91DebugObj new];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:s_lib91DebugOjb selector:@selector(SNSInitResult:) name:(NSString *)kNdCPInitDidFinishNotification object:nil];
        
    }
    [[NdComPlatform defaultPlatform] NdSetDebugMode:0];

    
    [[NdComPlatform defaultPlatform] NdSetScreenOrientation:UIInterfaceOrientationPortrait];
    [[NdComPlatform defaultPlatform] NdSetAutoRotation:NO];
    
}

void lib91Debug::updateApp()
{
    //[[NdComPlatform defaultPlatform] NdAppVersionUpdate:0 delegate:s_lib91DebugOjb];
    [s_lib91DebugOjb updateApp];
}
void lib91Debug::final()
{
    [s_lib91DebugOjb unregisterNotification];
}
bool lib91Debug::getLogined()
{
    return [[NdComPlatform defaultPlatform] isLogined];
}

bool mEnableLogin = false;

void lib91Debug::_enableLogin()
{
	mEnableLogin = true;
}

void lib91Debug::login()
{
    if(mEnableLogin)
	{
        [[NdComPlatform defaultPlatform] NdLogin:0];
        
    }
}
void lib91Debug::logout()
{
	[[NdComPlatform defaultPlatform] NdLogout:0];
}
void lib91Debug::switchUsers()
{
    //[[NdComPlatform defaultPlatform] NdEnterAccountManage];
    [[NdComPlatform defaultPlatform] NdEnterPlatform:0];
}

void lib91Debug::buyGoods(BUYINFO& info)
{
    if(info.cooOrderSerial=="")
    {
        info.cooOrderSerial = libOS::getInstance()->generateSerial();
    }
    NdBuyInfo* buyinfo = [NdBuyInfo new];
    buyinfo.cooOrderSerial = [NSString stringWithUTF8String:info.cooOrderSerial.c_str()];
    buyinfo.productId = [NSString stringWithUTF8String:info.productId.c_str()];
    buyinfo.productName = [NSString stringWithUTF8String:info.productName.c_str()];
    buyinfo.productPrice = info.productPrice;
    buyinfo.productOrignalPrice = info.productOrignalPrice;
    buyinfo.productCount = 1;//info.productCount;
    buyinfo.payDescription = [NSString stringWithUTF8String:info.description.c_str()];
    int res = [[NdComPlatform defaultPlatform] NdUniPayAsyn:buyinfo];
    if(res<0)
    {
        std::string log("购买信息发送失败");
        _boardcastBuyinfoSent(false, info,log);
    }
}
const std::string& lib91Debug::loginUin()
{
    NSString* retNS = [[NdComPlatform defaultPlatform] loginUin];
    static std::string retStr;
    if(retNS) retStr = [retNS UTF8String];
    return retStr;
}
const std::string& lib91Debug::sessionID()
{
	NSString* retNS = [[NdComPlatform defaultPlatform] sessionId];
    static std::string retStr;
    if(retNS) retStr = (const char*)[retNS UTF8String];
    return retStr;
}
const std::string& lib91Debug::nickName()
{
    NSString* retNS = [[NdComPlatform defaultPlatform] nickName];
    static std::string retStr;
    if(retNS) retStr = [retNS UTF8String];
    return retStr;
}

void lib91Debug::openBBS()
{
	 [[NdComPlatform defaultPlatform] NdEnterAppBBS:0];
}



void lib91Debug::userFeedBack()
{
    [[NdComPlatform defaultPlatform] NdUserFeedBack];
}
void lib91Debug::gamePause()
{
    [[NdComPlatform defaultPlatform] NdPause];
}


const std::string lib91Debug::getClientChannel()
{
    return "91";
}

const unsigned int lib91Debug::getPlatformId()
{
    return 0u;
}


std::string lib91Debug::getPlatformMoneyName()
{
    return "91豆";
}

void lib91Debug::setToolBarVisible(bool isShow)
{
    if(isShow)
    {
        [[NdComPlatform defaultPlatform] NdShowToolBar:NdToolBarAtTopRight];
    }
    else
    {
        [[NdComPlatform defaultPlatform] NdHideToolBar];
    }
}
