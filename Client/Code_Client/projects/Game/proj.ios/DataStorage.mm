//
//  DataStorage.m
//  hero
//
//  Created by Lyon on 18/6/14.
//
//
#import <sys/utsname.h>
#import "DataStorage.h"
#import "cocos2d.h"
#import "SSKeychain.h"

@implementation DataStorage

#define OC_DEVICE_ID_KEY "OC_DEVICE_ID_KEY"
#define OC_UU_ID_KEY "OC_UU_ID_KEY"
#define OC_SERVER_ID_KEY "OC_SERVER_ID_KEY"
#define OC_PAYMENT_RETRY_TIMES_KEY "OC_PAYMENT_RETRY_TIMES_KEY"
#define OC_GAME_CENTER_NICK_NAME_KEY "OC_GAME_CENTER_NICK_NAME_KEY"
#define OC_PAYMENT_UNFINISH_KEY "OC_PAYMENT_UNFINISH_KEY"

NSString * const KEY_APP_UUID = @"com.ucool.hero.uuid";
NSString * const KEY_DEVICE = @"com.ucool.hero.deviceid";
static NSMutableDictionary* UnfinishedPaymentList = nil;

//+(NSString*)getUUID{
//    NSString *uuid ;
//    //std::string uuIdstd =  cocos2d::CCUserDefault::sharedUserDefault()->getStringForKey(OC_UU_ID_KEY);
//    
//    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[HGKeychain load:KEY_PASSWORD];
//    uuid = [usernamepasswordKVPairs objectForKey:KEY_PASSWORD];
//    
//    if (uuid == nil || uuid.length == 0) {
//        UIDevice* device = [UIDevice currentDevice];
//        uuid = [[device identifierForVendor]UUIDString];
//        
////        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
////        uuid = (NSString *)CFUUIDCreateString (kCFAllocatorDefault,uuidRef);
//        
//        
//        NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
//        [usernamepasswordKVPairs setObject:uuid forKey:KEY_PASSWORD];
//        [HGKeychain save:KEY_PASSWORD data:usernamepasswordKVPairs];
//    }
//    return uuid;
//}
+(NSString *)getUUICompatible
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        // This will run if it is iOS6 or higher
        return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    } else {
        // This will run before iOS6 and you can use openUDID or other
        // method to generate an identifier
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        CFStringRef string = CFUUIDCreateString(NULL, theUUID);
        CFRelease(theUUID);
        return [(NSString *)string autorelease];
    }
}

+(NSString *)getUUID
{
    
//    NSString *appName=[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
   	
    
  
    NSString *strApplicationUUID = [SSKeychain passwordForService:KEY_APP_UUID account:@"incoding"];
    if (strApplicationUUID == nil)
    {
        strApplicationUUID  = [self getUUICompatible];
        [SSKeychain setPassword:strApplicationUUID forService:KEY_APP_UUID account:@"incoding"];
    }
    
    return strApplicationUUID;
   
    
   
}



+(NSString *)getDeviceId{
    
    NSString *deviceId = [SSKeychain passwordForService:KEY_DEVICE account:@"incoding"];
    if (deviceId == nil)
    {//如果keychain中取不到则到userdefault中取一遍
        deviceId = [DataStorage getUserDefaultDeviceId];
    }
    
    return deviceId;
}
+(void)setDeviceId:(NSString*)deviceId{
    NSString* oldDeviceId = [DataStorage getDeviceId];
    //针对丢号的情况多储存到userDefault中
    [DataStorage setUserDefaultDeviceId:deviceId];
    if ([oldDeviceId isEqualToString:deviceId]) {
        return;
    }
    [SSKeychain setPassword:deviceId forService:KEY_DEVICE account:@"incoding"];
}


+(NSString*)getUserDefaultDeviceId{
    NSString *deviceId ;
    std::string deviceIdstd =  cocos2d::CCUserDefault::sharedUserDefault()->getStringForKey(OC_DEVICE_ID_KEY);
    if (deviceIdstd.length() > 0) {
        deviceId= [NSString stringWithCString:deviceIdstd.c_str() encoding:[NSString defaultCStringEncoding]];
    }else{
        deviceId = @"0";
    }
    return deviceId;
}

+(void)setUserDefaultDeviceId:(NSString*)deviceId{
    std::string deviceIdStd = [deviceId UTF8String];
    
    cocos2d::CCUserDefault::sharedUserDefault()->setStringForKey(OC_DEVICE_ID_KEY, deviceIdStd);
    cocos2d::CCUserDefault::sharedUserDefault()->flush();
}





+(NSInteger)getRetryFinishPaymentTimes{
    NSInteger times ;
    times =  cocos2d::CCUserDefault::sharedUserDefault()->getIntegerForKey(OC_PAYMENT_RETRY_TIMES_KEY);
    return times;
}

+(void)setRetryFinishPaymentTimes:(NSInteger)times{
    cocos2d::CCUserDefault::sharedUserDefault()->setIntegerForKey(OC_PAYMENT_RETRY_TIMES_KEY, times);
    cocos2d::CCUserDefault::sharedUserDefault()->flush();
}

+(void)setServerId:(NSString*)serverId{
    std::string serverIdStd = [serverId UTF8String];
    cocos2d::CCUserDefault::sharedUserDefault()->setStringForKey(OC_SERVER_ID_KEY, serverIdStd);
    cocos2d::CCUserDefault::sharedUserDefault()->flush();
}

+(NSString*)getTimeZone{
    NSTimeZone* nowtimezone2 = [NSTimeZone systemTimeZone];
    NSString* timezone  =[nowtimezone2 name];
    return timezone;
}
+(NSString*)getLocalTime{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    NSLog(@"Local Time: %@",locationString);
    return locationString;
}
+(void)setGameCenterNickName:(NSString*)nickName{
    if(nickName == nil){
        return;
    }
    std::string nick = [nickName UTF8String];
    cocos2d::CCUserDefault::sharedUserDefault()->setStringForKey(OC_GAME_CENTER_NICK_NAME_KEY, nick);
    cocos2d::CCUserDefault::sharedUserDefault()->flush();
}

//    uin
//    serverId
//    orderId
//    receipt
//    isSandBox
//存储订单信息
+(void)savePaymentOrdersInfo:(NSString*)uin
                    ServerID:(NSString*)serverId
                     OrderID:(NSString*)orderId{
    
    [DataStorage clearPaymentOrdersInfo];
    std::string uinStd = [uin UTF8String];
    std::string serverIdStd = [serverId UTF8String];
    std::string orderIdStd = [orderId UTF8String];
    
    cocos2d::CCUserDefault::sharedUserDefault()->setStringForKey("PAYMENT_UIN_ID", uinStd);
    cocos2d::CCUserDefault::sharedUserDefault()->setStringForKey("PAYMENT_SERVER_ID", serverIdStd);
    cocos2d::CCUserDefault::sharedUserDefault()->setStringForKey("PAYMENT_ORDERID", orderIdStd);
    cocos2d::CCUserDefault::sharedUserDefault()->flush();
    
}

//获取订单信息
+(NSMutableDictionary*)getPaymentOrdersInfo{
    
    std::string uinStd = "";
    std::string serverIdStd = "";
    std::string orderIdStd = "";
    
    uinStd = cocos2d::CCUserDefault::sharedUserDefault()->getStringForKey("PAYMENT_UIN_ID");
    serverIdStd = cocos2d::CCUserDefault::sharedUserDefault()->getStringForKey("PAYMENT_SERVER_ID");
    orderIdStd = cocos2d::CCUserDefault::sharedUserDefault()->getStringForKey("PAYMENT_ORDERID");
    
    if (uinStd.length() == 0 || serverIdStd.length() == 0
        || orderIdStd.length() == 0 ) {
        return nil;
    }
    
    NSString* uin= [NSString stringWithCString:uinStd.c_str() encoding:[NSString defaultCStringEncoding]];
    NSString* serverId= [NSString stringWithCString:serverIdStd.c_str() encoding:[NSString defaultCStringEncoding]];
    NSString* orderId= [NSString stringWithCString:orderIdStd.c_str() encoding:[NSString defaultCStringEncoding]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setValue:uin forKey:@"uin"];
    [dictionary setValue:serverId forKey:@"serverId"];
    [dictionary setValue:orderId forKey:@"orderId"];
    
    
    return dictionary;
}

//清除订单信息
+(void)clearPaymentOrdersInfo{
    cocos2d::CCUserDefault::sharedUserDefault()->setStringForKey("PAYMENT_UIN_ID", "");
    cocos2d::CCUserDefault::sharedUserDefault()->setStringForKey("PAYMENT_SERVER_ID", "");
    cocos2d::CCUserDefault::sharedUserDefault()->setStringForKey("PAYMENT_ORDERID", "");
    cocos2d::CCUserDefault::sharedUserDefault()->flush();
}

+(NSString*)getDeviceAndOSInfo
{
    //here use sys/utsname.h
    struct utsname systemInfo;
    uname(&systemInfo);
    //get the device model and the system version
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", [[UIDevice currentDevice] systemVersion]);
}

+(NSMutableDictionary*)getFinishPaymentOrders:(NSString*)orderId{
    [DataStorage checkFinishPaymentOrdersInfo];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

    NSString *data = [UnfinishedPaymentList objectForKey:orderId];
    if (data != nil) {
        NSArray* array = [data componentsSeparatedByString:@":"];
        if ([array count] == 4) {
            [dictionary setValue:[array objectAtIndex:0] forKey:@"uin"];
            [dictionary setValue:[array objectAtIndex:1] forKey:@"serverId"];
            [dictionary setValue:[array objectAtIndex:2] forKey:@"orderId"];
            [dictionary setValue:[array objectAtIndex:3] forKey:@"receipt"];
        }
        return dictionary;
    }
    return nil;
}

+(NSMutableDictionary*)getFirstFinishPaymentOrders{
    [DataStorage checkFinishPaymentOrdersInfo];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

    for(NSString *tkey in UnfinishedPaymentList) {

        NSString* paymentinfo = [UnfinishedPaymentList objectForKey:tkey];
        if (paymentinfo != nil) {
            NSArray* array = [paymentinfo componentsSeparatedByString:@":"];
            if ([array count] == 4) {
                NSString* uin = [array objectAtIndex:0];
                NSString* serverId = [array objectAtIndex:1];
                NSString* orderId = [array objectAtIndex:2];
                NSString* receipt = [array objectAtIndex:3];
                if ([uin length]> 0 && [serverId length]> 0 && [orderId length]> 0) {
                    [dictionary setValue:uin forKey:@"uin"];
                    [dictionary setValue:serverId forKey:@"serverId"];
                    [dictionary setValue:orderId forKey:@"orderId"];
                    [dictionary setValue:receipt forKey:@"receipt"];
                    return dictionary;
                }else{
                    [UnfinishedPaymentList removeObjectForKey:tkey];
                }

            }
        }

    }
    return nil;
}

//    uin
//    serverId
//    orderId
//    receipt
//    isSandBox
//存储订单信息
+(NSString*)addFinishPaymentOrders:(NSString*)uin
                    ServerID:(NSString*)serverId
                       OrderID:(NSString*)orderId
                       Receipt:(NSString*)receipt{
    if([uin length] == 0 || [serverId length]==0 || [orderId length]== 0 ||[receipt length] ==0){
        return @"";
    }
    [DataStorage checkFinishPaymentOrdersInfo];
    NSString* paymentInfo = @"";
    paymentInfo = [uin stringByAppendingString:@":"];
    paymentInfo = [paymentInfo stringByAppendingString:serverId];
    paymentInfo = [paymentInfo stringByAppendingString:@":"];
    paymentInfo = [paymentInfo stringByAppendingString:orderId];
    paymentInfo = [paymentInfo stringByAppendingString:@":"];
    paymentInfo = [paymentInfo stringByAppendingString:receipt];
    [UnfinishedPaymentList setValue:paymentInfo forKey:orderId];
    [DataStorage wirtePaymentInfoToFile];
    return orderId;
}
+(void)removeFinishPaymentOrders:(NSString*)orderId{
    [DataStorage checkFinishPaymentOrdersInfo];
    if ([UnfinishedPaymentList objectForKey:orderId]) {
        [UnfinishedPaymentList removeObjectForKey:orderId];
    }
    
    [DataStorage wirtePaymentInfoToFile];

}

+(void)checkFinishPaymentOrdersInfo{
    if (UnfinishedPaymentList == nil) {
        [DataStorage readFinishPaymentInfoFromFile];
    }
}

+(void)readFinishPaymentInfoFromFile{
    UnfinishedPaymentList= [[NSMutableDictionary alloc] initWithCapacity:0];
    //orderId=uin:serverid:receipt||orderId=uin:serverid:receipt
    std::string infostd = cocos2d::CCUserDefault::sharedUserDefault()->getStringForKey("OC_PAYMENT_UNFINISH_KEY");
    
    if (infostd.length() == 0) {
        return ;
    }
    
    NSString* nsinfo= [NSString stringWithCString:infostd.c_str() encoding:[NSString defaultCStringEncoding]];
    
    if(nsinfo != nil){
        NSString* nspreinfo= nil;
        NSArray* preArray = nil;
        NSArray* array = [nsinfo componentsSeparatedByString:@"||"];
        NSString* key = nil;
        NSString* receipt = nil;

        for(NSUInteger j=0;j<[array count];j++)
        {
            nspreinfo = [array objectAtIndex:j];
            if (nspreinfo != nil && [nspreinfo length] >0) {
                preArray = [nspreinfo componentsSeparatedByString:@"="];
                if (preArray != nil && [preArray count] >= 2) {
                    key = [preArray objectAtIndex:0];
                    receipt = [preArray objectAtIndex:1];
                    if ([key length] > 0 && [receipt length] >0 && [UnfinishedPaymentList count] <10) {
                        NSLog(@"receipt: %@", receipt);
                        [UnfinishedPaymentList setValue:receipt forKey:key];
                    }
//                    [receipt release];
//                    [key release];
                }
//                [preArray release];
            }
//            [nspreinfo release];
        }
//        [array release];
    }
}

+(void)wirtePaymentInfoToFile{
    std::string stdKey;
    std::string stdData;
    std::string stdSaveData ="";
    for(NSString *tkey in UnfinishedPaymentList) {
        if(stdSaveData.length() >0){
            stdSaveData+="||";
        }
        NSString *data = [UnfinishedPaymentList objectForKey:tkey];
        std::string stdKey = [tkey UTF8String];
        std::string stdData = [data UTF8String];
        stdSaveData+=stdKey;
        stdSaveData+="=";
        stdSaveData+=stdData;
    }
    cocos2d::CCUserDefault::sharedUserDefault()->setStringForKey("OC_PAYMENT_UNFINISH_KEY",stdSaveData);
    cocos2d::CCUserDefault::sharedUserDefault()->flush();
}

+(void)wirteShopPriceInfo:(NSMutableDictionary*)itemsInfo{
    std::string stdKey;
    std::string stdData;
    for(NSString *tkey in itemsInfo) {
        NSString *data = [itemsInfo objectForKey:tkey];
        std::string stdKey = [tkey UTF8String];
        stdKey = "OC_SHOP_PRICE_"+stdKey;
        std::string stdData = [data UTF8String];
        cocos2d::CCUserDefault::sharedUserDefault()->setStringForKey(stdKey.c_str(),stdData);
    }

    cocos2d::CCUserDefault::sharedUserDefault()->flush();
}


+(NSString*)getCurrentLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    return currentLanguage;
}

+(NSString*)getDeviceInfo
{
    NSMutableString *osInfo = [[[NSMutableString alloc]init]autorelease];
    NSString* language = [self getCurrentLanguage];
    [osInfo appendString:@"&Language="];
    [osInfo appendString:language];
    NSString* strModel  = [DataStorage getDeviceAndOSInfo];
    [osInfo appendString:@"&Model="];
    [osInfo appendString:strModel];
    NSString* strSysVersion = [[UIDevice currentDevice] systemVersion];
    [osInfo appendString:@"&OSVer="];
    [osInfo appendString:strSysVersion];
    return osInfo;
}

@end
