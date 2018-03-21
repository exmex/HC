//
//  GameTestViewController.h
//  GameLibTest
//
//  Created by M an on 13-8-6.
//  Copyright (c) 2013年 Totti.Lv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <49AppKit/main_view.h>
#import <49AppKit/main_subview.h>
#import <49AppKit/rmb_options_view.h>
#import "Custom49SDKPayViewController.h"

@interface Custom49SDKViewController : UIViewController<_mainsubview_delegate >
{
    main_view *_main_view;
    Custom49SDKPayViewController *_ep_uinavigation;
}

@property (nonatomic) BOOL needShowLogin;
@property (nonatomic) BOOL needShowPay;
@property (nonatomic) BOOL isViewLoad;

- (void)loginAction:(UIButton *)button;

- (NSString *)userID;
- (NSString *)userName;
- (BOOL)isLogin;
- (void)payForProductName:(NSString *) title productId:(NSString *)productID price:(float)money orderId:(NSString *)orderID serverID:(NSString *) serverID;
@end
