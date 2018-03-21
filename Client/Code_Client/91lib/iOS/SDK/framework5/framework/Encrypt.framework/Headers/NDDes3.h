/*
 *  NDDes3.h
 *  Encrypt
 *
 *  Created by Ｓie Kensou on 6/1/10.
 *  Copyright 2010 NetDragon WebSoft Inc.. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "NDEncryptError.h"

@interface NDDes3 : NSObject

/*!
 create des3 encrypt Data for input Data, use key and iv to do the encrypt.use PKCS7Padding & CBC Mode.
 @param inputData the input data used for encryption
 @param key key for 3des encryption should be 24 byte,if less than 24, bytes of zero will be filled;else more than 24 bytes, the rest will not be used.
 @param iv init vector to do 3des, 8 bytes will be used, and also will be filled with zero if less than 8 bytes.if iv nil, we'll use the first 8 bytes of key.
 @param error if not NULL, error code will be stored in it if error ocurred.
 @result the encryted data, you should release it manualy after use.
 */
+ (NSData *)createDes3EncryptData:(NSData *)inputData keyData:(NSData *)keyData initVectorData:(NSData *)ivData error:(int *)error;

/*!
 create decrypt Data for encrypted input Data, use key and iv to do the decrypt.use PKCS7Padding & CBC Mode.
 @param inputData the input data was encrypted, use to decrypt
 @param key key for 3des encryption should be 24 byte,if less than 24, bytes of zero will be filled;else more than 24 bytes, the rest will not be used.
 @param iv init vector to do 3des, 8 bytes will be used, and also will be filled with zero if less than 8 bytes.if iv nil, we'll use the first 8 bytes of key.
 @param error if not NULL, error code will be stored in it if error ocurred. 
 @result the decrypt data, you should release it manualy after use.
 */

+ (NSData *)createDes3DecryptData:(NSData *)encryptData keyData:(NSData *)keyData initVectorData:(NSData *)ivData error:(int *)error;

+ (NSData *)createRandomDes3Key;
@end


