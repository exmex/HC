//
//  main_subview.h
//  49AppKit
//
//  Created by 14zynr on 13-7-20.
//  Copyright (c) 2013年 __jc_49app__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ep_uiimageview.h"
#import "login_subview.h"
#import "register_subview.h"
#import "modify_subview.h"
#import "forget_subview.h"
#import "found_subview.h"
#import "bound_subview.h"
#import "jcbound_subview.h"
#import "gift_subview.h"
#import "kf_subview.h"
#import "quicklogin_subview.h"
#import "more_subview.h"
#import "zxandgl_subview.h"
#import "zx_subview.h"
#import "gl_subview.h"
#import "game_subview.h"
#import "gamedetails_subview.h"

@protocol _mainsubview_delegate;
@interface main_subview : UIView < UIScrollViewDelegate, _epuiimageview_delegate, _login_delegate, _quicklogin_delegate, _register_delegate, _modify_delegate, _forget_delegate, _found_delegate, _bound_delegate, _jcbound_delegate, _kf_delegate, _more_delegate, _zxandgl_delegate, _zx_delegate, _gl_delegate, _game_delegate, _gamedetails_delegate,  NSURLConnectionDataDelegate, NSURLConnectionDelegate, NSURLConnectionDownloadDelegate >
{
    UIScrollView *_main_scrollview;
    
    login_subview *_login_subview;
    register_subview *_register_subview;
    modify_subview *_modify_subview;
    forget_subview *_forget_subview;
    found_subview *_found_subview;
    bound_subview *_bound_subview;
    jcbound_subview *_jcbound_subview;
    gift_subview *_gift_subview;
    kf_subview *_kf_subview;
    quicklogin_subview *_quicklogin_subview;
    more_subview *_more_subview;
    zxandgl_subview *_zxandgl_subview;
    zx_subview *_zx_subview;
    gl_subview *_gl_subview;
    game_subview *_game_subview;
    gamedetails_subview *_gamedetails_subview;
    
    NSString *_ad_link;
    
    CGRect _left_frame, _mid_frame, _right_frame;
    
    /* transform */
    CGAffineTransform textloadview_transform;
    
    UIView *_autologin_alertview, *_boundsucceed_alertview, *_foundsucceed_alertview;
    
    NSTimer *_timer;
}

@property (nonatomic, assign) id <_mainsubview_delegate> __mainsubview_delegate;
@property (nonatomic, retain) NSDictionary *_main_info_dic;
@property (nonatomic) int _zxorgl;
@property (nonatomic) long long int _ggtotalsize;
@property (nonatomic, assign) NSURLConnection *_ggconnection;
@property (nonatomic, retain) NSMutableData *_ggdata;
@property (nonatomic, retain) NSMutableArray *_marr_userinfo;
@property (nonatomic, retain) NSString *_loginid_str;
@property (nonatomic, retain) NSString *_loginpass_str;
@property (nonatomic, retain) NSString *_registerid_str;
@property (nonatomic, retain) NSString *_registerpass_str;
@property (nonatomic, retain) NSString *_modifyid_str;
@property (nonatomic, retain) NSString *_modifyoldpass_str;
@property (nonatomic, retain) NSString *_modifynewpass_str;
@property (nonatomic, retain) NSString *_boundid_str;
@property (nonatomic, retain) NSString *_boundmobile_str;
@property (nonatomic, retain) NSString *_boundyzm_str;
@property (nonatomic, retain) NSString *_jcboundmobile_str;
@property (nonatomic, retain) NSString *_jcboundyzm_str;
@property (nonatomic) int _timecount;

- (id)initWithFrame:(CGRect)frame withInfo:(NSDictionary *)_info_dic;

@end

@protocol _mainsubview_delegate <NSObject>
    - (void)_login_succeed:(NSString *)_uid withTimestamp:(NSString *)_timestamp withSign:(NSString *)_sign;
@end
