/*
 *  NDUtility.h
 *  NDUtility
 *
 *  Created by Ｓie Kensou on 6/8/10.
 *  Copyright 2010 NetDragon WebSoft Inc.. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

/*!
 this function will do this:
 [srcObject retain];
 [*destObject release];
 *destObject = srcObject;
 [*destObject retain];
 [srcObject release];
 @param destObject the dest object, should not be nil!
 @param srcObject the src object, can be nil
 @result return YES unless destObject nil
 */
BOOL setNSObjectRetain(id *destObject, id srcObject);