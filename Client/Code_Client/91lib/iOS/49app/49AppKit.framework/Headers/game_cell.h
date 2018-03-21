//
//  game_cell.h
//  49AppKit
//
//  Created by 14zynr on 13-7-29.
//  Copyright (c) 2013年 __jc_49app__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol _gamecell_delegate;
@interface game_cell : UITableViewCell
{
    CGRect _cgrect;
    
    NSString *_app_link;
}

@property (nonatomic, assign) id <_gamecell_delegate> __gamecell_delegate;
@property (nonatomic, retain) UIImageView *_app_icon;
@property (nonatomic, retain) UILabel *_app_title;
@property (nonatomic, retain) UILabel *_app_downloadcount;
@property (nonatomic) int _app_level;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withFrame:(CGRect)_rect;
- (void)_set_app_icon:(UIImage *)_icon;
- (void)_set_app_title:(NSString *)_title;
- (void)_set_app_downloadedcount:(NSString *)_downloadedcount;
- (void)_set_applevel:(int)_level;
- (void)_set_app_link:(NSString *)_link;

@end

@protocol _gamecell_delegate <NSObject>
    - (void)_download_applink:(id)_link;
@end
