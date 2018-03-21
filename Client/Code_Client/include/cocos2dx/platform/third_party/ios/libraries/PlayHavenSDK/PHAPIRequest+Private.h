/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright 2013-2014 Medium Entertainment, Inc.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

 PHAPIRequest+Private.h
 playhaven-sdk-ios

 Created by Anton Fedorchenko on 9/3/13.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

typedef NS_ENUM(NSUInteger, PHRequestHTTPMethod)
{
    PHRequestHTTPGet = 0,
    PHRequestHTTPPost
};

@interface PHAPIRequest ()

/**
 * Indicates HTTP method used to transfer parameters to the server. Default is PHRequestHTTPGet.
 **/
@property (nonatomic, assign, readonly) PHRequestHTTPMethod HTTPMethod;

/**
 * List of identifiers used for v4-style signature generation.
 **/
+ (NSDictionary *)identifiers;

/**
 * Generates v4 - style signature as defined by client-api documentation for a given message in
 * combination with a given key. The returned signature is a URL-safe base64 encoded string.
 *
 * @param aMessage
 *   An arbitrary message that is to be signed. Must not be nil.
 *
 * @param aKey
 *   A secret cryptographic key used for signature generation.
 *
 * @return
 *   v4 - style signature in form of a URL-safe base64 encoded string.
 **/
+ (NSString *)v4SignatureWithMessage:(NSString *)aMessage signatureKey:(NSString *)aKey;

/**
 * Generates v4 - style signature as defined by clietn-api documentation for a given dictionary of
 * identifiers, application token and nonce in combination with a given key. The returned signature
 * is a URL-safe base64 encoded string.
 *
 * @param anIdentifiers
 *   An dictionary of device identifiers used to construct a message that is to be signed using aKey
 *
 * @param aToken
 *   An application token used to construct a message that is to be signed using aKey.
 *
 * @param aNonce
 *   A nonce key used used to construct a message that is to be signed using aKey.
 *
 * @return
 *   v4 - style signature in form of a URL-safe base64 encoded string.
 **/
+ (NSString *)v4SignatureWithIdentifiers:(NSDictionary *)anIdentifiers token:(NSString *)aToken
            nonce:(NSString *)aNonce signatureKey:(NSString *)aKey;

/**
 * Constructs request URL and returns result to the given completion handler.
 **/
- (void)constructRequestURLWithCompletionHandler:(void (^)(NSURL *inURL))aCompletionHandler;

/**
 * Invoked upon receiving a response from the server. Subclasses may override this method to
 * implement their own logic of processing server response.
 **/
- (void)didSucceedWithResponse:(NSDictionary *)aResponseDictionary;

@end
