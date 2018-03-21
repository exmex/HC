
#ifndef __LUA_OBJC_H_
#define __LUA_OBJC_H_

#include "CCLuaEngine.h"

NS_CC_BEGIN

class CCLuaObjc
{
public:
    static void LuaEnterGameNotify();
    static void doRecharge(const char* title,int itemId,int cost,const char* gameServerIP,const char* userID);
    static void dologin();
    static void addLocalNotification(const char *key, const char * text, const char *itag, long date);
    static void cancelLocalNotification(const char *key);
    static void openURL(const char *url);
    static void sendMailReportIssue(const char* issueType,const char* clientVersion,const char* playerId);
    static void getShopPriceInfo(const char* items);
    static int isFacebookConnected();
    static void connectFacebook();
    static void disConnectFacebook();
};

NS_CC_END

#endif // __LUA_OBJC_H_
