/*
 *  NDRSA.h
 *  Encrypt
 *
 *  Created by Ｓie Kensou on 6/1/10.
 *  Copyright 2010 NetDragon WebSoft Inc.. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "NDEncryptError.h"

typedef struct R_RSA_PUBLIC_KEY*	RSA_PUBLIC_KEY_REF; 

@interface NDSimpleRSA : NSObject
{
	RSA_PUBLIC_KEY_REF			_publicKey;
}
/*!
 set the public key.This only accept 512byte key
 @param hexModulus the hexString of modulus
 @param hexExponent the hexString of hexExponent
 @result return 0 on success.
 */
- (int)setPublicKey:(char *)hexModulus hexExponent:(char *)hexExponent;

/*!
 do the rsa encrypt!you should call setPublicKey:hexExponent: to set publicKey at first.
 this only accept input length less than 53.
 @param inputString the string to be encrypt, len use strlen(inputString)
 @param error if not NULL, error num will be stored in.
 @result the data containing encrypt data, you should release it after use.
 */
- (NSData *)createEncryptData:(char *)inputString error:(int *)error;

/*!
 do the rsa encrypt!you should call setPublicKey:hexExponent: to set publicKey at first.
 this only accept input length less than 53.
 @param inputData the data to be encrypt, len use [inputData length]
 @param error if not NULL, error num will be stored in.
 @result the data containing encrypt data, you should release it after use.
 */
- (NSData *)createEncryptDataForData:(NSData *)inputData error:(int *)error;
@end
