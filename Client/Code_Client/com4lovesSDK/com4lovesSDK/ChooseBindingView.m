//
//  ChooseBindingView.m
//  com4lovesSDK
//
//  Created by GuoDong on 14-10-30.
//  Copyright (c) 2014年 com4loves. All rights reserved.
//

#import "ChooseBindingView.h"
#import "com4lovesSDK.h"
@interface ChooseBindingView ()
@property (retain, nonatomic) IBOutlet UILabel *labelWarning1;
@property (retain, nonatomic) IBOutlet UILabel *labelWarning2;
@property (retain, nonatomic) IBOutlet UIButton *btnBind;
@property (retain, nonatomic) IBOutlet UIButton *btnNotbind;

@end

@implementation ChooseBindingView

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    [self.labelWarning1 setText:[com4lovesSDK getLang:@"choosebind_waring1"]];
    [self.labelWarning2 setText:[com4lovesSDK getLang:@"choosebind_waring2"]];
  
    [self.btnBind setTitle:[com4lovesSDK getLang:@"choosebind_bind"] forState:UIControlStateNormal];
    [self.btnBind setTitle:[com4lovesSDK getLang:@"choosebind_bind"] forState:UIControlStateSelected];
    [self.btnBind setTitle:[com4lovesSDK getLang:@"choosebind_bind"] forState:UIControlStateHighlighted];
    NSLog(@"%@",@"choosebind_notbind");
    [self.btnNotbind setTitle:[com4lovesSDK getLang:@"choosebind_notbind"] forState:UIControlStateNormal];
    [self.btnNotbind setTitle:[com4lovesSDK getLang:@"choosebind_notbind"] forState:UIControlStateSelected];
    [self.btnNotbind setTitle:[com4lovesSDK getLang:@"choosebind_notbind"] forState:UIControlStateHighlighted];
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)bindingAccount:(id)sender
{
    [[com4lovesSDK sharedInstance]showBinding];
}

- (IBAction)laterBindingAccount:(id)sender
{
    [[com4lovesSDK sharedInstance]hideAll];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_labelWarning1 release];
    [_labelWarning2 release];
    [_btnBind release];
    [_btnNotbind release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLabelWarning1:nil];
    [self setLabelWarning2:nil];
    [self setBtnBind:nil];
    [self setBtnNotbind:nil];
    [super viewDidUnload];
}
@end
