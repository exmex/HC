//
//  AccountManagerView.m
//  com4lovesSDK
//
//  Created by fish on 13-8-28.
//  Copyright (c) 2013年 com4loves. All rights reserved.
//

#import "AccountManagerView.h"
#import "com4lovesSDK.h"
#import "ServerLogic.h"
#define LogoutAlert 123
#define SwitchUserAlert 124

@interface AccountManagerView ()
//@property (retain, nonatomic) IBOutlet UILabel *lableTitle;
//@property (retain, nonatomic) IBOutlet UILabel *viewLableTitle;
//@property (retain, nonatomic) IBOutlet UILabel *lableCenter;
//@property (retain, nonatomic) IBOutlet UILabel *lableWebsit;
//@property (retain, nonatomic) IBOutlet UILabel *lableSwithUser;
//@property (retain, nonatomic) IBOutlet UILabel *lableFeedback;
//
//@property (retain, nonatomic) IBOutlet UIButton *btnClose;
@property (retain, nonatomic) IBOutlet UIButton *btnLogout;
@property (retain, nonatomic) IBOutlet UILabel *labelUserID;
@property (retain, nonatomic) IBOutlet UIButton *btnEnterGame;
@property (retain, nonatomic) IBOutlet UIButton *btnChangePass;

@end

@implementation AccountManagerView
- (IBAction)enterGame:(id)sender {
    [[com4lovesSDK sharedInstance]hideAll];
}

- (IBAction)bindAccount:(id)sender {
    [[com4lovesSDK sharedInstance]showChangePassword];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"com4lovesBundle" ofType:@"bundle"]];
//        NSString *alertImagePath = [bundle pathForResource:@"background" ofType:@"png"];
//        UIImage* backImage =  [UIImage imageWithContentsOfFile:alertImagePath];
//        self.view.backgroundColor = [UIColor colorWithPatternImage:backImage];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginDone) name:(NSString*)com4loves_loginDone object:nil];
    // self.labelUserID.text = [com4lovesSDK getYouaiID];
    if ([[[ServerLogic sharedInstance] getLoginUserType] intValue]==2)
    {
        self.labelUserID.text = [com4lovesSDK getYouaiID];
    }
    else
    {
        self.labelUserID.text = [[com4lovesSDK sharedInstance] getLoginedUserName];
    }
    //    NSString* enableFeedback = [com4lovesSDK getPropertyFromIniFile:@"FeedBackEnable" andAttr:@"feedback"];
//    if (enableFeedback&&[enableFeedback isEqualToString:@"1"]) {
//        [self.feedbackView setHidden:NO];
//    } else {
//        [self.feedbackView setHidden:YES];
//    }
//    [self.lableTitle setText:[com4lovesSDK getLang:@"account_title"]];
//    [self.viewLableTitle setText:[com4lovesSDK getLang:@"viewtitle"]];
//    [self.lableCenter setText:[com4lovesSDK getLang:@"account_center"]];
//    [self.lableWebsit setText:[com4lovesSDK getLang:@"account_ourwebsite"]];
//    [self.lableSwithUser setText:[com4lovesSDK getLang:@"account_switchuser"]];
//    [self.lableFeedback setText:[com4lovesSDK getLang:@"account_feedback"]];
//    
    
    [self.btnEnterGame setTitle:[com4lovesSDK getLang:@"loginview_login"] forState:UIControlStateNormal];
    [self.btnEnterGame setTitle:[com4lovesSDK getLang:@"loginview_login"] forState:UIControlStateSelected];
    [self.btnEnterGame setTitle:[com4lovesSDK getLang:@"loginview_login"] forState:UIControlStateHighlighted];
    
    
    [self.btnLogout setTitle:[com4lovesSDK getLang:@"account_switchuser"] forState:UIControlStateNormal];
    [self.btnLogout setTitle:[com4lovesSDK getLang:@"account_switchuser"] forState:UIControlStateSelected];
    [self.btnLogout setTitle:[com4lovesSDK getLang:@"account_switchuser"] forState:UIControlStateHighlighted];
    
    [self.btnChangePass setTitle:[com4lovesSDK getLang:@"account_changepass"] forState:UIControlStateNormal];
    [self.btnChangePass setTitle:[com4lovesSDK getLang:@"account_changepass"] forState:UIControlStateSelected];
    [self.btnChangePass setTitle:[com4lovesSDK getLang:@"account_changepass"] forState:UIControlStateHighlighted];

}

-(void)LoginDone
{
    if ([[[ServerLogic sharedInstance] getLoginUserType] intValue]==2)
    {
        self.labelUserID.text = [com4lovesSDK getYouaiID];
    }
   else
   {
        self.labelUserID.text = [[com4lovesSDK sharedInstance] getLoginedUserName];
   }
}

- (IBAction)showUserList:(id)sender
{
    [[com4lovesSDK sharedInstance]showUserList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gobackLogin:(id)sender {
    
    //如果在游戏内部
    if ([[com4lovesSDK sharedInstance] getIsInGame])
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:[com4lovesSDK getLang:@"notice"]
                                                             message:[com4lovesSDK getLang:@"notice_restart"]
                                                            delegate:self
                                                   cancelButtonTitle:[com4lovesSDK getLang:@"cancel"]
                                                   otherButtonTitles:[com4lovesSDK getLang:@"ok"],nil];
        [alertView setTag:LogoutAlert];
        [alertView show];
        [alertView release];
    }else{
        [[com4lovesSDK sharedInstance] clearLoginInfo];
        [[com4lovesSDK sharedInstance] LoginTryUser];
        [[com4lovesSDK sharedInstance] hideAll];
    }
    [[com4lovesSDK sharedInstance] logout];
    if(![[com4lovesSDK sharedInstance] getIsInGame])
    {
        [[com4lovesSDK sharedInstance] logout];
    }
    [[com4lovesSDK sharedInstance] clearLoginInfo];
    [[com4lovesSDK sharedInstance] hideAll];
    [[com4lovesSDK sharedInstance] notifyLogoutGame];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == LogoutAlert) {
		YALog(@"buttonIndex %d",buttonIndex);
        if (buttonIndex==1) {
            [[com4lovesSDK sharedInstance] logout];
        }
	} else if (alertView.tag == SwitchUserAlert){
        if (buttonIndex==1) {
            [[com4lovesSDK sharedInstance] logout];
            //这里真变态，如果不拿定时器延时的话，界面回莫名其妙的消失，估计是移除alertview的时候把view移除了，延时等移除完再添加view进去
//             [NSTimer scheduledTimerWithTimeInterval:1.1 target:self selector:@selector(delayShowLogin) userInfo:nil repeats:NO] ;
        }
    }
}

-(void)delayShowLogin
{
    [[com4lovesSDK sharedInstance] showLogin];
}
//- (IBAction)accountCenter:(id)sender {
//        [[com4lovesSDK sharedInstance] showAccountCenter];
//}
//
//- (IBAction)gotoMainPage:(id)sender {
//    [[com4lovesSDK sharedInstance] showWeb:@"http://www.vipqlz.com"];
//}

- (IBAction)switchUser:(id)sender {
//    if ([[com4lovesSDK sharedInstance] getIsInGame])
//    {
//        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:[com4lovesSDK getLang:@"notice"]
//                                                             message:[com4lovesSDK getLang:@"notice_changeuser"]
//                                                            delegate:self
//                                                   cancelButtonTitle:[com4lovesSDK getLang:@"cancel"]
//                                                   otherButtonTitles:[com4lovesSDK getLang:@"ok"],nil];
//        
//        [alertView setTag:SwitchUserAlert];
//        [alertView show];
//        [alertView release];
//    } else
//    {
     [[com4lovesSDK sharedInstance] logout];
     [[com4lovesSDK sharedInstance] showIndex];
//    }
}

//- (IBAction)close:(id)sender {
//    [[com4lovesSDK sharedInstance] hideAll];
//    
//}

//- (IBAction)goFeedBack:(id)sender {
//    [[com4lovesSDK sharedInstance] showSdkFeedBack];
//}
- (void)dealloc {
 //   [_accountLabel release];
 //   [_feedbackView release];
//    [_lableTitle release];
//    [_viewLableTitle release];
//    [_lableCenter release];
//    [_lableWebsit release];
//    [_lableSwithUser release];
//    [_lableFeedback release];
//    [_btnClose release];
    [_btnLogout release];
    [[NSNotificationCenter defaultCenter]  removeObserver:self forKeyPath:com4loves_loginDone];

    [_labelUserID release];
    [_btnEnterGame release];
    [_btnChangePass release];
    [super dealloc];
}
- (void)viewDidUnload {
 //   [self setAccountLabel:nil];
 //   [self setFeedbackView:nil];
//    [self setLableTitle:nil];
//    [self setViewLableTitle:nil];
//    [self setLableCenter:nil];
//    [self setLableWebsit:nil];
//    [self setLableSwithUser:nil];
//    [self setLableFeedback:nil];
//    [self setBtnClose:nil];
    [self setBtnLogout:nil];
    [self setLabelUserID:nil];
    [self setBtnEnterGame:nil];
    [super viewDidUnload];
}
@end
