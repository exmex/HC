//
//  ServerLogic.h
//  com4lovesSDK
//
//  Created by fish on 13-8-28.
//  Copyright (c) 2013年 com4loves. All rights reserved.
//

#import <Foundation/Foundation.h>
#define UserListUserDefault             @"com4lovesSDK_userList"
#define UserListUserDefaultJSON         @"com4lovesSDK_userList_JSON"
#define LatestUserUserDefault           @"com4lovesSDK_latestUser"
#define LatestUserUserPasswordDefault   @"com4lovesSDK_latestUser_password"
#define TryUserUserDefault              @"com4lovesSDK_tryUser"
#define DocumentsFolder                 [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

#warning 发布前记得改地址
//#define SERVER_IP  @"http://203.195.147.31:6520/"
//#define SERVER_IP  @"http://203.90.236.237:8270/"
#define SERVER_IP  @"http://player.we4dota.com:6520/"
#define SERVER_URL @"http://player.we4dota.com:6520/"
//#define SERVER_URL @"http://player.we4dota.com:8270/"
#define SERVER_TEST_URL @"http://player.we4dota.com:8270/"

@class YouaiUser;
@interface ServerLogic : NSObject

+(ServerLogic*) sharedInstance;

-(BOOL) initServer;
-(void) initUserList;

-(NSMutableDictionary*)getUserList;

-(BOOL) removeUserInUserList:(YouaiUser *)user;
-(NSString*) getLatestUser;
-(NSString*) getLatestUserPassword;
-(NSString*) getTryUser;
-(NSString*) getYouaiID;
-(NSString*) getLoginedUserName;
-(NSString*) getPrecreatedYouaiName;
-(NSString*) getPrecreatedPassword;
-(NSNumber*) getLoginUserType;
-(NSString*) getServerUrl;

-(NSArray *)getUserLoginedServers;

-(BOOL) createOrLoginTryUser:(NSString *) youaiId;
-(BOOL) getyouaiNames;
-(BOOL) getServerPlayerList;

-(NSDictionary *) parseResult:(NSString *) _retValue;

-(void) setYouaiID:(NSString*)youaiID;
-(void) updateUserList;
-(void) clearLoginInfo;

-(BOOL) bindingGuestID:(NSString *)         youaiId
              withName:(NSString *)         youaiName
           andPassword:(NSString *)         youaiPsd;
-(BOOL) bindingThirdID:(NSString *)thirdId withName:(NSString *) thirdName;

-(BOOL) pushForClient:(int)         serverId
           playername:(NSString*)   name
             playerID:(int)         playerID
             rmbMoney:(long)        rmb
             gameCoin:(long long)   coin
             vipLevel:(int)         Vlevel
          playerLevel:(int)         level
              pushSer:(BOOL)        isPush;

-(BOOL) changeTryUser2OkUserWithName:(NSString *)    youaiName
                            password:(NSString *)    password
                            andEmail:(NSString *)    email;

-(BOOL) create:(NSString*)username
      password:(NSString*)password
         email:(NSString*)email;

-(BOOL) login:(NSString*)username
     password:(NSString*)password;

-(BOOL) preCreate;
-(BOOL) modify:(NSString*) password oldPassword:(NSString*) oldPassword;
-(int) putToServerForDeviceInfo;

@end
