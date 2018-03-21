//
//  BindingView.m
//  com4lovesSDK
//
//  Created by ljc on 13-10-3.
//  Copyright (c) 2013年 com4loves. All rights reserved.
//

#import "BindingView.h"
#import "com4lovesSDK.h"
#import "JSON.h"
#import "InAppPurchaseManager.h"
#import "SDKUtility.h"
#import "ServerLogic.h"

@interface BindingView ()

@end

@implementation BindingView

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setFrame:CGRectMake(0,0,320,240)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBinding:(id)sender {
    if([[SDKUtility sharedInstance] checkInput:self.plainTextField.text password:self.secretTextField.text email:nil] ==NO)
        return;
    //
    [[SDKUtility sharedInstance] setWaiting:YES];
    //
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(clickResp) userInfo:nil repeats:NO] ;
}
- (IBAction)RigesterBinding:(id)sender {
    [[SDKUtility sharedInstance] setWaiting:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(gotoRegisterResp) userInfo:nil repeats:NO] ;
}
- (IBAction)findPassword:(id)sender {
    [[com4lovesSDK sharedInstance] showWeb:@"http://pc.com4loves.com:8261/jsp/public/help"];
}

- (void)dealloc {
    [_plainTextField release];
    [_secretTextField release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setPlainTextField:nil];
    [self setSecretTextField:nil];
    [super viewDidUnload];
}

-(void) gotoRegisterResp
{
    if([[ServerLogic sharedInstance] preCreate]==YES)
    {
        [[com4lovesSDK sharedInstance] showRegister];
    }
    [[SDKUtility sharedInstance] setWaiting:NO];
    
}

-(void) gotoBindingResp
{
    
    [[com4lovesSDK sharedInstance] showBinding];
    [[SDKUtility sharedInstance] setWaiting:NO];
    
}
- (IBAction)gotoRegister:(id)sender {
   
}

- (IBAction)closeLoginView:(id)sender {
    [[com4lovesSDK sharedInstance] hideAll];
}

-(void) clickResp
{
    NSString *tryuser = [[[ServerLogic sharedInstance] getTryUser]retain];
    if ([[ServerLogic sharedInstance] bindingGuestID:tryuser withName:self.plainTextField.text andPassword:self.secretTextField.text])
    {
        
        //    }
        //    if([[ServerLogic sharedInstance] login:self.plainTextField.text password:self.secretTextField.text] == YES)
        //    {
        [[com4lovesSDK sharedInstance] hideAll];
        [[SDKUtility sharedInstance] showAlertMessage:[com4lovesSDK getLang:@"notice_bindingok"]];
    }
    [tryuser release];
    [[SDKUtility sharedInstance] setWaiting:NO];
}


- (IBAction)didEnd:(id)sender {
    [sender resignFirstResponder];
    [[SDKUtility sharedInstance] checkInput:self.plainTextField.text password:self.secretTextField.text email:nil];
}

@end
