//
//  ViewController.h
//  test3
//
//  Created by fish on 13-8-21.
//  Copyright (c) 2013年 com4loves. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    styleLogin,
    styleLoginWithRegister,
}LoginViewStyle;

@interface LoginView : UIViewController


- (IBAction)gotoRegister:(id)sender;
- (IBAction)click:(id)sender;
- (IBAction)didEnd:(id)sender;
//- (IBAction)forgetPassword:(id)sender;
- (IBAction)showUserList:(id)sender;
//- (IBAction)onBack:(id)sender;
- (IBAction)userNameEditEnd:(id)sender;

- (void)initWithViewStyle:(LoginViewStyle)style;
-(void)clearInfo;

//@property (nonatomic, retain) IBOutlet UIButton*    button;
//@property (nonatomic, retain) IBOutlet UIView*      frame;
@property (nonatomic, retain) IBOutlet UITextField* plainTextField;
@property (nonatomic, retain) IBOutlet UIButton *   btnRegister;
@property (retain, nonatomic) IBOutlet UIButton *   btnNameDel;
@property (retain, nonatomic) IBOutlet UIButton *   btnArrow;
@property (retain, nonatomic) IBOutlet UIButton *   btnPsdDel;
@property (nonatomic, retain) IBOutlet UITextField* secretTextField;
@end
