//
//  ViewController.m
//  test3
//
//  Created by fish on 13-8-21.
//  Copyright (c) 2013年 com4loves. All rights reserved.
//

#import "RegisterView.h"
#import "com4lovesSDK.h"
#import "JSON.h"
#import "SDKUtility.h"
#import "ServerLogic.h"
#import <regex.h>

@interface RegisterView ()
{
    CGFloat _fTextHight;
    CGFloat _fTextMove;
    CGRect  _originBKViewRect;
}
@property (nonatomic) RegisterViewStyle viewStyle;
//@property (retain, nonatomic) IBOutlet UILabel *lableTitle;
//@property (retain, nonatomic) IBOutlet UILabel *lableNotice;
//@property (retain, nonatomic) IBOutlet UILabel *lableAccount;
//@property (retain, nonatomic) IBOutlet UILabel *lablePassword;
//@property (retain, nonatomic) IBOutlet UILabel *lableEmail;
//@property (retain, nonatomic) IBOutlet UILabel *viewLabelTitle;
@property (retain, nonatomic) IBOutlet UIButton *btnComplete;
@property (retain, nonatomic) IBOutlet UIView *backGroundView;
@property (retain, nonatomic) IBOutlet UILabel *lableAgree;
@property (retain, nonatomic) IBOutlet UIButton *btnprotocol;
@property (nonatomic,assign) BOOL bKeyboardShow;
@end
@implementation RegisterView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"GamesBundle" ofType:@"bundle"]];
        NSString *alertImagePath = [bundle pathForResource:@"background" ofType:@"png"];
        self.agreeImagePath = [bundle pathForResource:@"cb_glossy_on" ofType:@"png"];
        self.disAgreeImagePath = [bundle pathForResource:@"cb_glossy_off" ofType:@"png"];
//        UIImage* backImage =  [UIImage imageWithContentsOfFile:alertImagePath];
//        self.view.backgroundColor = [UIColor colorWithPatternImage:backImage];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.bSelected = YES;
    _fTextMove = 0.0f;
    self.bKeyboardShow = NO;
//    [self.view setFrame:CGRectMake(0,0,320,240)];
//    [self.btnBack setTitle:[com4lovesSDK getLang:@"back"] forState:UIControlStateNormal];
//    [self.btnBack setTitle:[com4lovesSDK getLang:@"back"] forState:UIControlStateSelected];
//    [self.btnBack setTitle:[com4lovesSDK getLang:@"back"] forState:UIControlStateHighlighted];
     [self.view addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    self.lableAgree.text = [com4lovesSDK getLang:@"registerview_agree"];
  
    [self.btnprotocol setTitle:[com4lovesSDK getLang:@"registerview_protocol"] forState:UIControlStateNormal];
    [self.btnprotocol setTitle:[com4lovesSDK getLang:@"registerview_protocol"] forState:UIControlStateSelected];
    [self.btnprotocol setTitle:[com4lovesSDK getLang:@"registerview_protocol"] forState:UIControlStateHighlighted];

    [self.btnComplete setTitle:[com4lovesSDK getLang:@"registerview_register"] forState:UIControlStateNormal];
    [self.btnComplete setTitle:[com4lovesSDK getLang:@"registerview_register"] forState:UIControlStateSelected];
    [self.btnComplete setTitle:[com4lovesSDK getLang:@"registerview_register"] forState:UIControlStateHighlighted];
    [self.btnComplete setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
//    [self.viewLabelTitle setText:[com4lovesSDK getLang:@"viewtitle"]];
//    [self.lableTitle setText:[com4lovesSDK getLang:@"registerview_register"]];
//    [self.lableAccount setText:[com4lovesSDK getLang:@"registerview_account"]];
//    [self.lableEmail setText:[com4lovesSDK getLang:@"registerview_email"]];
//    [self.lableNotice setText:[com4lovesSDK getLang:@"registerview_notice"]];
//    [self.lablePassword setText:[com4lovesSDK getLang:@"registerview_password"]];
    
    [self.plainTextField setPlaceholder:[com4lovesSDK getLang:@"registerview_account_cint"]];
    [self.secretTextField setPlaceholder:[com4lovesSDK getLang:@"registerview_password_cint"]];
    [self.emailTextField setPlaceholder:[com4lovesSDK getLang:@"registerview_email_cint"]];
    UIImage* backImage =  [UIImage imageWithContentsOfFile:self.agreeImagePath];
    self.selectImageView.image = backImage;
    //gdd
    [self positionView];
}

/////////////////////////////////remove view ////////////////////////////////////
-(void)positionView
{
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    CGRect rectText = self.emailTextField.frame;
    CGRect rectWindow = window.rootViewController.view.frame;
    _originBKViewRect = self.backGroundView.frame;
   // _originBKViewRect = rectBackView;
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
    NSLog(@"%f,%f",kbSize.width,_fTextHight);
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
////////////////////////////////////////////////////////////

- (IBAction)selectUserAgreement:(id)sender {
    UIImage* backImage;
    if(self.bSelected)
    {
        backImage =  [UIImage imageWithContentsOfFile:self.disAgreeImagePath];
        self.button.enabled = NO;
        self.bSelected = NO;
    }
    else
    {
        backImage =  [UIImage imageWithContentsOfFile:self.agreeImagePath];
        self.button.enabled = YES;
        self.bSelected = YES;
    }
    if(backImage)
         self.selectImageView.image = backImage;
}

- (IBAction)gotoUserAgreement:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.we4dota.com/Agreement.html"]];

}

- (IBAction)gobackLogin:(id)sender {
    switch (self.viewStyle) {
        case stylePositive:
            [[com4lovesSDK sharedInstance] showChooseBinding];
            break;
        case styleRegister:
            {
                [[com4lovesSDK sharedInstance] showLogin];
            }
            break;
        case sytleBingding:
            [[com4lovesSDK sharedInstance] showChooseBinding];
            break;
    }
}

-(void) clickResp
{
    if([[SDKUtility sharedInstance] checkInput:self.plainTextField.text password:self.secretTextField.text email:self.emailTextField.text])
    {
        switch (self.viewStyle) {
            case stylePositive:
                if ([[ServerLogic sharedInstance] changeTryUser2OkUserWithName:self.plainTextField.text password:self.secretTextField.text andEmail:self.emailTextField.text]==YES)
//                if([[ServerLogic sharedInstance] create:self.plainTextField.text password:self.secretTextField.text email:self.emailTextField.text] == YES)
                {
                    [[com4lovesSDK sharedInstance] hideAll];
                    [[SDKUtility sharedInstance] showAlertMessage:[com4lovesSDK getLang:@"notice_bindingok"]];
                    [[com4lovesSDK sharedInstance] tryUser2SucessNotify];
                }
                break;
            case styleRegister:
                if([[ServerLogic sharedInstance] create:self.plainTextField.text password:self.secretTextField.text email:self.emailTextField.text] == YES)
                {
                    [[com4lovesSDK sharedInstance] hideAll];
                }
                break;
            case sytleBingding:

                break;
        }  
    }
   
    [[SDKUtility sharedInstance] setWaiting:NO];
}

#warning  轮询检测改为事件会掉
- (IBAction)click:(id)sender {

    [[SDKUtility sharedInstance] setWaiting:YES];

    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(clickResp) userInfo:nil repeats:NO] ;
    
}

- (IBAction)didEnd:(id)sender {
    
    if(self.plainTextField.text == nil || [self.plainTextField.text isEqualToString:@""])
    {
        [self.plainTextField becomeFirstResponder];
    }
    else if(self.secretTextField.text == nil || [self.secretTextField.text isEqualToString:@""])
    {
        [self.secretTextField becomeFirstResponder];
    }
    else if(self.emailTextField.text == nil || [self.emailTextField.text isEqualToString:@""])
    {
        [self.emailTextField becomeFirstResponder];
    }
    else
    {
        [sender resignFirstResponder];
        [[SDKUtility sharedInstance] checkInput:self.plainTextField.text password:self.secretTextField.text email:self.emailTextField.text];

    }
}

- (IBAction)initEmail:(id)sender {
    [self.emailTextField setText:@""];
}

- (void) initWithViewStyle:(RegisterViewStyle)style
{
    self.button.enabled = YES;
    self.bSelected = YES;
    UIImage* backImage =  [UIImage imageWithContentsOfFile:self.agreeImagePath];
    self.selectImageView.image = backImage;
    //[self.emailTextField setText:[com4lovesSDK getLang:@"registerview_email_cint"]];
    self.plainTextField.text = @"";
    self.secretTextField.text = @"";
    self.emailTextField.text = @"";
//    [self.btnBack setTitle:[com4lovesSDK getLang:@"back"] forState:UIControlStateNormal];
//    [self.btnBack setTitle:[com4lovesSDK getLang:@"back"] forState:UIControlStateSelected];
    self.viewStyle = style;
    YALog(@"style %d",style);
    switch (style) {
        case stylePositive:
        //    [self.viewTitle setText:[com4lovesSDK getLang:@"register_bind"]];
            [self.btnBack setHidden:NO];
            [self.btnComplete setTitle:[com4lovesSDK getLang:@"registerview_bind"] forState:UIControlStateNormal];
            [self.btnComplete setTitle:[com4lovesSDK getLang:@"registerview_bind"] forState:UIControlStateSelected];
            [self.btnComplete setTitle:[com4lovesSDK getLang:@"registerview_bind"] forState:UIControlStateHighlighted];
//            [self.btnBack setTitle:[com4lovesSDK getLang:@"close"]  forState:UIControlStateNormal];
//            [self.btnBack setTitle:[com4lovesSDK getLang:@"close"]  forState:UIControlStateSelected];
            break;
        case styleRegister:
        //    [self.viewTitle setText:[com4lovesSDK getLang:@"register"]];
            [self.btnBack setHidden:NO];
            [self.btnComplete setTitle:[com4lovesSDK getLang:@"registerview_register"] forState:UIControlStateNormal];
            [self.btnComplete setTitle:[com4lovesSDK getLang:@"registerview_register"] forState:UIControlStateSelected];
            [self.btnComplete setTitle:[com4lovesSDK getLang:@"registerview_register"] forState:UIControlStateHighlighted];

            break;
        case sytleBingding:
         //   [self.viewTitle setText:[com4lovesSDK getLang:@"binding"]];
            [self.btnBack setHidden:NO];
            break;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.plainTextField resignFirstResponder];
    [self.secretTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
}

- (void)dealloc {
    [self.view removeObserver:self forKeyPath:@"hidden"];
   // [_viewTitle release];
    [_btnBack release];
 //   [_lableTitle release];
  //  [_lableNotice release];
 //   [_lableAccount release];
 //   [_lablePassword release];
 //   [_lableEmail release];
    [_btnComplete release];
 //   [_viewLabelTitle release];
    [_selectImageView release];
    [_backGroundView release];
    [_lableAgree release];
    [_btnprotocol release];
    [super dealloc];
}
- (void)viewDidUnload {
//    [self setViewTitle:nil];
//    [self setLableTitle:nil];
//    [self setLableNotice:nil];
//    [self setLableAccount:nil];
//    [self setLablePassword:nil];
//    [self setLableEmail:nil];
    [self setBtnBack:nil];
    [self setBtnComplete:nil];
  //  [self setViewLabelTitle:nil];
    [self setSelectImageView:nil];
    [self setBackGroundView:nil];
    [self setLableAgree:nil];
    [self setBtnprotocol:nil];
    [super viewDidUnload];
}
@end
