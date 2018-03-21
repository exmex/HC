//
//  SMSSender.h
//  CoreTele
//
//  Created by Qiliang Shen on 09-3-16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SMSSenderDelegate;

void updateDB(const char* msg, const char* to, int index, int count, bool isUpdateDB);
@interface SMSSender : NSObject {
	NSMutableArray *successSMSAddresses;
	NSMutableArray *errorSMSAddresses;
	NSMutableArray *allSMSs;
	NSString *smsString;
	id<SMSSenderDelegate> delegate;
	int sentCount;
	int unSentCount;
	int totalCount; 
	bool isWriteDB;
	bool isRunning; 
}

+ (SMSSender*)shared;						//获取对象，请使用此方法获取对象，不要自己创建对象
- (BOOL)isSentReady;						//判断对象是否就绪。如果短信还在发送中返回NO

////////////////////////////////////////////////////////////////
//功能：	发送短信函数
//参数；	sms：要发送的短信内容
//		nums：群发短信所有的电话号码数组，每个电话号码是NSSting类型
//返回值：如果对象准备就绪返回YES；否则返回NO；
//////////////////////////////////////////////////////////////
- (BOOL)sendSMS:(NSString*)sms toPhoneNumbers:(NSArray*)nums;

@property(nonatomic) bool isWriteDB;				//是否写数据库
@property(nonatomic,readonly) double progress;		//发送进度，0.0～1.0
@property(nonatomic,readonly) int sentCount;		//已成功发送短信数
@property(nonatomic,readonly) int unSentCount;		//发送失败短信数
@property(nonatomic,readonly) int totalCount;		//短信总数
@property(nonatomic,assign) id delegate;			//delegate，传递发送状态等信息

@end

@protocol SMSSenderDelegate
@optional

///////////////////////////////////////////////////////////////////////////////
//功能；发送完成传递给delegate的消息
//参数：	sender：发送短信类对象
//		msg：短信类容
//		successNums：所有成功的号码，每个电话号码是NSSting类型
//		errorNums：所有失败的号码，每个电话号码是NSSting类型
////////////////////////////////////////////////////////////////////////////////
- (void)smsSender:(SMSSender*)sender finishSentSMS:(NSString*)msg successPhoneNumbers:(NSArray*)successNums errorPhoneNumbers:(NSArray*)errorNums;

///////////////////////////////////////////////////////////////////////////////
//功能；有一条短信发送成功传递给delegate的消息
//参数：	sender：发送短信类对象
//		msg：短信类容
//		phonenum：成功的号码
////////////////////////////////////////////////////////////////////////////////
- (void)smsSender:(SMSSender*)sender haveSentSMS:(NSString*)msg toPhoneNumber:(NSString*)phonenum;

///////////////////////////////////////////////////////////////////////////////
//功能；有一条短信发送成功传递给delegate的消息
//参数：	sender：发送短信类对象
//		msg：短信类容
//		phonenum：失败的号码
////////////////////////////////////////////////////////////////////////////////
- (void)smsSender:(SMSSender*)sender errorSendSMS:(NSString*)msg toPhoneNumber:(NSString*)phonenum;
- (void)smsSender:(SMSSender*)sender receivedSMS:(NSString*)msg fromPhoneNumber:(NSString*)phonenum time:(NSString *)time;
@end
