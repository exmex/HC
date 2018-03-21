//
//  ServerLogic.m
//  com4lovesSDK
//
//  Created by fish on 13-8-28.
//  Copyright (c) 2013年 com4loves. All rights reserved.
//

#import "ServerLogic.h"
#import <UIKit/UIKit.h>

#import "SDKUtility.h"
#import "JSON.h"
#import "SDKEncrypt.h"
#import "com4lovesSDK.h"
#import "YouaiUser.h"
#import "SBJSON.h"
#import "NSObject+SBJSON.h"
#import "SvUDIDTools.h"
#import <AdSupport/ASIdentifierManager.h>

#define IS_IOS7 [[UIDevice currentDevice].systemVersion hasPrefix:@"7"]

#define IS_IOS8 [[UIDevice currentDevice].systemVersion hasPrefix:@"8"]

#define IOS6_BEYOND [[UIDevice currentDevice]systemVersion].floatValue >= 6.0
//std::string deviceID = libOS::getInstance()->getDeviceID();


@interface ServerLogic()
{
    NSString* mYouaiID;
    long long mTimestamp;
    NSString* mLoginedUserName;
    NSString* mLoginedPassword;
    NSNumber* mUserType;
    NSString* mPrecreatedYouaiName;
    NSString* mPrecreatedPassword;
    NSMutableDictionary* userList;
    NSDictionary* serverUserList;
    BOOL serverInited;
    NSString* ServerUrl;
    NSArray *userUsedServers;
}
@end

@implementation ServerLogic

+(ServerLogic*) sharedInstance {
    static ServerLogic *_instance = nil;
    if (_instance == nil) {
        _instance = [[ServerLogic alloc] init];
        [_instance initialize];
    }
    return _instance;
}

-(void)initialize
{
    serverInited = false;
}

-(void)initUserList
{
    NSDictionary * dic = [[NSUserDefaults standardUserDefaults] objectForKey:UserListUserDefault];
    mUserType = [NSNumber numberWithInt:0];
    //把老数据转过来 dic to json
    if ([dic count]!=0) {
        userList = [[NSMutableDictionary alloc] init];
        for(NSString * akey in dic)
        {
            NSString* password = [dic objectForKey:akey];
            NSString* passwordOK = [[SDKEncrypt sharedInstance] base64Decrypt:password];
            YouaiUser* youaiUser = [[YouaiUser alloc] init];
            [youaiUser setName:akey];
            [youaiUser setPassword:passwordOK];
            [userList setValue:youaiUser forKey:youaiUser.youaiId];
            [youaiUser release];
        }
        [self updateUserList];
        [[NSUserDefaults standardUserDefaults] delete:UserListUserDefault];
    }
    //从本地初始化list
    [self initLocalUserList];
    //本地没有 从网络拉取
    if([userList count]==0)
    {
        if([self getyouaiNames] && serverUserList)
        {
            NSArray* users = [serverUserList objectForKey:@"users"];
            for(NSDictionary * user in users)
            {
                YouaiUser* youaiUser = [[YouaiUser alloc] init];
                [youaiUser setName:[user objectForKey:@"name"]];
                [youaiUser setYouaiId:[user objectForKey:@"nuclearId"]];
                NSNumber *myNum = [user objectForKey:@"userType"];
                [youaiUser setUserType:[myNum integerValue]];
                YALog(@"userType %d",[myNum intValue]);
                [userList setValue:youaiUser forKey:youaiUser.youaiId];
                [youaiUser release];
            }
            [self updateUserList];
        }
    }   
}
-(BOOL)removeUserInUserList:(YouaiUser *)user
{
    [userList removeObjectForKey:user.youaiId];
    return YES;
}

-(NSNumber*)getLoginUserType
{
    return mUserType;
}

-(NSMutableDictionary*)getUserList
{
    return userList;
}
-(NSString*)getTryUser
{
    NSArray* users = [userList allValues];
    for (YouaiUser *user in users) {
        if (user.userType==UserTypeTryUser) {
            return user.youaiId;
        }
    }
    return  nil;
}

-(NSString*)getLatestUser
{
    return  [[NSUserDefaults standardUserDefaults] valueForKey:LatestUserUserDefault];
}
-(NSString*)getLatestUserPassword
{
    NSString* password =  [[NSUserDefaults standardUserDefaults] valueForKey:LatestUserUserPasswordDefault];
    if (password) {
        return [[SDKEncrypt sharedInstance] base64Decrypt:[NSString stringWithString:password]];
    }
    return nil;
}
-(NSString*)getYouaiID
{
    return mYouaiID;
}
-(void) setYouaiID:(NSString*)youaiID
{
    if([mYouaiID isEqualToString:youaiID]==NO)
    {
        mYouaiID = [NSString stringWithString:youaiID];
        [mYouaiID retain];
    }

}

-(NSString*)getPrecreatedYouaiName
{
    return mPrecreatedYouaiName;
}
-(NSString*)getPrecreatedPassword
{
    return mPrecreatedPassword;
}
-(NSString*)getLoginedUserName
{
    return mLoginedUserName;
}
-(NSArray *)getUserLoginedServers;
{
    if(userUsedServers==nil)
    {
        [self getServerPlayerList];
    }
    return userUsedServers;
}
-(NSDictionary *) parseResult:(NSString *) _retValue
{

    NSString * retValue = [[SDKEncrypt sharedInstance] rsaDecrypt:_retValue];
    YALog(@"received:%@",retValue);
    
//    bool finalResult = NO;
    NSString * alertMsg = nil;
    
    //NSDictionary *array=[retValue JSONValue];//使用JSON解析返回数组类型
    SBJsonParser *jsonParser = [SBJsonParser new];
    id repr = [jsonParser objectWithString:retValue];
    if (!repr)
    {
//        YALog(@"-JSONValue failed. Error trace is: %@", [jsonParser errorTrace]);
        return nil;
    }
    [jsonParser release];
    
    NSDictionary *array = repr;
    
    NSNumber* resultObj = [array objectForKey:@"error"];
    
    int result = 500;
    if(resultObj)
        result = [resultObj intValue];
    
    NSNumber* timeObj = [array objectForKey:@"timestamp"];
    if(timeObj)
        mTimestamp = [timeObj longLongValue];
    
    if(result == 200)
    {
//        finalResult = YES;
        NSDictionary* retData = [array objectForKey:@"data"];
        return retData;
    }
    else
    {
        alertMsg = [array objectForKey:@"errorMessage"];
        if(alertMsg == nil)
        {
            alertMsg =[com4lovesSDK getLang:@"welcome"];
        } else {
            [[SDKUtility sharedInstance] showAlertMessage:alertMsg];
        }
        return nil;
        
    }
    
}

/*
 header获取方案
 IDFA字段         全部设备都要获取,其中系统>=IOS6的时候取IDFA, 系统<IOS6 用默认值  unavailable
                 (IDFA会存在钥匙串里面,不会改变)
 MAC字段          全部设备都要获取,IOS7 取得之后照常发送
 deviceMackID    系统>=IOS6时候为IDFV,系统<IOS6为MAC 
                 (IDFV 存储在钥匙串里面不会改变) 
 */
- (NSString*) buildData : (NSDictionary*) data
{
    NSString* macaddress = nil;
    if (IS_IOS7||IS_IOS8) { //ios 7 系统取UDID
        macaddress = [[SvUDIDTools UDID] retain];
    } else {
       macaddress = [[[SDKUtility sharedInstance] getMacAddress] retain];
    }

    NSString* devicename = [[UIDevice currentDevice] name];
    NSNumber* timestamp = [NSNumber numberWithLongLong:mTimestamp];
    NSString* appkey = [com4lovesSDK getAppID];
    NSDictionary *header= nil;
    //如果是IOS7以上设备 发送IDFA
    NSString *idfa = @"unavailable";
    if (IOS6_BEYOND) {
        idfa = [[SvUDIDTools IDFAWithKeychain] retain];
    }
    NSString *mac = [[[SDKUtility sharedInstance] getMacAddressOnly] retain];
    header = [NSDictionary dictionaryWithObjectsAndKeys:
                appkey,@"gameId",
                [com4lovesSDK getPlatformID],@"platform",
                macaddress,@"deviceMacId",
                timestamp,@"timestamp",
                devicename,@"deviceName",
                [[UIDevice currentDevice]systemVersion],@"osVersion",
                [NSString stringWithFormat:@"%@&%@",mac,idfa],@"idfa"
                ,nil];
    [idfa release];
    [mac release];
    
    YALog(@"header %@",header);

    NSDictionary *all= [NSDictionary dictionaryWithObjectsAndKeys:data,@"data",
                                   header,@"header",nil];

    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    
    NSString *jsonString=nil;
    jsonString=[writer stringWithObject:all];
    [writer release];
    //YALog(@"send:%@",jsonString);
    [macaddress release];

    return [[SDKEncrypt sharedInstance] rsaEncrypt:jsonString];
}

-(int) putToServerForDeviceInfo
{
    NSString* macaddress = nil;
    if (IS_IOS7 || IS_IOS8) { //ios 7 系统取UDID
        macaddress = [[SvUDIDTools UDID] retain];
    } else {
        macaddress = [[[SDKUtility sharedInstance] getMacAddress] retain];
    }
    NSDictionary* Devicedata = [NSDictionary dictionaryWithObjectsAndKeys:
                                macaddress,@"deviceMacId",
                                [[UIDevice currentDevice] name],@"deviceName",
                                [com4lovesSDK getPlatformID],@"platform",
                                [com4lovesSDK getAppID],@"gameId",
                                nil];
    NSString* devactionUrl = [[[NSString alloc] initWithString:@"nuclear/connect/init/user/action"] autorelease];
    NSString *postStr = [self buildData:Devicedata];
    [[SDKUtility sharedInstance] setWaiting:YES];
//    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
//    NSString *postStr=nil;
//    postStr=[writer stringWithObject:Devicedata];
//    [writer release];
//    writer = nil;
    //postStr=[[SDKEncrypt sharedInstance] rsaEncrypt:postStr];
    //    NSString *postStr = [self buildData:data];
    NSMutableString* actionUrl = [NSMutableString stringWithString:SERVER_IP];
    [actionUrl appendString:devactionUrl];
    
    YALog(@"sendto:%@",actionUrl);
    
    NSString* md5 = nil;
    
    if(Devicedata!=nil)
    {
        NSMutableString* checkmd5str = [NSMutableString stringWithString:postStr];
        [checkmd5str appendString:@"-128315"];
        md5 = [[SDKUtility sharedInstance] md5HexDigest:checkmd5str];
    }
    
    NSData *postdata=[postStr dataUsingEncoding:NSUTF8StringEncoding];
    [[SDKUtility sharedInstance] setWaiting:NO];
    return  [[SDKUtility sharedInstance] httpPutForStatus:actionUrl postData:postdata md5check:md5];
}

-(int) putToServerForStatusCode:(NSString*)command dataToPut:(NSDictionary*) data
{
    [[SDKUtility sharedInstance] setWaiting:YES];
    NSString *postStr = [self buildData:data];
    NSMutableString* actionUrl = [NSMutableString stringWithString:ServerUrl];
    [actionUrl appendString:command];
    
    YALog(@"sendto:%@",actionUrl);
    
    NSString* md5 = nil;
    
    if(data!=nil)
    {
        NSMutableString* checkmd5str = [NSMutableString stringWithString:postStr];
        [checkmd5str appendString:@"-128315"];
        
        md5 = [[SDKUtility sharedInstance] md5HexDigest:checkmd5str];
    }
    
    NSData *postdata=[postStr dataUsingEncoding:NSUTF8StringEncoding];
    [[SDKUtility sharedInstance] setWaiting:NO];
    return  [[SDKUtility sharedInstance] httpPutForStatus:actionUrl postData:postdata md5check:md5];
}

-(NSDictionary*) putToServer:(NSString*)command dataToPut:(NSDictionary*) data
{
    [[SDKUtility sharedInstance] setWaiting:YES];
    NSString *postStr = [self buildData:data];
    NSMutableString* actionUrl = [NSMutableString stringWithString:ServerUrl];
    [actionUrl appendString:command];
    
    YALog(@"sendto:%@",actionUrl);
    
    NSString* md5 = nil;
    
    if(data!=nil)
    {
        NSMutableString* checkmd5str = [NSMutableString stringWithString:postStr];
        [checkmd5str appendString:@"-128315"];
        
        md5 = [[SDKUtility sharedInstance] md5HexDigest:checkmd5str];
    }
    
    NSData *postdata=[postStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *retValue = [[SDKUtility sharedInstance] httpPut:actionUrl postData:postdata md5check:md5];
    [[SDKUtility sharedInstance] setWaiting:NO];
    return [self parseResult:retValue];
    
}

-(void) putToServerByGCD:(NSString*)command dataToPut:(NSDictionary*) data
                        withBlock:(void (^)(NSDictionary *result))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *postStr = [self buildData:data];
        NSMutableString* actionUrl = [NSMutableString stringWithString:ServerUrl];
        [actionUrl appendString:command];
        
        YALog(@"sendto:%@",actionUrl);
        
        NSString* md5 = nil;
        
        if(data!=nil)
        {
            NSMutableString* checkmd5str = [NSMutableString stringWithString:postStr];
            [checkmd5str appendString:@"-128315"];
            
            md5 = [[SDKUtility sharedInstance] md5HexDigest:checkmd5str];
        }
        
        NSData *postdata=[postStr dataUsingEncoding:NSUTF8StringEncoding];
        NSString *retValue = [[SDKUtility sharedInstance] httpPut:actionUrl postData:postdata md5check:md5];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block)
            {
                block([self parseResult:retValue]);
            }
        });
    });
    
}


-(void) putToServerAsyn:(NSString*)command dataToPut:(NSDictionary*) data selector:(SEL)selector
{
    [[SDKUtility sharedInstance] setWaiting:YES];
    NSString *postStr = [self buildData:data];
    NSMutableString* actionUrl = [NSMutableString stringWithString:ServerUrl];
    [actionUrl appendString:command];
    
    YALog(@"sendto:%@",actionUrl);
    
    NSString* md5 = nil;
    
    if(data!=nil)
    {
        NSMutableString* checkmd5str = [NSMutableString stringWithString:postStr];
        [checkmd5str appendString:@"-128315"];
        
        md5 = [[SDKUtility sharedInstance] md5HexDigest:checkmd5str];
    }
    
    NSData *postdata=[postStr dataUsingEncoding:NSUTF8StringEncoding];
    [[SDKUtility sharedInstance] httpAsynPut:actionUrl postData:postdata md5check:md5 selector:selector object:self];

    
}

-(void) clearLoginInfo
{
    if(mYouaiID)
    {
        [mYouaiID release];
        mYouaiID = nil;
    }
    mLoginedPassword = nil;
    mLoginedUserName = nil;
    mUserType = nil;
}

-(BOOL) isUser:(YouaiUser *) user inList:(NSArray *)list
{
    for (YouaiUser *temp in list) {
        if ([temp.youaiId isEqualToString:user.youaiId]) {
            return YES;
        }
    }
    YALog(@"重复了 %@",user.youaiId);
    return NO;
}

-(BOOL) saveUserListToJsonArray:(NSMutableDictionary *)jsonValue
{
    SBJSON *jsonParser = [[SBJSON alloc]init];
    YALog(@"jsonValue %@",jsonValue);
    NSError *e = nil;
    NSString *jsonString = [jsonParser stringWithObject:jsonValue error:&e];
    if (e) {
         YALog(@"json failed:%@", [e localizedDescription]);
    }
//    assert(!e);
    YALog(@"jsonValue %@",jsonValue);
    YALog(@"JsonString  %@",jsonString);
    
    NSData *dataToFile = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *realpath =[DocumentsFolder stringByAppendingPathComponent:@"userinfo5.dat"];
    [fm removeItemAtPath:realpath error:&e];
//    [fm ]
    if (e) {
        YALog(@"json failed:%@", [e localizedDescription]);
    }
//    assert(!e);
    if ([fm createFileAtPath:realpath contents:dataToFile attributes:nil]) {
        NSFileHandle *outFile;
        outFile = [NSFileHandle fileHandleForWritingAtPath:realpath];
        if (outFile ==nil) {
        }
        [outFile writeData:dataToFile];
    }
    [jsonParser release];
    return YES;
}

- (void)initLocalUserList
{
    NSString *realpath =[DocumentsFolder stringByAppendingPathComponent:@"userinfo5.dat"];
    NSData *filedata = [[NSData alloc] initWithContentsOfFile:realpath];
    NSString *jsonstring1 = [[NSString alloc]initWithData:filedata encoding:NSUTF8StringEncoding];
    NSMutableDictionary* recordWholeArray = [jsonstring1 JSONValue];
//    [userList release];
    [userList release];
    userList = [[NSMutableDictionary alloc] init];
    YALog(@"recoredarray%@",recordWholeArray);

    if (recordWholeArray) {
        NSArray* users = [recordWholeArray allValues];
        for (NSDictionary* user in users) {
            YouaiUser *youaiUser = [[YouaiUser alloc] init];
            [youaiUser setName:[user objectForKey:@"name"]];
            NSNumber *myNum = [user objectForKey:@"userType"];
            [youaiUser setUserType:[myNum integerValue]];
            [youaiUser setYouaiId:[user objectForKey:@"nuclearId"]];
            if ([user objectForKey:@"password"]) {
                YALog(@"password1 %@",[user objectForKey:@"password"]);
                YALog(@"password2 %@",[[SDKEncrypt sharedInstance] base64Decrypt:[user objectForKey:@"password"]]);
                [youaiUser  setPassword:[[SDKEncrypt sharedInstance] base64Decrypt:[user objectForKey:@"password"]]];
            }
            [userList setObject:youaiUser forKey:youaiUser.youaiId];
            [youaiUser release];
        }
    }

}

-(void) updateUserList
{
    [self saveUserListToJsonArray:userList];
    if (mLoginedPassword) {
        NSString* password =  [[SDKEncrypt sharedInstance] base64Encrypt:[NSString stringWithString:mLoginedPassword]];
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:LatestUserUserPasswordDefault];
    }else{
         [[NSUserDefaults standardUserDefaults] setObject:nil forKey:LatestUserUserPasswordDefault];
    }
    [[NSUserDefaults standardUserDefaults] setObject:mLoginedUserName forKey:LatestUserUserDefault];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString*) getServerUrl
{
    return ServerUrl;
}

-(BOOL) initServer
{
    if(serverInited==YES)
        return YES;
    
    ServerUrl = SERVER_URL;

    [[SDKUtility sharedInstance] setWaiting:YES];
    
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:
                          [com4lovesSDK getSDKAppID],@"appid",
                          [com4lovesSDK getSDKAppKey],@"appKey",
                          [com4lovesSDK getChannelID],@"channel",
                          nil];
    NSString* actionUrl = [[[NSString alloc] initWithString:@"nuclear/connect/init"] autorelease];
    
    int status = [self putToServerForStatusCode:actionUrl dataToPut:data];
    
    serverInited = (status==200);
    if (!serverInited) {
        ServerUrl = SERVER_IP;
        int i = 0;
        do {
            status = [self putToServerForStatusCode:actionUrl dataToPut:data];
            serverInited = (status==200);
            i++;
        } while (i<2&&!serverInited);
    }
    [[SDKUtility sharedInstance] setWaiting:NO];

    return serverInited;
}


-(BOOL) create:(NSString*)username password:(NSString*)password email:(NSString*)email
{
    if(! [self initServer])
    {
        [[SDKUtility sharedInstance] showAlertMessage:[com4lovesSDK getLang:@"notice_init_failed"]];
        return NO;
    }

    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:
                                username,@"nuclearName",
                                password,@"password",
                                [com4lovesSDK  getChannelID],@"channel",
                                email,@"email",
                                nil];
    NSString* actionUrl = [[[NSString alloc] initWithString:@"nuclear/users/create"] autorelease];
    
    NSDictionary* dataRet = [self putToServer:actionUrl dataToPut:data];
    
    if(dataRet)
    {
        mUserType = [NSNumber numberWithInt:1];

        if(mLoginedUserName!=nil && ![mLoginedUserName isEqualToString:username])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:com4loves_logout object:nil];
        }
        
        mYouaiID = [NSString stringWithString:[dataRet objectForKey:@"nuclearId"]];
        [mYouaiID retain];
        
        mLoginedUserName = [NSString stringWithString:username];
        [mLoginedUserName retain];
        
        mLoginedPassword = [NSString stringWithString:password];
        [mLoginedPassword retain];
        
        YouaiUser *user = [[YouaiUser alloc] init];
        user.youaiId = mYouaiID;
        user.name = mLoginedUserName;
        user.password = mLoginedPassword;
        user.userType  = 1;
        mUserType = [NSNumber numberWithInt:1];
        [userList setObject:user forKey:user.youaiId];
        
        [self updateUserList];
        [user release];
        [[NSNotificationCenter defaultCenter] postNotificationName:com4loves_loginDone object:nil];
        
        return YES;
    }
    else
    {
        return NO;
    }
    
}

-(BOOL) login:(NSString*)username password:(NSString*)password 
{
    if(! [self initServer])
    {
        [[SDKUtility sharedInstance] showAlertMessage:[com4lovesSDK getLang:@"notice_init_failed"]];
        return NO;
    }
    
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:
                          username,@"nuclearName",
                          password,@"password",
                          nil];
    NSString* actionUrl = [[[NSString alloc] initWithString:@"nuclear/users/login"] autorelease];
    
    NSDictionary* dataRet = [self putToServer:actionUrl dataToPut:data];
    
    if(dataRet)
    {
        mYouaiID = [NSString stringWithString:[dataRet objectForKey:@"nuclearId"]];
        [mYouaiID retain];
        mUserType = [NSNumber numberWithInt:1];
        if(mLoginedUserName!=nil && ![mLoginedUserName isEqualToString:username])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:com4loves_logout object:nil];
        }
        mLoginedUserName = [NSString stringWithString:username];
        [mLoginedUserName retain];
        
      
        mLoginedPassword = [NSString stringWithString:password];
        [mLoginedPassword retain];
        YouaiUser *user = [[YouaiUser alloc] init];
        [user setName:mLoginedUserName];
        [user setPassword:mLoginedPassword];
        [user setYouaiId:mYouaiID];
        [user setUserType:1];
        [userList setObject:user forKey:user.youaiId];
        [self updateUserList];
        [user release];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:com4loves_loginDone object:nil];
        
        return YES;
    }
    else
    {
        return NO;
    }

}

-(BOOL) bindingGuestID:(NSString *)youaiId withName:(NSString *) youaiName andPassword:(NSString *) youaiPsd
{
    if(! [self initServer])
    {
        [[SDKUtility sharedInstance] showAlertMessage:[com4lovesSDK getLang:@"notice_init_failed"]];
        return NO;
    }
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:
                          youaiId,@"guestnuclearId",
                          youaiName,@"boundnuclearName",
                          youaiPsd,@"boundPassword",
                          nil];
    //
    NSString* actionUrl = [[[NSString alloc] initWithString:@"nuclear/guest/binding"] autorelease];
    
    NSDictionary* dataRet = [self putToServer:actionUrl dataToPut:data];
    
    if(dataRet)
    {
        mLoginedPassword = youaiPsd;
        mLoginedUserName = youaiName;
        mUserType = [NSNumber numberWithInt:1];
        YouaiUser *user  = [[YouaiUser alloc] init];
        [user setPassword:mLoginedPassword];
        [user setName:youaiName];
        [user setYouaiId:mYouaiID];
        [user setUserType:1];
        
        [userList setObject:user forKey:user.youaiId];
        [self updateUserList];
        [user release];
        [[NSNotificationCenter defaultCenter] postNotificationName:com4loves_loginDone object:nil];
        
        return YES;
    }
    else
    {
        return NO;
    }
    
    return NO;
}

//binding thirdaccount
-(BOOL) bindingThirdID:(NSString *)thirdId withName:(NSString *) thirdName
{
    if(! [self initServer])
    {
        [[SDKUtility sharedInstance] showAlertMessage:[com4lovesSDK getLang:@"notice_init_failed"]];
        return NO;
    }
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"6",@"platform",
                          thirdName,@"nickName",
                          thirdId,@"thirdId",
                          [com4lovesSDK  getChannelID],@"channel",
                          nil];
    //
    NSString* actionUrl = [[[NSString alloc] initWithString:@"/nuclear/thirdUser/createorlogin"] autorelease];
    
    NSDictionary* dataRet = [self putToServer:actionUrl dataToPut:data];
    
    if(dataRet)
    {
        
        mYouaiID = [NSString stringWithString:[dataRet objectForKey:@"nuclearId"]];
        [mYouaiID retain];
        
        mLoginedUserName = [NSString stringWithString:[dataRet objectForKey:@"nuclearName"]];
        [mLoginedUserName retain];
        
        mLoginedPassword = [NSString stringWithString:[dataRet objectForKey:@"password"]];
        [mLoginedPassword retain];
        
        mUserType = [NSNumber numberWithInt:3];
        YouaiUser *user  = [[YouaiUser alloc] init];
        [user setPassword:mLoginedPassword];
        [user setName:mLoginedUserName];
        [user setYouaiId:mYouaiID];
        [user setUserType:3];
        
        [userList setObject:user forKey:user.youaiId];
        [self updateUserList];
        [user release];
        [[NSNotificationCenter defaultCenter] postNotificationName:com4loves_loginDone object:nil];
        
        return YES;
    }
    else
    {
        return NO;
    }
    
    return NO;
}

-(BOOL) createOrLoginTryUser:(NSString *)youaiId
{
    if(! [self initServer])
    {
        [[SDKUtility sharedInstance] showAlertMessage:[com4lovesSDK getLang:@"notice_init_failed"]];
        return NO;
    }
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:
                          youaiId,@"nuclearId",
                          [com4lovesSDK getChannelID],@"channel",
                          nil];
//
    NSString* actionUrl = [[[NSString alloc] initWithString:@"nuclear/guest/createorlogin"] autorelease];
    
    NSDictionary* dataRet = [self putToServer:actionUrl dataToPut:data];
    
    if(dataRet)
    {
        [mYouaiID release];
        mYouaiID = [[dataRet objectForKey:@"nuclearId"] retain];
        NSNumber *isCreate = [dataRet objectForKey:@"isCreate"];
        NSString *username = [dataRet objectForKey:@"nuclearName"];
        YALog(@"isCreate %d",[isCreate boolValue]);
        mUserType = [NSNumber numberWithInt:2];
        if(mLoginedUserName!=nil && ![mLoginedUserName isEqualToString:username])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:com4loves_logout object:nil];
        }
        [mLoginedUserName release];
        mLoginedUserName = [[NSString stringWithString:username] retain];
        
        YouaiUser *tryUser = [[YouaiUser alloc] init];
        [tryUser setName:username];
        [tryUser setUserType:UserTypeTryUser];
        [tryUser setYouaiId:mYouaiID];
        
        [userList setObject:tryUser forKey:tryUser.youaiId];
        [tryUser release];
        [self updateUserList];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:com4loves_loginDone object:nil];
        return YES;
    }
    else
    {
        return NO;
    }

    return NO;
}

-(BOOL) preCreate
{
    if(! [self initServer])
    {
        [[SDKUtility sharedInstance] showAlertMessage:[com4lovesSDK getLang:@"notice_init_failed"]];
        return NO;
    }
    
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:nil];
    NSString* actionUrl = [[[NSString alloc] initWithString:@"nuclear/users/precreate"] autorelease];
    
    NSDictionary* dataRet = [self putToServer:actionUrl dataToPut:data];
    
    if(dataRet)
    {
        mPrecreatedYouaiName = [dataRet objectForKey:@"nuclearName"];
        mPrecreatedPassword = [dataRet objectForKey:@"password"];
        return YES;
    }
    else
    {
        return NO;
    }
    
}
-(BOOL) changeTryUser2OkUserWithName:(NSString*)youaiName password:(NSString*)password andEmail:(NSString *)email
{
    if(! [self initServer])return NO;
    
    if( mYouaiID==nil)
    {
        return NO;
    }
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:
                          mYouaiID,@"nuclearId",
                          youaiName,@"nuclearName",
                          password,@"password",
                          @"1",@"isGuestConversion",
                          @"1",@"isInitPassword",
                          email,@"email",
                          nil];
    NSString* actionUrl = [[[NSString alloc] initWithString:@"nuclear/users/modify"] autorelease];
    
    NSDictionary* dataRet = [self putToServer:actionUrl dataToPut:data];
    
    if(dataRet)
    {
        mLoginedPassword = password;
        mLoginedUserName = youaiName;
        mUserType = [NSNumber numberWithInt:1];
        YouaiUser *user  = [[YouaiUser alloc] init];
        [user setPassword:mLoginedPassword];
        [user setName:youaiName];
        [user setYouaiId:mYouaiID];
        [user setUserType:1];
        
        [userList setObject:user forKey:user.youaiId];
        [self updateUserList];
        [user release];
        [[NSNotificationCenter defaultCenter] postNotificationName:com4loves_loginDone object:nil];
        return YES;
    }
    else
    {
        return NO;
    }
}

-(BOOL) modify:(NSString*)newPassword oldPassword:(NSString *)oldPassword
{
    if(! [self initServer])return NO;
    
    if( mYouaiID==nil)
    {
        return NO;
    }
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:
                          mYouaiID,@"nuclearId",
                          oldPassword,@"oldPassword",
                          newPassword,@"password",
                          @"0",@"isGuestConversion",
                          @"0",@"isInitPassword",
                          nil];
    NSString* actionUrl = [[[NSString alloc] initWithString:@"nuclear/users/modify"] autorelease];
    
    NSDictionary* dataRet = [self putToServer:actionUrl dataToPut:data];
    
    if(dataRet)
    {
        mLoginedPassword = newPassword;
        [self updateUserList];
        return YES;
    }
    else
    {
        return NO;
    }
    
}

-(BOOL) getyouaiNames
{
    if(! [self initServer])return NO;
    
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:nil];
    NSString* actionUrl = [[[NSString alloc] initWithString:@"nuclear/connect/users"] autorelease];
    [serverUserList release];
    serverUserList = [[self putToServer:actionUrl dataToPut:data] retain];
    
//    if(serverUserList)[serverUserList retain];
    YALog(@"user info  %@",serverUserList);
    return serverUserList!=nil;
}

-(BOOL) getServerPlayerList
{
    if(! [self initServer])return NO;
    
    if( mYouaiID==nil)
    {
        return NO;
    }

    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:
                          mYouaiID,@"puid",
                          nil];
    NSString* actionUrl = [[[NSString alloc] initWithString:@"nuclear/gameplayer/getplayerlist"] autorelease];
    
    NSDictionary* dataRet = [self putToServer:actionUrl dataToPut:data];
    [userUsedServers release];
    userUsedServers = [dataRet objectForKey:@"players"];
    YALog(@"players %@",dataRet);
    [userUsedServers retain];
    
    return dataRet!=nil;
    
}

-(BOOL) pushForClient:(int)serverId playername:(NSString*)name playerID:(int)playerID rmbMoney:(long) rmb gameCoin:(long long) coin vipLevel:(int)Vlevel playerLevel:(int) level pushSer:(BOOL) isPush
{
    if(! [self initServer])return NO;
    
    if( mYouaiID==nil)
    {
        return NO;
    }
    NSNumber* serv = [NSNumber numberWithInt:serverId];
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:
                          mYouaiID,@"puid",
                          serv,@"serverId",
                          [NSNumber numberWithInt:0],@"playerPuid",
                          [NSNumber numberWithInt:playerID],@"playerId",
                          name,@"playerName",
                          [NSNumber numberWithLong:rmb],@"gameCoin1",
                          [NSNumber numberWithLongLong:coin],@"gameCoin2",
                          [NSNumber numberWithInt:level],@"playerLvl",
                          [NSNumber numberWithInt:Vlevel],@"vipLvl",
                          nil];
    NSString* actionUrl = [[[NSString alloc] initWithString:@"nuclear/gameplayer/pushforclient"] autorelease];
    
//    NSDictionary* dataRet = [self putToServer:actionUrl dataToPut:data];
    YALog(@"putToServerByGCD data %@ ",data);
    [self putToServerByGCD:actionUrl dataToPut:data withBlock:^(NSDictionary *result) {
        YALog(@"putToServerByGCD %@ ",result);
    }];
//    return dataRet!=nil;
    return NO;
    
}

-(void)dealloc
{
    [userList release];
    [serverUserList release];
    [userUsedServers release];
    [super dealloc];
}
@end
