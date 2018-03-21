//
//  gamedetails_subview.h
//  49AppKit
//
//  Created by 14zynr on 13-7-29.
//  Copyright (c) 2013年 __jc_49app__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol _gamedetails_delegate;
@interface gamedetails_subview : UIView < UIScrollViewDelegate, UITextViewDelegate >
{
    UIScrollView *_gamedetails_scrollview;
    
    NSString *_link;
    
    /* transform */
    CGAffineTransform textloadview_transform;
}

@property (nonatomic, assign) id <_gamedetails_delegate> __gamedetails_delegate;
@property (nonatomic, retain) UIImageView *_app_icon;
@property (nonatomic, retain) UILabel *_app_title;
@property (nonatomic, retain) UILabel *_price_title;
@property (nonatomic, retain) UILabel *_lx_title;
@property (nonatomic, retain) UILabel *_bq_title;
@property (nonatomic, retain) UILabel *_rl_title;
@property (nonatomic, retain) UILabel *_yy_title;
@property (nonatomic, retain) UILabel *_jf_title;
@property (nonatomic, retain) UITextView *_gamedetails_textview;
@property (nonatomic, retain) NSDictionary *_main_info_dic;
@property (nonatomic, retain) NSDictionary *_gamedetails_info_dic;

- (id)initWithFrame:(CGRect)frame withInfo:(NSDictionary *)_info_dic;
- (void)_load_data:(NSString *)_yyid;

@end

@protocol _gamedetails_delegate <NSObject>
    - (void)_gamedetails2pev_action;
    - (void)_download_applink:(id)_link;
@end
