//
//  NdSMSAssistant.h
//  ATSMS
//
//  Created by chenjianshe on 10-12-24.
//  Copyright 2010 NetDragon WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NdSMSAssistant : NSObject {
	BOOL isIphone4;
}

+ (NdSMSAssistant*)sharedInstance;

+ (NSString*)getIMSI;

@end
