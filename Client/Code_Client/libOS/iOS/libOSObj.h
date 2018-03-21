//
//  libOSObj.h
//  libOS
//
//  Created by lyg on 13-3-5.
//  Copyright (c) 2013年 youai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface libOSObj : NSObject
{
    UIActivityIndicatorView *waitView;
}
-(void) showWait;
-(void) hideWait;
//-(void) appVersionUpdateDidFinish:(ND_APP_UPDATE_RESULT)updateResult;
@end
