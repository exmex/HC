/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright 2014 Medium Entertainment, Inc.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

 PHKontagentDataAccessor.m
 playhaven-sdk-ios

 Created by Anton Fedorchenko on 1/31/14.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "PHKontagentDataAccessor.h"

NSString *const kPHKontagentAPIKey = @"PHKontagentAPIKey";
NSString *const kPHKontagentSenderIDKeyPrefix = @"com.kontagent.lib.SENDER_ID.";

static NSString *const kPHPersistentValuesFileName = @"PersistentValues";
static NSString *const kPHPersistentValuesWithTypoFileName = @"PersistentValuest";

static PHKontagentDataAccessor *sSharedDataAccessor = nil;

@implementation PHKontagentDataAccessor

+ (instancetype)sharedAccessor
{
    @synchronized (self)
    {
        if (nil == sSharedDataAccessor)
        {
            sSharedDataAccessor = [PHKontagentDataAccessor new];
        }
    }
    
    return sSharedDataAccessor;
}

- (NSString *)primarySenderID
{
    NSString *theKTAPIKey = [[NSUserDefaults standardUserDefaults] stringForKey:kPHKontagentAPIKey];

    return nil == theKTAPIKey ? nil : [self senderIDForAPIKey:theKTAPIKey];
}

- (NSDictionary *)allAPIKeySenderIDPairs
{
    NSDictionary *thePreferences = [self persistentValues];
    
    if (nil == thePreferences)
    {
        // Checkout if there is no PersistentValues file
        thePreferences = [NSMutableDictionary dictionaryWithDictionary:
                    [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
    }

    NSMutableDictionary *theAPIKeySIDPairs = [NSMutableDictionary dictionary];
    
    for (NSString *theDefault in [thePreferences allKeys])
    {
        if ([theDefault isKindOfClass:[NSString class]] && [theDefault hasPrefix:
                    kPHKontagentSenderIDKeyPrefix])
        {
            NSRange thePrefixRange = [theDefault rangeOfString:kPHKontagentSenderIDKeyPrefix];
            NSString *theAPIKey = [theDefault substringFromIndex:thePrefixRange.location +
                        thePrefixRange.length];
            
            theAPIKeySIDPairs[theAPIKey] = thePreferences[theDefault];
        }
    }
    
    return theAPIKeySIDPairs;
}

- (void)storePrimarySenderID:(NSString *)aSenderID forAPIKey:(NSString *)anAPIKey
{
    if (nil == aSenderID || nil == anAPIKey)
    {
        return;
    }

    [[NSUserDefaults standardUserDefaults] setObject:anAPIKey forKey:kPHKontagentAPIKey];

    // Do not override sender ID for the given API key.
    NSString *theStoredSenderID = [self senderIDForAPIKey:anAPIKey];
    if (nil == theStoredSenderID)
    {
        NSString *theSenderIDStoreKey = [[self class] senderIDStoreKeyWithAPIKey:anAPIKey];
        [[NSUserDefaults standardUserDefaults] setObject:aSenderID forKey:theSenderIDStoreKey];
    }
}

#pragma mark -

+ (NSURL *)persistentValuesFileURL
{
    return [[[[NSFileManager defaultManager] URLsForDirectory:
                NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject]
                URLByAppendingPathComponent:kPHPersistentValuesFileName];
}

+ (NSURL *)persistentValuesWithTypoFileURL
{
    // NB: KT SDK 1.5.7 stored preferences in the file with a typo (PersistentValuest with
    // extra 't' at the end), so that file should be checked if PersistentValues doesn't exist.

    return [[[[NSFileManager defaultManager] URLsForDirectory:
                NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject]
                URLByAppendingPathComponent:kPHPersistentValuesWithTypoFileName];
}

- (NSDictionary *)persistentValues
{
    NSDictionary *thePersistentValues = [NSDictionary dictionaryWithContentsOfURL:[[self class]
                persistentValuesFileURL]];

    if (nil == thePersistentValues)
    {
        thePersistentValues = [NSDictionary dictionaryWithContentsOfURL:[[self class]
                    persistentValuesWithTypoFileURL]];
    }
    
    return thePersistentValues;
}

+ (NSString *)senderIDStoreKeyWithAPIKey:(NSString *)anAPIKey
{
    return [NSString stringWithFormat:@"%@%@", kPHKontagentSenderIDKeyPrefix, anAPIKey];
}

- (NSString *)senderIDForAPIKey:(NSString *)anAPIKey
{
    NSDictionary *thePersistentValues = [self persistentValues];
    NSString *theSenderIDStoreKey = [[self class] senderIDStoreKeyWithAPIKey:anAPIKey];
    NSString *theSenderID = thePersistentValues[theSenderIDStoreKey];
    
    if (nil == theSenderID)
    {
        // Look up in the NSUserDefauls as a fallback
        theSenderID = [[NSUserDefaults standardUserDefaults] stringForKey:theSenderIDStoreKey];
    }
    
    return theSenderID;
}

@end
