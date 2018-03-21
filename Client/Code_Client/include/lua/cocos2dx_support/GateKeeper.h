//
//  GateKeeper.h
//  hero
//
//  Created by dany on 14-6-13.
//
//

#ifndef __hero__GateKeeper__
#define __hero__GateKeeper__

#include "ccConfig.h"
//#include "platform/CCPlatformConfig.h"

//#include "platform/android/CCPlatformDefine.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#define URL_PLATFORM_PARAM "&device_type=android"
#else
#define URL_PLATFORM_PARAM "&device_type=ios"
#endif

#define URL_VERSION_PARAM "&version="

#ifdef HERO_TARGET_DEV
#define GK_DEVICE_LOGIN_URL "http://hero.ip.ai/index.php?r=hero/DeviceID"URL_PLATFORM_PARAM""URL_VERSION_PARAM
#define GK_GAMECENTER_LOGIN_CHECK "http://hero.ip.ai/index.php?r=hero/GameCenter/CheckLink"URL_PLATFORM_PARAM
#define GK_GAMECENTER_BING_NEW "http://hero.ip.ai/index.php?r=hero/GameCenter/LinkNew"URL_PLATFORM_PARAM
#define GK_PAYMENT_REQUEST "http://hero.ip.ai/index.php?r=payInterface/AppleIAP/GetOrderId"URL_PLATFORM_PARAM
#define GK_PAYMENT_FINISH "http://hero.ip.ai/index.php?r=payInterface/AppleIAP/WebIPN"URL_PLATFORM_PARAM
#define GK_CHECK_VERSION_URL "http://alpha.hero.ucool.com/index.php?r=Updatelist"URL_PLATFORM_PARAM
#else
#define GK_DEVICE_LOGIN_URL "http://alpha.hero.ucool.com/index.php?r=hero/DeviceID"URL_PLATFORM_PARAM""URL_VERSION_PARAM
#define GK_GAMECENTER_LOGIN_CHECK "http://alpha.hero.ucool.com/index.php?r=hero/GameCenter/CheckLink"URL_PLATFORM_PARAM
#define GK_GAMECENTER_BING_NEW "http://alpha.hero.ucool.com/index.php?r=hero/GameCenter/LinkNew"URL_PLATFORM_PARAM
#define GK_PAYMENT_REQUEST "http://alpha.hero.ucool.com/index.php?r=payInterface/AppleIAP/GetOrderId"
#define GK_PAYMENT_FINISH "http://alpha.hero.ucool.com/index.php?r=payInterface/AppleIAP/WebIPN"

#define GK_ANDROID_PAYMENT_REUQEST "http://alpha.hero.ucool.com/index.php?r=payInterface/GoogleIAP/GetOrderId"
#define GK_ANDROID_PAYMENT_GETKEY "http://alpha.hero.ucool.com/index.php?r=payInterface/GoogleIAP/GetKey"
#define GK_ANDROID_PAYMENT_DELIVER "http://alpha.hero.ucool.com/index.php?r=payInterface/GoogleIAP/Deliver"

#define GK_CHECK_VERSION_URL "http://alpha.hero.ucool.com/index.php?r=Updatelist"URL_PLATFORM_PARAM
#endif
//#define GK_DEVICE_LOGIN_URL "http://hc.ucool.com/index.php?r=hero/DeviceID"URL_PLATFORM_PARAM""URL_VERSION_PARAM
//#define GK_GAMECENTER_LOGIN_CHECK "http://hc.ucool.com/index.php?r=hero/GameCenter/CheckLink"
//#define GK_GAMECENTER_BING_NEW "http://hc.ucool.com/index.php?r=hero/GameCenter/LinkNew"
//#define GK_PAYMENT_REQUEST "http://hc.ucool.com/index.php?r=payInterface/AppleIAP/GetOrderId"
//#define GK_PAYMENT_FINISH "http://hc.ucool.com/index.php?r=payInterface/AppleIAP/WebIPN"
//#define GK_CHECK_VERSION_URL "http://hc.ucool.com/index.php?r=Updatelist"



#define IS_ALPHA_VERION 0

int   gk_get_gamecenter_enabled();
int   gk_is_alpha_version();

#endif /* defined(__hero__GateKeeper__) */
