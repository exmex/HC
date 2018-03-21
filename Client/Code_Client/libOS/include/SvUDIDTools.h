
#import <Foundation/Foundation.h>

@interface SvUDIDTools : NSObject


/*
 * @brief obtain Unique Device Identity
 */
+ (NSString*)UDID;
+ (NSString*)IDFAWithKeychain;
+ (NSString*)getDeviceIdIDFAOrMAC;
+ (NSString*)getMacAddressOnly;

@end
