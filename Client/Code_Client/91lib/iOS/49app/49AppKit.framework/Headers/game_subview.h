//
//  game_subview.h
//  49AppKit
//
//  Created by 14zynr on 13-7-29.
//  Copyright (c) 2013年 __jc_49app__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "asyimage_view.h"
#import "PullingRefreshTableView.h"
#import "game_cell.h"

@protocol _game_delegate;
@interface game_subview : asyimage_view < UIScrollViewDelegate, _asyimage_delegate, PullingRefreshTableViewDelegate, _gamecell_delegate >
{
    /* transform */
    CGAffineTransform textloadview_transform;
}

@property (nonatomic, assign) id <_game_delegate> __game_delegate;
@property (nonatomic, retain) PullingRefreshTableView *_49game_tableview;
@property (nonatomic, retain) NSMutableArray *_marr_appdata;
@property (nonatomic) BOOL _refreshing;
@property (nonatomic, retain) NSMutableArray *_marr_cell;
@property (nonatomic, retain) NSDictionary *_main_info_dic;

- (id)initWithFrame:(CGRect)frame withInfo:(NSDictionary *)_info_dic;

@end

@protocol _game_delegate <NSObject>
    - (void)_game_select:(NSIndexPath *)_indexPath;
    - (void)_download_applink:(id)_link;
@end
