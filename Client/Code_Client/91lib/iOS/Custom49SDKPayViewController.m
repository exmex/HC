//
//  GameTestViewController.m
//  GameLibTest
//
//  Created by M an on 13-8-6.
//  Copyright (c) 2013年 Totti.Lv. All rights reserved.


//  继承 49app的uinavigationController 监听他的关闭时间..

#import "Custom49SDKPayViewController.h"

#import "Custom49SDK.h"

@interface Custom49SDKPayViewController (){

}
    
@end

@implementation Custom49SDKPayViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [Custom49SDK hideAllView];
}

@end
