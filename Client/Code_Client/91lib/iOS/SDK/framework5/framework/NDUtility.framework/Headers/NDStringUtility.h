/*
 *  NDStringUtility.h
 *  NDUtility
 *
 *  Created by Ｓie Kensou on 6/4/10.
 *  Copyright 2010 NetDragon WebSoft Inc.. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

/*!
 A Simple Tool about strings.
 */

@interface NDStringUtility : NSObject

/*!
 convert hex strings to byte.
 e.g. "C1AB" to {0xC1, 0xAB}
 @param hexString the hexString,the length of it should be even.
 @result returns the corresponding data of the hexString.
 */
+ (NSData *)getDataFromHexString:(const char*)hexString;

/*!
 convert bytes to hex strings.
 e.g. {0xC1, 0xAB} to "C1AB"
 @param bytes the data start pointer
 @param length the length of the data
 @result returns the corresponding hexString of the data.
 */
+ (NSString *)getHexStringFromBytes:(const char*)bytes length:(int)length;
@end
