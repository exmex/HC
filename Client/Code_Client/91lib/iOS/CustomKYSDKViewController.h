//
//  GameTestViewController.h
//  GameLibTest
//
//  Created by M an on 13-8-6.
//  Copyright (c) 2013年 Totti.Lv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KYSDK/KyUserSDK.h"
#import "KYSDK/KY_PaySDK.h"

@interface CustomKYSDKViewController : UIViewController<KyUserSDKDelegate>{
    
}
- (void)loginAction:(UIButton *)button;
- (void)logoutAction:(UIButton *)button;

- (NSString *)userID;
- (BOOL)isLogin;
- (void)payForProductName:(NSString *) title productId:(NSString *)productID price:(int)money orderId:(NSString *)orderID;
@end
