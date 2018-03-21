/*
 *  NDGZipUtility.h
 *  NDUtility
 *
 *  Created by Ｓie Kensou on 6/4/10.
 *  Copyright 2010 NetDragon WebSoft Inc.. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

/*!
 A simple gizp tool.
 */

@interface NDGZipUtility : NSObject

/*!
 create gzip format data for memory data.
 @param bytes pointer to memory data
 @param len length of memory data
 @param error pointer to an integer, if not NULL, error number will be stored in it.
 @result return the gzip format data, nil on fail.
 */
+ (NSData *)createGZipData:(const void *)bytes dataLength:(int)len error:(int *)error;

/*!
 create ungzip format data for gzip memory data.
 @param bytes pointer to gziped memory data
 @param len length of gziped memory data
 @param error pointer to an integer, if not NULL, error number will be stored in it.
 @result return ungziped data, nil on fail.
 */
+ (NSData *)createDataFromGZip:(const void *)bytes dataLength:(int)len error:(int *)error;

@end
