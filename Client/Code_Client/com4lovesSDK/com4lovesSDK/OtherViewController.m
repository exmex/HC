//
//  OtherViewController.m
//  PayDemo
//
//  Created by 呼啦呼啦圈 on 13-9-13.
//  Copyright (c) 2013年 吕冬剑. All rights reserved.
//

#import "OtherViewController.h"


@interface OtherViewController ()

@end

@implementation OtherViewController

- (id)init
{
    self = [super init];
    if (self) {
        view = [[ViewController alloc]init];
        UINavigationController * uiNvC = [[UINavigationController alloc] initWithRootViewController:view];
        uiNvC.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        uiNvC.navigationBar.hidden = YES;
        [uiNvC setNavigationBarHidden:YES];
        [self.view addSubview:uiNvC.view];
    }
    return self;
}

- (void) setTotalFee:(float) fee
{
    [view setTotalFee:fee];
}
- (void) setServerId:(NSString*) serverId
{
    [view setServerId:serverId];
}
- (void) setDesc:(NSString *) desc
{
    [view setDesc:desc];
}
- (void) setSubject:(NSString *)subject
{
    [view setSubject:subject];
}
- (void) setOrderId:(NSString *)orderId
{
    [view setOrderId:orderId];
}
- (void)showPay
{
    [view showPay];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
