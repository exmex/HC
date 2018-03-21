//
//  Platform.m
//  hero
//
//  Created by Lyon on 10/6/14.
//
//

#import "PlatformSupport.h"
#import <GameKit/GameKit.h>


#import "apiforlua.h"
#import "PlatformSupport.h"
#import "GateKeeper.h"
#import "CCLuaEngine.h"
#import "DataStorage.h"
#import "cocos2d.h"
#import "AppController.h"
#import "ModuleAppStore.h"
#import "FacebookController.h"

@implementation PlatformSupport

#define LOGIN_OP_PROGRESS_KEY "LOGIN_OP_PROGRESS_KEY"

#define AERLT_WIN_NETWORK_ERROR "ERROR"
#define AERLT_WIN_GAMECENTER_BIND "BING"

#define LOGIN_PROGRESS_DEVICE 1
#define LOGIN_PROGRESS_GAMECENTER_CHECK 2
#define LOGIN_PROGRESS_GAMECENTER_BIND 3
#define LOGIN_PROGRESS_ENTER_GAME 4


@synthesize currentPlayerID,
gameCenterAuthenticationComplete;

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] \
compare:v options:NSNumericSearch] == NSOrderedAscending)


//====================game center begin====================//
#pragma mark -
#pragma mark Application lifecycle
// Check for the availability of Game Center API.
BOOL isGameCenterAPIAvailable()
{
    // Check for presence of GKLocalPlayer API.
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // The device must be running running iOS 4.1 or later.
    NSString *reqSysVer = @"6.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}



-(void)gameCenterLogin{
    self.gameCenterAuthenticationComplete = NO;
    
    if (!isGameCenterAPIAvailable()) {
        // Game Center is not availœable.
        [self gameCenterAuthentFailed];
    } else {
        GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
        
        if (localPlayer.isAuthenticated) {
            [self gameCenterAuthentSuccse:localPlayer];
        } else {
            if (SYSTEM_VERSION_LESS_THAN(@"6.0"))
            {
                // ios 5.x and below
                localPlayer.authenticateHandler =
                ^(UIViewController *viewController,
                  NSError *error) {
                    
                    // Player already authenticated
                    if (localPlayer.isAuthenticated) {
                        [self gameCenterAuthentSuccse:localPlayer];
                    } else {
                        [self gameCenterAuthentFailed];
                    }
                };
            }
            else
            {
                // ios 6.0 and above
                [localPlayer setAuthenticateHandler:(^(UIViewController* viewController, NSError *error) {
                    
//                    cocos2d::CCDirector::sharedDirector()->resume();
                    if (error && error.code == GKErrorCancelled) {
                        NSLog(@"Game Center code:%d %@", error.code, [error debugDescription]);
                        [self gameCenterAuthentFailed];
                        return ;
                    }
                    if (localPlayer.isAuthenticated) {
                        [self gameCenterAuthentSuccse:localPlayer];
                    }
                    else if (viewController) {
//                        cocos2d::CCDirector::sharedDirector()->pause();
                        RootViewController* root = [[AppController shared] getViewController];
                        [root presentViewController:viewController animated:YES completion:nil];
                    }
                })];
            }
            
        }
        
        
    }
}

-(void)gameCenterAuthentSuccse:(GKLocalPlayer*)localPlayer{
    self.gameCenterAuthenticationComplete = YES;
    
    if (! self.currentPlayerID || ! [self.currentPlayerID isEqualToString:localPlayer.playerID]) {
        // Current playerID has changed. Create/Load a game state around the new user.
        self.currentPlayerID = localPlayer.playerID;
        NSString* nickname =  localPlayer.alias;
        if (nickname != nil) {
            [DataStorage setGameCenterNickName:nickname];
        }
        // Load game instance for new current player, if none exists create a new.
        [self postCheckGameCenter];
    }
}
-(void)gameCenterAuthentFailed{
    self.gameCenterAuthenticationComplete = NO;
}



//====================game center end====================//


-(NSString*)getGameCenterID{
    return currentPlayerID;
}

//====================获取发送数据 begin====================//
- (NSData*)getWebLoginJsonData{
    currentPlayerID = @"";
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    NSString* deviceId = [DataStorage getDeviceId];
    NSString* uuId = [DataStorage getUUID];
    NSString* zoneTime = [DataStorage getTimeZone];
    [dictionary setValue:deviceId forKey:@"deviceID"];
    [dictionary setValue:uuId forKey:@"uuid"];
    [dictionary setValue:zoneTime forKey:@"timeZone"];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"dic->%@",error);
    }
    
    [dictionary release];
    return jsonData;
}

- (NSData*)getGameCenterJsonData{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    NSString* deviceId = [DataStorage getDeviceId];
    NSString* uin = [DataStorage getUUID];
    NSString* playerID = [self getGameCenterID];
    if(playerID.length <=0){
        return nil;
    }
    [dictionary setValue:deviceId forKey:@"deviceID"];
    [dictionary setValue:uin forKey:@"uuid"];
    [dictionary setValue:playerID forKey:@"playerID"];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"dic->%@",error);
    }
    
    [dictionary release];
    return jsonData;
}

//====================获取发送数据 end====================//


//====================网络消息发送 begin====================//
-(void)postWebLogin{
    self.gameProgress = LOGIN_PROGRESS_DEVICE;
    NSData* sendData = [self getWebLoginJsonData];
    
    NSString* loginUrl = @GK_DEVICE_LOGIN_URL;
    std::string versionStr = cocos2d::CCUserDefault::sharedUserDefault()->getStringForKey("current-version");
    NSString* nsVersion = [NSString stringWithCString:versionStr.c_str() encoding:[NSString defaultCStringEncoding]];
    loginUrl = [loginUrl stringByAppendingString:nsVersion];
    
//    NSURL *serverurl = [NSURL URLWithString:loginUrl];
    [self httpPostMessage:sendData URL:loginUrl];
}

-(void)postCheckGameCenter{
    self.gameProgress = LOGIN_PROGRESS_GAMECENTER_CHECK;
    NSData* sendData = [self getGameCenterJsonData];
    if(sendData != nil){
//        NSURL *serverurl = [NSURL URLWithString:@GK_GAMECENTER_LOGIN_CHECK];
        [self httpPostMessage:sendData URL:@GK_GAMECENTER_LOGIN_CHECK];
    }
}

-(void)postBindGameCenter{
    self.gameProgress = LOGIN_PROGRESS_GAMECENTER_BIND;
    NSData* sendData= [self getGameCenterJsonData];
    if(sendData != nil){
//        NSURL *serverurl = [NSURL URLWithString:@GK_GAMECENTER_BING_NEW];
        [self httpPostMessage:sendData URL:@GK_GAMECENTER_BING_NEW];
    }
}

//====================网络消息发送 end====================//

//====================http post op begin====================//
-(void)httpPostMessage:(NSData*)data URL:(NSString*)serverurl{
    
    NSString* deviceInfo = [DataStorage getDeviceInfo];
    serverurl = [serverurl stringByAppendingString:deviceInfo];
    NSURL *httpurl = [NSURL URLWithString:serverurl];
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:httpurl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:8];

    [request setURL:httpurl];
    [request setHTTPMethod:@"POST"];
    
    //set headers
    NSString *contentType = [NSString stringWithFormat:@"application/json"];
    NSString *postLength = [NSString stringWithFormat:@"%d", [data length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setValue:contentType forHTTPHeaderField:@"Accept"];
    
    NSMutableData *postBody = [NSMutableData dataWithData:data];
    //post
    [request setHTTPBody:postBody];
    
    //第三步，连接服务器
    if (connection != nil) {
        [connection release];
        connection = nil;
    }
    connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [request release];
}


//接收到服务器回应的时候调用此方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
        NSInteger code =[res statusCode];
        if ( code < 200 || code >= 300) {
            NSLog(@"error");
            //出错了
        }
    }
    self.receiveData = [[NSMutableData alloc]init];
}
//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receiveData appendData:data];
    
}
//数据传完之后调用此方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    switch (self.gameProgress) {
        case LOGIN_PROGRESS_DEVICE:
            [self webLoginResponse:self.receiveData];
            break;
        case LOGIN_PROGRESS_GAMECENTER_CHECK:
            [self checkGameCenterResponse:self.receiveData];
            break;
        case LOGIN_PROGRESS_GAMECENTER_BIND:
            [self bindGameCenterResponse:self.receiveData];
            break;
        case LOGIN_PROGRESS_ENTER_GAME:
            break;
        default:
            break;
    }
    
    [self.receiveData release];
    self.receiveData =nil;
}
//====================http post end====================//

//====================服务器消息响应 begin====================//
-(void)webLoginResponse:(NSData*)data{
    NSError *error = [[NSError alloc] init];
    NSMutableDictionary* jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    NSString* uin = [jsonObject objectForKey:@"uin"];
    NSString* sessionKey = [jsonObject objectForKey:@"sessionKey"];
    NSString* userId = [jsonObject objectForKey:@"userId"];
    NSString* serverId = [jsonObject objectForKey:@"serverId"];
    NSString* deviceID = [jsonObject objectForKey:@"deviceID"];
    NSString* serverIP = [jsonObject objectForKey:@"serverIP"];
    NSString* serverPort = [jsonObject objectForKey:@"serverPort"];
    NSString* productionList = [jsonObject objectForKey:@"rechargeProductionIdList"];
    [[ModuleAppStore shared] getRechargeProductionIdInfo:productionList];
    if(uin == nil || sessionKey == nil || userId == nil || serverId==nil){
        [self showReconnectWin];
        return;
    }
    [DataStorage setDeviceId:deviceID];
    std::string uinstd = [uin UTF8String];
    std::string sessionKeystd = [sessionKey UTF8String];
    std::string userIdstd = [userId UTF8String];
    std::string serverIdstd = [serverId UTF8String];
    std::string deviceIDstd = [deviceID UTF8String];
    std::string serverIPstd = [serverIP UTF8String];
    std::string serverPortstd = [serverPort UTF8String];
    
    setUserID(TRUE,sessionKeystd.c_str(), uinstd.c_str(),userIdstd.c_str(),serverIdstd.c_str(),serverIPstd.c_str(),serverPortstd.c_str());
    [error dealloc];
    
    if (!FacebookController::IsLoggedIn()) {
        NSLog(@"facebook creat.....");
        //DidChangeFBLoginState(false);
        
        FacebookController::CreateNewSession();
        FacebookController::OpenSession(FacebookController::doLog);
    }
    else {
        //DidChangeFBLoginState(true);
    }
}

-(void)checkGameCenterResponse:(NSData*)data{
    NSError *error = [[NSError alloc] init];
    NSMutableDictionary* jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    // NSString* reterror = [jsonObject objectForKey:@"error"];
    NSString* state = [jsonObject objectForKey:@"state"];
    NSInteger result = [state intValue];
    NSString* playerName = [jsonObject objectForKey:@"linkedAccountName"];
    NSString* playerLevel = [jsonObject objectForKey:@"linkedAccountLevel"];
    if(result > 0){
        [self showBindGameCenterWin:playerName :playerLevel];
    }
    [error dealloc];
}

-(void)bindGameCenterResponse:(NSData*)data{
    [self postWebLogin];
    //    NSError *error = [[NSError alloc] init];
    //    NSMutableDictionary* jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    //
    //    NSString* reterror = [jsonObject objectForKey:@"error"];
    //    NSString* state = [jsonObject objectForKey:@"state"];
}


//====================服务器消息响应 end====================//


//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法
-(void)connection:(NSURLConnection *)connection
 didFailWithError:(NSError *)error
{
    [self.receiveData release];
    [self showReconnectWin];
}

-(void)showBindGameCenterWin:(NSString*)playerName :(NSString*)playerLevel{
    alertWinType = @AERLT_WIN_GAMECENTER_BIND;
    NSString* info = @"Do you want to load ";
    info = [info stringByAppendingString:playerName];
    info = [info stringByAppendingString:@" with level "];
    info = [info stringByAppendingString:playerLevel];
    info = [info stringByAppendingString:@"? Warning: progress in the current game will be lost."];
    UIAlertView *bindAlertView = [[UIAlertView alloc] initWithTitle:@"Game Center Alert" message:info delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Okay", nil];
    [bindAlertView show];
    [bindAlertView release];
}

-(void) showReconnectWin{
    alertWinType = @AERLT_WIN_NETWORK_ERROR;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Connection error" message:@"Unable to connect with the server. Check your internet connection and try again." delegate:self cancelButtonTitle:@"Try again" otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        if([alertWinType compare:@AERLT_WIN_GAMECENTER_BIND]== NSOrderedSame){
            [self postBindGameCenter];
            restartGame();
            return;
        }
    }
    if([alertWinType compare:@AERLT_WIN_NETWORK_ERROR] == NSOrderedSame){
        [self reConnection];
    }
}

-(void)reConnection{
    switch (self.gameProgress) {
        case LOGIN_PROGRESS_DEVICE:
            [self postWebLogin];
            break;
        case LOGIN_PROGRESS_GAMECENTER_CHECK:
            [self postCheckGameCenter];
            break;
        case LOGIN_PROGRESS_GAMECENTER_BIND:
            [self postBindGameCenter];
            break;
        case LOGIN_PROGRESS_ENTER_GAME:
            break;
        default:
            break;
    }
}

- (void)dealloc {
    [super dealloc];
    [self.receiveData dealloc];
}


@end


