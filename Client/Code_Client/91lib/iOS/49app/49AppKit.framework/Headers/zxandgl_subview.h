//
//  zxandgl_subview.h
//  49AppKit
//
//  Created by 14zynr on 13-7-26.
//  Copyright (c) 2013年 __jc_49app__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"

@protocol _zxandgl_delegate;
@interface zxandgl_subview : UIView < UITableViewDelegate, UITableViewDataSource, PullingRefreshTableViewDelegate >
{
    /* transform */
    CGAffineTransform textloadview_transform;
}

@property (nonatomic, assign) id <_zxandgl_delegate> __zxandgl_delegate;
@property (nonatomic, retain) PullingRefreshTableView *_49zxandgl_tableview;
@property (nonatomic, retain) NSMutableArray *_marr_appdata;
@property (nonatomic) BOOL _refreshing;
@property (nonatomic, retain) NSMutableArray *_marr_cell;
@property (nonatomic, retain) NSDictionary *_main_info_dic;
@property (nonatomic) int _news_type;

- (id)initWithFrame:(CGRect)frame withInfo:(NSDictionary *)_info_dic;
- (void)_load_data;

@end

@protocol _zxandgl_delegate <NSObject>
    - (void)_zxandgl_select:(NSIndexPath *)_indexPath withLinks:(NSString *)_links;
@end
