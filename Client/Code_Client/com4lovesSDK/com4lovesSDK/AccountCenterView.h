//
//  AccountCenterView.h
//  com4lovesSDK
//
//  Created by fish on 13-8-28.
//  Copyright (c) 2013年 com4loves. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountCenterView : UIViewController
- (IBAction)goBack:(id)sender;
- (IBAction)changePassword:(id)sender;
@property (nonatomic , retain) IBOutlet UILabel* accountLabel;
@end
