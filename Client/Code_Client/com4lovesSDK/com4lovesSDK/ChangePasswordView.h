//
//  ChangePasswordView.h
//  com4lovesSDK
//
//  Created by fish on 13-8-28.
//  Copyright (c) 2013年 com4loves. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordView : UIViewController
- (IBAction)goBack:(id)sender;
- (IBAction)changeDone:(id)sender;

- (IBAction)initPasswordOri:(id)sender;
- (IBAction)initPasswordNew:(id)sender;

- (IBAction)didEnd:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *makesureText;
@property(nonatomic, retain) IBOutlet UITextField *oriSecretText;
@property(nonatomic, retain) IBOutlet UITextField *newSecretText;
@end
