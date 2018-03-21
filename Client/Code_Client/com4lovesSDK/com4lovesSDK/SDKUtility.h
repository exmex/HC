//
//  SDKUtility.h
//  com4lovesSDK
//
//  Created by fish on 13-8-26.
//  Copyright (c) 2013年 com4loves. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDKUtility : NSObject<NSURLConnectionDelegate>

+ (SDKUtility *)sharedInstance;

- (NSString*)encodeURL:(NSString *)urlString;

-(void) setWaiting:(BOOL) isWait;

//utility
-(NSString*) httpPost: (NSString*) actionUrl postData:(NSData *)postStr;
-(NSString*) httpPost: (NSString*) actionUrl postData:(NSData *)postStr md5check:(NSString*) check;

-(int) httpPutForStatus: (NSString*) actionUrl postData:(NSData *)postStr md5check:(NSString*) check;
-(NSString*) httpPut: (NSString*) actionUrl postData:(NSData *)postStr md5check:(NSString*) check;
-(NSString*) httpPut: (NSString*) actionUrl postData:(NSData *)postStr;


-(void) httpAsynPut: (NSString*) actionUrl postData:(NSData *)postStr md5check:(NSString*) check selector:(SEL)selector object:(id)object;

-(NSString*) getMacAddress;
-(NSString*) getMacAddressOnly;
-(NSString *) md5HexDigest :(NSString*) str;
-(BOOL)checkInput:(NSString*) userName password:(NSString*)password email:(NSString*)email;

-(void) showAlertMessage: (NSString*)message;
-(int) httpPostForStatus: (NSString*) actionUrl postData:(NSData *)postStr md5check:(NSString*) check;

@end
