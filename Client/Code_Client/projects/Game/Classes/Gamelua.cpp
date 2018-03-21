/*
** Lua binding: Gamelua
** Generated automatically by tolua++-1.0.92 on 12/25/14 17:01:13.
*/

/****************************************************************************
 Copyright (c) 2011 cocos2d-x.org

 http://www.cocos2d-x.org

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/
 #ifndef __cplusplus
#include "stdlib.h"
#endif
#include "string.h"
#include "tolua++.h"

 

/* Exported function */
TOLUA_API int  tolua_Gamelua_open (lua_State* tolua_S);

#include "Gamelua.h"
#include "libOS.h"
#include "Language.h"
#include "libPlatform.h"
#include "SeverConsts.h"
#include "AnnouncementNewPage.h"
#include "ArmatureContainer.h"
#include "SpineContainer.h"
#include "CCBContainer.h"

/* function to release collected object via destructor */
#ifdef __cplusplus

static int tolua_collect_NetworkStatus (lua_State* tolua_S)
{
 NetworkStatus* self = (NetworkStatus*) tolua_tousertype(tolua_S,1,0);
    Mtolua_delete(self);
    return 0;
}

static int tolua_collect_AnnouncementNewPage (lua_State* tolua_S)
{
 AnnouncementNewPage* self = (AnnouncementNewPage*) tolua_tousertype(tolua_S,1,0);
    Mtolua_delete(self);
    return 0;
}
#endif


/* function to register type */
static void tolua_reg_types (lua_State* tolua_S)
{
 tolua_usertype(tolua_S,"CCPoint");
 tolua_usertype(tolua_S,"CCLabelBMFont");
 tolua_usertype(tolua_S,"CCScrollView");
 tolua_usertype(tolua_S,"NetworkStatus");
 tolua_usertype(tolua_S,"CCMenuItemImage");
 tolua_usertype(tolua_S,"_ccColor3B");
 tolua_usertype(tolua_S,"libOS");
 tolua_usertype(tolua_S,"CCMenuItemCCBFile");
 tolua_usertype(tolua_S,"SeverConsts");
 tolua_usertype(tolua_S,"CCParticleSystem");
 tolua_usertype(tolua_S,"libOSListener");
 tolua_usertype(tolua_S,"CCBone");
 tolua_usertype(tolua_S,"BUYINFO");
 tolua_usertype(tolua_S,"Language");
 tolua_usertype(tolua_S,"CCSprite");
 tolua_usertype(tolua_S,"const");
 tolua_usertype(tolua_S,"CCBContainer");
 tolua_usertype(tolua_S,"ArmatureContainer");
 tolua_usertype(tolua_S,"Singleton<SeverConsts>");
 tolua_usertype(tolua_S,"cocos2d::CCNode");
 tolua_usertype(tolua_S,"SpineContainer");
 tolua_usertype(tolua_S,"CCNode");
 tolua_usertype(tolua_S,"CurlDownload::DownloadListener");
 tolua_usertype(tolua_S,"CCScale9Sprite");
 tolua_usertype(tolua_S,"AnnouncementNewPage");
 tolua_usertype(tolua_S,"CCLabelTTF");
 tolua_usertype(tolua_S,"ccColor3B");
 
 tolua_usertype(tolua_S,"libPlatformManager");
 tolua_usertype(tolua_S,"libPlatform");
 tolua_usertype(tolua_S,"std::map<std::string,std::string>");
}

/* method: getInstance of class  libOS */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libOS_getInstance00
static int tolua_Gamelua_libOS_getInstance00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"libOS",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   libOS* tolua_ret = (libOS*)  libOS::getInstance();
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"libOS");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getInstance'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: avalibleMemory of class  libOS */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libOS_avalibleMemory00
static int tolua_Gamelua_libOS_avalibleMemory00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libOS",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libOS* self = (libOS*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'avalibleMemory'", NULL);
#endif
  {
   long tolua_ret = (long)  self->avalibleMemory();
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'avalibleMemory'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: rmdir of class  libOS */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libOS_rmdir00
static int tolua_Gamelua_libOS_rmdir00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libOS",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libOS* self = (libOS*)  tolua_tousertype(tolua_S,1,0);
  const char* path = ((const char*)  tolua_tostring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'rmdir'", NULL);
#endif
  {
   self->rmdir(path);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'rmdir'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: generateSerial of class  libOS */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libOS_generateSerial00
static int tolua_Gamelua_libOS_generateSerial00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libOS",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libOS* self = (libOS*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'generateSerial'", NULL);
#endif
  {
   const std::string tolua_ret = (const std::string)  self->generateSerial();
   tolua_pushcpplstring(tolua_S,tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'generateSerial'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: showInputbox of class  libOS */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libOS_showInputbox00
static int tolua_Gamelua_libOS_showInputbox00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libOS",0,&tolua_err) ||
     !tolua_isboolean(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libOS* self = (libOS*)  tolua_tousertype(tolua_S,1,0);
  bool multiline = ((bool)  tolua_toboolean(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'showInputbox'", NULL);
#endif
  {
   self->showInputbox(multiline);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'showInputbox'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: showMessagebox of class  libOS */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libOS_showMessagebox00
static int tolua_Gamelua_libOS_showMessagebox00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libOS",0,&tolua_err) ||
     !tolua_iscppstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libOS* self = (libOS*)  tolua_tousertype(tolua_S,1,0);
  const std::string msg = ((const std::string)  tolua_tocppstring(tolua_S,2,0));
  int tag = ((int)  tolua_tonumber(tolua_S,3,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'showMessagebox'", NULL);
#endif
  {
   self->showMessagebox(msg,tag);
   tolua_pushcppstring(tolua_S,(const char*)msg);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'showMessagebox'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: openURL of class  libOS */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libOS_openURL00
static int tolua_Gamelua_libOS_openURL00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libOS",0,&tolua_err) ||
     !tolua_iscppstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libOS* self = (libOS*)  tolua_tousertype(tolua_S,1,0);
  const std::string url = ((const std::string)  tolua_tocppstring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'openURL'", NULL);
#endif
  {
   self->openURL(url);
   tolua_pushcppstring(tolua_S,(const char*)url);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'openURL'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: emailTo of class  libOS */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libOS_emailTo00
static int tolua_Gamelua_libOS_emailTo00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libOS",0,&tolua_err) ||
     !tolua_iscppstring(tolua_S,2,0,&tolua_err) ||
     !tolua_iscppstring(tolua_S,3,0,&tolua_err) ||
     !tolua_iscppstring(tolua_S,4,0,&tolua_err) ||
     !tolua_iscppstring(tolua_S,5,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,6,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libOS* self = (libOS*)  tolua_tousertype(tolua_S,1,0);
  const std::string mailto = ((const std::string)  tolua_tocppstring(tolua_S,2,0));
  const std::string cc = ((const std::string)  tolua_tocppstring(tolua_S,3,0));
  const std::string title = ((const std::string)  tolua_tocppstring(tolua_S,4,0));
  const std::string body = ((const std::string)  tolua_tocppstring(tolua_S,5,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'emailTo'", NULL);
#endif
  {
   self->emailTo(mailto,cc,title,body);
   tolua_pushcppstring(tolua_S,(const char*)mailto);
   tolua_pushcppstring(tolua_S,(const char*)cc);
   tolua_pushcppstring(tolua_S,(const char*)title);
   tolua_pushcppstring(tolua_S,(const char*)body);
  }
 }
 return 4;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'emailTo'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setWaiting of class  libOS */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libOS_setWaiting00
static int tolua_Gamelua_libOS_setWaiting00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libOS",0,&tolua_err) ||
     !tolua_isboolean(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libOS* self = (libOS*)  tolua_tousertype(tolua_S,1,0);
  bool tolua_var_1 = ((bool)  tolua_toboolean(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setWaiting'", NULL);
#endif
  {
   self->setWaiting(tolua_var_1);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setWaiting'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: fbAttention of class  libOS */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libOS_fbAttention00
static int tolua_Gamelua_libOS_fbAttention00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libOS",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libOS* self = (libOS*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'fbAttention'", NULL);
#endif
  {
   self->fbAttention();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'fbAttention'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getFreeSpace of class  libOS */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libOS_getFreeSpace00
static int tolua_Gamelua_libOS_getFreeSpace00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libOS",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libOS* self = (libOS*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getFreeSpace'", NULL);
#endif
  {
   long long tolua_ret = (long long)  self->getFreeSpace();
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getFreeSpace'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getNetWork of class  libOS */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libOS_getNetWork00
static int tolua_Gamelua_libOS_getNetWork00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libOS",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libOS* self = (libOS*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getNetWork'", NULL);
#endif
  {
   NetworkStatus tolua_ret = (NetworkStatus)  self->getNetWork();
   {
#ifdef __cplusplus
    void* tolua_obj = Mtolua_new((NetworkStatus)(tolua_ret));
     tolua_pushusertype(tolua_S,tolua_obj,"NetworkStatus");
    tolua_register_gc(tolua_S,lua_gettop(tolua_S));
#else
    void* tolua_obj = tolua_copy(tolua_S,(void*)&tolua_ret,sizeof(NetworkStatus));
     tolua_pushusertype(tolua_S,tolua_obj,"NetworkStatus");
    tolua_register_gc(tolua_S,lua_gettop(tolua_S));
#endif
   }
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getNetWork'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: clearNotification of class  libOS */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libOS_clearNotification00
static int tolua_Gamelua_libOS_clearNotification00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libOS",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libOS* self = (libOS*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'clearNotification'", NULL);
#endif
  {
   self->clearNotification();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'clearNotification'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: addNotification of class  libOS */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libOS_addNotification00
static int tolua_Gamelua_libOS_addNotification00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libOS",0,&tolua_err) ||
     !tolua_iscppstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isboolean(tolua_S,4,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libOS* self = (libOS*)  tolua_tousertype(tolua_S,1,0);
  const std::string msg = ((const std::string)  tolua_tocppstring(tolua_S,2,0));
  int secondsdelay = ((int)  tolua_tonumber(tolua_S,3,0));
  bool daily = ((bool)  tolua_toboolean(tolua_S,4,false));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'addNotification'", NULL);
#endif
  {
   self->addNotification(msg,secondsdelay,daily);
   tolua_pushcppstring(tolua_S,(const char*)msg);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'addNotification'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getDeviceID of class  libOS */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libOS_getDeviceID00
static int tolua_Gamelua_libOS_getDeviceID00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libOS",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libOS* self = (libOS*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getDeviceID'", NULL);
#endif
  {
   const std::string tolua_ret = (const std::string)  self->getDeviceID();
   tolua_pushcpplstring(tolua_S,tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getDeviceID'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getPlatformInfo of class  libOS */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libOS_getPlatformInfo00
static int tolua_Gamelua_libOS_getPlatformInfo00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libOS",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libOS* self = (libOS*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getPlatformInfo'", NULL);
#endif
  {
   const std::string tolua_ret = (const std::string)  self->getPlatformInfo();
   tolua_pushcpplstring(tolua_S,tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getPlatformInfo'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: analyticsLogEvent of class  libOS */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libOS_analyticsLogEvent00
static int tolua_Gamelua_libOS_analyticsLogEvent00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libOS",0,&tolua_err) ||
     !tolua_iscppstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libOS* self = (libOS*)  tolua_tousertype(tolua_S,1,0);
  const std::string event = ((const std::string)  tolua_tocppstring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'analyticsLogEvent'", NULL);
#endif
  {
   self->analyticsLogEvent(event);
   tolua_pushcppstring(tolua_S,(const char*)event);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'analyticsLogEvent'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: analyticsLogEvent of class  libOS */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libOS_analyticsLogEvent01
static int tolua_Gamelua_libOS_analyticsLogEvent01(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libOS",0,&tolua_err) ||
     !tolua_iscppstring(tolua_S,2,0,&tolua_err) ||
     (tolua_isvaluenil(tolua_S,3,&tolua_err) || !tolua_isusertype(tolua_S,3,"const std::map<std::string,std::string>",0,&tolua_err)) ||
     !tolua_isboolean(tolua_S,4,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  libOS* self = (libOS*)  tolua_tousertype(tolua_S,1,0);
  const std::string event = ((const std::string)  tolua_tocppstring(tolua_S,2,0));
  const std::map<std::string,std::string>* dictionary = ((const std::map<std::string,std::string>*)  tolua_tousertype(tolua_S,3,0));
  bool timed = ((bool)  tolua_toboolean(tolua_S,4,false));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'analyticsLogEvent'", NULL);
#endif
  {
   self->analyticsLogEvent(event,*dictionary,timed);
   tolua_pushcppstring(tolua_S,(const char*)event);
  }
 }
 return 1;
tolua_lerror:
 return tolua_Gamelua_libOS_analyticsLogEvent00(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: analyticsLogEndTimeEvent of class  libOS */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libOS_analyticsLogEndTimeEvent00
static int tolua_Gamelua_libOS_analyticsLogEndTimeEvent00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libOS",0,&tolua_err) ||
     !tolua_iscppstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libOS* self = (libOS*)  tolua_tousertype(tolua_S,1,0);
  const std::string event = ((const std::string)  tolua_tocppstring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'analyticsLogEndTimeEvent'", NULL);
#endif
  {
   self->analyticsLogEndTimeEvent(event);
   tolua_pushcppstring(tolua_S,(const char*)event);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'analyticsLogEndTimeEvent'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: WeChatInit of class  libOS */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libOS_WeChatInit00
static int tolua_Gamelua_libOS_WeChatInit00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libOS",0,&tolua_err) ||
     !tolua_iscppstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libOS* self = (libOS*)  tolua_tousertype(tolua_S,1,0);
  const std::string appID = ((const std::string)  tolua_tocppstring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'WeChatInit'", NULL);
#endif
  {
   self->WeChatInit(appID);
   tolua_pushcppstring(tolua_S,(const char*)appID);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'WeChatInit'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: WeChatIsInstalled of class  libOS */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libOS_WeChatIsInstalled00
static int tolua_Gamelua_libOS_WeChatIsInstalled00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libOS",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libOS* self = (libOS*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'WeChatIsInstalled'", NULL);
#endif
  {
   bool tolua_ret = (bool)  self->WeChatIsInstalled();
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'WeChatIsInstalled'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: WeChatInstall of class  libOS */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libOS_WeChatInstall00
static int tolua_Gamelua_libOS_WeChatInstall00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libOS",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libOS* self = (libOS*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'WeChatInstall'", NULL);
#endif
  {
   self->WeChatInstall();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'WeChatInstall'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: WeChatOpen of class  libOS */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libOS_WeChatOpen00
static int tolua_Gamelua_libOS_WeChatOpen00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libOS",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libOS* self = (libOS*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'WeChatOpen'", NULL);
#endif
  {
   self->WeChatOpen();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'WeChatOpen'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: init of class  Language */
#ifndef TOLUA_DISABLE_tolua_Gamelua_Language_init00
static int tolua_Gamelua_Language_init00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"Language",0,&tolua_err) ||
     !tolua_iscppstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  Language* self = (Language*)  tolua_tousertype(tolua_S,1,0);
  const std::string languagefile = ((const std::string)  tolua_tocppstring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'init'", NULL);
#endif
  {
   self->init(languagefile);
   tolua_pushcppstring(tolua_S,(const char*)languagefile);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'init'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: addLanguageFile of class  Language */
#ifndef TOLUA_DISABLE_tolua_Gamelua_Language_addLanguageFile00
static int tolua_Gamelua_Language_addLanguageFile00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"Language",0,&tolua_err) ||
     !tolua_iscppstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  Language* self = (Language*)  tolua_tousertype(tolua_S,1,0);
  const std::string languagefile = ((const std::string)  tolua_tocppstring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'addLanguageFile'", NULL);
#endif
  {
   self->addLanguageFile(languagefile);
   tolua_pushcppstring(tolua_S,(const char*)languagefile);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'addLanguageFile'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: hasString of class  Language */
#ifndef TOLUA_DISABLE_tolua_Gamelua_Language_hasString00
static int tolua_Gamelua_Language_hasString00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"Language",0,&tolua_err) ||
     !tolua_iscppstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  Language* self = (Language*)  tolua_tousertype(tolua_S,1,0);
  const std::string _key = ((const std::string)  tolua_tocppstring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'hasString'", NULL);
#endif
  {
   bool tolua_ret = (bool)  self->hasString(_key);
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
   tolua_pushcppstring(tolua_S,(const char*)_key);
  }
 }
 return 2;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'hasString'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getString of class  Language */
#ifndef TOLUA_DISABLE_tolua_Gamelua_Language_getString00
static int tolua_Gamelua_Language_getString00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"Language",0,&tolua_err) ||
     !tolua_iscppstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  Language* self = (Language*)  tolua_tousertype(tolua_S,1,0);
  const std::string _key = ((const std::string)  tolua_tocppstring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getString'", NULL);
#endif
  {
   const std::string tolua_ret = (const std::string)  self->getString(_key);
   tolua_pushcpplstring(tolua_S,tolua_ret);
   tolua_pushcppstring(tolua_S,(const char*)_key);
  }
 }
 return 2;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getString'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: updateNode of class  Language */
#ifndef TOLUA_DISABLE_tolua_Gamelua_Language_updateNode00
static int tolua_Gamelua_Language_updateNode00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"Language",0,&tolua_err) ||
     !tolua_isusertype(tolua_S,2,"cocos2d::CCNode",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  Language* self = (Language*)  tolua_tousertype(tolua_S,1,0);
  cocos2d::CCNode* _root = ((cocos2d::CCNode*)  tolua_tousertype(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'updateNode'", NULL);
#endif
  {
   self->updateNode(_root);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'updateNode'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: clear of class  Language */
#ifndef TOLUA_DISABLE_tolua_Gamelua_Language_clear00
static int tolua_Gamelua_Language_clear00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"Language",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  Language* self = (Language*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'clear'", NULL);
#endif
  {
   self->clear();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'clear'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getInstance of class  Language */
#ifndef TOLUA_DISABLE_tolua_Gamelua_Language_getInstance00
static int tolua_Gamelua_Language_getInstance00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"Language",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   Language* tolua_ret = (Language*)  Language::getInstance();
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"Language");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getInstance'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* get function: cooOrderSerial of class  BUYINFO */
#ifndef TOLUA_DISABLE_tolua_get_BUYINFO_cooOrderSerial
static int tolua_get_BUYINFO_cooOrderSerial(lua_State* tolua_S)
{
  BUYINFO* self = (BUYINFO*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'cooOrderSerial'",NULL);
#endif
  tolua_pushcppstring(tolua_S,(const char*)self->cooOrderSerial);
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: cooOrderSerial of class  BUYINFO */
#ifndef TOLUA_DISABLE_tolua_set_BUYINFO_cooOrderSerial
static int tolua_set_BUYINFO_cooOrderSerial(lua_State* tolua_S)
{
  BUYINFO* self = (BUYINFO*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'cooOrderSerial'",NULL);
  if (!tolua_iscppstring(tolua_S,2,0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  self->cooOrderSerial = ((std::string)  tolua_tocppstring(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* get function: productId of class  BUYINFO */
#ifndef TOLUA_DISABLE_tolua_get_BUYINFO_productId
static int tolua_get_BUYINFO_productId(lua_State* tolua_S)
{
  BUYINFO* self = (BUYINFO*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'productId'",NULL);
#endif
  tolua_pushcppstring(tolua_S,(const char*)self->productId);
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: productId of class  BUYINFO */
#ifndef TOLUA_DISABLE_tolua_set_BUYINFO_productId
static int tolua_set_BUYINFO_productId(lua_State* tolua_S)
{
  BUYINFO* self = (BUYINFO*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'productId'",NULL);
  if (!tolua_iscppstring(tolua_S,2,0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  self->productId = ((std::string)  tolua_tocppstring(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* get function: productName of class  BUYINFO */
#ifndef TOLUA_DISABLE_tolua_get_BUYINFO_productName
static int tolua_get_BUYINFO_productName(lua_State* tolua_S)
{
  BUYINFO* self = (BUYINFO*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'productName'",NULL);
#endif
  tolua_pushcppstring(tolua_S,(const char*)self->productName);
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: productName of class  BUYINFO */
#ifndef TOLUA_DISABLE_tolua_set_BUYINFO_productName
static int tolua_set_BUYINFO_productName(lua_State* tolua_S)
{
  BUYINFO* self = (BUYINFO*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'productName'",NULL);
  if (!tolua_iscppstring(tolua_S,2,0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  self->productName = ((std::string)  tolua_tocppstring(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* get function: productPrice of class  BUYINFO */
#ifndef TOLUA_DISABLE_tolua_get_BUYINFO_productPrice
static int tolua_get_BUYINFO_productPrice(lua_State* tolua_S)
{
  BUYINFO* self = (BUYINFO*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'productPrice'",NULL);
#endif
  tolua_pushnumber(tolua_S,(lua_Number)self->productPrice);
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: productPrice of class  BUYINFO */
#ifndef TOLUA_DISABLE_tolua_set_BUYINFO_productPrice
static int tolua_set_BUYINFO_productPrice(lua_State* tolua_S)
{
  BUYINFO* self = (BUYINFO*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'productPrice'",NULL);
  if (!tolua_isnumber(tolua_S,2,0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  self->productPrice = ((float)  tolua_tonumber(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* get function: productOrignalPrice of class  BUYINFO */
#ifndef TOLUA_DISABLE_tolua_get_BUYINFO_productOrignalPrice
static int tolua_get_BUYINFO_productOrignalPrice(lua_State* tolua_S)
{
  BUYINFO* self = (BUYINFO*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'productOrignalPrice'",NULL);
#endif
  tolua_pushnumber(tolua_S,(lua_Number)self->productOrignalPrice);
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: productOrignalPrice of class  BUYINFO */
#ifndef TOLUA_DISABLE_tolua_set_BUYINFO_productOrignalPrice
static int tolua_set_BUYINFO_productOrignalPrice(lua_State* tolua_S)
{
  BUYINFO* self = (BUYINFO*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'productOrignalPrice'",NULL);
  if (!tolua_isnumber(tolua_S,2,0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  self->productOrignalPrice = ((float)  tolua_tonumber(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* get function: productCount of class  BUYINFO */
#ifndef TOLUA_DISABLE_tolua_get_BUYINFO_unsigned_productCount
static int tolua_get_BUYINFO_unsigned_productCount(lua_State* tolua_S)
{
  BUYINFO* self = (BUYINFO*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'productCount'",NULL);
#endif
  tolua_pushnumber(tolua_S,(lua_Number)self->productCount);
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: productCount of class  BUYINFO */
#ifndef TOLUA_DISABLE_tolua_set_BUYINFO_unsigned_productCount
static int tolua_set_BUYINFO_unsigned_productCount(lua_State* tolua_S)
{
  BUYINFO* self = (BUYINFO*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'productCount'",NULL);
  if (!tolua_isnumber(tolua_S,2,0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  self->productCount = ((unsigned int)  tolua_tonumber(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* get function: description of class  BUYINFO */
#ifndef TOLUA_DISABLE_tolua_get_BUYINFO_description
static int tolua_get_BUYINFO_description(lua_State* tolua_S)
{
  BUYINFO* self = (BUYINFO*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'description'",NULL);
#endif
  tolua_pushcppstring(tolua_S,(const char*)self->description);
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: description of class  BUYINFO */
#ifndef TOLUA_DISABLE_tolua_set_BUYINFO_description
static int tolua_set_BUYINFO_description(lua_State* tolua_S)
{
  BUYINFO* self = (BUYINFO*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'description'",NULL);
  if (!tolua_iscppstring(tolua_S,2,0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  self->description = ((std::string)  tolua_tocppstring(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* method: openBBS of class  libPlatform */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libPlatform_openBBS00
static int tolua_Gamelua_libPlatform_openBBS00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libPlatform",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libPlatform* self = (libPlatform*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'openBBS'", NULL);
#endif
  {
   self->openBBS();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'openBBS'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: userFeedBack of class  libPlatform */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libPlatform_userFeedBack00
static int tolua_Gamelua_libPlatform_userFeedBack00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libPlatform",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libPlatform* self = (libPlatform*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'userFeedBack'", NULL);
#endif
  {
   self->userFeedBack();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'userFeedBack'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: gamePause of class  libPlatform */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libPlatform_gamePause00
static int tolua_Gamelua_libPlatform_gamePause00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libPlatform",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libPlatform* self = (libPlatform*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'gamePause'", NULL);
#endif
  {
   self->gamePause();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'gamePause'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getLogined of class  libPlatform */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libPlatform_getLogined00
static int tolua_Gamelua_libPlatform_getLogined00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libPlatform",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libPlatform* self = (libPlatform*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getLogined'", NULL);
#endif
  {
   bool tolua_ret = (bool)  self->getLogined();
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getLogined'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: loginUin of class  libPlatform */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libPlatform_loginUin00
static int tolua_Gamelua_libPlatform_loginUin00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libPlatform",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libPlatform* self = (libPlatform*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'loginUin'", NULL);
#endif
  {
   const std::string tolua_ret = (const std::string)  self->loginUin();
   tolua_pushcpplstring(tolua_S,tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'loginUin'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: login of class  libPlatform */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libPlatform_login00
static int tolua_Gamelua_libPlatform_login00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libPlatform",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libPlatform* self = (libPlatform*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'login'", NULL);
#endif
  {
   self->login();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'login'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: switchUsers of class  libPlatform */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libPlatform_switchUsers00
static int tolua_Gamelua_libPlatform_switchUsers00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libPlatform",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libPlatform* self = (libPlatform*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'switchUsers'", NULL);
#endif
  {
   self->switchUsers();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'switchUsers'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: sessionID of class  libPlatform */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libPlatform_sessionID00
static int tolua_Gamelua_libPlatform_sessionID00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libPlatform",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libPlatform* self = (libPlatform*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'sessionID'", NULL);
#endif
  {
   const std::string tolua_ret = (const std::string)  self->sessionID();
   tolua_pushcpplstring(tolua_S,tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'sessionID'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: nickName of class  libPlatform */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libPlatform_nickName00
static int tolua_Gamelua_libPlatform_nickName00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libPlatform",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libPlatform* self = (libPlatform*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'nickName'", NULL);
#endif
  {
   const std::string tolua_ret = (const std::string)  self->nickName();
   tolua_pushcpplstring(tolua_S,tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'nickName'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getPlatformInfo of class  libPlatform */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libPlatform_getPlatformInfo00
static int tolua_Gamelua_libPlatform_getPlatformInfo00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libPlatform",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libPlatform* self = (libPlatform*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getPlatformInfo'", NULL);
#endif
  {
   const std::string tolua_ret = (const std::string)  self->getPlatformInfo();
   tolua_pushcpplstring(tolua_S,tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getPlatformInfo'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getClientChannel of class  libPlatform */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libPlatform_getClientChannel00
static int tolua_Gamelua_libPlatform_getClientChannel00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libPlatform",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libPlatform* self = (libPlatform*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getClientChannel'", NULL);
#endif
  {
   const std::string tolua_ret = (const std::string)  self->getClientChannel();
   tolua_pushcpplstring(tolua_S,tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getClientChannel'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getPlatformId of class  libPlatform */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libPlatform_getPlatformId00
static int tolua_Gamelua_libPlatform_getPlatformId00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libPlatform",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libPlatform* self = (libPlatform*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getPlatformId'", NULL);
#endif
  {
   unsigned const int tolua_ret = ( unsigned const int)  self->getPlatformId();
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getPlatformId'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setPlatform of class  libPlatformManager */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libPlatformManager_setPlatform00
static int tolua_Gamelua_libPlatformManager_setPlatform00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"libPlatformManager",0,&tolua_err) ||
     !tolua_iscppstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  libPlatformManager* self = (libPlatformManager*)  tolua_tousertype(tolua_S,1,0);
  std::string name = ((std::string)  tolua_tocppstring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setPlatform'", NULL);
#endif
  {
   self->setPlatform(name);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setPlatform'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getPlatform of class  libPlatformManager */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libPlatformManager_getPlatform00
static int tolua_Gamelua_libPlatformManager_getPlatform00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"libPlatformManager",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   libPlatform* tolua_ret = (libPlatform*)  libPlatformManager::getPlatform();
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"libPlatform");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getPlatform'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getInstance of class  libPlatformManager */
#ifndef TOLUA_DISABLE_tolua_Gamelua_libPlatformManager_getInstance00
static int tolua_Gamelua_libPlatformManager_getInstance00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"libPlatformManager",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   libPlatformManager* tolua_ret = (libPlatformManager*)  libPlatformManager::getInstance();
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"libPlatformManager");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getInstance'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getInstance of class  SeverConsts */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SeverConsts_getInstance00
static int tolua_Gamelua_SeverConsts_getInstance00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"SeverConsts",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   SeverConsts* tolua_ret = (SeverConsts*)  SeverConsts::getInstance();
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"SeverConsts");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getInstance'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getServerInfoByLua of class  SeverConsts */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SeverConsts_getServerInfoByLua00
static int tolua_Gamelua_SeverConsts_getServerInfoByLua00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SeverConsts",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SeverConsts* self = (SeverConsts*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getServerInfoByLua'", NULL);
#endif
  {
   const std::string tolua_ret = (const std::string)  self->getServerInfoByLua();
   tolua_pushcpplstring(tolua_S,tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getServerInfoByLua'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getBaseVersion of class  SeverConsts */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SeverConsts_getBaseVersion00
static int tolua_Gamelua_SeverConsts_getBaseVersion00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"const SeverConsts",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const SeverConsts* self = (const SeverConsts*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getBaseVersion'", NULL);
#endif
  {
   const std::string tolua_ret = (const std::string)  self->getBaseVersion();
   tolua_pushcpplstring(tolua_S,tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getBaseVersion'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setIsInLoading of class  SeverConsts */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SeverConsts_setIsInLoading00
static int tolua_Gamelua_SeverConsts_setIsInLoading00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SeverConsts",0,&tolua_err) ||
     !tolua_isboolean(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SeverConsts* self = (SeverConsts*)  tolua_tousertype(tolua_S,1,0);
  bool isInLoading = ((bool)  tolua_toboolean(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setIsInLoading'", NULL);
#endif
  {
   self->setIsInLoading(isInLoading);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setIsInLoading'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getServerInGrayMsg of class  SeverConsts */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SeverConsts_getServerInGrayMsg00
static int tolua_Gamelua_SeverConsts_getServerInGrayMsg00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SeverConsts",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SeverConsts* self = (SeverConsts*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getServerInGrayMsg'", NULL);
#endif
  {
   const std::string tolua_ret = (const std::string)  self->getServerInGrayMsg();
   tolua_pushcpplstring(tolua_S,tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getServerInGrayMsg'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getServerInUpdateMsg of class  SeverConsts */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SeverConsts_getServerInUpdateMsg00
static int tolua_Gamelua_SeverConsts_getServerInUpdateMsg00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SeverConsts",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SeverConsts* self = (SeverConsts*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getServerInUpdateMsg'", NULL);
#endif
  {
   const std::string tolua_ret = (const std::string)  self->getServerInUpdateMsg();
   tolua_pushcpplstring(tolua_S,tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getServerInUpdateMsg'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getSeverDefaultID of class  SeverConsts */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SeverConsts_getSeverDefaultID00
static int tolua_Gamelua_SeverConsts_getSeverDefaultID00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SeverConsts",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SeverConsts* self = (SeverConsts*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getSeverDefaultID'", NULL);
#endif
  {
   int tolua_ret = (int)  self->getSeverDefaultID();
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getSeverDefaultID'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* get function: __CurlDownload of class  SeverConsts */
#ifndef TOLUA_DISABLE_tolua_get_SeverConsts___CurlDownload__DownloadListener__
static int tolua_get_SeverConsts___CurlDownload__DownloadListener__(lua_State* tolua_S)
{
  SeverConsts* self = (SeverConsts*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable '__CurlDownload'",NULL);
#endif
#ifdef __cplusplus
   tolua_pushusertype(tolua_S,(void*)static_cast<CurlDownload::DownloadListener*>(self), "CurlDownload::DownloadListener");
#else
   tolua_pushusertype(tolua_S,(void*)((CurlDownload::DownloadListener*)self), "CurlDownload::DownloadListener");
#endif
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* get function: __libOSListener__ of class  SeverConsts */
#ifndef TOLUA_DISABLE_tolua_get_SeverConsts___libOSListener__
static int tolua_get_SeverConsts___libOSListener__(lua_State* tolua_S)
{
  SeverConsts* self = (SeverConsts*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable '__libOSListener__'",NULL);
#endif
#ifdef __cplusplus
   tolua_pushusertype(tolua_S,(void*)static_cast<libOSListener*>(self), "libOSListener");
#else
   tolua_pushusertype(tolua_S,(void*)((libOSListener*)self), "libOSListener");
#endif
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* method: new of class  AnnouncementNewPage */
#ifndef TOLUA_DISABLE_tolua_Gamelua_AnnouncementNewPage_new00
static int tolua_Gamelua_AnnouncementNewPage_new00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"AnnouncementNewPage",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   AnnouncementNewPage* tolua_ret = (AnnouncementNewPage*)  Mtolua_new((AnnouncementNewPage)());
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"AnnouncementNewPage");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'new'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: new_local of class  AnnouncementNewPage */
#ifndef TOLUA_DISABLE_tolua_Gamelua_AnnouncementNewPage_new00_local
static int tolua_Gamelua_AnnouncementNewPage_new00_local(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"AnnouncementNewPage",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   AnnouncementNewPage* tolua_ret = (AnnouncementNewPage*)  Mtolua_new((AnnouncementNewPage)());
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"AnnouncementNewPage");
    tolua_register_gc(tolua_S,lua_gettop(tolua_S));
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'new'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: delete of class  AnnouncementNewPage */
#ifndef TOLUA_DISABLE_tolua_Gamelua_AnnouncementNewPage_delete00
static int tolua_Gamelua_AnnouncementNewPage_delete00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"AnnouncementNewPage",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  AnnouncementNewPage* self = (AnnouncementNewPage*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'delete'", NULL);
#endif
  Mtolua_delete(self);
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'delete'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: startDown of class  AnnouncementNewPage */
#ifndef TOLUA_DISABLE_tolua_Gamelua_AnnouncementNewPage_startDown00
static int tolua_Gamelua_AnnouncementNewPage_startDown00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"AnnouncementNewPage",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  AnnouncementNewPage* self = (AnnouncementNewPage*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'startDown'", NULL);
#endif
  {
   self->startDown();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'startDown'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: downInternalAnnouncementFile of class  AnnouncementNewPage */
#ifndef TOLUA_DISABLE_tolua_Gamelua_AnnouncementNewPage_downInternalAnnouncementFile00
static int tolua_Gamelua_AnnouncementNewPage_downInternalAnnouncementFile00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"AnnouncementNewPage",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  AnnouncementNewPage* self = (AnnouncementNewPage*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'downInternalAnnouncementFile'", NULL);
#endif
  {
   self->downInternalAnnouncementFile();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'downInternalAnnouncementFile'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: downloaded of class  AnnouncementNewPage */
#ifndef TOLUA_DISABLE_tolua_Gamelua_AnnouncementNewPage_downloaded00
static int tolua_Gamelua_AnnouncementNewPage_downloaded00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"AnnouncementNewPage",0,&tolua_err) ||
     !tolua_iscppstring(tolua_S,2,0,&tolua_err) ||
     !tolua_iscppstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  AnnouncementNewPage* self = (AnnouncementNewPage*)  tolua_tousertype(tolua_S,1,0);
  const std::string url = ((const std::string)  tolua_tocppstring(tolua_S,2,0));
  const std::string filename = ((const std::string)  tolua_tocppstring(tolua_S,3,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'downloaded'", NULL);
#endif
  {
   self->downloaded(url,filename);
   tolua_pushcppstring(tolua_S,(const char*)url);
   tolua_pushcppstring(tolua_S,(const char*)filename);
  }
 }
 return 2;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'downloaded'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getInstance of class  AnnouncementNewPage */
#ifndef TOLUA_DISABLE_tolua_Gamelua_AnnouncementNewPage_getInstance00
static int tolua_Gamelua_AnnouncementNewPage_getInstance00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"AnnouncementNewPage",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   AnnouncementNewPage* tolua_ret = (AnnouncementNewPage*)  AnnouncementNewPage::getInstance();
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"AnnouncementNewPage");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getInstance'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: create of class  ArmatureContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_ArmatureContainer_create00
static int tolua_Gamelua_ArmatureContainer_create00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"ArmatureContainer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isusertype(tolua_S,4,"CCNode",1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* path = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* name = ((const char*)  tolua_tostring(tolua_S,3,0));
  CCNode* parent = ((CCNode*)  tolua_tousertype(tolua_S,4,NULL));
  {
   ArmatureContainer* tolua_ret = (ArmatureContainer*)  ArmatureContainer::create(path,name,parent);
    int nID = (tolua_ret) ? (int)tolua_ret->m_uID : -1;
    int* pLuaID = (tolua_ret) ? &tolua_ret->m_nLuaID : NULL;
    toluafix_pushusertype_ccobject(tolua_S, nID, pLuaID, (void*)tolua_ret,"ArmatureContainer");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'create'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: runAnimation of class  ArmatureContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_ArmatureContainer_runAnimation00
static int tolua_Gamelua_ArmatureContainer_runAnimation00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"ArmatureContainer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  ArmatureContainer* self = (ArmatureContainer*)  tolua_tousertype(tolua_S,1,0);
  const char* name = ((const char*)  tolua_tostring(tolua_S,2,0));
  unsigned int loopTimes = ((unsigned int)  tolua_tonumber(tolua_S,3,1));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'runAnimation'", NULL);
#endif
  {
   self->runAnimation(name,loopTimes);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'runAnimation'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: changeSkin of class  ArmatureContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_ArmatureContainer_changeSkin00
static int tolua_Gamelua_ArmatureContainer_changeSkin00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"ArmatureContainer",0,&tolua_err) ||
     !tolua_isusertype(tolua_S,2,"CCBone",0,&tolua_err) ||
     !tolua_isusertype(tolua_S,3,"CCNode",0,&tolua_err) ||
     !tolua_isboolean(tolua_S,4,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  ArmatureContainer* self = (ArmatureContainer*)  tolua_tousertype(tolua_S,1,0);
  CCBone* bone = ((CCBone*)  tolua_tousertype(tolua_S,2,0));
  CCNode* node = ((CCNode*)  tolua_tousertype(tolua_S,3,0));
  bool force = ((bool)  tolua_toboolean(tolua_S,4,true));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'changeSkin'", NULL);
#endif
  {
   self->changeSkin(bone,node,force);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'changeSkin'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: update of class  ArmatureContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_ArmatureContainer_update00
static int tolua_Gamelua_ArmatureContainer_update00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"ArmatureContainer",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isboolean(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  ArmatureContainer* self = (ArmatureContainer*)  tolua_tousertype(tolua_S,1,0);
  float dt = ((float)  tolua_tonumber(tolua_S,2,0));
  bool value = ((bool)  tolua_toboolean(tolua_S,3,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'update'", NULL);
#endif
  {
   self->update(dt,value);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'update'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: changeSkin of class  ArmatureContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_ArmatureContainer_changeSkin01
static int tolua_Gamelua_ArmatureContainer_changeSkin01(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"ArmatureContainer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isboolean(tolua_S,4,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  ArmatureContainer* self = (ArmatureContainer*)  tolua_tousertype(tolua_S,1,0);
  const char* boneName = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* skinName = ((const char*)  tolua_tostring(tolua_S,3,0));
  bool force = ((bool)  tolua_toboolean(tolua_S,4,true));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'changeSkin'", NULL);
#endif
  {
   self->changeSkin(boneName,skinName,force);
  }
 }
 return 0;
tolua_lerror:
 return tolua_Gamelua_ArmatureContainer_changeSkin00(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: changeSkin of class  ArmatureContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_ArmatureContainer_changeSkin02
static int tolua_Gamelua_ArmatureContainer_changeSkin02(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"ArmatureContainer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isusertype(tolua_S,3,"CCLabelTTF",0,&tolua_err) ||
     !tolua_isboolean(tolua_S,4,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  ArmatureContainer* self = (ArmatureContainer*)  tolua_tousertype(tolua_S,1,0);
  const char* boneName = ((const char*)  tolua_tostring(tolua_S,2,0));
  CCLabelTTF* label = ((CCLabelTTF*)  tolua_tousertype(tolua_S,3,0));
  bool force = ((bool)  tolua_toboolean(tolua_S,4,true));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'changeSkin'", NULL);
#endif
  {
   self->changeSkin(boneName,label,force);
  }
 }
 return 0;
tolua_lerror:
 return tolua_Gamelua_ArmatureContainer_changeSkin01(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: changeSkin of class  ArmatureContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_ArmatureContainer_changeSkin03
static int tolua_Gamelua_ArmatureContainer_changeSkin03(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"ArmatureContainer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isusertype(tolua_S,3,"CCParticleSystem",0,&tolua_err) ||
     !tolua_isboolean(tolua_S,4,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  ArmatureContainer* self = (ArmatureContainer*)  tolua_tousertype(tolua_S,1,0);
  const char* boneName = ((const char*)  tolua_tostring(tolua_S,2,0));
  CCParticleSystem* particle = ((CCParticleSystem*)  tolua_tousertype(tolua_S,3,0));
  bool force = ((bool)  tolua_toboolean(tolua_S,4,true));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'changeSkin'", NULL);
#endif
  {
   self->changeSkin(boneName,particle,force);
  }
 }
 return 0;
tolua_lerror:
 return tolua_Gamelua_ArmatureContainer_changeSkin02(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: registerLuaListener of class  ArmatureContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_ArmatureContainer_registerLuaListener00
static int tolua_Gamelua_ArmatureContainer_registerLuaListener00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"ArmatureContainer",0,&tolua_err) ||
     (tolua_isvaluenil(tolua_S,2,&tolua_err) || !toluafix_isfunction(tolua_S,2,"LUA_FUNCTION",0,&tolua_err)) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  ArmatureContainer* self = (ArmatureContainer*)  tolua_tousertype(tolua_S,1,0);
  LUA_FUNCTION listener = (  toluafix_ref_function(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'registerLuaListener'", NULL);
#endif
  {
   self->registerLuaListener(listener);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'registerLuaListener'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: unregisterLuaListener of class  ArmatureContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_ArmatureContainer_unregisterLuaListener00
static int tolua_Gamelua_ArmatureContainer_unregisterLuaListener00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"ArmatureContainer",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  ArmatureContainer* self = (ArmatureContainer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'unregisterLuaListener'", NULL);
#endif
  {
   self->unregisterLuaListener();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'unregisterLuaListener'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setAction of class  ArmatureContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_ArmatureContainer_setAction00
static int tolua_Gamelua_ArmatureContainer_setAction00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"ArmatureContainer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isboolean(tolua_S,3,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  ArmatureContainer* self = (ArmatureContainer*)  tolua_tousertype(tolua_S,1,0);
  const char* name = ((const char*)  tolua_tostring(tolua_S,2,0));
  bool bRemoveQueue = ((bool)  tolua_toboolean(tolua_S,3,true));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setAction'", NULL);
#endif
  {
   bool tolua_ret = (bool)  self->setAction(name,bRemoveQueue);
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setAction'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setLoop of class  ArmatureContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_ArmatureContainer_setLoop00
static int tolua_Gamelua_ArmatureContainer_setLoop00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"ArmatureContainer",0,&tolua_err) ||
     !tolua_isboolean(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  ArmatureContainer* self = (ArmatureContainer*)  tolua_tousertype(tolua_S,1,0);
  bool val = ((bool)  tolua_toboolean(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setLoop'", NULL);
#endif
  {
   self->setLoop(val);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setLoop'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setResourcePath of class  ArmatureContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_ArmatureContainer_setResourcePath00
static int tolua_Gamelua_ArmatureContainer_setResourcePath00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"ArmatureContainer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  ArmatureContainer* self = (ArmatureContainer*)  tolua_tousertype(tolua_S,1,0);
  const char* resourcePath = ((const char*)  tolua_tostring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setResourcePath'", NULL);
#endif
  {
   self->setResourcePath(resourcePath);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setResourcePath'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getResourcePath of class  ArmatureContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_ArmatureContainer_getResourcePath00
static int tolua_Gamelua_ArmatureContainer_getResourcePath00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"ArmatureContainer",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  ArmatureContainer* self = (ArmatureContainer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getResourcePath'", NULL);
#endif
  {
   std::string tolua_ret = (std::string)  self->getResourcePath();
   tolua_pushcpplstring(tolua_S,tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getResourcePath'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: clearResource of class  ArmatureContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_ArmatureContainer_clearResource00
static int tolua_Gamelua_ArmatureContainer_clearResource00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"ArmatureContainer",0,&tolua_err) ||
     !tolua_iscppstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  std::string resourcePath = ((std::string)  tolua_tocppstring(tolua_S,2,0));
  {
   ArmatureContainer::clearResource(resourcePath);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'clearResource'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setColor of class  ArmatureContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_ArmatureContainer_setColor00
static int tolua_Gamelua_ArmatureContainer_setColor00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"ArmatureContainer",0,&tolua_err) ||
     (tolua_isvaluenil(tolua_S,2,&tolua_err) || !tolua_isusertype(tolua_S,2,"const ccColor3B",0,&tolua_err)) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  ArmatureContainer* self = (ArmatureContainer*)  tolua_tousertype(tolua_S,1,0);
  const ccColor3B* color = ((const ccColor3B*)  tolua_tousertype(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setColor'", NULL);
#endif
  {
   self->setColor(*color);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setColor'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: tint of class  ArmatureContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_ArmatureContainer_tint00
static int tolua_Gamelua_ArmatureContainer_tint00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"ArmatureContainer",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  ArmatureContainer* self = (ArmatureContainer*)  tolua_tousertype(tolua_S,1,0);
  float r = ((float)  tolua_tonumber(tolua_S,2,0));
  float g = ((float)  tolua_tonumber(tolua_S,3,0));
  float b = ((float)  tolua_tonumber(tolua_S,4,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'tint'", NULL);
#endif
  {
   self->tint(r,g,b);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'tint'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: addEffect of class  ArmatureContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_ArmatureContainer_addEffect00
static int tolua_Gamelua_ArmatureContainer_addEffect00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"ArmatureContainer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  ArmatureContainer* self = (ArmatureContainer*)  tolua_tousertype(tolua_S,1,0);
  const char* resName = ((const char*)  tolua_tostring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'addEffect'", NULL);
#endif
  {
   int tolua_ret = (int)  self->addEffect(resName);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'addEffect'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: addEffect of class  ArmatureContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_ArmatureContainer_addEffect01
static int tolua_Gamelua_ArmatureContainer_addEffect01(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"ArmatureContainer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     (tolua_isvaluenil(tolua_S,3,&tolua_err) || !tolua_isusertype(tolua_S,3,"const",0,&tolua_err)) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  ArmatureContainer* self = (ArmatureContainer*)  tolua_tousertype(tolua_S,1,0);
  const char* resName = ((const char*)  tolua_tostring(tolua_S,2,0));
  CCAffineTransform const* mat = ((CCAffineTransform const*)  tolua_tousertype(tolua_S,3,0));
  int zorder = ((int)  tolua_tonumber(tolua_S,4,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'addEffect'", NULL);
#endif
  {
   int tolua_ret = (int)  self->addEffect(resName,*mat,zorder);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
tolua_lerror:
 return tolua_Gamelua_ArmatureContainer_addEffect00(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: addEffect of class  ArmatureContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_ArmatureContainer_addEffect02
static int tolua_Gamelua_ArmatureContainer_addEffect02(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"ArmatureContainer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     (tolua_isvaluenil(tolua_S,3,&tolua_err) || !tolua_isusertype(tolua_S,3,"CCPoint",0,&tolua_err)) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  ArmatureContainer* self = (ArmatureContainer*)  tolua_tousertype(tolua_S,1,0);
  const char* resName = ((const char*)  tolua_tostring(tolua_S,2,0));
  CCPoint pos = *((CCPoint*)  tolua_tousertype(tolua_S,3,0));
  int zorder = ((int)  tolua_tonumber(tolua_S,4,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'addEffect'", NULL);
#endif
  {
   int tolua_ret = (int)  self->addEffect(resName,pos,zorder);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
tolua_lerror:
 return tolua_Gamelua_ArmatureContainer_addEffect01(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: addEffect of class  ArmatureContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_ArmatureContainer_addEffect03
static int tolua_Gamelua_ArmatureContainer_addEffect03(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"ArmatureContainer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  ArmatureContainer* self = (ArmatureContainer*)  tolua_tousertype(tolua_S,1,0);
  const char* name = ((const char*)  tolua_tostring(tolua_S,2,0));
  int zorder = ((int)  tolua_tonumber(tolua_S,3,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'addEffect'", NULL);
#endif
  {
   int tolua_ret = (int)  self->addEffect(name,zorder);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
tolua_lerror:
 return tolua_Gamelua_ArmatureContainer_addEffect02(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: removeEffectWithID of class  ArmatureContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_ArmatureContainer_removeEffectWithID00
static int tolua_Gamelua_ArmatureContainer_removeEffectWithID00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"ArmatureContainer",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  ArmatureContainer* self = (ArmatureContainer*)  tolua_tousertype(tolua_S,1,0);
  int eid = ((int)  tolua_tonumber(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'removeEffectWithID'", NULL);
#endif
  {
   self->removeEffectWithID(eid);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'removeEffectWithID'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: removeEffectWithName of class  ArmatureContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_ArmatureContainer_removeEffectWithName00
static int tolua_Gamelua_ArmatureContainer_removeEffectWithName00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"ArmatureContainer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  ArmatureContainer* self = (ArmatureContainer*)  tolua_tousertype(tolua_S,1,0);
  const char* effectName = ((const char*)  tolua_tostring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'removeEffectWithName'", NULL);
#endif
  {
   self->removeEffectWithName(effectName);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'removeEffectWithName'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: useDefaultShader of class  ArmatureContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_ArmatureContainer_useDefaultShader00
static int tolua_Gamelua_ArmatureContainer_useDefaultShader00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"ArmatureContainer",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  ArmatureContainer* self = (ArmatureContainer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'useDefaultShader'", NULL);
#endif
  {
   self->useDefaultShader();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'useDefaultShader'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: useShader of class  ArmatureContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_ArmatureContainer_useShader00
static int tolua_Gamelua_ArmatureContainer_useShader00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"ArmatureContainer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  ArmatureContainer* self = (ArmatureContainer*)  tolua_tousertype(tolua_S,1,0);
  const char* shaderName = ((const char*)  tolua_tostring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'useShader'", NULL);
#endif
  {
   self->useShader(shaderName);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'useShader'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setActionElapsed of class  ArmatureContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_ArmatureContainer_setActionElapsed00
static int tolua_Gamelua_ArmatureContainer_setActionElapsed00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"ArmatureContainer",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  ArmatureContainer* self = (ArmatureContainer*)  tolua_tousertype(tolua_S,1,0);
  float elapsed = ((float)  tolua_tonumber(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setActionElapsed'", NULL);
#endif
  {
   self->setActionElapsed(elapsed);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setActionElapsed'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setActionSpeeder of class  ArmatureContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_ArmatureContainer_setActionSpeeder00
static int tolua_Gamelua_ArmatureContainer_setActionSpeeder00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"ArmatureContainer",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  ArmatureContainer* self = (ArmatureContainer*)  tolua_tousertype(tolua_S,1,0);
  float speeder = ((float)  tolua_tonumber(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setActionSpeeder'", NULL);
#endif
  {
   self->setActionSpeeder(speeder);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setActionSpeeder'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setNextAction of class  ArmatureContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_ArmatureContainer_setNextAction00
static int tolua_Gamelua_ArmatureContainer_setNextAction00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"ArmatureContainer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  ArmatureContainer* self = (ArmatureContainer*)  tolua_tousertype(tolua_S,1,0);
  const char* actionName = ((const char*)  tolua_tostring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setNextAction'", NULL);
#endif
  {
   self->setNextAction(actionName);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setNextAction'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: create of class  SpineContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SpineContainer_create00
static int tolua_Gamelua_SpineContainer_create00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"SpineContainer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* path = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* name = ((const char*)  tolua_tostring(tolua_S,3,0));
  float scale = ((float)  tolua_tonumber(tolua_S,4,1.0f));
  {
   SpineContainer* tolua_ret = (SpineContainer*)  SpineContainer::create(path,name,scale);
    int nID = (tolua_ret) ? (int)tolua_ret->m_uID : -1;
    int* pLuaID = (tolua_ret) ? &tolua_ret->m_nLuaID : NULL;
    toluafix_pushusertype_ccobject(tolua_S, nID, pLuaID, (void*)tolua_ret,"SpineContainer");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'create'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: runAnimation of class  SpineContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SpineContainer_runAnimation00
static int tolua_Gamelua_SpineContainer_runAnimation00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SpineContainer",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,1,&tolua_err) ||
     !tolua_isnumber(tolua_S,5,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,6,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SpineContainer* self = (SpineContainer*)  tolua_tousertype(tolua_S,1,0);
  int trackIndex = ((int)  tolua_tonumber(tolua_S,2,0));
  const char* name = ((const char*)  tolua_tostring(tolua_S,3,0));
  int loopTimes = ((int)  tolua_tonumber(tolua_S,4,1));
  float delay = ((float)  tolua_tonumber(tolua_S,5,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'runAnimation'", NULL);
#endif
  {
   self->runAnimation(trackIndex,name,loopTimes,delay);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'runAnimation'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: registerLuaListener of class  SpineContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SpineContainer_registerLuaListener00
static int tolua_Gamelua_SpineContainer_registerLuaListener00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SpineContainer",0,&tolua_err) ||
     (tolua_isvaluenil(tolua_S,2,&tolua_err) || !toluafix_isfunction(tolua_S,2,"LUA_FUNCTION",0,&tolua_err)) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SpineContainer* self = (SpineContainer*)  tolua_tousertype(tolua_S,1,0);
  LUA_FUNCTION listener = (  toluafix_ref_function(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'registerLuaListener'", NULL);
#endif
  {
   self->registerLuaListener(listener);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'registerLuaListener'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: unregisterLuaListener of class  SpineContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SpineContainer_unregisterLuaListener00
static int tolua_Gamelua_SpineContainer_unregisterLuaListener00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SpineContainer",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SpineContainer* self = (SpineContainer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'unregisterLuaListener'", NULL);
#endif
  {
   self->unregisterLuaListener();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'unregisterLuaListener'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: stopAllAnimations of class  SpineContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SpineContainer_stopAllAnimations00
static int tolua_Gamelua_SpineContainer_stopAllAnimations00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SpineContainer",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SpineContainer* self = (SpineContainer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'stopAllAnimations'", NULL);
#endif
  {
   self->stopAllAnimations();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'stopAllAnimations'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: stopAnimationByIndex of class  SpineContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SpineContainer_stopAnimationByIndex00
static int tolua_Gamelua_SpineContainer_stopAnimationByIndex00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SpineContainer",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SpineContainer* self = (SpineContainer*)  tolua_tousertype(tolua_S,1,0);
  int trackIndex = ((int)  tolua_tonumber(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'stopAnimationByIndex'", NULL);
#endif
  {
   self->stopAnimationByIndex(trackIndex);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'stopAnimationByIndex'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setAction of class  SpineContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SpineContainer_setAction00
static int tolua_Gamelua_SpineContainer_setAction00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SpineContainer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isboolean(tolua_S,3,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SpineContainer* self = (SpineContainer*)  tolua_tousertype(tolua_S,1,0);
  const char* name = ((const char*)  tolua_tostring(tolua_S,2,0));
  bool bRemoveQueue = ((bool)  tolua_toboolean(tolua_S,3,true));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setAction'", NULL);
#endif
  {
   bool tolua_ret = (bool)  self->setAction(name,bRemoveQueue);
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setAction'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: addEffect of class  SpineContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SpineContainer_addEffect00
static int tolua_Gamelua_SpineContainer_addEffect00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SpineContainer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SpineContainer* self = (SpineContainer*)  tolua_tousertype(tolua_S,1,0);
  const char* resName = ((const char*)  tolua_tostring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'addEffect'", NULL);
#endif
  {
   int tolua_ret = (int)  self->addEffect(resName);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'addEffect'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: addEffect of class  SpineContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SpineContainer_addEffect01
static int tolua_Gamelua_SpineContainer_addEffect01(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SpineContainer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     (tolua_isvaluenil(tolua_S,3,&tolua_err) || !tolua_isusertype(tolua_S,3,"const",0,&tolua_err)) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  SpineContainer* self = (SpineContainer*)  tolua_tousertype(tolua_S,1,0);
  const char* resName = ((const char*)  tolua_tostring(tolua_S,2,0));
  CCAffineTransform const* mat = ((CCAffineTransform const*)  tolua_tousertype(tolua_S,3,0));
  int zorder = ((int)  tolua_tonumber(tolua_S,4,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'addEffect'", NULL);
#endif
  {
   int tolua_ret = (int)  self->addEffect(resName,*mat,zorder);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
tolua_lerror:
 return tolua_Gamelua_SpineContainer_addEffect00(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: addEffect of class  SpineContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SpineContainer_addEffect02
static int tolua_Gamelua_SpineContainer_addEffect02(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SpineContainer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     (tolua_isvaluenil(tolua_S,3,&tolua_err) || !tolua_isusertype(tolua_S,3,"CCPoint",0,&tolua_err)) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  SpineContainer* self = (SpineContainer*)  tolua_tousertype(tolua_S,1,0);
  const char* resName = ((const char*)  tolua_tostring(tolua_S,2,0));
  CCPoint pos = *((CCPoint*)  tolua_tousertype(tolua_S,3,0));
  int zorder = ((int)  tolua_tonumber(tolua_S,4,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'addEffect'", NULL);
#endif
  {
   int tolua_ret = (int)  self->addEffect(resName,pos,zorder);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
tolua_lerror:
 return tolua_Gamelua_SpineContainer_addEffect01(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: addEffect of class  SpineContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SpineContainer_addEffect03
static int tolua_Gamelua_SpineContainer_addEffect03(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SpineContainer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  SpineContainer* self = (SpineContainer*)  tolua_tousertype(tolua_S,1,0);
  const char* name = ((const char*)  tolua_tostring(tolua_S,2,0));
  int zorder = ((int)  tolua_tonumber(tolua_S,3,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'addEffect'", NULL);
#endif
  {
   int tolua_ret = (int)  self->addEffect(name,zorder);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
tolua_lerror:
 return tolua_Gamelua_SpineContainer_addEffect02(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: clearActionSequence of class  SpineContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SpineContainer_clearActionSequence00
static int tolua_Gamelua_SpineContainer_clearActionSequence00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SpineContainer",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SpineContainer* self = (SpineContainer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'clearActionSequence'", NULL);
#endif
  {
   self->clearActionSequence();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'clearActionSequence'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: interruptSound of class  SpineContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SpineContainer_interruptSound00
static int tolua_Gamelua_SpineContainer_interruptSound00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SpineContainer",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SpineContainer* self = (SpineContainer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'interruptSound'", NULL);
#endif
  {
   self->interruptSound();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'interruptSound'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: onActionFinished of class  SpineContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SpineContainer_onActionFinished00
static int tolua_Gamelua_SpineContainer_onActionFinished00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SpineContainer",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SpineContainer* self = (SpineContainer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'onActionFinished'", NULL);
#endif
  {
   self->onActionFinished();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'onActionFinished'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: removeEffectWithID of class  SpineContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SpineContainer_removeEffectWithID00
static int tolua_Gamelua_SpineContainer_removeEffectWithID00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SpineContainer",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SpineContainer* self = (SpineContainer*)  tolua_tousertype(tolua_S,1,0);
  int eid = ((int)  tolua_tonumber(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'removeEffectWithID'", NULL);
#endif
  {
   self->removeEffectWithID(eid);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'removeEffectWithID'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: removeEffectWithName of class  SpineContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SpineContainer_removeEffectWithName00
static int tolua_Gamelua_SpineContainer_removeEffectWithName00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SpineContainer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SpineContainer* self = (SpineContainer*)  tolua_tousertype(tolua_S,1,0);
  const char* effectName = ((const char*)  tolua_tostring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'removeEffectWithName'", NULL);
#endif
  {
   self->removeEffectWithName(effectName);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'removeEffectWithName'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setColor of class  SpineContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SpineContainer_setColor00
static int tolua_Gamelua_SpineContainer_setColor00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SpineContainer",0,&tolua_err) ||
     (tolua_isvaluenil(tolua_S,2,&tolua_err) || !tolua_isusertype(tolua_S,2,"_ccColor3B",0,&tolua_err)) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SpineContainer* self = (SpineContainer*)  tolua_tousertype(tolua_S,1,0);
  _ccColor3B clr = *((_ccColor3B*)  tolua_tousertype(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setColor'", NULL);
#endif
  {
   self->setColor(clr);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setColor'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setComponent of class  SpineContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SpineContainer_setComponent00
static int tolua_Gamelua_SpineContainer_setComponent00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SpineContainer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SpineContainer* self = (SpineContainer*)  tolua_tousertype(tolua_S,1,0);
  const char* param1 = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* param2 = ((const char*)  tolua_tostring(tolua_S,3,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setComponent'", NULL);
#endif
  {
   bool tolua_ret = (bool)  self->setComponent(param1,param2);
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setComponent'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setComponent of class  SpineContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SpineContainer_setComponent01
static int tolua_Gamelua_SpineContainer_setComponent01(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SpineContainer",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  SpineContainer* self = (SpineContainer*)  tolua_tousertype(tolua_S,1,0);
  int index = ((int)  tolua_tonumber(tolua_S,2,0));
  const char* lpszName = ((const char*)  tolua_tostring(tolua_S,3,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setComponent'", NULL);
#endif
  {
   bool tolua_ret = (bool)  self->setComponent(index,lpszName);
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
tolua_lerror:
 return tolua_Gamelua_SpineContainer_setComponent00(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: setNextAction of class  SpineContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SpineContainer_setNextAction00
static int tolua_Gamelua_SpineContainer_setNextAction00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SpineContainer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SpineContainer* self = (SpineContainer*)  tolua_tousertype(tolua_S,1,0);
  const char* actionName = ((const char*)  tolua_tostring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setNextAction'", NULL);
#endif
  {
   self->setNextAction(actionName);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setNextAction'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setOpacity of class  SpineContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SpineContainer_setOpacity00
static int tolua_Gamelua_SpineContainer_setOpacity00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SpineContainer",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SpineContainer* self = (SpineContainer*)  tolua_tousertype(tolua_S,1,0);
  unsigned char param1 = ((unsigned char)  tolua_tonumber(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setOpacity'", NULL);
#endif
  {
   self->setOpacity(param1);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setOpacity'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: tint of class  SpineContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SpineContainer_tint00
static int tolua_Gamelua_SpineContainer_tint00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SpineContainer",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SpineContainer* self = (SpineContainer*)  tolua_tousertype(tolua_S,1,0);
  float r = ((float)  tolua_tonumber(tolua_S,2,0));
  float g = ((float)  tolua_tonumber(tolua_S,3,0));
  float b = ((float)  tolua_tonumber(tolua_S,4,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'tint'", NULL);
#endif
  {
   self->tint(r,g,b);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'tint'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: update of class  SpineContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SpineContainer_update00
static int tolua_Gamelua_SpineContainer_update00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SpineContainer",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isboolean(tolua_S,3,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SpineContainer* self = (SpineContainer*)  tolua_tousertype(tolua_S,1,0);
  float dt = ((float)  tolua_tonumber(tolua_S,2,0));
  bool isAuto = ((bool)  tolua_toboolean(tolua_S,3,true));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'update'", NULL);
#endif
  {
   self->update(dt,isAuto);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'update'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: useDefaultShader of class  SpineContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SpineContainer_useDefaultShader00
static int tolua_Gamelua_SpineContainer_useDefaultShader00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SpineContainer",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SpineContainer* self = (SpineContainer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'useDefaultShader'", NULL);
#endif
  {
   self->useDefaultShader();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'useDefaultShader'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: useShader of class  SpineContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SpineContainer_useShader00
static int tolua_Gamelua_SpineContainer_useShader00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SpineContainer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SpineContainer* self = (SpineContainer*)  tolua_tousertype(tolua_S,1,0);
  const char* shaderName = ((const char*)  tolua_tostring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'useShader'", NULL);
#endif
  {
   self->useShader(shaderName);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'useShader'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setActionElapsed of class  SpineContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SpineContainer_setActionElapsed00
static int tolua_Gamelua_SpineContainer_setActionElapsed00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SpineContainer",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SpineContainer* self = (SpineContainer*)  tolua_tousertype(tolua_S,1,0);
  float elapsed = ((float)  tolua_tonumber(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setActionElapsed'", NULL);
#endif
  {
   self->setActionElapsed(elapsed);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setActionElapsed'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setActionSpeeder of class  SpineContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SpineContainer_setActionSpeeder00
static int tolua_Gamelua_SpineContainer_setActionSpeeder00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SpineContainer",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SpineContainer* self = (SpineContainer*)  tolua_tousertype(tolua_S,1,0);
  float speeder = ((float)  tolua_tonumber(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setActionSpeeder'", NULL);
#endif
  {
   self->setActionSpeeder(speeder);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setActionSpeeder'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setLoop of class  SpineContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_SpineContainer_setLoop00
static int tolua_Gamelua_SpineContainer_setLoop00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SpineContainer",0,&tolua_err) ||
     !tolua_isboolean(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SpineContainer* self = (SpineContainer*)  tolua_tousertype(tolua_S,1,0);
  bool val = ((bool)  tolua_toboolean(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setLoop'", NULL);
#endif
  {
   self->setLoop(val);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setLoop'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: create of class  CCBContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_CCBContainer_create00
static int tolua_Gamelua_CCBContainer_create00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCBContainer",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   CCBContainer* tolua_ret = (CCBContainer*)  CCBContainer::create();
    int nID = (tolua_ret) ? (int)tolua_ret->m_uID : -1;
    int* pLuaID = (tolua_ret) ? &tolua_ret->m_nLuaID : NULL;
    toluafix_pushusertype_ccobject(tolua_S, nID, pLuaID, (void*)tolua_ret,"CCBContainer");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'create'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: loadCcbiFile of class  CCBContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_CCBContainer_loadCcbiFile00
static int tolua_Gamelua_CCBContainer_loadCcbiFile00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCBContainer",0,&tolua_err) ||
     !tolua_iscppstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isboolean(tolua_S,3,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCBContainer* self = (CCBContainer*)  tolua_tousertype(tolua_S,1,0);
  const std::string filename = ((const std::string)  tolua_tocppstring(tolua_S,2,0));
  bool froceLoad = ((bool)  tolua_toboolean(tolua_S,3,false));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'loadCcbiFile'", NULL);
#endif
  {
   self->loadCcbiFile(filename,froceLoad);
   tolua_pushcppstring(tolua_S,(const char*)filename);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'loadCcbiFile'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: registerTouchDispatcherSelf of class  CCBContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_CCBContainer_registerTouchDispatcherSelf00
static int tolua_Gamelua_CCBContainer_registerTouchDispatcherSelf00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCBContainer",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCBContainer* self = (CCBContainer*)  tolua_tousertype(tolua_S,1,0);
  int priority = ((int)  tolua_tonumber(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'registerTouchDispatcherSelf'", NULL);
#endif
  {
   self->registerTouchDispatcherSelf(priority);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'registerTouchDispatcherSelf'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: unregisterTouchDispatcherSelf of class  CCBContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_CCBContainer_unregisterTouchDispatcherSelf00
static int tolua_Gamelua_CCBContainer_unregisterTouchDispatcherSelf00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCBContainer",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCBContainer* self = (CCBContainer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'unregisterTouchDispatcherSelf'", NULL);
#endif
  {
   self->unregisterTouchDispatcherSelf();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'unregisterTouchDispatcherSelf'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getCCNodeFromCCB of class  CCBContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_CCBContainer_getCCNodeFromCCB00
static int tolua_Gamelua_CCBContainer_getCCNodeFromCCB00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCBContainer",0,&tolua_err) ||
     !tolua_iscppstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCBContainer* self = (CCBContainer*)  tolua_tousertype(tolua_S,1,0);
  const std::string variablename = ((const std::string)  tolua_tocppstring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getCCNodeFromCCB'", NULL);
#endif
  {
   CCNode* tolua_ret = (CCNode*)  self->getCCNodeFromCCB(variablename);
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"CCNode");
   tolua_pushcppstring(tolua_S,(const char*)variablename);
  }
 }
 return 2;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getCCNodeFromCCB'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getCCSpriteFromCCB of class  CCBContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_CCBContainer_getCCSpriteFromCCB00
static int tolua_Gamelua_CCBContainer_getCCSpriteFromCCB00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCBContainer",0,&tolua_err) ||
     !tolua_iscppstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCBContainer* self = (CCBContainer*)  tolua_tousertype(tolua_S,1,0);
  const std::string variablename = ((const std::string)  tolua_tocppstring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getCCSpriteFromCCB'", NULL);
#endif
  {
   CCSprite* tolua_ret = (CCSprite*)  self->getCCSpriteFromCCB(variablename);
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"CCSprite");
   tolua_pushcppstring(tolua_S,(const char*)variablename);
  }
 }
 return 2;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getCCSpriteFromCCB'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getCCScale9SpriteFromCCB of class  CCBContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_CCBContainer_getCCScale9SpriteFromCCB00
static int tolua_Gamelua_CCBContainer_getCCScale9SpriteFromCCB00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCBContainer",0,&tolua_err) ||
     !tolua_iscppstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCBContainer* self = (CCBContainer*)  tolua_tousertype(tolua_S,1,0);
  const std::string variablename = ((const std::string)  tolua_tocppstring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getCCScale9SpriteFromCCB'", NULL);
#endif
  {
   CCScale9Sprite* tolua_ret = (CCScale9Sprite*)  self->getCCScale9SpriteFromCCB(variablename);
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"CCScale9Sprite");
   tolua_pushcppstring(tolua_S,(const char*)variablename);
  }
 }
 return 2;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getCCScale9SpriteFromCCB'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getCCLabelBMFontFromCCB of class  CCBContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_CCBContainer_getCCLabelBMFontFromCCB00
static int tolua_Gamelua_CCBContainer_getCCLabelBMFontFromCCB00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCBContainer",0,&tolua_err) ||
     !tolua_iscppstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCBContainer* self = (CCBContainer*)  tolua_tousertype(tolua_S,1,0);
  const std::string variablename = ((const std::string)  tolua_tocppstring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getCCLabelBMFontFromCCB'", NULL);
#endif
  {
   CCLabelBMFont* tolua_ret = (CCLabelBMFont*)  self->getCCLabelBMFontFromCCB(variablename);
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"CCLabelBMFont");
   tolua_pushcppstring(tolua_S,(const char*)variablename);
  }
 }
 return 2;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getCCLabelBMFontFromCCB'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getCCLabelTTFFromCCB of class  CCBContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_CCBContainer_getCCLabelTTFFromCCB00
static int tolua_Gamelua_CCBContainer_getCCLabelTTFFromCCB00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCBContainer",0,&tolua_err) ||
     !tolua_iscppstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCBContainer* self = (CCBContainer*)  tolua_tousertype(tolua_S,1,0);
  const std::string variablename = ((const std::string)  tolua_tocppstring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getCCLabelTTFFromCCB'", NULL);
#endif
  {
   CCLabelTTF* tolua_ret = (CCLabelTTF*)  self->getCCLabelTTFFromCCB(variablename);
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"CCLabelTTF");
   tolua_pushcppstring(tolua_S,(const char*)variablename);
  }
 }
 return 2;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getCCLabelTTFFromCCB'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getCCMenuItemImageFromCCB of class  CCBContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_CCBContainer_getCCMenuItemImageFromCCB00
static int tolua_Gamelua_CCBContainer_getCCMenuItemImageFromCCB00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCBContainer",0,&tolua_err) ||
     !tolua_iscppstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCBContainer* self = (CCBContainer*)  tolua_tousertype(tolua_S,1,0);
  const std::string variablename = ((const std::string)  tolua_tocppstring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getCCMenuItemImageFromCCB'", NULL);
#endif
  {
   CCMenuItemImage* tolua_ret = (CCMenuItemImage*)  self->getCCMenuItemImageFromCCB(variablename);
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"CCMenuItemImage");
   tolua_pushcppstring(tolua_S,(const char*)variablename);
  }
 }
 return 2;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getCCMenuItemImageFromCCB'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getCCScrollViewFromCCB of class  CCBContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_CCBContainer_getCCScrollViewFromCCB00
static int tolua_Gamelua_CCBContainer_getCCScrollViewFromCCB00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCBContainer",0,&tolua_err) ||
     !tolua_iscppstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCBContainer* self = (CCBContainer*)  tolua_tousertype(tolua_S,1,0);
  const std::string variablename = ((const std::string)  tolua_tocppstring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getCCScrollViewFromCCB'", NULL);
#endif
  {
   CCScrollView* tolua_ret = (CCScrollView*)  self->getCCScrollViewFromCCB(variablename);
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"CCScrollView");
   tolua_pushcppstring(tolua_S,(const char*)variablename);
  }
 }
 return 2;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getCCScrollViewFromCCB'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getCCMenuItemCCBFileFromCCB of class  CCBContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_CCBContainer_getCCMenuItemCCBFileFromCCB00
static int tolua_Gamelua_CCBContainer_getCCMenuItemCCBFileFromCCB00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCBContainer",0,&tolua_err) ||
     !tolua_iscppstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCBContainer* self = (CCBContainer*)  tolua_tousertype(tolua_S,1,0);
  const std::string variablename = ((const std::string)  tolua_tocppstring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getCCMenuItemCCBFileFromCCB'", NULL);
#endif
  {
   CCMenuItemCCBFile* tolua_ret = (CCMenuItemCCBFile*)  self->getCCMenuItemCCBFileFromCCB(variablename);
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"CCMenuItemCCBFile");
   tolua_pushcppstring(tolua_S,(const char*)variablename);
  }
 }
 return 2;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getCCMenuItemCCBFileFromCCB'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* get function: mIndex of class  CCBContainer */
#ifndef TOLUA_DISABLE_tolua_get_CCBContainer_mIndex
static int tolua_get_CCBContainer_mIndex(lua_State* tolua_S)
{
  CCBContainer* self = (CCBContainer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'mIndex'",NULL);
#endif
  tolua_pushnumber(tolua_S,(lua_Number)self->mIndex);
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: mIndex of class  CCBContainer */
#ifndef TOLUA_DISABLE_tolua_set_CCBContainer_mIndex
static int tolua_set_CCBContainer_mIndex(lua_State* tolua_S)
{
  CCBContainer* self = (CCBContainer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'mIndex'",NULL);
  if (!tolua_isnumber(tolua_S,2,0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  self->mIndex = ((int)  tolua_tonumber(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* method: registerFunctionHandler of class  CCBContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_CCBContainer_registerFunctionHandler00
static int tolua_Gamelua_CCBContainer_registerFunctionHandler00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCBContainer",0,&tolua_err) ||
     (tolua_isvaluenil(tolua_S,2,&tolua_err) || !toluafix_isfunction(tolua_S,2,"LUA_FUNCTION",0,&tolua_err)) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCBContainer* self = (CCBContainer*)  tolua_tousertype(tolua_S,1,0);
  LUA_FUNCTION nHandler = (  toluafix_ref_function(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'registerFunctionHandler'", NULL);
#endif
  {
   self->registerFunctionHandler(nHandler);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'registerFunctionHandler'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: unregisterFunctionHandler of class  CCBContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_CCBContainer_unregisterFunctionHandler00
static int tolua_Gamelua_CCBContainer_unregisterFunctionHandler00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCBContainer",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCBContainer* self = (CCBContainer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'unregisterFunctionHandler'", NULL);
#endif
  {
   self->unregisterFunctionHandler();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'unregisterFunctionHandler'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: dumpInfo of class  CCBContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_CCBContainer_dumpInfo00
static int tolua_Gamelua_CCBContainer_dumpInfo00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCBContainer",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCBContainer* self = (CCBContainer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'dumpInfo'", NULL);
#endif
  {
   std::string tolua_ret = (std::string)  self->dumpInfo();
   tolua_pushcpplstring(tolua_S,tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'dumpInfo'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getCurAnimationDoneName of class  CCBContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_CCBContainer_getCurAnimationDoneName00
static int tolua_Gamelua_CCBContainer_getCurAnimationDoneName00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCBContainer",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCBContainer* self = (CCBContainer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getCurAnimationDoneName'", NULL);
#endif
  {
   std::string tolua_ret = (std::string)  self->getCurAnimationDoneName();
   tolua_pushcpplstring(tolua_S,tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getCurAnimationDoneName'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: unload of class  CCBContainer */
#ifndef TOLUA_DISABLE_tolua_Gamelua_CCBContainer_unload00
static int tolua_Gamelua_CCBContainer_unload00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCBContainer",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCBContainer* self = (CCBContainer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'unload'", NULL);
#endif
  {
   self->unload();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'unload'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* Open function */
TOLUA_API int tolua_Gamelua_open (lua_State* tolua_S)
{
 tolua_open(tolua_S);
 tolua_reg_types(tolua_S);
 tolua_module(tolua_S,NULL,0);
 tolua_beginmodule(tolua_S,NULL);
  tolua_cclass(tolua_S,"libOS","libOS","",NULL);
  tolua_beginmodule(tolua_S,"libOS");
   tolua_function(tolua_S,"getInstance",tolua_Gamelua_libOS_getInstance00);
   tolua_function(tolua_S,"avalibleMemory",tolua_Gamelua_libOS_avalibleMemory00);
   tolua_function(tolua_S,"rmdir",tolua_Gamelua_libOS_rmdir00);
   tolua_function(tolua_S,"generateSerial",tolua_Gamelua_libOS_generateSerial00);
   tolua_function(tolua_S,"showInputbox",tolua_Gamelua_libOS_showInputbox00);
   tolua_function(tolua_S,"showMessagebox",tolua_Gamelua_libOS_showMessagebox00);
   tolua_function(tolua_S,"openURL",tolua_Gamelua_libOS_openURL00);
   tolua_function(tolua_S,"emailTo",tolua_Gamelua_libOS_emailTo00);
   tolua_function(tolua_S,"setWaiting",tolua_Gamelua_libOS_setWaiting00);
   tolua_function(tolua_S,"fbAttention",tolua_Gamelua_libOS_fbAttention00);
   tolua_function(tolua_S,"getFreeSpace",tolua_Gamelua_libOS_getFreeSpace00);
   tolua_function(tolua_S,"getNetWork",tolua_Gamelua_libOS_getNetWork00);
   tolua_function(tolua_S,"clearNotification",tolua_Gamelua_libOS_clearNotification00);
   tolua_function(tolua_S,"addNotification",tolua_Gamelua_libOS_addNotification00);
   tolua_function(tolua_S,"getDeviceID",tolua_Gamelua_libOS_getDeviceID00);
   tolua_function(tolua_S,"getPlatformInfo",tolua_Gamelua_libOS_getPlatformInfo00);
   tolua_function(tolua_S,"analyticsLogEvent",tolua_Gamelua_libOS_analyticsLogEvent00);
   tolua_function(tolua_S,"analyticsLogEvent",tolua_Gamelua_libOS_analyticsLogEvent01);
   tolua_function(tolua_S,"analyticsLogEndTimeEvent",tolua_Gamelua_libOS_analyticsLogEndTimeEvent00);
   tolua_function(tolua_S,"WeChatInit",tolua_Gamelua_libOS_WeChatInit00);
   tolua_function(tolua_S,"WeChatIsInstalled",tolua_Gamelua_libOS_WeChatIsInstalled00);
   tolua_function(tolua_S,"WeChatInstall",tolua_Gamelua_libOS_WeChatInstall00);
   tolua_function(tolua_S,"WeChatOpen",tolua_Gamelua_libOS_WeChatOpen00);
  tolua_endmodule(tolua_S);
  tolua_cclass(tolua_S,"Language","Language","",NULL);
  tolua_beginmodule(tolua_S,"Language");
   tolua_function(tolua_S,"init",tolua_Gamelua_Language_init00);
   tolua_function(tolua_S,"addLanguageFile",tolua_Gamelua_Language_addLanguageFile00);
   tolua_function(tolua_S,"hasString",tolua_Gamelua_Language_hasString00);
   tolua_function(tolua_S,"getString",tolua_Gamelua_Language_getString00);
   tolua_function(tolua_S,"updateNode",tolua_Gamelua_Language_updateNode00);
   tolua_function(tolua_S,"clear",tolua_Gamelua_Language_clear00);
   tolua_function(tolua_S,"getInstance",tolua_Gamelua_Language_getInstance00);
  tolua_endmodule(tolua_S);
  tolua_cclass(tolua_S,"BUYINFO","BUYINFO","",NULL);
  tolua_beginmodule(tolua_S,"BUYINFO");
   tolua_variable(tolua_S,"cooOrderSerial",tolua_get_BUYINFO_cooOrderSerial,tolua_set_BUYINFO_cooOrderSerial);
   tolua_variable(tolua_S,"productId",tolua_get_BUYINFO_productId,tolua_set_BUYINFO_productId);
   tolua_variable(tolua_S,"productName",tolua_get_BUYINFO_productName,tolua_set_BUYINFO_productName);
   tolua_variable(tolua_S,"productPrice",tolua_get_BUYINFO_productPrice,tolua_set_BUYINFO_productPrice);
   tolua_variable(tolua_S,"productOrignalPrice",tolua_get_BUYINFO_productOrignalPrice,tolua_set_BUYINFO_productOrignalPrice);
   tolua_variable(tolua_S,"productCount",tolua_get_BUYINFO_unsigned_productCount,tolua_set_BUYINFO_unsigned_productCount);
   tolua_variable(tolua_S,"description",tolua_get_BUYINFO_description,tolua_set_BUYINFO_description);
  tolua_endmodule(tolua_S);
  tolua_cclass(tolua_S,"libPlatform","libPlatform","",NULL);
  tolua_beginmodule(tolua_S,"libPlatform");
   tolua_function(tolua_S,"openBBS",tolua_Gamelua_libPlatform_openBBS00);
   tolua_function(tolua_S,"userFeedBack",tolua_Gamelua_libPlatform_userFeedBack00);
   tolua_function(tolua_S,"gamePause",tolua_Gamelua_libPlatform_gamePause00);
   tolua_function(tolua_S,"getLogined",tolua_Gamelua_libPlatform_getLogined00);
   tolua_function(tolua_S,"loginUin",tolua_Gamelua_libPlatform_loginUin00);
   tolua_function(tolua_S,"login",tolua_Gamelua_libPlatform_login00);
   tolua_function(tolua_S,"switchUsers",tolua_Gamelua_libPlatform_switchUsers00);
   tolua_function(tolua_S,"sessionID",tolua_Gamelua_libPlatform_sessionID00);
   tolua_function(tolua_S,"nickName",tolua_Gamelua_libPlatform_nickName00);
   tolua_function(tolua_S,"getPlatformInfo",tolua_Gamelua_libPlatform_getPlatformInfo00);
   tolua_function(tolua_S,"getClientChannel",tolua_Gamelua_libPlatform_getClientChannel00);
   tolua_function(tolua_S,"getPlatformId",tolua_Gamelua_libPlatform_getPlatformId00);
  tolua_endmodule(tolua_S);
  tolua_cclass(tolua_S,"libPlatformManager","libPlatformManager","",NULL);
  tolua_beginmodule(tolua_S,"libPlatformManager");
   tolua_function(tolua_S,"setPlatform",tolua_Gamelua_libPlatformManager_setPlatform00);
   tolua_function(tolua_S,"getPlatform",tolua_Gamelua_libPlatformManager_getPlatform00);
   tolua_function(tolua_S,"getInstance",tolua_Gamelua_libPlatformManager_getInstance00);
  tolua_endmodule(tolua_S);
  tolua_cclass(tolua_S,"SeverConsts","SeverConsts","Singleton<SeverConsts>",NULL);
  tolua_beginmodule(tolua_S,"SeverConsts");
   tolua_function(tolua_S,"getInstance",tolua_Gamelua_SeverConsts_getInstance00);
   tolua_function(tolua_S,"getServerInfoByLua",tolua_Gamelua_SeverConsts_getServerInfoByLua00);
   tolua_function(tolua_S,"getBaseVersion",tolua_Gamelua_SeverConsts_getBaseVersion00);
   tolua_function(tolua_S,"setIsInLoading",tolua_Gamelua_SeverConsts_setIsInLoading00);
   tolua_function(tolua_S,"getServerInGrayMsg",tolua_Gamelua_SeverConsts_getServerInGrayMsg00);
   tolua_function(tolua_S,"getServerInUpdateMsg",tolua_Gamelua_SeverConsts_getServerInUpdateMsg00);
   tolua_function(tolua_S,"getSeverDefaultID",tolua_Gamelua_SeverConsts_getSeverDefaultID00);
   tolua_variable(tolua_S,"__CurlDownload__DownloadListener__",tolua_get_SeverConsts___CurlDownload__DownloadListener__,NULL);
   tolua_variable(tolua_S,"__libOSListener__",tolua_get_SeverConsts___libOSListener__,NULL);
  tolua_endmodule(tolua_S);
  #ifdef __cplusplus
  tolua_cclass(tolua_S,"AnnouncementNewPage","AnnouncementNewPage","",tolua_collect_AnnouncementNewPage);
  #else
  tolua_cclass(tolua_S,"AnnouncementNewPage","AnnouncementNewPage","",NULL);
  #endif
  tolua_beginmodule(tolua_S,"AnnouncementNewPage");
   tolua_function(tolua_S,"new",tolua_Gamelua_AnnouncementNewPage_new00);
   tolua_function(tolua_S,"new_local",tolua_Gamelua_AnnouncementNewPage_new00_local);
   tolua_function(tolua_S,".call",tolua_Gamelua_AnnouncementNewPage_new00_local);
   tolua_function(tolua_S,"delete",tolua_Gamelua_AnnouncementNewPage_delete00);
   tolua_function(tolua_S,"startDown",tolua_Gamelua_AnnouncementNewPage_startDown00);
   tolua_function(tolua_S,"downInternalAnnouncementFile",tolua_Gamelua_AnnouncementNewPage_downInternalAnnouncementFile00);
   tolua_function(tolua_S,"downloaded",tolua_Gamelua_AnnouncementNewPage_downloaded00);
   tolua_function(tolua_S,"getInstance",tolua_Gamelua_AnnouncementNewPage_getInstance00);
  tolua_endmodule(tolua_S);
  tolua_cclass(tolua_S,"ArmatureContainer","ArmatureContainer","CCNode",NULL);
  tolua_beginmodule(tolua_S,"ArmatureContainer");
   tolua_function(tolua_S,"create",tolua_Gamelua_ArmatureContainer_create00);
   tolua_function(tolua_S,"runAnimation",tolua_Gamelua_ArmatureContainer_runAnimation00);
   tolua_function(tolua_S,"changeSkin",tolua_Gamelua_ArmatureContainer_changeSkin00);
   tolua_function(tolua_S,"update",tolua_Gamelua_ArmatureContainer_update00);
   tolua_function(tolua_S,"changeSkin",tolua_Gamelua_ArmatureContainer_changeSkin01);
   tolua_function(tolua_S,"changeSkin",tolua_Gamelua_ArmatureContainer_changeSkin02);
   tolua_function(tolua_S,"changeSkin",tolua_Gamelua_ArmatureContainer_changeSkin03);
   tolua_function(tolua_S,"registerLuaListener",tolua_Gamelua_ArmatureContainer_registerLuaListener00);
   tolua_function(tolua_S,"unregisterLuaListener",tolua_Gamelua_ArmatureContainer_unregisterLuaListener00);
   tolua_function(tolua_S,"setAction",tolua_Gamelua_ArmatureContainer_setAction00);
   tolua_function(tolua_S,"setLoop",tolua_Gamelua_ArmatureContainer_setLoop00);
   tolua_function(tolua_S,"setResourcePath",tolua_Gamelua_ArmatureContainer_setResourcePath00);
   tolua_function(tolua_S,"getResourcePath",tolua_Gamelua_ArmatureContainer_getResourcePath00);
   tolua_function(tolua_S,"clearResource",tolua_Gamelua_ArmatureContainer_clearResource00);
   tolua_function(tolua_S,"setColor",tolua_Gamelua_ArmatureContainer_setColor00);
   tolua_function(tolua_S,"tint",tolua_Gamelua_ArmatureContainer_tint00);
   tolua_function(tolua_S,"addEffect",tolua_Gamelua_ArmatureContainer_addEffect00);
   tolua_function(tolua_S,"addEffect",tolua_Gamelua_ArmatureContainer_addEffect01);
   tolua_function(tolua_S,"addEffect",tolua_Gamelua_ArmatureContainer_addEffect02);
   tolua_function(tolua_S,"addEffect",tolua_Gamelua_ArmatureContainer_addEffect03);
   tolua_function(tolua_S,"removeEffectWithID",tolua_Gamelua_ArmatureContainer_removeEffectWithID00);
   tolua_function(tolua_S,"removeEffectWithName",tolua_Gamelua_ArmatureContainer_removeEffectWithName00);
   tolua_function(tolua_S,"useDefaultShader",tolua_Gamelua_ArmatureContainer_useDefaultShader00);
   tolua_function(tolua_S,"useShader",tolua_Gamelua_ArmatureContainer_useShader00);
   tolua_function(tolua_S,"setActionElapsed",tolua_Gamelua_ArmatureContainer_setActionElapsed00);
   tolua_function(tolua_S,"setActionSpeeder",tolua_Gamelua_ArmatureContainer_setActionSpeeder00);
   tolua_function(tolua_S,"setNextAction",tolua_Gamelua_ArmatureContainer_setNextAction00);
  tolua_endmodule(tolua_S);
  tolua_cclass(tolua_S,"SpineContainer","SpineContainer","CCNode",NULL);
  tolua_beginmodule(tolua_S,"SpineContainer");
   tolua_function(tolua_S,"create",tolua_Gamelua_SpineContainer_create00);
   tolua_function(tolua_S,"runAnimation",tolua_Gamelua_SpineContainer_runAnimation00);
   tolua_function(tolua_S,"registerLuaListener",tolua_Gamelua_SpineContainer_registerLuaListener00);
   tolua_function(tolua_S,"unregisterLuaListener",tolua_Gamelua_SpineContainer_unregisterLuaListener00);
   tolua_function(tolua_S,"stopAllAnimations",tolua_Gamelua_SpineContainer_stopAllAnimations00);
   tolua_function(tolua_S,"stopAnimationByIndex",tolua_Gamelua_SpineContainer_stopAnimationByIndex00);
   tolua_function(tolua_S,"setAction",tolua_Gamelua_SpineContainer_setAction00);
   tolua_function(tolua_S,"addEffect",tolua_Gamelua_SpineContainer_addEffect00);
   tolua_function(tolua_S,"addEffect",tolua_Gamelua_SpineContainer_addEffect01);
   tolua_function(tolua_S,"addEffect",tolua_Gamelua_SpineContainer_addEffect02);
   tolua_function(tolua_S,"addEffect",tolua_Gamelua_SpineContainer_addEffect03);
   tolua_function(tolua_S,"clearActionSequence",tolua_Gamelua_SpineContainer_clearActionSequence00);
   tolua_function(tolua_S,"interruptSound",tolua_Gamelua_SpineContainer_interruptSound00);
   tolua_function(tolua_S,"onActionFinished",tolua_Gamelua_SpineContainer_onActionFinished00);
   tolua_function(tolua_S,"removeEffectWithID",tolua_Gamelua_SpineContainer_removeEffectWithID00);
   tolua_function(tolua_S,"removeEffectWithName",tolua_Gamelua_SpineContainer_removeEffectWithName00);
   tolua_function(tolua_S,"setColor",tolua_Gamelua_SpineContainer_setColor00);
   tolua_function(tolua_S,"setComponent",tolua_Gamelua_SpineContainer_setComponent00);
   tolua_function(tolua_S,"setComponent",tolua_Gamelua_SpineContainer_setComponent01);
   tolua_function(tolua_S,"setNextAction",tolua_Gamelua_SpineContainer_setNextAction00);
   tolua_function(tolua_S,"setOpacity",tolua_Gamelua_SpineContainer_setOpacity00);
   tolua_function(tolua_S,"tint",tolua_Gamelua_SpineContainer_tint00);
   tolua_function(tolua_S,"update",tolua_Gamelua_SpineContainer_update00);
   tolua_function(tolua_S,"useDefaultShader",tolua_Gamelua_SpineContainer_useDefaultShader00);
   tolua_function(tolua_S,"useShader",tolua_Gamelua_SpineContainer_useShader00);
   tolua_function(tolua_S,"setActionElapsed",tolua_Gamelua_SpineContainer_setActionElapsed00);
   tolua_function(tolua_S,"setActionSpeeder",tolua_Gamelua_SpineContainer_setActionSpeeder00);
   tolua_function(tolua_S,"setLoop",tolua_Gamelua_SpineContainer_setLoop00);
  tolua_endmodule(tolua_S);
  tolua_cclass(tolua_S,"CCBContainer","CCBContainer","CCNode",NULL);
  tolua_beginmodule(tolua_S,"CCBContainer");
   tolua_function(tolua_S,"create",tolua_Gamelua_CCBContainer_create00);
   tolua_function(tolua_S,"loadCcbiFile",tolua_Gamelua_CCBContainer_loadCcbiFile00);
   tolua_function(tolua_S,"registerTouchDispatcherSelf",tolua_Gamelua_CCBContainer_registerTouchDispatcherSelf00);
   tolua_function(tolua_S,"unregisterTouchDispatcherSelf",tolua_Gamelua_CCBContainer_unregisterTouchDispatcherSelf00);
   tolua_function(tolua_S,"getCCNodeFromCCB",tolua_Gamelua_CCBContainer_getCCNodeFromCCB00);
   tolua_function(tolua_S,"getCCSpriteFromCCB",tolua_Gamelua_CCBContainer_getCCSpriteFromCCB00);
   tolua_function(tolua_S,"getCCScale9SpriteFromCCB",tolua_Gamelua_CCBContainer_getCCScale9SpriteFromCCB00);
   tolua_function(tolua_S,"getCCLabelBMFontFromCCB",tolua_Gamelua_CCBContainer_getCCLabelBMFontFromCCB00);
   tolua_function(tolua_S,"getCCLabelTTFFromCCB",tolua_Gamelua_CCBContainer_getCCLabelTTFFromCCB00);
   tolua_function(tolua_S,"getCCMenuItemImageFromCCB",tolua_Gamelua_CCBContainer_getCCMenuItemImageFromCCB00);
   tolua_function(tolua_S,"getCCScrollViewFromCCB",tolua_Gamelua_CCBContainer_getCCScrollViewFromCCB00);
   tolua_function(tolua_S,"getCCMenuItemCCBFileFromCCB",tolua_Gamelua_CCBContainer_getCCMenuItemCCBFileFromCCB00);
   tolua_variable(tolua_S,"mIndex",tolua_get_CCBContainer_mIndex,tolua_set_CCBContainer_mIndex);
   tolua_function(tolua_S,"registerFunctionHandler",tolua_Gamelua_CCBContainer_registerFunctionHandler00);
   tolua_function(tolua_S,"unregisterFunctionHandler",tolua_Gamelua_CCBContainer_unregisterFunctionHandler00);
   tolua_function(tolua_S,"dumpInfo",tolua_Gamelua_CCBContainer_dumpInfo00);
   tolua_function(tolua_S,"getCurAnimationDoneName",tolua_Gamelua_CCBContainer_getCurAnimationDoneName00);
   tolua_function(tolua_S,"unload",tolua_Gamelua_CCBContainer_unload00);
  tolua_endmodule(tolua_S);
 tolua_endmodule(tolua_S);
 return 1;
}


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
 TOLUA_API int luaopen_Gamelua (lua_State* tolua_S) {
 return tolua_Gamelua_open(tolua_S);
};
#endif

