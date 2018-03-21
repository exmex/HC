//
//  apiforlua.h
//  HelloLua
//
//  Created by eboz on 14-5-11.
//
//

#ifndef HelloLua_apiforlua_h
#define HelloLua_apiforlua_h



extern double g_ani_scale_factor;
extern int   g_soundSwitch;
extern double g_time_factor;
#ifdef __cplusplus
extern "C" {
#endif 

void setUserID(int isOk, const char* session, const char * uin, const char* userId, const char* serverId, const char* serverIP, const char* serverPort);
void OnPayResult();
void didEnterGround(int enterType);
void showAnnouncement(std::string fileContent);
void showAnnouncement2(std::string annStr);//add by cooper.x
void showAnnouncementDownloadFailed();
void printErrorInLua(const char* errorInfo);
void doGoogleConnectResponse(const char* state);
void OnFacebookConnectResult(int result);

#ifdef __cplusplus
}
#endif

void restartGame();

#endif
