//
//  UserInfomation.h
//  DownjoySDK2.0
//
//  Created by soon on 13-10-10.
//  Copyright (c) 2013年 downjoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfomation : NSObject


@property (retain,  nonatomic) NSString *userName;
@property (retain, nonatomic) NSString *nickName;
@property (retain, nonatomic) NSString *token;
@property (retain, nonatomic) NSString *mid;
@property(nonatomic, assign) NSNumber *errorCode;
@property(nonatomic, retain) NSString *errorMsg;
@property(nonatomic, retain) NSString *avatarUrl;
@property(nonatomic, retain) NSString *level;
@property(nonatomic, retain) NSString *gender;

@property(nonatomic, retain) NSString *phoneNum;
@property(nonatomic, retain) NSNumber *isBandNum;

- (void) setPassword:(NSString *)password; 
+ (id) userInfomationWithUsername:(NSString *)userName password:(NSString *)password;
+ (id) dictionaryFromUserInfomation:(UserInfomation *)user;
+(UserInfomation *) initWithDict : (NSDictionary *) dict;

@end
