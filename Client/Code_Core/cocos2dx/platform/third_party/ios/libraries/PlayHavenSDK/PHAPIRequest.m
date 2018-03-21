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

 PHAPIRequest.m
 playhaven-sdk-ios

 Created by Jesus Fernandez on 3/30/11.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import <CommonCrypto/CommonHMAC.h>
#import "PHConnectionManager.h"
#import "PHAPIRequest.h"

#import "NSObject+QueryComponents.h"
#import "PHStringUtil.h"
#import "JSON.h"
#import "UIDevice+HardwareString.h"
#import "PHNetworkUtil.h"
#import "PHConstants.h"
#import "PHAPIRequest+Private.h"
#import "PHKontagentDataAccessor.h"

#ifdef PH_USE_NETWORK_FIXTURES
#import "WWURLConnection.h"
#endif

typedef NS_ENUM(NSUInteger, PHRequestStatus)
{
    kPHRequestStatusInitialized = 0,
    kPHRequestStatusInProgress,
    kPHRequestStatusSucceeded,
    kPHRequestStatusFailed
};

static NSString *sPlayHavenSession = nil;
static NSString *sPlayHavenPluginIdentifier = nil;
static NSString *sPlayHavenCustomUDID = nil;

static NSString *const kSessionPasteboard = @"com.playhaven.session";
static NSString *const kPHRequestParameterIDFVKey = @"idfv";
static NSString *const kPHRequestParameterOptOutStatusKey = @"opt_out";
static NSString *const kPHRequestParameterConnectionKey = @"connection";
static NSString *const kPHDefaultUserIsOptedOut = @"PHDefaultUserIsOptedOut";

static NSString *const kPHKontagentSenderIDKey = @"sid";

static NSString *const kPHHTTPMethodPost = @"POST";
static NSString *const kPHHTTPContentTypeURLEncoded = @"application/x-www-form-urlencoded";
static NSString *const kPHHTTPHeaderContentType = @"Content-Type";

static NSString *const kPHUnexpectedServerResponse = @"Unexpected server response!";

@interface PHAPIRequest ()
@property (nonatomic, assign) PHRequestStatus requestStatus;
@property (nonatomic, retain, readwrite) NSDictionary *signedParameters;
@property (nonatomic, retain, readwrite) NSURL *URL;
@property (nonatomic, retain, readonly) NSDictionary *basicParameters;

+ (NSMutableSet *)allRequests;
- (void)finish;
- (void)afterConnectionDidFinishLoading;
+ (void)setSession:(NSString *)session;
- (void)processRequestResponse:(NSDictionary *)responseData;

- (void)didFailWithError:(NSError *)error;
@end

@implementation PHAPIRequest
@synthesize token    = _token;
@synthesize secret   = _secret;
@synthesize delegate = _delegate;
@synthesize urlPath  = _urlPath;
@synthesize hashCode = _hashCode;
@synthesize additionalParameters = _additionalParameters;

+ (void)initialize
{
    if  (self == [PHAPIRequest class]) {
        // Tom DiZoglio: Added DNS resolution once before the first call to media and api2
        // playhaven.com servers. Speeds up initial few calls, then after that stays the same. I
        // think AT&T is caching DNS at that point.
        
        [[PHNetworkUtil sharedInstance] checkDNSResolutionForURLPath:PHGetBaseURL()];
        [[PHNetworkUtil sharedInstance] checkDNSResolutionForURLPath:PH_CONTENT_ADDRESS];
#ifdef PH_USE_NETWORK_FIXTURES
        [WWURLConnection setResponsesFromFileNamed:@"dev.wwfixtures"];
#endif
    }
}

+ (NSMutableSet *)allRequests
{
    static NSMutableSet *allRequests = nil;

    if (allRequests == nil) {
        allRequests = [[NSMutableSet alloc] init];
    }

    return allRequests;
}

+ (void)cancelAllRequestsWithDelegate:(id<PHAPIRequestDelegate>)delegate
{
    NSEnumerator *allRequests = [[PHAPIRequest allRequests] objectEnumerator];
    PHAPIRequest *request = nil;

    NSMutableSet *canceledRequests = [NSMutableSet set];

    while ((request = [allRequests nextObject])) {
        if ([[request delegate] isEqual:delegate]) {
            [canceledRequests addObject:request];
        }
    }

    [canceledRequests makeObjectsPerformSelector:@selector(cancel)];
}

+ (int)cancelRequestWithHashCode:(int)hashCode
{
    PHAPIRequest *request = [self requestWithHashCode:hashCode];
    if (!!request) {
        [request cancel];

        return 1;
    }
    return 0;
}

+ (NSString *)base64SignatureWithString:(NSString *)string
{
    return [PHStringUtil b64DigestForString:string];
}

+ (NSString *)expectedSignatureValueForResponse:(NSString *)responseString nonce:(NSString *)nonce secret:(NSString *)secret
{
    if (!responseString || !secret)
        return nil;

    const char   *cKey = [secret cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];

    CCHmacContext context;
    CCHmacInit(&context, kCCHmacAlgSHA1, cKey, strlen(cKey));

    if (nonce) {
        const char *cNonce = [nonce cStringUsingEncoding:NSUTF8StringEncoding];
        CCHmacUpdate(&context, cNonce, strlen(cNonce));
    }

    const char *cResponse = [responseString cStringUsingEncoding:NSUTF8StringEncoding];
    CCHmacUpdate(&context, cResponse, strlen(cResponse));

    CCHmacFinal(&context, &cHMAC);

    NSData *HMAC = [[[NSData alloc] initWithBytes:cHMAC
                                           length:sizeof(cHMAC)] autorelease];

    NSString *localSignature = [PHStringUtil base64EncodedStringForData:HMAC];

    // Figure out if we need to pad to multiple of 4 length
    NSUInteger length = [localSignature length];
    NSUInteger modulo = [localSignature length] % 4;
    if (modulo != 0) {
        length = length + (4 - modulo);
    }

    return [localSignature stringByPaddingToLength:length withString:@"=" startingAtIndex:0];
}

+ (NSString *)session
{
    @synchronized (self) {
        if (sPlayHavenSession == nil) {
            UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:kSessionPasteboard create:NO];
            sPlayHavenSession = [[NSString alloc] initWithString:([pasteboard string] == nil ? @"" : [pasteboard string])];
        }
    }

    return (!!sPlayHavenSession) ? sPlayHavenSession : @"";
}

+ (void)setSession:(NSString *)session
{
    @synchronized (self) {
        if (![session isEqualToString:sPlayHavenSession]) {
            UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:kSessionPasteboard create:YES];
            [pasteboard setString:((session!= nil) ? session : @"")];
            [sPlayHavenSession release];
            sPlayHavenSession = (!!session) ? [[NSString alloc] initWithString:session] : nil;
        }
    }
}

+ (BOOL)optOutStatus
{
    BOOL theDefaultOptOutStatus = [[[NSBundle mainBundle] infoDictionary][kPHDefaultUserIsOptedOut]
                boolValue];
    NSNumber *theUserPreference = [[NSUserDefaults standardUserDefaults] objectForKey:
                @"PlayHavenOptOutStatus"];
    BOOL theOptOutStatus = theDefaultOptOutStatus;
    
    // User preference overrides the default status.
    if (nil != theUserPreference)
    {
        theOptOutStatus = [theUserPreference boolValue];
    }

    return theOptOutStatus;
}

+ (void)setOptOutStatus:(BOOL)yesOrNo
{
    [[NSUserDefaults standardUserDefaults] setBool:yesOrNo forKey:@"PlayHavenOptOutStatus"];
}

+ (NSString *)pluginIdentifier
{
    @synchronized (self) {
        if (sPlayHavenPluginIdentifier == nil ||
            [sPlayHavenPluginIdentifier isEqualToString:@""]) {
                [sPlayHavenPluginIdentifier autorelease];
                sPlayHavenPluginIdentifier = [[NSString alloc] initWithFormat:@"ios"];
        }
    }

    return sPlayHavenPluginIdentifier;
}

+ (void)setPluginIdentifier:(NSString *)identifier
{
    @synchronized (self) {
        [sPlayHavenPluginIdentifier autorelease];

        if (!identifier || [identifier isEqual:[NSNull null]] || [identifier isEqualToString:@""]) {
            PH_LOG(@"Setting the plugin identifier to nil or an empty string will result in using the default value: \"ios\"", nil);
            sPlayHavenPluginIdentifier = nil;
            return;
        }

        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^A-Za-z0-9\\-\\.\\_\\~]*"
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];

        NSString *string = [regex stringByReplacingMatchesInString:identifier
                                                           options:NSMatchingWithTransparentBounds
                                                             range:NSMakeRange(0, [identifier length])
                                                      withTemplate:@""];

        if ([string length] > 42)
            string = [string substringToIndex:42];

        if (error || !string) {
            PH_LOG(@"There was an error setting the plugin identifier. Using the default value: \"ios\"", nil);
            string = nil;
        }


        sPlayHavenPluginIdentifier = [string retain];
    }
}

+ (NSString *)customUDID
{
    return sPlayHavenCustomUDID;
}

+ (void)setCustomUDID:(NSString *)customUDID
{
    @synchronized (self) {
        [sPlayHavenCustomUDID autorelease];

        if (!customUDID || [customUDID isEqual:[NSNull null]] || [customUDID isEqualToString:@""]) {
            sPlayHavenCustomUDID = nil;
            return;
        }

        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^A-Za-z0-9\\-\\.\\_\\~]*"
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];

        NSString *string = [regex stringByReplacingMatchesInString:customUDID
                                                           options:NSMatchingWithTransparentBounds
                                                             range:NSMakeRange(0, [customUDID length])
                                                      withTemplate:@""];

        if (error || !string || ![string length]) {
            PH_LOG(@"There was an error setting the custom UDID. Value will not be sent to PlayHaven server.", nil);
            string = nil;
        }

        sPlayHavenCustomUDID = [string retain];
    }
}

- (void)setCustomUDID:(NSString *)customUDID
{
    [PHAPIRequest setCustomUDID:customUDID];
}

- (NSString *)customUDID
{
    return [PHAPIRequest customUDID];
}

+ (id)requestForApp:(NSString *)token secret:(NSString *)secret
{
    return [[[[self class] alloc] initWithApp:token secret:secret] autorelease];
}

+ (id)requestWithHashCode:(int)hashCode
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hashCode == %d", hashCode];
    NSSet       *resultSet = [[self allRequests] filteredSetUsingPredicate:predicate];

    return [resultSet anyObject];
}

- (id)initWithApp:(NSString *)token secret:(NSString *)secret
{
    if (nil == token || nil == secret)
    {
        PH_LOG(@"[%@ %@] ERROR: Nil input arguments. (token - %@; secret - %@)", NSStringFromClass(
                    [self class]), NSStringFromSelector(_cmd), token, secret, nil);
        [self release];
        return nil;
    }

    self = [self init];
    if (self) {
        _token  = [token copy];
        _secret = [secret copy];
    }

    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [[PHAPIRequest allRequests] addObject:self];
    }

    return  self;
}

- (NSDictionary *)basicParameters
{
    CGRect  screenBounds = [[UIScreen mainScreen] applicationFrame];
    BOOL    isLandscape  = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
    CGFloat screenWidth  = (isLandscape) ? CGRectGetHeight(screenBounds) : CGRectGetWidth(screenBounds);
    CGFloat screenHeight = (!isLandscape) ? CGRectGetHeight(screenBounds) : CGRectGetWidth(screenBounds);
    CGFloat screenScale  = [[UIScreen mainScreen] scale];

    NSString *preferredLanguage = ([[NSLocale preferredLanguages] count] > 0) ?
                                        [[NSLocale preferredLanguages] objectAtIndex:0] : nil;

    NSDictionary *theIdentifiers = [[self class] identifiers];
    NSMutableDictionary *combinedParams = [[[NSMutableDictionary alloc] initWithDictionary:
                theIdentifiers] autorelease];

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
#if PH_USE_AD_SUPPORT == 1
    if ([ASIdentifierManager class])
    {
        NSNumber *trackingEnabled = [NSNumber numberWithBool:[[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]];
        [combinedParams setValue:trackingEnabled forKey:@"tracking"];
    }
#endif
#endif
#endif

    if (self.customUDID)
    {
        [combinedParams setValue:self.customUDID forKey:@"d_custom"];
    }

    // Adds plugin identifier
    [combinedParams setValue:[PHAPIRequest pluginIdentifier] forKey:@"plugin"];

    // This allows for unit testing of request values!
    NSBundle *mainBundle = [NSBundle bundleForClass:[self class]];

    NSString
        *nonce         = [PHStringUtil uuid],
        *appId         = [[mainBundle infoDictionary] objectForKey:@"CFBundleIdentifier"],
        *appVersion    = [[mainBundle infoDictionary] objectForKey:@"CFBundleVersion"],
        *hardware      = [[UIDevice currentDevice] hardware],
        *os            = [NSString stringWithFormat:@"%@ %@",
                                [[UIDevice currentDevice] systemName],
                                [[UIDevice currentDevice] systemVersion]],
        *languages     = preferredLanguage;

    if (!appVersion) appVersion = @"NA";
    
    NSString *signature = [[self class] v4SignatureWithIdentifiers:theIdentifiers token:
                self.token nonce:nonce signatureKey:self.secret];
    signature = nil != signature ? signature : @"";

    NSNumber
        *idiom      = [NSNumber numberWithInt:(int)UI_USER_INTERFACE_IDIOM()],
        *width      = [NSNumber numberWithFloat:screenWidth],
        *height     = [NSNumber numberWithFloat:screenHeight],
        *scale      = [NSNumber numberWithFloat:screenScale];
    NSNumber *theOptOutStatus = @([PHAPIRequest optOutStatus]);

    [combinedParams addEntriesFromDictionary:self.additionalParameters];

    NSDictionary *signatureParams =
         [NSDictionary dictionaryWithObjectsAndKeys:
                             self.token,     @"token",
                             signature,      @"sig4",
                             nonce,          @"nonce",
                             appId,          @"app",
                             hardware,       @"hardware",
                             os,             @"os",
                             idiom,          @"idiom",
                             appVersion,     @"app_version",
                             PH_SDK_VERSION, @"sdk-ios",
                             languages,      @"languages",
                             width,          @"width",
                             height,         @"height",
                             scale,          @"scale",
                             theOptOutStatus, kPHRequestParameterOptOutStatusKey,
                             nil];

    [combinedParams addEntriesFromDictionary:signatureParams];
    
    return combinedParams;
}

- (NSString *)signedParameterString
{
    return [[self signedParameters] stringFromQueryComponents];
}

- (void)dealloc
{
    [_token release], _token = nil;
    [_secret release], _secret = nil;
    [_URL release], _URL = nil;
    [_signedParameters release], _signedParameters = nil;
    [_urlPath release], _urlPath = nil;
    [_additionalParameters release], _additionalParameters = nil;

    [super dealloc];
}

#pragma mark -
#pragma mark PHPublisherOpenRequest

- (void)send
{
    if (kPHRequestStatusInProgress == self.requestStatus || kPHRequestStatusSucceeded ==
                self.requestStatus)
    {
        PH_DEBUG(@"Trying to re-send request with status = %lu", (unsigned long)self.requestStatus);
        return;
    }

    self.requestStatus = kPHRequestStatusInProgress;
    
    [self constructRequestURLWithCompletionHandler:
    ^(NSURL *inURL)
    {
        self.URL = inURL;
        PH_LOG(@"Sending request: %@", [self.URL absoluteString]);

        NSURLRequest *request = nil;
        
        if (PHRequestHTTPPost == self.HTTPMethod)
        {
            NSURL *theEndPointURL = [[self class] URLByStrippingQuery:self.URL];
            NSMutableURLRequest *theMutableRequest = [NSMutableURLRequest requestWithURL:
                        theEndPointURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                        timeoutInterval:PH_REQUEST_TIMEOUT];
            NSData *theRequestData = [[self.URL query] dataUsingEncoding:NSUTF8StringEncoding
                        allowLossyConversion:NO];

            [theMutableRequest setHTTPMethod:kPHHTTPMethodPost];
            [theMutableRequest setHTTPBody:theRequestData];
            [theMutableRequest setValue:kPHHTTPContentTypeURLEncoded forHTTPHeaderField:
                        kPHHTTPHeaderContentType];
            request = theMutableRequest;
        }
        else
        {
            request = [NSURLRequest requestWithURL:self.URL cachePolicy:
                        NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:PH_REQUEST_TIMEOUT];
        }

        if (![PHConnectionManager createConnectionFromRequest:request forDelegate:self
                    withContext:nil])
        {
            [self didFailWithError:nil]; // TODO: Create error
        }
    }];
}

- (void)cancel
{
    PH_LOG(@"%@ canceled!", NSStringFromClass([self class]));

    // TODO: Confirm that by moving this from 'finish' to 'cancel' doesn't break anything
    [PHConnectionManager stopConnectionsForDelegate:self];
    [self finish];
}

/*
 * Internal cleanup method
 */
- (void)finish
{
    // REQUEST_RELEASE see REQUEST_RETAIN
    [[PHAPIRequest allRequests] removeObject:self];
}

#pragma mark -
#pragma mark NSURLConnectionDelegate PHConnectionManagerDelegate
- (void)connectionDidFinishLoadingWithRequest:(NSURLRequest *)request response:(NSURLResponse *)response data:(NSData *)data context:(id)context
{
    PH_NOTE(@"Request finished!");

    if ([self.delegate respondsToSelector:@selector(requestDidFinishLoading:)]) {
        [self.delegate performSelector:@selector(requestDidFinishLoading:) withObject:self withObject:nil];
    }

    NSString *responseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    PH_SBJSONPARSER_CLASS *parser = [[[PH_SBJSONPARSER_CLASS alloc] init] autorelease];
    NSDictionary *resultDictionary = [parser objectWithString:responseString];
    
    if (![resultDictionary isKindOfClass:[NSDictionary class]])
    {
        PH_LOG(@"[ERROR] %s %@", __PRETTY_FUNCTION__, kPHUnexpectedServerResponse);
        [self didFailWithError:PHCreateErrorWithTypeAndDescription(PHAPIResponseErrorType,
                    kPHUnexpectedServerResponse)];
        return;
    }

    // client-api responses with an error do not contain digest, therefore we should check for an
    // error first and then check the request signature.
    id errorValue = [resultDictionary valueForKey:@"error"];
    if (errorValue && ![errorValue isEqual:[NSNull null]])
    {
        PH_LOG(@"Server response: %@", resultDictionary);
        [self didFailWithError:PHCreateErrorWithTypeAndDescription(PHAPIResponseErrorType,
                    [NSString stringWithFormat:@"Server responded with the error: error - %@; "
                    "response - %@;", errorValue, resultDictionary[@"response"]])];
        return;
    }

    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSString *requestSignature  = [self requestSignatureFromHttpHeaderFields:[httpResponse allHeaderFields]];
        NSString *nonce             = [self.signedParameters valueForKey:@"nonce"];
        NSString *expectedSignature = [PHAPIRequest expectedSignatureValueForResponse:responseString
                                                                                nonce:nonce
                                                                               secret:self.secret];

        if (![expectedSignature isEqualToString:requestSignature]) {
            [self didFailWithError:PHCreateError(PHRequestDigestErrorType)];

            return;
        }
    }

    [self processRequestResponse:resultDictionary];
}

- (void)afterConnectionDidFinishLoading
{

}

- (void)connectionDidFailWithError:(NSError *)error request:(NSURLRequest *)request context:(id)context
{
    PH_LOG(@"Request failed with error: %@", [error localizedDescription]);
    [self didFailWithError:error];

    // REQUEST_RELEASE see REQUEST_RETAIN
    //[self finish]; // TODO: Why is this here if it's also in didFailWithError which is called immediately above??
    // TODO: Investigate this further. Having it here causes crash, and removing it makes things work more as expected. Why else would it be needed?
}

#pragma mark -
- (void)processRequestResponse:(NSDictionary *)responseData
{
    id responseValue = [responseData valueForKey:@"response"];
    if ([responseValue isEqual:[NSNull null]]) {
        responseValue = nil;
    }

    self.requestStatus = kPHRequestStatusSucceeded;
    [self didSucceedWithResponse:responseValue];
}

- (void)didSucceedWithResponse:(NSDictionary *)responseData
{
    if ([self.delegate respondsToSelector:@selector(request:didSucceedWithResponse:)]) {
        [self.delegate performSelector:@selector(request:didSucceedWithResponse:) withObject:self withObject:responseData];
    }

    [self finish];
}

- (void)didFailWithError:(NSError *)error
{
    self.requestStatus = kPHRequestStatusFailed;
    
    if ([self.delegate respondsToSelector:@selector(request:didFailWithError:)]) {
        [self.delegate performSelector:@selector(request:didFailWithError:) withObject:self withObject:error];
    }

    [self finish];
}

#pragma mark -

- (PHRequestHTTPMethod)HTTPMethod
{
    return PHRequestHTTPGet;
}

+ (NSURL *)URLByStrippingQuery:(NSURL *)anURL
{
    NSString *theQuery = [anURL query];

    if (0 == [theQuery length])
    {
        return anURL;
    }

    NSRange theQueryRange = [[anURL absoluteString] rangeOfString:[NSString stringWithFormat:@"?%@",
                theQuery]];
    NSURL *theStrippedURL = nil;

    if (0 < theQueryRange.length)
    {
        NSString *theStrippedString = [[anURL absoluteString] substringToIndex:
                    theQueryRange.location];
        theStrippedURL = [NSURL URLWithString:theStrippedString];
    }

    return theStrippedURL;
}

#pragma mark -

// The functions returns request signature looking for X-PH-DIGEST header field using
// caseinsennsetive comparsion. It fixes an issue with signature validation failing as some
// iOS versions return expected header but with changed letters so that just first letter are in
// upper-case. F.e. 4.3.2 returns X-Ph-Digest.
- (NSString *)requestSignatureFromHttpHeaderFields:(NSDictionary *)aHeaderFields
{
    NSString *theSignature = nil;
    
    for (NSString *theFiledName in [aHeaderFields allKeys])
    {
        if (NSOrderedSame == [theFiledName caseInsensitiveCompare:@"X-PH-DIGEST"])
        {
            theSignature = [aHeaderFields objectForKey:theFiledName];
            break;
        }
    }
    
    return theSignature;
}

+ (NSDictionary *)identifiers
{
    NSMutableDictionary *theIdentifiers = [NSMutableDictionary dictionary];
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)])
    {
        NSString *theDeviceIDFV = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        if (nil != theDeviceIDFV)
        {
            theIdentifiers[kPHRequestParameterIDFVKey] = theDeviceIDFV;
        }
    }

#if PH_USE_MAC_ADDRESS == 1
    if (![PHAPIRequest optOutStatus] && PH_SYSTEM_VERSION_LESS_THAN(@"6.0"))
    {
        PHNetworkUtil *netUtil = [PHNetworkUtil sharedInstance];
        CFDataRef macBytes = [netUtil newMACBytes];
        if (macBytes)
        {
            [theIdentifiers setValue:[netUtil stringForMACBytes:macBytes] forKey:@"mac"];
            CFRelease(macBytes);
        }
    }
#endif

    NSString *theSession = [PHAPIRequest session];
    if (0 < [theSession length])
    {
        theIdentifiers[@"session"] = theSession;
    }
    
    // Sender ID, if any, must be sent on each request and included in the request signature.
    NSString *theKTSenderIDKey = [[PHKontagentDataAccessor sharedAccessor] primarySenderID];
    
    if (nil != theKTSenderIDKey)
    {
        theIdentifiers[kPHKontagentSenderIDKey] = theKTSenderIDKey;
    }

    return theIdentifiers;
}

+ (NSString *)v4SignatureWithIdentifiers:(NSDictionary *)anIdentifiers token:(NSString *)aToken
            nonce:(NSString *)aNonce signatureKey:(NSString *)aKey
{
    if (0 == [aToken length] || 0 == [aNonce length] || 0 == [aKey length])
    {
        PH_DEBUG(@"Incorrect input parmameters: token - %@, nonce - %@, key - %@\n", aToken, aNonce,
                    aKey);
        return nil;
    }
    
    NSArray *theSortedKeys = [[anIdentifiers allKeys] sortedArrayUsingSelector:@selector(
                caseInsensitiveCompare:)];
    // Sort the identifiers by key (identifier name).
    NSArray *theSortedValues = [anIdentifiers objectsForKeys:theSortedKeys notFoundMarker:[NSNull
                null]];

    // Join identifiers with a colon.
    NSString *theJoinedIdentifiers = [theSortedValues componentsJoinedByString:@":"];

    // Construct message with the format string.
    NSString *theMessage = [NSString stringWithFormat:@"%@:%@:%@", nil != theJoinedIdentifiers ?
                theJoinedIdentifiers : @"", aToken, aNonce];

    return [self v4SignatureWithMessage:theMessage signatureKey:aKey];
}

+ (NSString *)v4SignatureWithMessage:(NSString *)aMessage signatureKey:(NSString *)aKey
{
    if (0 == [aMessage length] || 0 == [aKey length])
    {
        PH_DEBUG(@"Incorrect input parmameters: message - %@, key - %@\n", aMessage, aKey);
        return nil;
    }

    const char *theMessageCString = [aMessage cStringUsingEncoding:NSUTF8StringEncoding];
    const char *theKeyCString = [aKey cStringUsingEncoding:NSUTF8StringEncoding];

    unsigned char theHMACDigest[CC_SHA1_DIGEST_LENGTH];
    NSString *theBase64EncodedDigest = nil;

    if (NULL != theKeyCString && NULL != theMessageCString)
    {
        CCHmac(kCCHmacAlgSHA1, theKeyCString, strlen(theKeyCString), theMessageCString,
                    strlen(theMessageCString), &theHMACDigest);

        NSData *theHMACData = [[[NSData alloc] initWithBytes:theHMACDigest length:sizeof(
                    theHMACDigest)] autorelease];
        theBase64EncodedDigest = [PHStringUtil base64EncodedStringForData:theHMACData];
    }
    
    return theBase64EncodedDigest;
}

#pragma mark -

- (void)obtainRequestParametersWithCompletionHandler:(void (^)(NSDictionary *))aCompletionHandler
{
    [self obtainNetworkStatusWithCompletionHandler:
    ^(int inNetworkStatus)
    {
        NSMutableDictionary *theRequestParameters = [NSMutableDictionary dictionaryWithDictionary:
                    self.basicParameters];
        theRequestParameters[kPHRequestParameterConnectionKey] = @(inNetworkStatus);
        
        if (nil != aCompletionHandler)
        {
            aCompletionHandler(theRequestParameters);
        }
    }];
}

- (void)obtainNetworkStatusWithCompletionHandler:(void (^)(int inNetworkStatus))aCompletionHandler
{
    // Network status is obtained on a background thread due to blocking nature of the underlying
    // PHNetworkStatus() function.

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
    ^{
        int theNetworkStatus = PHNetworkStatus();
        
        if (nil != aCompletionHandler)
        {
            dispatch_async(dispatch_get_main_queue(),
            ^{
                aCompletionHandler(theNetworkStatus);
            });
        }
    });
}

- (void)constructRequestURLWithCompletionHandler:(void (^)(NSURL *inURL))aCompletionHandler
{
    [self obtainRequestParametersWithCompletionHandler:
    ^(NSDictionary *inRequestParameters)
    {
        self.signedParameters = inRequestParameters;
        NSString *theURLString = [NSString stringWithFormat:@"%@?%@", [self urlPath], [self
                    signedParameterString]];
        
        if (nil != aCompletionHandler)
        {
            aCompletionHandler([NSURL URLWithString:theURLString]);
        }
    }];
}

@end
