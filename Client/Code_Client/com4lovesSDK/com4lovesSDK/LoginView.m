//
//  ViewController.m
//  test3
//
//  Created by fish on 13-8-21.
//  Copyright (c) 2013年 com4loves. All rights reserved.
//

#import "LoginView.h"
#import "com4lovesSDK.h"
#import "JSON.h"
#import "InAppPurchaseManager.h"
#import "SDKUtility.h"
#import "ServerLogic.h"
#import "UserListView.h"
@interface LoginView ()<UIAlertViewDelegate,userListDelegate>
{
    CGFloat _fTextHight;
    CGFloat _fTextMove;
    CGRect _originBKViewRect;
}
@property (retain, nonatomic) IBOutlet UIView *listBackgroundView;
@property (retain, nonatomic) IBOutlet UIButton *btnShowList;
@property (retain, nonatomic) IBOutlet UIView *backGroundView;
@property (retain, nonatomic) IBOutlet UIButton *btnLogin;
@property (retain,nonatomic) UserListView*          viewUserList;
@property (retain,nonatomic) NSBundle               *mainBundle;
@property (nonatomic,assign) BOOL bListShow;
@property (nonatomic,assign) BOOL bKeyboardShow;
@end

@implementation LoginView
//@synthesize button;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     [self.view addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    _fTextMove = 0.0f;
    self.listBackgroundView.hidden = YES;
    self.bListShow = NO;
    self.bKeyboardShow = NO;
    CALayer *layer = self.listBackgroundView.layer;
    layer.cornerRadius = 3;
    
    [self.view setFrame:CGRectMake(0,0,568,320)];
    
    [self.btnRegister setTitle:[com4lovesSDK getLang:@"registerview_register"] forState:UIControlStateNormal];
    [self.btnRegister setTitle:[com4lovesSDK getLang:@"registerview_register"] forState:UIControlStateSelected];
    [self.btnRegister setTitle:[com4lovesSDK getLang:@"registerview_register"] forState:UIControlStateHighlighted];
    
    [self.btnLogin setTitle:[com4lovesSDK getLang:@"loginview_login"] forState:UIControlStateNormal];
    [self.btnLogin setTitle:[com4lovesSDK getLang:@"loginview_login"] forState:UIControlStateSelected];
    [self.btnLogin setTitle:[com4lovesSDK getLang:@"loginview_login"] forState:UIControlStateHighlighted];
    [self positionView];
}

- (NSBundle *)mainBundle
{
    if (!_mainBundle) {
        NSString* fullpath1 = [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:"GamesBundle.bundle"]
                                                              ofType:nil
                                                         inDirectory:[NSString stringWithUTF8String:""]];
        self.mainBundle = [NSBundle bundleWithPath:fullpath1];
        //NSBundle *buddle = [NSBundle bundleWithIdentifier:@"com.loves.com4lovesBundle"];
        [_mainBundle load];
    }
    
    return _mainBundle;
}

-(UserListView *)viewUserList
{
    if (!_viewUserList) {
         self.viewUserList = [[[UserListView alloc] initWithNibName:@"UserListView" bundle:self.mainBundle] autorelease];
        self.viewUserList.delegate = self;
        CGRect rect = self.listBackgroundView.frame;
        [self.viewUserList.view setFrame:CGRectMake(0, -rect.size.height, rect.size.width, rect.size.height)];
        [self.listBackgroundView addSubview:self.viewUserList.view];
    }
    return _viewUserList;
}



/////////////////////////////////remove view ////////////////////////////////////
-(void)positionView
{
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    CGRect rectText = _secretTextField.frame;
    CGRect rectWindow = window.rootViewController.view.frame;
    _originBKViewRect = self.backGroundView.frame;
  //  _originBKViewRect = rectBackView;
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
                //self.backGroundView.frame =  _originBKViewRect;
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
   //  NSLog(@"%f",kbSize.width);
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) gotoRegisterResp
{
    //一秒注册代码在这里
//    if([[ServerLogic sharedInstance] preCreate]==YES)
//    {
        [[com4lovesSDK sharedInstance] showRegister];
//    }
    [[SDKUtility sharedInstance] setWaiting:NO];
}
- (IBAction)gotoRegister:(id)sender {
//    NSString *tryUser = [[ServerLogic sharedInstance] getTryUser];
//    NSString *UserID = [[ServerLogic sharedInstance]getYouaiID];
//    if (tryUser!=nil && UserID != nil)
//    {
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的试玩账号尚未绑定，是否进行绑定" delegate:self cancelButtonTitle:@"不绑定" otherButtonTitles:@"绑定", nil];
//        [alertView setTag:100];
//        [alertView show];
//        [alertView release];
//    }
//    else
//    {
        [[SDKUtility sharedInstance] setWaiting:YES];
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(gotoRegisterResp) userInfo:nil repeats:NO];
   // }
}

- (IBAction)onEditChange:(id)sender {
    if (0 == self.plainTextField.text.length) {
        [self.btnArrow setHidden:NO];
        [self.btnNameDel setHidden:YES];
    } else{
        [self.btnArrow setHidden:YES];
        [self.btnNameDel setHidden:NO];
    }
    
}
- (IBAction)onPasswordChange:(id)sender {
    if (0 == self.secretTextField.text.length) {
        [self.btnPsdDel setHidden:YES];
    } else{
        [self.btnPsdDel setHidden:NO];
    }
}
- (IBAction)onNameDelClick:(id)sender {
    [self.plainTextField setText:@""];
    [self.btnArrow setHidden:NO];
    [self.btnNameDel setHidden:YES];
}
- (IBAction)onPsdDelClick:(id)sender {
    [self.secretTextField setText:@""];
    [self.btnPsdDel setHidden:YES];

}

-(void) clickResp
{
    if([[ServerLogic sharedInstance] login:self.plainTextField.text password:self.secretTextField.text] == YES)
    {
        [[com4lovesSDK sharedInstance] hideAll];
    }
    [[SDKUtility sharedInstance] setWaiting:NO];
}

- (IBAction)click:(id)sender {
    
    if([[SDKUtility sharedInstance] checkInput:self.plainTextField.text password:self.secretTextField.text email:nil] ==NO)
        return;

    [[SDKUtility sharedInstance] setWaiting:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(clickResp) userInfo:nil repeats:NO] ;

}

- (IBAction)didEnd:(id)sender {
    [sender resignFirstResponder];
    [[SDKUtility sharedInstance] checkInput:self.plainTextField.text password:self.secretTextField.text email:nil];
}

- (IBAction)showUserList:(id)sender {
   // [[com4lovesSDK sharedInstance] showUserList];
    [sender resignFirstResponder];
    [self animationListShow];
  
}

-(void)animationListShow
{
    if(self.bListShow)
    {
        self.btnShowList.enabled = NO;
        self.bListShow = NO;
        CGRect rect = self.listBackgroundView.frame;
        [UIView beginAnimations:@"counterclockwiseAnimation"context:NULL];
        /* 5 seconds long */
        [UIView setAnimationDuration:0.8f];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(hideListStopped)];
        /* 回到原始旋转 */
        self.btnShowList.transform = CGAffineTransformIdentity;
         self.viewUserList.view.frame = CGRectOffset(self.viewUserList.view.frame,0,-rect.size.height);
        [UIView commitAnimations];
    }
    else
    {
        self.btnShowList.enabled = NO;
        [_secretTextField resignFirstResponder];
        [_plainTextField resignFirstResponder];
        CGRect rect = self.listBackgroundView.frame;
        [self.viewUserList.view setFrame:CGRectMake(0, -rect.size.height, rect.size.width, rect.size.height)];
        self.bListShow = YES;
        self.listBackgroundView.hidden = NO;
        [UIView beginAnimations:@"clockwiseAnimation" context:NULL];
        /* Make the animation 5 seconds long */
        [UIView setAnimationDuration:0.8f];
        [UIView setAnimationDelegate:self];
        //停止动画时候调用clockwiseRotationStopped方法
        [UIView setAnimationDidStopSelector:@selector(clockwiseRotationStopped)];
      //  [self.viewUserList refresh];
        self.viewUserList.view.frame = CGRectOffset(self.viewUserList.view.frame,0,rect.size.height);
        //顺时针旋转90度
        self.btnShowList.transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
        /* Commit the animation */
        [UIView commitAnimations];
    }
}

-(void)hideListStopped
{
    self.btnShowList.enabled = YES;
    self.listBackgroundView.hidden = YES;
    if (0 != self.plainTextField.text.length)
    {
        [self.btnArrow setHidden:YES];
        [self.btnNameDel setHidden:NO];
    }
    if (0 != self.secretTextField.text.length)
    {
        [self.btnPsdDel setHidden:NO];
    }
}

-(void)clockwiseRotationStopped
{
    self.btnShowList.enabled = YES;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [[SDKUtility sharedInstance] setWaiting:YES];
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(gotoRegisterResp) userInfo:nil repeats:NO];
    }
    else if(buttonIndex == 1)
    {
        [[com4lovesSDK sharedInstance]showBinding];
    }
}
- (IBAction)returnIndex:(id)sender
{
    [[com4lovesSDK sharedInstance]showIndex];
}

//////////////userListDeletate///////////////
-(void)hideListViewUser:(NSString*)name andPassWord:(NSString*)password
{
    [self.plainTextField setText:name];
    [self.secretTextField setText:password];
    [self animationListShow];
}

-(void)clearInfo
{
    [self.plainTextField setText:@""];
    [self.secretTextField setText:@""];
    [self.btnArrow setHidden:NO];
    [self.btnNameDel setHidden:YES];
    [self.btnArrow setHidden:NO];
    [self.btnNameDel setHidden:YES];
}

- (IBAction)userNameEditEnd:(id)sender
{
    if(self.secretTextField.text == nil || [self.secretTextField.text isEqualToString:@""])
        [_secretTextField becomeFirstResponder];
    else
    {
        [sender resignFirstResponder];
        [[SDKUtility sharedInstance] checkInput:self.plainTextField.text password:self.secretTextField.text email:nil];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.secretTextField resignFirstResponder];
    [self.plainTextField resignFirstResponder];
}

- (void)dealloc {
    [self.view removeObserver:self forKeyPath:@"hidden"];
    [_btnRegister release];
    [_btnNameDel release];
    [_btnPsdDel release];
    [_btnArrow release];
    [_btnLogin release];
    [_listBackgroundView release];
    [_btnShowList release];
    [_backGroundView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setBtnRegister:nil];
    [self setBtnNameDel:nil];
    [self setBtnPsdDel:nil];
    [self setBtnArrow:nil];
    [self setBtnRegister:nil];
    [self setBtnLogin:nil];
    [self setListBackgroundView:nil];
    [self setBtnShowList:nil];
    self.viewUserList = nil;
    [self setBackGroundView:nil];
    [super viewDidUnload];
}


- (void)initWithViewStyle:(LoginViewStyle)style
{
//    switch (style) {
//        case styleLogin:
//            [self.btnRegister setHidden:YES];
//            self.button.frame = CGRectMake(18, 262, 265, 44);
//            break;
//        case styleLoginWithRegister:
//            [self.btnRegister setHidden:NO];
//            self.button.frame = CGRectMake(158, 262, 125, 44);
//            break;
//    }
}
@end
