//
//  asyimage_view.h
//  49app_client_iphone
//
//  Created by 14zynr on 13-4-17.
//  Copyright (c) 2013年 __jc_49app__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kImageKey   @"image"
#define kIdKey      @"id"

@protocol _asyimage_delegate;
@interface asyimage_view : UIView < UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource >
{
@public
    id <_asyimage_delegate> __asyimage_delegate;
    NSMutableArray *_marr_tabledata;
    UITableView *_asyimage_tableview;
}

@end

@protocol _asyimage_delegate <NSObject>
@required
    - (void)_cellimage_did_load:(NSIndexPath *)_indexPath withImage:(UIImage *)_image;
@end
