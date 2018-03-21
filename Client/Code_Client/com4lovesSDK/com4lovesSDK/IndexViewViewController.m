//
//  IndexViewViewController.m
//  com4lovesSDK
//
//  Created by GuoDong on 14-10-30.
//  Copyright (c) 2014年 com4loves. All rights reserved.
//

#import "IndexViewViewController.h"
#import "com4lovesSDK.h"
#import "ServerLogic.h"
#import "SDKUtility.h"
#import <FacebookSDK/FacebookSDK.h>
@interface IndexViewViewController ()<FBLoginViewDelegate>
@property (retain, nonatomic) IBOutlet UIButton *btnQUickLogin;
@property (retain, nonatomic) IBOutlet UIButton *btnShowLogin;
@property (retain, nonatomic) IBOutlet UIButton *btnFacebookLogin;
@property (retain, nonatomic) IBOutlet FBLoginView *facebookView;
@property (retain, nonatomic) IBOutlet UIButton *btnClose;

@end

@implementation IndexViewViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.facebookView.delegate = self;
    [self.btnShowLogin setTitle:[com4lovesSDK getLang:@"loginview_login"] forState:UIControlStateNormal];
    [self.btnShowLogin setTitle:[com4lovesSDK getLang:@"loginview_login"] forState:UIControlStateSelected];
    [self.btnShowLogin setTitle:[com4lovesSDK getLang:@"loginview_login"] forState:UIControlStateHighlighted];
    
    [self.btnQUickLogin setTitle:[com4lovesSDK getLang:@"loginview_Quicklogin"] forState:UIControlStateNormal];
    [self.btnQUickLogin setTitle:[com4lovesSDK getLang:@"loginview_Quicklogin"] forState:UIControlStateSelected];
    [self.btnQUickLogin setTitle:[com4lovesSDK getLang:@"loginview_Quicklogin"] forState:UIControlStateHighlighted];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)quickLogin:(id)sender
{
    BOOL logined = [[ServerLogic sharedInstance] createOrLoginTryUser:@""];
    if(logined)
    {
        [[com4lovesSDK sharedInstance]hideAll];
    }
}


- (IBAction)showLoginView:(id)sender
{
    [[com4lovesSDK sharedInstance]showLogin];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

////////////////////////////////facebook ////////////////////////////////
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user
{
    if([[ServerLogic sharedInstance] bindingThirdID:user.id withName:user.name] == YES)
    {
        self.btnClose.hidden = NO;
        [[com4lovesSDK sharedInstance] hideAll];
        self.btnQUickLogin.enabled = NO;
        self.btnShowLogin.enabled = NO;
        [[SDKUtility sharedInstance] setWaiting:NO];
    }
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    self.btnClose.hidden = YES;
    self.btnQUickLogin.enabled = YES;
    self.btnShowLogin.enabled = YES;
    [[com4lovesSDK sharedInstance] clearLoginInfo];
   // [[com4lovesSDK sharedInstance] LoginTryUser];
 //   [[com4lovesSDK sharedInstance] hideAll];
}

- (IBAction)close:(id)sender
{
    [[com4lovesSDK sharedInstance]hideAll];
}

- (void)dealloc {
    [_btnQUickLogin release];
    [_btnShowLogin release];
    [_btnFacebookLogin release];
    [_facebookView release];
    [_btnClose release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setBtnQUickLogin:nil];
    [self setBtnShowLogin:nil];
    [self setBtnFacebookLogin:nil];
    [self setFacebookView:nil];
    [self setBtnClose:nil];
    [super viewDidUnload];
}
@end
