#include "libOS.h"
#include "libOSObj.h"
#include <sys/sysctl.h>
#include <mach/mach.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#import "UIDevice+IdentifierAddition.h"
#import "MovieMgr.h"

//#define FLURRY_ENABLE

#ifdef FLURRY_ENABLE
#import "Flurry.h"
#endif

#import "WXApi.h"
#import "SvUDIDTools.h"

//#define MTA_ENABLE

#define MTA_APP_KEY @"IPI6IR1NR34Q"

#ifdef MTA_ENABLE
#import "MTA.h"
#import "MTAConfig.h"
#endif

libOS * libOS::m_sInstance = 0;
libOSObj* s_libOSOjb = 0;

int _enc_unicode_to_utf8_one(wchar_t unic, std::string& outstr)  
{  

	if ( unic <= 0x0000007F )  
	{  
		// * U-00000000 - U-0000007F:  0xxxxxxx  
		outstr.push_back(unic & 0x7F);  
		return 1;  
	}  
	else if ( unic >= 0x00000080 && unic <= 0x000007FF )  
	{  
		// * U-00000080 - U-000007FF:  110xxxxx 10xxxxxx  
		outstr.push_back(((unic >> 6) & 0x1F) | 0xC0); 
		outstr.push_back((unic & 0x3F) | 0x80);  
		return 2;  
	}  
	else if ( unic >= 0x00000800 && unic <= 0x0000FFFF )  
	{  
		// * U-00000800 - U-0000FFFF:  1110xxxx 10xxxxxx 10xxxxxx  
		outstr.push_back( ((unic >> 12) & 0x0F) | 0xE0);  
		outstr.push_back(((unic >>  6) & 0x3F) | 0x80);  
		outstr.push_back( (unic & 0x3F) | 0x80);  
		return 3;  
	}  
	else if ( unic >= 0x00010000 && unic <= 0x001FFFFF )  
	{  
		// * U-00010000 - U-001FFFFF:  11110xxx 10xxxxxx 10xxxxxx 10xxxxxx  
		outstr.push_back( ((unic >> 18) & 0x07) | 0xF0); 
		outstr.push_back( ((unic >> 12) & 0x3F) | 0x80);
		outstr.push_back( ((unic >>  6) & 0x3F) | 0x80);
		outstr.push_back( (unic & 0x3F) | 0x80);
		return 4;  
	}  
	else if ( unic >= 0x00200000 && unic <= 0x03FFFFFF )  
	{  
		// * U-00200000 - U-03FFFFFF:  111110xx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx  

		outstr.push_back( ((unic >> 24) & 0x03) | 0xF8); 
		outstr.push_back( ((unic >> 18) & 0x3F) | 0x80);
		outstr.push_back( ((unic >> 12) & 0x3F) | 0x80);
		outstr.push_back( ((unic >>  6) & 0x3F) | 0x80);  
		outstr.push_back( (unic & 0x3F) | 0x80);  
		return 5;  
	}  
	else if ( unic >= 0x04000000 && unic <= 0x7FFFFFFF )  
	{  
		// * U-04000000 - U-7FFFFFFF:  1111110x 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx  
		outstr.push_back( ((unic >> 30) & 0x01) | 0xFC);
		outstr.push_back( ((unic >> 24) & 0x3F) | 0x80); 
		outstr.push_back( ((unic >> 18) & 0x3F) | 0x80);
		outstr.push_back( ((unic >> 12) & 0x3F) | 0x80);  
		outstr.push_back( ((unic >>  6) & 0x3F) | 0x80);  
		outstr.push_back( (unic & 0x3F) | 0x80); 
		return 6;  
	}  

	return 0;  
}
void libOS::requestRestart()
{
	exit(0);
}
NetworkStatus libOS::getNetWork()
{
    //¥¥Ω®¡„µÿ÷∑£¨0.0.0.0µƒµÿ÷∑±Ì æ≤È—Ø±æª˙µƒÕ¯¬Á¡¨Ω”◊¥Ã¨
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    //ªÒµ√¡¨Ω”µƒ±Í÷æ
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    //»Áπ˚≤ªƒ‹ªÒ»°¡¨Ω”±Í÷æ£¨‘Ú≤ªƒ‹¡¨Ω”Õ¯¬Á£¨÷±Ω”∑µªÿ
    if (!didRetrieveFlags)
    {
        return NotReachable;
    }
    //∏˘æ›ªÒµ√µƒ¡¨Ω”±Í÷æΩ¯––≈–∂œ
    bool isReachable = flags & kSCNetworkFlagsReachable;
    bool needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    bool is3G = flags & kSCNetworkReachabilityFlagsIsWWAN;
    return (isReachable && !needsConnection) ? (is3G ? ReachableViaWWAN : ReachableViaWiFi) : NotReachable;
}
void libOS::rmdir(const char* path)
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* nPath = [NSString stringWithUTF8String:path];
    [fileManager removeItemAtPath:nPath error:nil];
}

const std::string& libOS::generateSerial()
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef guid = CFUUIDCreateString(NULL, theUUID);
	CFRelease(theUUID);
	NSString *uuidString = [((__bridge NSString *)guid) stringByReplacingOccurrencesOfString:@"-" withString:@""];
	CFRelease(guid);
	static std::string ret;
    ret = [[uuidString lowercaseString] UTF8String];
    return ret;
}

void libOS::showInputbox(bool multiline,std::string content)
{
    
    if (IS_IOS7||IS_IOS8 )
    {
        UIAlertView* dialog = [[UIAlertView alloc] init];
        [dialog setDelegate:s_libOSOjb];
        [dialog setTitle:@""];
        [dialog setMessage:@""];
        [dialog addButtonWithTitle:@"OK"];
        dialog.tag = multiline?1002:1001;
        dialog.alertViewStyle = UIAlertViewStylePlainTextInput;
        [dialog textFieldAtIndex:0].keyboardType = UIKeyboardTypeDefault;
        CGAffineTransform moveUp = CGAffineTransformMakeTranslation(0.0, 0.0);
        [dialog setTransform: moveUp];
        [dialog show];
        [dialog release];
    }
    else
    {
        UIAlertView *prompt = nil;
        if(!s_libOSOjb) s_libOSOjb = [libOSObj new];
        if(multiline)
        {
            prompt = [[UIAlertView alloc] initWithTitle:@""
                                                message:@"\n\n\n\n\n\n"
                                               delegate:s_libOSOjb
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil, nil];
            UITextView *textField = [[UITextView alloc] initWithFrame:CGRectMake(27.0, 27.0, 230.0, 120.0)];
            [textField setBackgroundColor:[UIColor whiteColor]];
            [textField setTag:1002];
            [prompt addSubview:textField];
            [textField release];
        }
        else
        {
            prompt = [[UIAlertView alloc] initWithTitle:@"\n"
                                                message:@""
                                               delegate:s_libOSOjb
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil, nil];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(27.0, 27.0, 230.0, 28.0)];
            [textField setBackgroundColor:[UIColor whiteColor]];
            [textField setPlaceholder:@""];
            [textField setTag:1001];
            [prompt addSubview:textField];
            [textField release];
        }
        
        [prompt setTransform:CGAffineTransformMakeTranslation(0.0, -100.0)];  //ø…“‘µ˜’˚µØ≥ˆøÚ‘⁄∆¡ƒª…œµƒŒª÷√
        
        [prompt show];
        
    }
    
    
    
}
// ios no MessageBox, use CCLog instead
void libOS::showMessagebox(const std::string& _msg, int tag)
{
	if(!s_libOSOjb) s_libOSOjb = [libOSObj new];
    NSString * title =  nil;
    NSString * msg = [NSString stringWithUTF8String : _msg.c_str()];
    UIAlertView * messageBox = [[UIAlertView alloc] initWithTitle: title
                                                          message: msg
                                                         delegate: s_libOSOjb
                                                cancelButtonTitle: @"OK"
                                                otherButtonTitles: nil];
    [messageBox setTag:tag];
    [messageBox show];
}
void libOS::openURL(const std::string& url)
{
    NSString * urlstr = [NSString stringWithUTF8String:url.c_str()];
    NSRange range6 = NSMakeRange(0, 7);
    if([urlstr length]<7 || ![[[urlstr substringWithRange:range6] lowercaseString]isEqualToString:@"http://"])
    {
        std::string head("http://");
        head.append([urlstr UTF8String]);
        urlstr = [NSString stringWithUTF8String:head.c_str()];
    }
    if(urlstr)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlstr]];
    
   
}

void libOS::fbAttention()
{
    NSInteger i = 1;
}

void libOS::openURLHttps(const std::string& url)
{
    NSString * urlstr = [NSString stringWithUTF8String:url.c_str()];
    NSRange range6 = NSMakeRange(0, 7);
    if([urlstr length]<7 || ![[[urlstr substringWithRange:range6] lowercaseString]isEqualToString:@"https://"])
    {
        std::string head("https://");
        head.append([urlstr UTF8String]);
        urlstr = [NSString stringWithUTF8String:head.c_str()];
    }
    if(urlstr)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlstr]];
    
    
}

void libOS::emailTo( const std::string& mailto, const std::string & cc , const std::string& title, const std::string & body )
{
	NSString * n_mailto = [NSString stringWithUTF8String:mailto.c_str()];
	NSString * n_title = [NSString stringWithUTF8String:title.c_str()];
	NSString * n_body = [NSString stringWithUTF8String:body.c_str()];
	NSString * n_cc = [NSString stringWithUTF8String:cc.c_str()];
	
	NSString* str = [NSString stringWithFormat:@"mailto:%@?cc=%@&subject=%@&body=%@",  
                     n_mailto, n_cc, n_title, n_body];  
  
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];  
     
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];  
}
long libOS::avalibleMemory()
{
    vm_statistics64_data_t vmStats;
    mach_msg_type_number_t infocount = HOST_VM_INFO_COUNT;
    kern_return_t kernRet = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infocount);
    if(kernRet!=KERN_SUCCESS)
    {
        return 0;
    }
    else
    {
        return (unsigned long)vm_page_size*(unsigned long)vmStats.free_count/1024/1024;
    }
    
}

void libOS::setWaiting(bool show)
{
	if(!s_libOSOjb) s_libOSOjb = [libOSObj new];
    if(show)
    {
        [s_libOSOjb showWait];
    }
    else
    {
        [s_libOSOjb hideWait];
    }
}
void libOS::clearNotification()
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}
void libOS::addNotification(const std::string& msg, int secondsdelay, bool daily)
{
    UILocalNotification* notification = [[UILocalNotification alloc]init];
    if(notification!=nil)
    {
        NSDate* nowtime = [NSDate new];
        notification.fireDate = [nowtime dateByAddingTimeInterval:secondsdelay];
        [nowtime release];
        if(daily)
            notification.repeatInterval = kCFCalendarUnitDay;
        else
            notification.repeatInterval = 0;
        
        notification.timeZone = [NSTimeZone defaultTimeZone];
        NSString* message = [NSString stringWithUTF8String:msg.c_str()];
        notification.alertBody = message;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
        //[[UIApplication sharedApplication] scheduledLocalNotifications:notification];
    }
    [notification release];
}

long long libOS::getFreeSpace()
{

//    long long totalSpace = -1;
    long long totalFreeSpace = -1;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];

    if (dictionary) {
//        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
//        totalSpace = [fileSystemSizeInBytes longLongValue];
        totalFreeSpace = [freeFileSystemSizeInBytes longLongValue];
    }

    return totalFreeSpace;
//
//	struct statfs buf;  
//    long long freespace = -1;  
//    if(statfs("/var", &buf) >= 0){  
//        freespace = (long long)(buf.f_bsize * buf.f_bfree);  
//    } 
//	return freespace;
}

const std::string libOS::getDeviceID()
{
    //NSString *nsDeviceID = [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
    // modify by dylan at 20140225,nulcear use idfa
    NSString *nsDeviceIDFAOrMAC=[[SvUDIDTools getDeviceIdIDFAOrMAC] retain];
    if(nsDeviceIDFAOrMAC)
    {
        std::string sDeviceID([nsDeviceIDFAOrMAC UTF8String]);
        return sDeviceID;
    }
    
    return "";
}

const std::string getDeviceIDForAppStore()
{
    NSString *nsDeviceId=[[SvUDIDTools getDeviceIdIDFAOrMAC] retain];
    if(nsDeviceId)
    {
        std::string sDeviceID([nsDeviceId UTF8String]);
        return sDeviceID;
    }
        return "";
}

const std::string libOS::getPlatformInfo()
{
    NSString *nsSystemVersion = [NSString stringWithString:[[UIDevice currentDevice] systemVersion]];
    std::string sSystemVersion([nsSystemVersion UTF8String]);
    NSString *nsSystemName = [NSString stringWithString:[[UIDevice currentDevice] systemName]];
    std::string sSystemName([nsSystemName UTF8String]);
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *nsPlatform = [NSString stringWithUTF8String:machine];
    free(machine);
    std::string splatform([nsPlatform UTF8String]);
    
    return splatform+"#"+sSystemVersion+"#"+sSystemName+"#IOS";
}

void libOS::initAnalytics(const std::string& appid)
{
    NSString* appkey = [NSString stringWithUTF8String:appid.c_str()] ;
#ifdef FLURRY_ENABLE
    [Flurry setCrashReportingEnabled:YES];
    [Flurry startSession:appkey];
	mAnalyticsOpen = true;
#endif
    
#ifdef MTA_ENABLE
    [[MTAConfig getInstance] setDebugEnable:true];
    [[MTAConfig getInstance] setReportStrategy:MTA_STRATEGY_APP_LAUNCH];
    //[[MTAConfig getInstance] minBatchReportCount:10];
    [[MTAConfig getInstance] setSmartReporting:false];
    //modify dy dylan at 20140108 MTA 写死
    [MTA startWithAppkey:MTA_APP_KEY];
    mAnalyticsOpen = true;
#else
    
#endif
}
void libOS::initUserID(const std::string userid)
{
	if (!mAnalyticsOpen)
		return;
    
    NSString* userID = [NSString stringWithUTF8String:userid.c_str()] ;
#ifdef FLURRY_ENABLE
    [Flurry setUserID:userID];
#endif
#ifdef MTA_ENABLE
    [MTA trackGameUser:userID world:@"" level:@""];
#endif

}
void libOS::analyticsLogEvent(const std::string& event)
{
	if (!mAnalyticsOpen)
		return;

    NSString* eventNS = [NSString stringWithUTF8String:event.c_str()] ;
#ifdef FLURRY_ENABLE
    [Flurry logEvent:eventNS];
#endif
    
#ifdef MTA_ENABLE
    [MTA trackCustomEvent:eventNS args:nil];
#endif
}
void libOS::analyticsLogEvent(const std::string& event, const std::map<std::string, std::string>& dictionary, bool timed)
{
	if (!mAnalyticsOpen)
		return;

    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init] ;
    std::map<std::string, std::string>::const_iterator it = dictionary.begin();
    for (; it!=dictionary.end(); ++it) {
        NSString * key = [NSString stringWithUTF8String:it->second.c_str()];
        NSString * val = [NSString stringWithUTF8String:it->first.c_str()];
        [dic setObject:val forKey:key];
    }
    NSString* eventNS = [NSString stringWithUTF8String:event.c_str()] ;
#ifdef FLURRY_ENABLE
    [Flurry logEvent:eventNS withParameters:dic timed:timed];
#endif
    
#ifdef MTA_ENABLE
    [MTA trackCustomKeyValueEventBegin:eventNS props:dic];
#endif
    [dic release];
}
void libOS::analyticsLogEndTimeEvent(const std::string& event)
{
	if (!mAnalyticsOpen)
		return;

    NSString* eventNS = [NSString stringWithUTF8String:event.c_str()] ;
#ifdef FLURRY_ENABLE
    [Flurry endTimedEvent:eventNS withParameters:nil];
#endif
    
#ifdef MTA_ENABLE
#warning be care to the parameters
    [MTA trackCustomKeyValueEventEnd:eventNS props:nil];
#endif
}

void libOS::WeChatInit(const std::string& appID)
{
    NSString* app =[ NSString stringWithUTF8String:appID.c_str()] ;
    [WXApi registerApp:app];
}
bool libOS::WeChatIsInstalled()
{
    return ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]);
}
void libOS::WeChatInstall()
{
    NSString* installurl = [WXApi getWXAppInstallUrl];
    openURL([installurl UTF8String]);
}
void libOS::WeChatOpen()
{
    [WXApi openWXApp];
}

void libOS::weChatShareFriends(const std::string& shareContent)
{
    setShareWeChatCallBackEnabled();
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.text = [NSString stringWithUTF8String:shareContent.c_str()];
    req.bText = YES;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}

void libOS::weChatShareFriends(const std::string& shareImgPath,const std::string& shareContent)
{
    setShareWeChatCallBackEnabled();
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"share.png"]];
    
    WXImageObject *ext = [WXImageObject object];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"share.png"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        filePath = [[NSBundle mainBundle] pathForResource:@"share" ofType:@"png"];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        filePath=nil;
    }
    NSLog(@"filepath :%@",filePath);
    ext.imageData = [NSData dataWithContentsOfFile:filePath];
    
    UIImage* image = [UIImage imageWithData:ext.imageData];
    ext.imageData = UIImagePNGRepresentation(image);
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    if(shareContent!="")
        req.text=[NSString stringWithUTF8String:shareContent.c_str()] ;
    [WXApi sendReq:req];
}


void libOS::weChatSharePerson(const std::string& shareContent)
{
    setShareWeChatCallBackEnabled();
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.text = [NSString stringWithUTF8String:shareContent.c_str()];
    req.bText = YES;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}
void libOS::weChatSharePerson(const std::string& shareImgPath,const std::string& shareContent)
{
    setShareWeChatCallBackEnabled();
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"share.png"]];
    
    WXImageObject *ext = [WXImageObject object];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"share.png"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        filePath = [[NSBundle mainBundle] pathForResource:@"share" ofType:@"png"];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        filePath=nil;
    }
    NSLog(@"filepath :%@",filePath);
    ext.imageData = [NSData dataWithContentsOfFile:filePath];
    
    UIImage* image = [UIImage imageWithData:ext.imageData];
    ext.imageData = UIImagePNGRepresentation(image);
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    if(shareContent!="")
        req.text=[NSString stringWithUTF8String:shareContent.c_str()] ;
    [WXApi sendReq:req];
}

void libOS::playMovie(const char *fileName, int needSkip /*= true*/)
{
    setShareWeChatCallBackEnabled();
    MovieMgr::instance()->playMovie(fileName, needSkip);	
}

void libOS::stopMovie()
{
    MovieMgr::instance()->stopMovie();
}

int libOS::getSecondsFromGMT()
{
    NSTimeZone* zone = [NSTimeZone systemTimeZone];
    NSInteger secondes = [zone secondsFromGMT];
    return secondes;
}

