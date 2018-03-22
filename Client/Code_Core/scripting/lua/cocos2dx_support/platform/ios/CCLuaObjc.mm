
#include "CCLuaObjc.h"
#include "AppController.h"
#include "PlatformSupport.h"
#include "ModuleAppStore.h"
#include "DataStorage.h"
#include "FacebookController.h"
NS_CC_BEGIN

void CCLuaObjc::LuaEnterGameNotify()
{
    [[AppController getPlatformSupport]  gameCenterLogin];
}

void CCLuaObjc::doRecharge(const char* title,int itemId,int cost,const char* gameServerId,const char* uin)
{
    
    char* itemIdStr = new char[128];
    
    sprintf(itemIdStr, "%d",itemId);
    
    NSString* nsUin= [NSString stringWithCString:uin encoding:[NSString defaultCStringEncoding]];
    NSString* nsServerIdStr= [NSString stringWithCString:gameServerId encoding:[NSString defaultCStringEncoding]];
    NSString* nsItemIdStr= [NSString stringWithCString:itemIdStr encoding:[NSString defaultCStringEncoding]];
    [[ModuleAppStore shared]  doPayment:nsUin:nsServerIdStr:nsItemIdStr];
}

void CCLuaObjc::dologin()
{
    [[AppController getPlatformSupport]  postWebLogin];
}

void CCLuaObjc::addLocalNotification(const char *key, const char * text, const char *itag, long date)
{
    
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    // 设置notification的属性
    localNotification.fireDate =   [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)date];  //出发时间
    
    localNotification.alertBody = [[NSString alloc] initWithCString:text encoding:NSUTF8StringEncoding]; // 消息内容
    
    if(strcmp(itag, "day")==0)
    {
        localNotification.repeatInterval = NSDayCalendarUnit; // 重复的时间间隔
    }
    else
    {
        localNotification.repeatInterval = 0;
    }
    localNotification.soundName = UILocalNotificationDefaultSoundName; // 触发消息时播放的声音
    localNotification.applicationIconBadgeNumber = 1; //应用程序Badge数目
    
    //设置随Notification传递的参数
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             [[NSString alloc] initWithCString:key encoding:NSUTF8StringEncoding], @"key",
                             [[NSString alloc] initWithCString:itag encoding:NSUTF8StringEncoding], @"tag" , nil];
    localNotification.userInfo = infoDict;

    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification]; //注册
    [localNotification release]; //释放

}

void CCLuaObjc::cancelLocalNotification(const char *key)
{
    NSString *nsKey =  [[NSString alloc] initWithCString:key encoding:NSUTF8StringEncoding];
    
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in notifications ) {
        if( [[notification.userInfo objectForKey:@"key"] isEqualToString:nsKey] ) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            break;
        }
    }
}
void CCLuaObjc::openURL(const char *szUrl)
{
    NSString *url =  [NSString stringWithCString:szUrl encoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url ]];
}

void CCLuaObjc::sendMailReportIssue(const char* issueType,const char* clientVersion,const char* playerID)
{
//    const char* playerId,
    NSMutableString *mailUrl = [[[NSMutableString alloc]init]autorelease];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: @"support@ucool.com"];
    [mailUrl appendFormat:@"mailto:%@", [toRecipients componentsJoinedByString:@","]];
    //添加抄送
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"",nil];
    [mailUrl appendFormat:@"?cc=%@", [ccRecipients componentsJoinedByString:@","]];
    //添加密送
    NSArray *bccRecipients = [NSArray arrayWithObjects:@"", nil];
    [mailUrl appendFormat:@"&bcc=%@", [bccRecipients componentsJoinedByString:@","]];
    //添加主题
    NSString* nsIssueType= [NSString stringWithCString:issueType encoding:[NSString defaultCStringEncoding]];

    [mailUrl appendString:@"&subject=Heroes Charge "];
    [mailUrl appendString:nsIssueType];
    
    /*
     UTC Time:
     Version:
     PlayerID:
     Category: Report probem
     Language: EN
     Device Type: ipod5.1
     OS Version: 7.1.1
     */
    
    if([nsIssueType isEqualToString: @"Lost Account"])
    {
        [mailUrl appendString:@"&body=Please Give us the following information about your lost account."];
        [mailUrl appendString:@"\nExact name of account:"];
        [mailUrl appendString:@"\nGame level:"];
        [mailUrl appendString:@"\nName of guild(if any):\n\n\n\n"];
        
    }else{
        [mailUrl appendString:@"&body=\n\n\n\n"];
    }
    
    [mailUrl appendString:@"\n---------DO NOT DELETE---------"];
    NSString* strTime = [DataStorage getLocalTime];
    [mailUrl appendString:@"\nLocal Time: "];
    [mailUrl appendString:strTime];
    [mailUrl appendString:@"\nTime Stamp: "];
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval itime=[dat timeIntervalSince1970];
    long long dTime = [[NSNumber numberWithDouble:itime] longLongValue]; // 将double转为long long型
    NSString *timeString = [NSString stringWithFormat:@"%llu",dTime];
    //NSString *timeString = [NSString stringWithFormat:@"%f", a];
    
    [mailUrl appendString:timeString];
    NSLog(@"date1:%@",timeString);
    [dat release];
    
    
    [mailUrl appendString:@"\nGame: Heroes Charge"];
    NSString* nsVersion= [NSString stringWithCString:clientVersion encoding:[NSString defaultCStringEncoding]];
    [mailUrl appendString:@"\nVersion: "];
    [mailUrl appendString:nsVersion];
    NSString* nsPlayerId= [NSString stringWithCString:playerID encoding:[NSString defaultCStringEncoding]];
    [mailUrl appendString:@"\nPlayerID: "];
    [mailUrl appendString:nsPlayerId];
    
    
    [mailUrl appendString:@"\nCategory: "];
    [mailUrl appendString:nsIssueType];
    [mailUrl appendString:@"\nLanguage: "];
    NSString* language = [DataStorage getCurrentLanguage];
    [mailUrl appendString:language];
    NSString* strModel  = [DataStorage getDeviceAndOSInfo];
    [mailUrl appendString:@"\nDevice Type: "];
    [mailUrl appendString:strModel];
    NSString* strSysVersion = [[UIDevice currentDevice] systemVersion];
    [mailUrl appendString:@"\nOS Version: "];
    [mailUrl appendString:strSysVersion];
    [mailUrl appendString:@"\n-------------------------------"];
    //NSString *immutableString = [NSString stringWithString:info];
    
    //添加邮件内容
    //[mailUrl appendString:@"&body=<b>email</b> body!"];
    NSString* email = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];


}

void CCLuaObjc::getShopPriceInfo(const char* items){
//    NSString* nsstrItem = [NSString stringWithCString:items encoding:[NSString defaultCStringEncoding]];
//    NSArray* array = [nsstrItem componentsSeparatedByString:@":"];
//    [[ModuleAppStore shared] getShopPriceInfo:array];
}

int CCLuaObjc::isFacebookConnected(){
    if(FacebookController::IsLoggedIn() == true){
        return 1;
    }
    
    return 0;
}

void CCLuaObjc::connectFacebook(){
    FacebookController::Login(FacebookController::doLog);
}

void CCLuaObjc::disConnectFacebook(){
    FacebookController::Logout(FacebookController::doLog);
}

NS_CC_END

