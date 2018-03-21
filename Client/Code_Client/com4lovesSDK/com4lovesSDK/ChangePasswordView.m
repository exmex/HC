//
//  ChangePasswordView.m
//  com4lovesSDK
//
//  Created by fish on 13-8-28.
//  Copyright (c) 2013年 com4loves. All rights reserved.
//

#import "ChangePasswordView.h"
#import "com4lovesSDK.h"
#import "ServerLogic.h"
#import "SDKUtility.h"
@interface ChangePasswordView ()
{
    CGFloat _fTextHight;
    CGFloat _fTextMove;
    CGRect _originBKViewRect;
}
//@property (retain, nonatomic) IBOutlet UILabel *lableTitle;
//@property (retain, nonatomic) IBOutlet UILabel *lableOldPsd;
//@property (retain, nonatomic) IBOutlet UILabel *lableNewPsd;
//@property (retain, nonatomic) IBOutlet UILabel *viewLableTitle;
//@property (retain, nonatomic) IBOutlet UILabel *labelMakeSure;

@property (retain, nonatomic) IBOutlet UIButton *btnBack;
@property (retain, nonatomic) IBOutlet UIButton *btnComplete;

@property (retain, nonatomic) IBOutlet UIView *backGroundView;
@property (nonatomic,assign) BOOL bKeyboardShow;
@end

@implementation ChangePasswordView

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
    
    [self.view addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    _fTextMove = 0.0f;
    self.bKeyboardShow = NO;
 //   [self.lableTitle setText:[com4lovesSDK getLang:@"changepsd_title"]];
//    [self.lableOldPsd setText:[com4lovesSDK getLang:@"changepsd_oldpsd"]];
//    [self.lableNewPsd setText:[com4lovesSDK getLang:@"changepsd_newpsd"]];
// //   [self.viewLableTitle setText:[com4lovesSDK getLang:@"viewtitle"]];
//    [self.labelMakeSure setText:[com4lovesSDK getLang:@"changepsd_makesure"]];
    
    self.oriSecretText.placeholder = [com4lovesSDK getLang:@"changepsd_oldpsd"];
    self.newSecretText.placeholder = [com4lovesSDK getLang:@"changepsd_newpsd"];
    self.makesureText.placeholder = [com4lovesSDK getLang:@"changepsd_makesure"];
    
    [self.btnBack setTitle:[com4lovesSDK getLang:@"changepsd_cancel"] forState:UIControlStateNormal];
    [self.btnBack setTitle:[com4lovesSDK getLang:@"changepsd_cancel"] forState:UIControlStateSelected];
    [self.btnBack setTitle:[com4lovesSDK getLang:@"changepsd_cancel"] forState:UIControlStateHighlighted];
    
    [self.btnComplete setTitle:[com4lovesSDK getLang:@"changepsd_ok"] forState:UIControlStateNormal];
    [self.btnComplete setTitle:[com4lovesSDK getLang:@"changepsd_ok"] forState:UIControlStateSelected];
    [self.btnComplete setTitle:[com4lovesSDK getLang:@"changepsd_ok"] forState:UIControlStateHighlighted];
    //gdd
    [self positionView];
}

/////////////////////////////////remove view ////////////////////////////////////
-(void)positionView
{
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    CGRect rectText = self.makesureText.frame;
    CGRect rectWindow = window.rootViewController.view.frame;
    _originBKViewRect = self.backGroundView.frame;
    //_originBKViewRect = rectBackView;
    CGFloat hightlength = _originBKViewRect.size.height - rectText.origin.y - rectText.size.height;
    CGFloat fWindowHight;
    if(rectWindow.size.width < rectWindow.size.height)
        fWindowHight = rectWindow.size.width;
    else
        fWindowHight = rectWindow.size.height;
    _fTextHight = hightlength + (fWindowHight - _originBKViewRect.size.height)/2;
}


//////////////////////////////////keyboard //////////////////////////////////////
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"hidden"])
    {
        NSNumber *bViewHidden = [change objectForKey:@"new"];
        NSLog(@"%@",bViewHidden);
        if([bViewHidden intValue] == 1)
        {
            [self unRegisterForKeyboardNotifications];
        }
        else
        {
            [self registerForKeyboardNotifications];
        }
    }
}

- (void)registerForKeyboardNotifications
{
    //   //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
}

- (void)unRegisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

-(void)keyboardWillHidden:(NSNotification*)notification
{
    if(_fTextMove != 0.0f && self.bKeyboardShow)
    {
        self.bKeyboardShow = NO;
        double animationDuaration;
        UIViewAnimationOptions animationOption;
        [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey]getValue:&animationDuaration];
        [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey]getValue:&animationOption];
        [UIView animateWithDuration:animationDuaration delay:0.0f options:animationOption animations:^{
            [UIView animateWithDuration:0.5 delay:0.0f options:nil animations:^{
              //  self.backGroundView.frame =  _originBKViewRect;
                self.backGroundView.frame =  CGRectOffset(self.backGroundView.frame, 0, _fTextMove);
            } completion:^(BOOL finished){}];}completion:^(BOOL finished)
         {
         }];
    }
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    double animationDuaration;
    UIViewAnimationOptions animationOption;
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey]getValue:&animationDuaration];
    [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey]getValue:&animationOption];
    NSDictionary* info = [notification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat keybdHeight = kbSize.width > kbSize.height ? kbSize.height : kbSize.width;
   // NSLog(@"%f",kbSize.width);
    if(keybdHeight > _fTextHight && !self.bKeyboardShow)
    {
        self.bKeyboardShow = YES;
        _fTextMove = keybdHeight - _fTextHight;
        [UIView animateWithDuration:animationDuaration delay:0.0f options:animationOption animations:^{
            [UIView animateWithDuration:0.5 delay:0.0f options:nil animations:^{
                self.backGroundView.frame =  CGRectOffset(self.backGroundView.frame, 0, -_fTextMove);
            } completion:^(BOOL finished){}];}completion:^(BOOL finished)
         {
         }];
    }
}


- (IBAction)goBack:(id)sender {
    [[com4lovesSDK sharedInstance] showAccountManager];
}
-(void) changeDoneResp
{
    if([[SDKUtility sharedInstance] checkInput:[[ServerLogic sharedInstance] getLoginedUserName] password:self.newSecretText.text email:nil])
    {
        if([[ServerLogic sharedInstance] modify:self.newSecretText.text oldPassword:self.oriSecretText.text] == YES)
        {
            [[com4lovesSDK sharedInstance] showAccountManager];
            [[SDKUtility sharedInstance] showAlertMessage:[com4lovesSDK getLang:@"notice_modify_password_ok"]];
        }
    }
    [[SDKUtility sharedInstance] setWaiting:NO];
}
- (IBAction)changeDone:(id)sender {
    
    if(self.makesureText.text != nil && ![self.newSecretText.text isEqualToString:self.makesureText.text])
    {
        NSString *tip = [com4lovesSDK getLang:@"changepsd_tip"];
        NSString *tipMessage = [com4lovesSDK getLang:@"changepsd_tipmessage"];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:tip message:tipMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        return;
    }
    
    [[SDKUtility sharedInstance] setWaiting:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeDoneResp) userInfo:nil repeats:NO] ;
}

- (IBAction)initPasswordOri:(id)sender {
    [self.oriSecretText setText:@""];
}

- (IBAction)initPasswordNew:(id)sender {
    [self.newSecretText setText:@""];
}

- (IBAction)didEnd:(id)sender {
    [sender resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.oriSecretText resignFirstResponder];
    [self.newSecretText resignFirstResponder];
    [self.makesureText resignFirstResponder];
}

- (void)dealloc {
    [self.view removeObserver:self forKeyPath:@"hidden"];
 //   [_lableTitle release];
 //   [_lableOldPsd release];
 //   [_lableNewPsd release];
    [_btnBack release];
    [_btnComplete release];
 //   [_viewLableTitle release];
//    [_labelMakeSure release];
    [_makesureText release];
    [_backGroundView release];
    [super dealloc];
}
- (void)viewDidUnload {
//    [self setLableTitle:nil];
//    [self setLableOldPsd:nil];
//    [self setLableNewPsd:nil];
    [self setBtnBack:nil];
    [self setBtnComplete:nil];
//    [self setViewLableTitle:nil];
//    [self setLabelMakeSure:nil];
    [self setMakesureText:nil];
    [self setBackGroundView:nil];
    [super viewDidUnload];
}
@end
