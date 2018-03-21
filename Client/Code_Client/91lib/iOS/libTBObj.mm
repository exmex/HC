//
//  libTBObj.m
//  libTB
//
//  Created by lvjc on 13-7-25.
//  Copyright (c) 2013年 youai. All rights reserved.
//
#include "libTB.h"
#import "libTBObj.h"
#import <TBPlatform/TBPlatform.h>


@implementation libTBObj
-(void) SNSInitResult:(NSNotification *)notify
{
    [self registerNotification];
    std::string outstr = "";
    //libPlatformManager::getPlatform()->_boardcastUpdateCheckDone(true,outstr);
}

-(void) registerNotification
{
 
    /* 监听登录结果通知（新版接口统一成功和失败的通知）*/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(SNSLoginResult:)
                                                 name:(NSString *)kTBLoginNotification
                                               object:nil];
    /* 监听用户注销通知*/

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(PlatformLogout:)
                                                 name:(NSString *)kTBUserLogoutNotification
                                               object:nil];
    /*监听初始化结果通知（3.0.1新增），该通知userInfo字典中带有检查更新结果*/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tbInitFinished:)
                                                 name:kTBInitDidFinishNotification
                                               object:nil];
    /* 监听离开平台通知（3.0.1版本开始，该通知userInfo字典中带有离开的类型及订单号 */
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(LeavePlatform:)
                                                 name:(NSString *)kTBLeavePlatformNotification
                                               object:nil];
    
    CGRect rect = [UIScreen mainScreen].applicationFrame; //获取屏幕大小
    waitView = [[UIActivityIndicatorView alloc] initWithFrame:rect];//定义图标大小，此处为32x32
    [waitView setCenter:CGPointMake(rect.size.width/2,rect.size.height/2)];//根据屏幕大小获取中心点
    [waitView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置图标风格，采用灰色的，其他还有白色设置
    [waitView setBackgroundColor:[ UIColor colorWithWhite: 0.0 alpha: 0.5 ]];
    //[self.view addSubview:waitView];//添加该waitView
    [[[UIApplication sharedApplication] keyWindow] addSubview:waitView];
}

-(void) unregisterNotification
{
  //  [[NSNotificationCenter defaultCenter] removeObserver:self name:kNdCPBuyResultNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *	@brief	平台关闭通知，监听注销平台通知以对游戏界面进行重新调整
 */	
- (void)PlatformLogout:(NSNotification *)notify
{
    if(!([[TBPlatform defaultPlatform] TBIsLogined]))
    {
        static int leaveCount=1;
        if(leaveCount%2!=0)
        {
            libTB* plat = dynamic_cast<libTB*>(libPlatformManager::getPlatform());
            if(plat)
            {
                plat->_disableLogin();
            }
            libPlatformManager::getPlatform()->_boardcastPlatformLogout();
        }
        ++leaveCount;
    }
}

/**
 *	@brief	平台关闭通知，监听离开平台通知以对游戏界面进行重新调整
 */
- (void)LeavePlatform:(NSNotification *)notify
{
    if(!([[TBPlatform defaultPlatform] TBIsLogined]))
    {
        static int leaveCount=1;
        if(leaveCount%2!=0)
        {
            libTB* plat = dynamic_cast<libTB*>(libPlatformManager::getPlatform());
            if(plat)
            {
                plat->_disableLogin();
            }
//        libPlatformManager::getPlatform()->_boardcastPlatformLogout();
        }
        ++leaveCount;
    }
}

/**
 *	@brief	登录通知监听方法，登录成功、失败都在这个方法处理
 *
 *	@param 	notification 	通知的userInfo包含登录结果信息
 */
- (void)SNSLoginResult:(NSNotification *)notify
{
    
    if ([[TBPlatform defaultPlatform] TBIsLogined]) {
        NSString* strTip = [NSString stringWithFormat:@"游客账号登录成功"];
        std::string out = [strTip UTF8String];
        libTB* plat = dynamic_cast<libTB*>(libPlatformManager::getPlatform());
        if(plat)
        {
            plat->_enableLogin();
        }
        libPlatformManager::getPlatform()->_boardcastLoginResult(true, out);
        
        //显示浮动工具条
        [[TBPlatform defaultPlatform] TBShowToolBar:TBToolBarAtMiddleLeft
                                      isUseOldPlace:YES];
    }

    
}

-(void)NdUniPayAysnResult:(NSNotification*)notify
{
    //回调购买成功。其余都是失败
    if ([[notify object] isEqualToString:@"购买成功"])
    {
		libTB* plat = dynamic_cast<libTB*>(libPlatformManager::getPlatform());
		if(plat)
		{
			BUYINFO info = plat->getBuyInfo();
			std::string log("购买成功");
			libPlatformManager::getPlatform()->_boardcastBuyinfoSent(true, info, log);
		}
        
    }
}

#pragma mark - BuyGoods Delegate
- (void)TBBuyGoodsDidSuccessWithOrder:(NSString*)order
{
    libTB* plat = dynamic_cast<libTB*>(libPlatformManager::getPlatform());
    if(plat)
    {
        BUYINFO info = plat->getBuyInfo();
        std::string log("购买成功");
        libPlatformManager::getPlatform()->_boardcastBuyinfoSent(true, info, log);
    }
}

- (void)TBBuyGoodsDidFailedWithOrder:(NSString *)order resultCode:(TB_BUYGOODS_ERROR)errorType;{
    switch (errorType) {
        case kBuyGoodsOrderEmpty:
            NSLog(@"订单号为空");
            break;
        case kBuyGoodsBalanceNotEnough:
            NSLog(@"推币余额不足");
            break;
        case kBuyGoodsServerError:
            NSLog(@"服务器错误");
            break;
        case kBuyGoodsOtherError:
            NSLog(@"其他错误");
            
            break;
        default:
            break;
    }
}


#pragma mark - 监听通知方法
- (void)tbInitFinished:(NSNotification *)notification
{
    libPlatformManager::getPlatform()->_boardcastUpdateCheckDone(true,"");
}

-(void) uploadChannelIdDidFinish:(int)error
{
}

-(void) updateApp
{
 
}

@end
