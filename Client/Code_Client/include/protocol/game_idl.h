#pragma once
#include "xproto.h"

namespace Legend {



class _EINTERNAL_NOTIFY_BY_PROXY_A{
public:
	enum E{
    CLIENT_DISCONNECT                       =1,
    CLIENT_NOT_EXIST_WHEN_RESPONSE          =2,
    CLIENT_WRITE_ERROR                      =3,
    CLIENT_SOCKET_DEAD_ALREADY              =4,

	};
public:
	static const char* s_szEnumNames[];
	static const char* GetName(_EINTERNAL_NOTIFY_BY_PROXY_A::E _lpValue);
	_EINTERNAL_NOTIFY_BY_PROXY_A::E value;
	_EINTERNAL_NOTIFY_BY_PROXY_A(_EINTERNAL_NOTIFY_BY_PROXY_A::E _lpValue){
		value = _lpValue;
	}
	inline operator const char*() const {
		return GetName(value);
	}
};


class _ECOMMON_SERVER_ERROR_A{
public:
	enum E{
    SUCCESS                                 =0,
    PROXY_FASTCGI_INTERAL_ERROR             =1,
    PROXY_SENDTO_FCGI_FAILED_TOO_MUCH       =2,
    PROXY_FCGI_REQUEST_TIMEOUT              =3,
    PROXY_FCGI_UNAVAILABLE                  =4,
    KICKED_OUT_BY_OTHER_DUPLICATED_LOGIN    =5,
    KICKED_OUT_FOR_IDLE_TOO_LONG            =6,
    KICKED_OUT_FOR_BAD_STATE_NOT_LOGIN_YET  =7,
    KICKED_OUT_FOR_BAD_STATE_LOING_ALREADY  =8,
    SERVER_UNDER_MAINTAIN                   =9,

	};
public:
	static const char* s_szEnumNames[];
	static const char* GetName(_ECOMMON_SERVER_ERROR_A::E _lpValue);
	_ECOMMON_SERVER_ERROR_A::E value;
	_ECOMMON_SERVER_ERROR_A(_ECOMMON_SERVER_ERROR_A::E _lpValue){
		value = _lpValue;
	}
	inline operator const char*() const {
		return GetName(value);
	}
};


class _EMSG_ServerInterface{
public:
	enum E{
    CMSG_DoLogin                            =1,
    CMSG_SendInternalNotifyByProxy          =12,
    CMSG_OnKickout                          =25,
    CMSG_SendPing                           =34,
    CMSG_SendProtoBuff                      =35,
    CMSG_MAX                                =36,

	};
public:
	static const char* s_szEnumNames[];
	static const char* GetName(_EMSG_ServerInterface::E _lpValue);
	_EMSG_ServerInterface::E value;
	_EMSG_ServerInterface(_EMSG_ServerInterface::E _lpValue){
		value = _lpValue;
	}
	inline operator const char*() const {
		return GetName(value);
	}
};


class _EMSG_ServerEvent{
public:
	enum E{
    SMSG_OnServerErrorMessage               =1,
    SMSG_OnSendZipData                      =2,
    SMSG_OnPong                             =46,
    SMSG_OnProtoReponse                     =47,
    SMSG_MAX                                =48,

	};
public:
	static const char* s_szEnumNames[];
	static const char* GetName(_EMSG_ServerEvent::E _lpValue);
	_EMSG_ServerEvent::E value;
	_EMSG_ServerEvent(_EMSG_ServerEvent::E _lpValue){
		value = _lpValue;
	}
	inline operator const char*() const {
		return GetName(value);
	}
};


class XPACKET_DoLogin:public _auto_pointer_class_base
{
public:
    static const INT _m_xcmd=_EMSG_ServerInterface::CMSG_DoLogin;

//fields

    std::string userId;
    std::string server;
    std::string sessionKey;
    std::string version;

  std::string & get_userId(){ return userId ;};
  std::string & get_server(){ return server ;};
  std::string & get_sessionKey(){ return sessionKey ;};
  std::string & get_version(){ return version ;};


public:
	static	INT   _Size(std::string&  userId,std::string&  server,std::string&  sessionKey,std::string&  version);
	static	INT   _FromBuffer(const char *__src,INT    __len,std::string&  userId,std::string&  server,std::string&  sessionKey,std::string&  version);
	static	INT   _ToBuffer(char *__dst,INT    __len,std::string&  userId,std::string&  server,std::string&  sessionKey,std::string&  version);
	INT  Size();
	INT  FromBuffer(const char *__src,INT    __len);
	INT  ToBuffer(char *__dst,INT    __len);
#if !defined(CC_TARGET_OS_IPHONE) && !defined(CC_TARGET_OS_MAC) && !defined(ANDROID)
	INT  FromXml(XP_XMLNODE_PTR pNode);
INT  ToXml(XSTRING_STREAM & out);
	#endif
	


private:


	XPACKET_DoLogin(XPACKET_DoLogin& src);//avoid bit constructor
public:
	//static int Clone(XPACKET_DoLogin* src, XPACKET_DoLogin* dst);
	

	static XPACKET_DoLogin* CreateInstance()
	{
		 XPACKET_DoLogin* p =  new (::std::nothrow) XPACKET_DoLogin();
		 return p;
	}



private:
	XPACKET_DoLogin()
	{

	}
	virtual ~XPACKET_DoLogin()
	{
	}
	
};
typedef _bean_ptr_t<XPACKET_DoLogin>  XPACKET_DoLoginPtr;

//--------------------------------------------------------------


class XPACKET_SendInternalNotifyByProxy:public _auto_pointer_class_base
{
public:
    static const INT _m_xcmd=_EMSG_ServerInterface::CMSG_SendInternalNotifyByProxy;

//fields

    int action;

  int get_action(){ return action ;};


public:
	static	INT   _Size(int&  action);
	static	INT   _FromBuffer(const char *__src,INT    __len,int&  action);
	static	INT   _ToBuffer(char *__dst,INT    __len,int&  action);
	INT  Size();
	INT  FromBuffer(const char *__src,INT    __len);
	INT  ToBuffer(char *__dst,INT    __len);
#if !defined(CC_TARGET_OS_IPHONE) && !defined(CC_TARGET_OS_MAC) && !defined(ANDROID)
	INT  FromXml(XP_XMLNODE_PTR pNode);
INT  ToXml(XSTRING_STREAM & out);
	#endif
	


private:


	XPACKET_SendInternalNotifyByProxy(XPACKET_SendInternalNotifyByProxy& src);//avoid bit constructor
public:
	//static int Clone(XPACKET_SendInternalNotifyByProxy* src, XPACKET_SendInternalNotifyByProxy* dst);
	

	static XPACKET_SendInternalNotifyByProxy* CreateInstance()
	{
		 XPACKET_SendInternalNotifyByProxy* p =  new (::std::nothrow) XPACKET_SendInternalNotifyByProxy();
		 return p;
	}



private:
	XPACKET_SendInternalNotifyByProxy()
	{

	}
	virtual ~XPACKET_SendInternalNotifyByProxy()
	{
	}
	
};
typedef _bean_ptr_t<XPACKET_SendInternalNotifyByProxy>  XPACKET_SendInternalNotifyByProxyPtr;

//--------------------------------------------------------------


class XPACKET_OnKickout:public _auto_pointer_class_base
{
public:
    static const INT _m_xcmd=_EMSG_ServerInterface::CMSG_OnKickout;

//fields

    int error_code;

  int get_error_code(){ return error_code ;};


public:
	static	INT   _Size(int&  error_code);
	static	INT   _FromBuffer(const char *__src,INT    __len,int&  error_code);
	static	INT   _ToBuffer(char *__dst,INT    __len,int&  error_code);
	INT  Size();
	INT  FromBuffer(const char *__src,INT    __len);
	INT  ToBuffer(char *__dst,INT    __len);
#if !defined(CC_TARGET_OS_IPHONE) && !defined(CC_TARGET_OS_MAC) && !defined(ANDROID)
	INT  FromXml(XP_XMLNODE_PTR pNode);
INT  ToXml(XSTRING_STREAM & out);
	#endif
	


private:


	XPACKET_OnKickout(XPACKET_OnKickout& src);//avoid bit constructor
public:
	//static int Clone(XPACKET_OnKickout* src, XPACKET_OnKickout* dst);
	

	static XPACKET_OnKickout* CreateInstance()
	{
		 XPACKET_OnKickout* p =  new (::std::nothrow) XPACKET_OnKickout();
		 return p;
	}



private:
	XPACKET_OnKickout()
	{

	}
	virtual ~XPACKET_OnKickout()
	{
	}
	
};
typedef _bean_ptr_t<XPACKET_OnKickout>  XPACKET_OnKickoutPtr;

//--------------------------------------------------------------


class XPACKET_SendPing:public _auto_pointer_class_base
{
public:
    static const INT _m_xcmd=_EMSG_ServerInterface::CMSG_SendPing;

//fields

    std::string time;

  std::string & get_time(){ return time ;};


public:
	static	INT   _Size(std::string&  time);
	static	INT   _FromBuffer(const char *__src,INT    __len,std::string&  time);
	static	INT   _ToBuffer(char *__dst,INT    __len,std::string&  time);
	INT  Size();
	INT  FromBuffer(const char *__src,INT    __len);
	INT  ToBuffer(char *__dst,INT    __len);
#if !defined(CC_TARGET_OS_IPHONE) && !defined(CC_TARGET_OS_MAC) && !defined(ANDROID)
	INT  FromXml(XP_XMLNODE_PTR pNode);
INT  ToXml(XSTRING_STREAM & out);
	#endif
	


private:


	XPACKET_SendPing(XPACKET_SendPing& src);//avoid bit constructor
public:
	//static int Clone(XPACKET_SendPing* src, XPACKET_SendPing* dst);
	

	static XPACKET_SendPing* CreateInstance()
	{
		 XPACKET_SendPing* p =  new (::std::nothrow) XPACKET_SendPing();
		 return p;
	}



private:
	XPACKET_SendPing()
	{

	}
	virtual ~XPACKET_SendPing()
	{
	}
	
};
typedef _bean_ptr_t<XPACKET_SendPing>  XPACKET_SendPingPtr;

//--------------------------------------------------------------


class XPACKET_SendProtoBuff:public _auto_pointer_class_base
{
public:
    static const INT _m_xcmd=_EMSG_ServerInterface::CMSG_SendProtoBuff;

//fields

   std::vector<unsigned char> data;

   std::vector<unsigned char> &get_data(){ return data ;};


public:
	static	INT   _Size(std::vector<unsigned char>&  data);
	static	INT   _FromBuffer(const char *__src,INT    __len,std::vector<unsigned char>&  data);
	static	INT   _ToBuffer(char *__dst,INT    __len,std::vector<unsigned char>&  data);
	INT  Size();
	INT  FromBuffer(const char *__src,INT    __len);
	INT  ToBuffer(char *__dst,INT    __len);
#if !defined(CC_TARGET_OS_IPHONE) && !defined(CC_TARGET_OS_MAC) && !defined(ANDROID)
	INT  FromXml(XP_XMLNODE_PTR pNode);
INT  ToXml(XSTRING_STREAM & out);
	#endif
	


private:


	XPACKET_SendProtoBuff(XPACKET_SendProtoBuff& src);//avoid bit constructor
public:
	//static int Clone(XPACKET_SendProtoBuff* src, XPACKET_SendProtoBuff* dst);
	

	static XPACKET_SendProtoBuff* CreateInstance()
	{
		 XPACKET_SendProtoBuff* p =  new (::std::nothrow) XPACKET_SendProtoBuff();
		 return p;
	}



private:
	XPACKET_SendProtoBuff()
	{

	}
	virtual ~XPACKET_SendProtoBuff()
	{
	}
	
};
typedef _bean_ptr_t<XPACKET_SendProtoBuff>  XPACKET_SendProtoBuffPtr;

//--------------------------------------------------------------


class XPACKET_OnServerErrorMessage:public _auto_pointer_class_base
{
public:
    static const INT _m_xcmd=_EMSG_ServerEvent::SMSG_OnServerErrorMessage;

//fields

    int error_code;
    std::string lpszMsg;

  int get_error_code(){ return error_code ;};
  std::string & get_lpszMsg(){ return lpszMsg ;};


public:
	static	INT   _Size(int&  error_code,std::string&  lpszMsg);
	static	INT   _FromBuffer(const char *__src,INT    __len,int&  error_code,std::string&  lpszMsg);
	static	INT   _ToBuffer(char *__dst,INT    __len,int&  error_code,std::string&  lpszMsg);
	INT  Size();
	INT  FromBuffer(const char *__src,INT    __len);
	INT  ToBuffer(char *__dst,INT    __len);
#if !defined(CC_TARGET_OS_IPHONE) && !defined(CC_TARGET_OS_MAC) && !defined(ANDROID)
	INT  FromXml(XP_XMLNODE_PTR pNode);
INT  ToXml(XSTRING_STREAM & out);
	#endif
	


private:


	XPACKET_OnServerErrorMessage(XPACKET_OnServerErrorMessage& src);//avoid bit constructor
public:
	//static int Clone(XPACKET_OnServerErrorMessage* src, XPACKET_OnServerErrorMessage* dst);
	

	static XPACKET_OnServerErrorMessage* CreateInstance()
	{
		 XPACKET_OnServerErrorMessage* p =  new (::std::nothrow) XPACKET_OnServerErrorMessage();
		 return p;
	}



private:
	XPACKET_OnServerErrorMessage()
	{

	}
	virtual ~XPACKET_OnServerErrorMessage()
	{
	}
	
};
typedef _bean_ptr_t<XPACKET_OnServerErrorMessage>  XPACKET_OnServerErrorMessagePtr;

//--------------------------------------------------------------


class XPACKET_OnSendZipData:public _auto_pointer_class_base
{
public:
    static const INT _m_xcmd=_EMSG_ServerEvent::SMSG_OnSendZipData;

//fields

   std::vector<unsigned char> zipData;

   std::vector<unsigned char> &get_zipData(){ return zipData ;};


public:
	static	INT   _Size(std::vector<unsigned char>&  zipData);
	static	INT   _FromBuffer(const char *__src,INT    __len,std::vector<unsigned char>&  zipData);
	static	INT   _ToBuffer(char *__dst,INT    __len,std::vector<unsigned char>&  zipData);
	INT  Size();
	INT  FromBuffer(const char *__src,INT    __len);
	INT  ToBuffer(char *__dst,INT    __len);
#if !defined(CC_TARGET_OS_IPHONE) && !defined(CC_TARGET_OS_MAC) && !defined(ANDROID)
	INT  FromXml(XP_XMLNODE_PTR pNode);
INT  ToXml(XSTRING_STREAM & out);
	#endif
	


private:


	XPACKET_OnSendZipData(XPACKET_OnSendZipData& src);//avoid bit constructor
public:
	//static int Clone(XPACKET_OnSendZipData* src, XPACKET_OnSendZipData* dst);
	

	static XPACKET_OnSendZipData* CreateInstance()
	{
		 XPACKET_OnSendZipData* p =  new (::std::nothrow) XPACKET_OnSendZipData();
		 return p;
	}



private:
	XPACKET_OnSendZipData()
	{

	}
	virtual ~XPACKET_OnSendZipData()
	{
	}
	
};
typedef _bean_ptr_t<XPACKET_OnSendZipData>  XPACKET_OnSendZipDataPtr;

//--------------------------------------------------------------


class XPACKET_OnPong:public _auto_pointer_class_base
{
public:
    static const INT _m_xcmd=_EMSG_ServerEvent::SMSG_OnPong;

//fields

    std::string time;

  std::string & get_time(){ return time ;};


public:
	static	INT   _Size(std::string&  time);
	static	INT   _FromBuffer(const char *__src,INT    __len,std::string&  time);
	static	INT   _ToBuffer(char *__dst,INT    __len,std::string&  time);
	INT  Size();
	INT  FromBuffer(const char *__src,INT    __len);
	INT  ToBuffer(char *__dst,INT    __len);
#if !defined(CC_TARGET_OS_IPHONE) && !defined(CC_TARGET_OS_MAC) && !defined(ANDROID)
	INT  FromXml(XP_XMLNODE_PTR pNode);
INT  ToXml(XSTRING_STREAM & out);
	#endif
	


private:


	XPACKET_OnPong(XPACKET_OnPong& src);//avoid bit constructor
public:
	//static int Clone(XPACKET_OnPong* src, XPACKET_OnPong* dst);
	

	static XPACKET_OnPong* CreateInstance()
	{
		 XPACKET_OnPong* p =  new (::std::nothrow) XPACKET_OnPong();
		 return p;
	}



private:
	XPACKET_OnPong()
	{

	}
	virtual ~XPACKET_OnPong()
	{
	}
	
};
typedef _bean_ptr_t<XPACKET_OnPong>  XPACKET_OnPongPtr;

//--------------------------------------------------------------


class XPACKET_OnProtoReponse:public _auto_pointer_class_base
{
public:
    static const INT _m_xcmd=_EMSG_ServerEvent::SMSG_OnProtoReponse;

//fields

    int error_code;
   std::vector<unsigned char> data;

  int get_error_code(){ return error_code ;};
   std::vector<unsigned char> &get_data(){ return data ;};


public:
	static	INT   _Size(int&  error_code,std::vector<unsigned char>&  data);
	static	INT   _FromBuffer(const char *__src,INT    __len,int&  error_code,std::vector<unsigned char>&  data);
	static	INT   _ToBuffer(char *__dst,INT    __len,int&  error_code,std::vector<unsigned char>&  data);
	INT  Size();
	INT  FromBuffer(const char *__src,INT    __len);
	INT  ToBuffer(char *__dst,INT    __len);
#if !defined(CC_TARGET_OS_IPHONE) && !defined(CC_TARGET_OS_MAC) && !defined(ANDROID)
	INT  FromXml(XP_XMLNODE_PTR pNode);
INT  ToXml(XSTRING_STREAM & out);
	#endif
	


private:


	XPACKET_OnProtoReponse(XPACKET_OnProtoReponse& src);//avoid bit constructor
public:
	//static int Clone(XPACKET_OnProtoReponse* src, XPACKET_OnProtoReponse* dst);
	

	static XPACKET_OnProtoReponse* CreateInstance()
	{
		 XPACKET_OnProtoReponse* p =  new (::std::nothrow) XPACKET_OnProtoReponse();
		 return p;
	}



private:
	XPACKET_OnProtoReponse()
	{

	}
	virtual ~XPACKET_OnProtoReponse()
	{
	}
	
};
typedef _bean_ptr_t<XPACKET_OnProtoReponse>  XPACKET_OnProtoReponsePtr;

//--------------------------------------------------------------


}
