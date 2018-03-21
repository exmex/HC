//
//  AdverView.m
//  lib91
//
//  Created by GuoDong on 14-9-24.
//  Copyright (c) 2014年 youai. All rights reserved.
//

#import "AdverView.h"

@implementation AdverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"%f,%f,%f,%f",frame.origin.x,frame.origin.y,frame.size.height,frame.size.width);
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithRed:41.0/255.0 green:41.0/255.0 blue:41.0/255.0 alpha:0.7];
        float height = frame.size.height/8*5;
        float width  = height*4/3;
        UIImageView *iView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        iView.center = self.center;
        UIImage *image = [UIImage imageNamed:@"advertise.png"];
        iView.image = image;
        [self addSubview:iView];
        [iView release];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = iView.frame;
        button.center = self.center;
        [iView addSubview:button];
        [button addTarget:self action:@selector(buttonDown) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake(0, 0, 100, 40);
        closeButton.center = CGPointMake(self.center.x, self.center.y-height/2-40);
        closeButton.layer.cornerRadius = 12;
        closeButton.backgroundColor = [UIColor blueColor];
        [self addSubview:closeButton];
        [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setTitle:@"Close" forState:UIControlStateNormal];
        [closeButton setTitle:@"Close" forState:UIControlStateSelected];
    }
    return self;
}

-(void)buttonDown
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/app/id529479190"]];
}

-(void)close
{
    self.hidden = YES;
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
