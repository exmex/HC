
#include "stdafx.h"

#include "PacketManager.h"
#include "PacketBase.h"
#include "GameMaths.h"
#include "cocos2d.h"
#include "ThreadSocket.h"
#include "json/json.h"
//#include "LoginPacket.h"

#include "AsyncSocket.h"

#ifndef _UTILITY_USE_

//#include "MessageBoxPage.h"
#include "script_support/CCScriptSupport.h"
#include "CCLuaEngine.h"

#include "GamePlatform.h"
#include "Language.h"
//#include "waitingManager.h"

#else


unsigned char* getFileData(const char* pszFileName, const char* pszMode, unsigned long* pSize,bool isShowBox=true)
{
	unsigned char* pBuffer = NULL;

	*pSize = 0;
	do 
	{
		// read the file from hardware
		FILE *fp = fopen(pszFileName, pszMode);
		CC_BREAK_IF(!fp);

		fseek(fp,0,SEEK_END);
		*pSize = ftell(fp);
		fseek(fp,0,SEEK_SET);
		pBuffer = new unsigned char[*pSize];
		*pSize = fread(pBuffer,sizeof(unsigned char), *pSize,fp);
		fclose(fp);
	} while (0);
	if (! pBuffer)
	{
		std::string msg = "Get data from file(";
		msg.append(pszFileName).append(") failed!");

		CCLOG(msg.c_str());
		//add by dylan at 20131015  file not found show messagebox
		if(isShowBox)
		{
			if(isShowBox&&msg.find(".msg")==std::string::npos&&msg!=".ccbi")
			{
				if(msg.find(".")!=std::string::npos)
				{
					CCMessageBox(msg.c_str(),"File Not Found");
				}
				if(msg.find(".png")!=std::string::npos||msg.find(".PNG")!=std::string::npos)
				{
					do
					{
						// read the file from hardware
						std::string fullPath = fullPathForFilename("mainScene/empty.png");//todo:draw a pic
						FILE *fp = fopen(fullPath.c_str(), pszMode);
						CC_BREAK_IF(!fp);

						fseek(fp,0,SEEK_END);
						*pSize = ftell(fp);
						fseek(fp,0,SEEK_SET);
						pBuffer = new unsigned char[*pSize];
						*pSize = fread(pBuffer,sizeof(unsigned char), *pSize,fp);
						fclose(fp);
					} while (0);
				}
			}
		}
	}
	return pBuffer;
}

#endif

USING_NS_CC;

//AsyncSocket mySocket;

/////////////////////////////////////////////////////////////////////////////////////
//PacketManager
/////////////////////////////////////////////////////////////////////////////////////
#define PM_EVENT_FOR_LISTENER(fun) \
{ \
	std::set<PacketManagerListener*> itSet; \
	itSet.insert(mPacketManagerListenerList.begin(),mPacketManagerListenerList.end()); \
	std::set<PacketManagerListener*>::iterator itListener; \
	for(itListener = itSet.begin();itListener!=itSet.end();++itListener) \
	{ \
		(*itListener)->fun; \
	} \
} \

/*
#define PM_EVENT_FOR_HANDLE(fun) \
{ \
	PACKET_HANDLER_MAP::iterator it = mHandlers.begin();\
	for(;it != mHandlers.end();++it)\
	{\
		std::set<PacketHandler*> handlerset;\
		handlerset.insert(it->second.begin(),it->second.end());\
		std::set<PacketHandler*>& handlerset_ref = it->second;\
		std::set<PacketHandler*>::iterator hanIt = handlerset.begin();\
		for( ; hanIt!= handlerset.end(); ++hanIt)\
		{\
			(*hanIt)->fun;\
		}\
	}\
} \
*/

#define PM_EVENT_FOR_HANDLE(opcode,fun)\
{\
	PACKET_HANDLER_MAP::iterator it = mHandlers.find(opcode);\
	if(it!=mHandlers.end())\
	{\
		CCLog("[NetWork][PacketManager] PM_EVENT_FOR_HANDLE, find opcode:%d",opcode);\
		std::set<PacketHandler*> handlerset;\
		handlerset.insert(it->second.begin(),it->second.end());\
		std::set<PacketHandler*>& handlerset_ref = it->second;\
		std::set<PacketHandler*>::iterator hanIt = handlerset.begin();\
		for( ; hanIt!= handlerset.end(); ++hanIt)\
		{\
			(*hanIt)->fun;\
		}\
	}\
	else\
	{\
		CCLog("[NetWork][PacketManager] PM_EVENT_FOR_HANDLE,Can't find opcode:%d boardcast all",opcode);\
		it=mHandlers.begin();;\
		for(;it != mHandlers.end();++it)\
		{\
			std::set<PacketHandler*> handlerset;\
			handlerset.insert(it->second.begin(),it->second.end());\
			std::set<PacketHandler*>& handlerset_ref = it->second;\
			std::set<PacketHandler*>::iterator hanIt = handlerset.begin();\
			for( ; hanIt!= handlerset.end(); ++hanIt)\
			{\
				(*hanIt)->fun;\
			}\
		}\
	}\
}\


PacketManager::PacketManager(void)
	:needReConnect(false)
	,mPMState(PM_UnInit)
	,mLoginTimer(0)
	,mReconnectCount(0)
	,mReloginCount(0)
{
	ThreadSocket::Get()->registerSocketListener(this);
}


PacketManager::~PacketManager(void)
{
	disconnect();
}

PacketManager* PacketManager::getInstance()
{
	return PacketManager::Get();
}

void PacketManager::init(const std::string& configFile)
{
	std::string ip = "127.0.0.1";
	int port = 9999;
	if(configFile!="")
	{

		Json::Reader jreader;
		Json::Value root;
		unsigned long filesize;
		unsigned short crc = 0;

#ifndef _UTILITY_USE_
		char* pBuffer = (char*)getFileData(cocos2d::CCFileUtils::sharedFileUtils()->fullPathForFilename(configFile.c_str()).c_str(),"rt",&filesize,&crc,false);
#else
		char* pBuffer = (char*)getFileData((const char*)configFile.c_str(),"rt",&filesize,&crc,false);
#endif
		if(!pBuffer)
		{
			char msg[256];
			sprintf(msg,"Failed open net config file: %s !!",configFile.c_str());
			cocos2d::CCMessageBox(msg,Language::Get()->getString("@ShowMsgBoxTitle").c_str());
		}
		else
		{
			jreader.parse(pBuffer,root,false);
			CC_SAFE_DELETE_ARRAY(pBuffer);

			if(root["version"].asInt()<=1)
			{
				ip = root["ip"].asString();
				port = root["port"].asInt();
			}
		}
		CC_SAFE_DELETE_ARRAY(pBuffer);
	}

	init(ip.c_str(),port);
}

void PacketManager::init( const std::string& ip, int port )
{
	CCLog("[NetWork] [PacketManager::init] ip = %s, port = %d",ip.c_str(), port);
	ThreadSocket::Get()->disconnect();
	ThreadSocket::Get()->connect(ip.c_str(),port);
	
	PM_EVENT_FOR_LISTENER(onConnection())
	setPmState(PM_Connecting);
}

void PacketManager::update( float dt )
{
	if(getPmState() == PM_UnInit) return;
	ThreadSocket::Get()->update();
}

void PacketManager::disconnect()
{
	CCLog("[NetWork] [PacketManager::disconnect]");

	ThreadSocket::Get()->disconnect();
	
	PM_EVENT_FOR_LISTENER(onDisConnection())
	
	setPmState(PM_Init);
}

void PacketManager::reconnect()
{
	if(getPmState() == PM_UnInit) 
	{
		CCLog("[NetWork] [PacketManager::reconnect] error! statt = PM_UnInit");
		return;
	}

	mReconnectCount++;
	if(mReconnectCount > 5)
	{
		CCLog("[NetWork] [PacketManager::reconnect] ReconnectCount over limit");

		PM_EVENT_FOR_LISTENER(onReConnectionError());

		setPmState(PM_ReConnectError);
		mReconnectCount = 0;
		return;
	}

	CCLog("[NetWork] [PacketManager::reconnect]");

	ThreadSocket::Get()->reconnect();

	PM_EVENT_FOR_LISTENER(onReConnection())

	setPmState(PM_ReConnecting);
}

void PacketManager::relogin()
{
	/*
	if(mLoginInfo.mRecOpcode == 0)
	{
		CCLOG("[NetWork] [PacketManager::relogin] error! LoginInfo RecOpcode = 0");
		setPmState(PM_Connected);
		return;
	}

	mReloginCount++;
	if(mReloginCount > 5)
	{
		CCLOG("[NetWork] [PacketManager::relogin] reloginCount over limit");

		PM_EVENT_FOR_LISTENER(onReLoginError());

		setPmState(PM_ReLogingError);
		mReloginCount == 0;
		return;
	}

	CCLOG("[NetWork] [PacketManager::relogin]");

	_sendPakcet(mLoginInfo);

	needReConnect = false;

	PM_EVENT_FOR_LISTENER(onReLogin())

	setPmState(PM_ReLoging);
	*/
}

void PacketManager::sendPakcet( int opcode, ::google::protobuf::Message* msg, bool needWaiting/*=true*/, int targetOpcode/*=0*/)
{
	//先注释，不需要，影响编译，google的protobuf删除，导致编译不过
	/*PM_EVENT_FOR_LISTENER(onPreSend(opcode,msg,needWaiting))
	if(targetOpcode==0)
	{
	targetOpcode=opcode+1;
	}
	setPacketOpcodeWaitReason(opcode,targetOpcode);

	std::string debugstr = msg->DebugString();
	std::string outStr;
	GameMaths::replaceStringWithCharacter(debugstr,'\n',' ',outStr);

	CCLOG("[Network][PacketManager::sendPakcet]|send packet! opcode:%d waiting opcode:%d,message:%s",opcode,targetOpcode,outStr.c_str());

	PacketBase* pack = createPacket(opcode);
	int size;
	void* buffer = pack->PackPacket(size,msg);
	ThreadSocket::PacketData data;
	data.buffer=buffer;
	data.length = size;
	ThreadSocket::Get()->sendPacket(data,opcode);
	delete pack;

	PM_EVENT_FOR_LISTENER(onPostSend(opcode,msg,needWaiting,targetOpcode))*/
}

void PacketManager::sendPakcet( int opcode, char* buff, int length, bool needWaiting )
{
	//先注释，不需要，影响编译，google的protobuf删除，导致编译不过
	/*PM_EVENT_FOR_LISTENER(onPreSend(opcode,buff,length,needWaiting))
	setPacketOpcodeWaitReason(opcode);
	ThreadSocket::PacketData data;
	if(length == 0)length = strlen(buff);
	std::string str(buff,length);
	void*buffGen = PacketBase::PackPacket(opcode,data.length,str);
	data.buffer = new char[data.length+1];
	memcpy(data.buffer,buffGen,data.length);
	((char*)data.buffer)[data.length]=0;
	CCLOG("[Network][PacketManager::sendPakcet]|send packet! opcode:%d waiting opcode:%d message is in lua",opcode,opcode+1);
	ThreadSocket::Get()->sendPacket(data,opcode);
	delete (char*)buffGen;
	
	PM_EVENT_FOR_LISTENER(onPostSend(opcode,buff,length,needWaiting))*/
}

void PacketManager::onReceivePacket( void* buffer, int len )
{
	//先注释，不需要，影响编译，google的protobuf删除，导致编译不过
	//CCLOG("[Network][PacketManager::onReceivePacket]|PacketManager::_onReceivedPacket| ReceivedPacket size:%d", len);
	//static char left_buf[PacketManager::DEFAULT_BUFFER_LENGTH];
	//static int left_len = 0;

	//if(len <= 0)
	//	return;

	//char _buff[PacketManager::DEFAULT_BUFFER_LENGTH];
	//char* rec = _buff;
	//int rec_len = 0;
	//if(left_len != 0)
	//{
	//	memcpy( rec, left_buf, left_len);
	//	rec_len += left_len;
	//	memset(left_buf, 0, sizeof(left_buf));
	//	left_len = 0;
	//}
	//memcpy( rec + rec_len, buffer, len);
	//rec_len += len;

	//do 
	//{
	//	//modify by dylan nuclear project at 20140226
	//	if(rec[0] != 0x5d || rec[1] != 0x6b)
	//	{
	//		CCLOG("PacketManager::_onReceivedPacket | rec[0] != 0x5d || rec[1] != 0xc3 , disconnect!");
	//		disconnect();
	//		return ;
	//	}

	//	int size,opcode;
	//	memcpy(&opcode,rec+2,4);
	//	//add by zhenhui for the zlib compress flag
	//	//reserve 1byte
	//	char cReserve;
	//	memcpy(&cReserve,rec+6,1);
	//	//compress 1byte
	//	char cCompress;
	//	memcpy(&cCompress,rec+7,1);

	//	memcpy(&size,rec+8,4);
	//	size = ReverseAuto<int>(size);
	//	opcode = ReverseAuto<int>(opcode);
	//	int packSize = size + PacketHead;

	//	CCLOG("PacketManager::_onReceivedPacket opcode:%d size:%d,rec_len:%d,",opcode,packSize,rec_len);
	//	if(packSize>DEFAULT_BUFFER_LENGTH || rec_len>DEFAULT_BUFFER_LENGTH || packSize<PacketHead)
	//	{
	//		CCLOG("packSize>DEFAULT_BUFFER_LENGTH || rec_len>DEFAULT_BUFFER_LENGTH || packSize<PacketHead || packSize:%d,rec_len:%d,",packSize,rec_len);
	//		return;
	//	}
	//	
	//	if(rec_len < packSize)
	//	{
	//		CCLOG("ReceivedPacket len:%d < packSize:%d opcode:%d", rec_len, packSize, opcode);

	//		memcpy(left_buf+left_len, rec, rec_len);
	//		left_len += rec_len;
	//		break;
	//	}
	//	else
	//	{
	//		CCLog("Do ReceivedPacket packSize:%d opcode:%d", packSize, opcode);
	//		PacketBase* pack = createPacket(opcode);
	//		if(pack)
	//		{
	//			if(pack->UnpackPacket(rec + PacketHead,size,cCompress))
	//				_boardcastPacketToHandler(pack->getOpcode(), pack->getMessage(), pack->getInfoString());
	//			else
	//			{
	//				char out[128];
	//				sprintf(out,"Network error!\nFailed to create packet! \nopcode:%d",opcode);
	//				CCMessageBox(out,"error");
	//			}
	//		}
	//		else
	//		{
	//			_boardcastPacketToHandler(opcode, NULL, PacketBase::UnpackPacket(opcode, rec + PacketHead, size,cCompress));
	//		}
	//		if(pack)
	//			delete pack;

	//		rec += packSize;
	//		rec_len -= packSize;
	//	}

	//} while (rec_len > 0);
}

void PacketManager::_checkReceivePacket()
{
//	char rec[DEFAULT_BUFFER_LENGTH];
//	int len = mySocket.onReceive(rec,DEFAULT_BUFFER_LENGTH);
//	_onReceivedPacket(rec,len);
}

PacketBase* PacketManager::createPacket( int opcode )
{
	PACKET_FACTORY_MAP::iterator it = mFactories.find(opcode);
	if(it==mFactories.end())
	{
		CCLog("Can't find Packet Factory Name !");
		return 0;
	}
	return it->second->createPacket();
}

bool PacketManager::_registerPacketFactory( int opcode, const std::string& packetName, PacketFactoryBase* fac)
{
	CCAssert(mFactories.find(opcode)==mFactories.end(),"Packet Factory Name REDEFINED!!!");
	mFactories.insert(std::make_pair(opcode,fac));
	mNameToOpcode.insert(std::make_pair(packetName,opcode));
	return true;
}

bool PacketManager::registerPacketHandler( int opcode,PacketHandler* handler)
{
	if(handler == 0)
		return false;
	PACKET_HANDLER_MAP::iterator it = mHandlers.find(opcode);
	if(it == mHandlers.end())
	{
		std::set<PacketHandler*> sec;
		sec.insert(handler);
		mHandlers.insert(std::make_pair(opcode,sec));
	}
	else 
	{
		std::set<PacketHandler*>& handlerset = it->second;
		if(handlerset.find(handler)==handlerset.end())
			handlerset.insert(handler);
	}
	return true;
}


void PacketManager::_boardcastPacketToHandler( int id, const ::google::protobuf::Message* msg, const std::string& msgStr)
{
	if(msg == 0 && msgStr.empty())
		return ;
	
	/*
	std::set<PacketManagerListener*> itSet;
	itSet.insert(mPacketManagerListenerList.begin(),mPacketManagerListenerList.end());
	std::set<PacketManagerListener*>::iterator itListener;
	for(itListener = itSet.begin();itListener!=itSet.end();++itListener)
	{
		(*itListener)->onBoardcastPacketToHandler(id,msg,msgStr);
	}
	*/

	PM_EVENT_FOR_LISTENER(onBoardcastPacketToHandler(id,msg,msgStr))

	PACKET_HANDLER_MAP::iterator it = mHandlers.find(id);
	if(it != mHandlers.end())
	{
		std::set<PacketHandler*> handlerset;
		handlerset.insert(it->second.begin(),it->second.end());

		std::set<PacketHandler*>& handlerset_ref = it->second;
		std::set<PacketHandler*>::reverse_iterator hanIt = handlerset.rbegin();
		for( ; hanIt!= handlerset.rend(); ++hanIt)
		{
			if(handlerset_ref.find(*hanIt)!=handlerset_ref.end())
			{
				if( (*hanIt)->getHandleType() == PacketHandler::Default_Handler )
				{
					if(msg!=0)
						(*hanIt)->onReceivePacket(id,msg);
				}
				else if(!msgStr.empty() && (*hanIt)->getHandleType() == PacketHandler::Scripty_Handler)
					(*hanIt)->onReceivePacket(id,msgStr);
				else
					(*hanIt)->onReceivePacket(id,msg);
			}
		}
	}
}

void PacketManager::_boardcastConnectionFailed(std::string ip, int port)
{
	/*
	std::set<PacketManagerListener*> itSet;
	itSet.insert(mPacketManagerListenerList.begin(),mPacketManagerListenerList.end());
	std::set<PacketManagerListener*>::iterator itListener;
	for(itListener = itSet.begin();itListener!=itSet.end();++itListener)
	{
		(*itListener)->onBoardcastConnectionFailed(ip,port);
	}
	*/

	PM_EVENT_FOR_LISTENER(onBoardcastConnectionFailed(ip,port))
	/*
	PACKET_HANDLER_MAP::iterator it =mHandlers.begin();;
	for(;it != mHandlers.end();++it)
	{
		std::set<PacketHandler*> handlerset;
		handlerset.insert(it->second.begin(),it->second.end());

		std::set<PacketHandler*>& handlerset_ref = it->second;
		std::set<PacketHandler*>::iterator hanIt = handlerset.begin();
		for( ; hanIt!= handlerset.end(); ++hanIt)
		{
			(*hanIt)->onConnectFailed(ip,port);
		}
	}
	*/
	PM_EVENT_FOR_HANDLE(0,onConnectFailed(ip,port))

	CCLog("ConnectionFailed! ip:%s port:%d",ip.c_str(),port);
}

void PacketManager::_boardcastSendFailed( int opcode)
{
	/*
	std::set<PacketManagerListener*> itSet;
	itSet.insert(mPacketManagerListenerList.begin(),mPacketManagerListenerList.end());
	std::set<PacketManagerListener*>::iterator itListener;
	for(itListener = itSet.begin();itListener!=itSet.end();++itListener)
	{
		(*itListener)->onBoardcastSendFailed(opcode);
	}
	*/

	PM_EVENT_FOR_LISTENER(onBoardcastSendFailed(opcode))

	/*
	PACKET_HANDLER_MAP::iterator it = mHandlers.begin();
	for(;it != mHandlers.end();++it)
	{
		//此处onSendPacketFailed 是全量opcode通知, why it->first==opcode? dylan
		std::set<PacketHandler*> handlerset;
		handlerset.insert(it->second.begin(),it->second.end());

		std::set<PacketHandler*>& handlerset_ref = it->second;
		std::set<PacketHandler*>::iterator hanIt = handlerset.begin();
		for( ; hanIt!= handlerset.end(); ++hanIt)
		{
			(*hanIt)->onSendPacketFailed(opcode);
		}
	}
	*/
	PM_EVENT_FOR_HANDLE(getPacketWaitOpcode(opcode),onSendPacketFailed(opcode))

	CCLOG("PacketManager::_boardcastSendFailed | SendFailed! opcode:%d",opcode);
}

void PacketManager::_boardcastReceiveFailed()
{
	/*
	std::set<PacketManagerListener*> itSet;
	itSet.insert(mPacketManagerListenerList.begin(),mPacketManagerListenerList.end());
	std::set<PacketManagerListener*>::iterator itListener;
	for(itListener = itSet.begin();itListener!=itSet.end();++itListener)
	{
		(*itListener)->onBoardcastReceiveFailed();
	}
	*/
	PM_EVENT_FOR_LISTENER(onBoardcastReceiveFailed())
	/*
	PACKET_HANDLER_MAP::iterator it = mHandlers.begin();
	for(;it != mHandlers.end();++it)
	{
		std::set<PacketHandler*> handlerset;
		handlerset.insert(it->second.begin(),it->second.end());

		std::set<PacketHandler*>& handlerset_ref = it->second;
		std::set<PacketHandler*>::iterator hanIt = handlerset.begin();
		for( ; hanIt!= handlerset.end(); ++hanIt)
		{
			(*hanIt)->onReceivePacketFailed();
		}
	}
	*/
	PM_EVENT_FOR_HANDLE(0,onReceivePacketFailed())

	CCLOG("PacketManager::_boardcastReceiveFailed() ReceiveFailed!");
}

void PacketManager::_boardcastReceiveTimeout(int opcode)
{
	CCLOG("PacketManager::_boardcastReceiveTimeout | ReceiveTimeout! opcode:%d",opcode);
	/*
	std::set<PacketManagerListener*> itSet;
	itSet.insert(mPacketManagerListenerList.begin(),mPacketManagerListenerList.end());
	std::set<PacketManagerListener*>::iterator itListener;
	for(itListener = itSet.begin();itListener!=itSet.end();++itListener)
	{
		(*itListener)->onBoardcastReceiveTimeout(opcode);
	}
	*/
	PM_EVENT_FOR_LISTENER(onBoardcastReceiveTimeout(opcode))
	
	/*
	PACKET_HANDLER_MAP::iterator it = mHandlers.begin();
	for(;it != mHandlers.end();++it)
	{
		std::set<PacketHandler*> handlerset;
		handlerset.insert(it->second.begin(),it->second.end());

		std::set<PacketHandler*>& handlerset_ref = it->second;
		std::set<PacketHandler*>::iterator hanIt = handlerset.begin();
		for( ; hanIt!= handlerset.end(); ++hanIt)
		{
			(*hanIt)->onTimeout(opcode);
		}
	}
	*/
	PM_EVENT_FOR_HANDLE(opcode,onTimeout(opcode))
}

void PacketManager::_boardcastPacketError( int opcode,const std::string &errmsg)
{
	/*
	std::set<PacketManagerListener*> itSet;
	itSet.insert(mPacketManagerListenerList.begin(),mPacketManagerListenerList.end());
	std::set<PacketManagerListener*>::iterator itListener;
	for(itListener = itSet.begin();itListener!=itSet.end();++itListener)
	{
		(*itListener)->onBoardcastPacketError(opcode,errmsg);
	}
	*/

	PM_EVENT_FOR_LISTENER(onBoardcastPacketError(opcode,errmsg))

	/*
	PACKET_HANDLER_MAP::iterator it = mHandlers.begin();
	for(;it != mHandlers.end();++it)
	{
		std::set<PacketHandler*> handlerset;
		handlerset.insert(it->second.begin(),it->second.end());

		std::set<PacketHandler*>& handlerset_ref = it->second;
		std::set<PacketHandler*>::iterator hanIt = handlerset.begin();
		for( ; hanIt!= handlerset.end(); ++hanIt)
		{
			(*hanIt)->onPacketError(opcode);
		}
	}
	*/
	PM_EVENT_FOR_HANDLE(getPacketWaitOpcode(opcode),onPacketError(opcode))
// #ifndef _UTILITY_USE_
// 
//	MSG_BOX_LAN("@ReceivedTimeout");
// #endif
}

void PacketManager::removePacketHandler(int opcode, PacketHandler* messagehandler)
{
	if(messagehandler == 0)
		return;

	PACKET_HANDLER_MAP::iterator it = mHandlers.find(opcode);
	if(it != mHandlers.end())
	{//modify by dylan at 20130717 HZW-1764
		std::set<PacketHandler*>& handlerset = it->second;
		if(handlerset.find(messagehandler) != handlerset.end())
			handlerset.erase(messagehandler);
	}
}

void PacketManager::removePacketHandler(PacketHandler* messagehandler)
{
	if(messagehandler == 0)
		return;

	PACKET_HANDLER_MAP::iterator it = mHandlers.begin();
	for(;it!=mHandlers.end();++it)
	{
		std::set<PacketHandler*>& handlerset = it->second;
		if(handlerset.find(messagehandler)!= handlerset.end())
		{
			handlerset.erase(messagehandler);
		}
	}
}

int PacketManager::nameToOpcode( const std::string& name )
{
	int ret = -1;
	NAME_TO_OPCODE_MAP::iterator it = mNameToOpcode.find(name);
	if(it!=mNameToOpcode.end())
		ret = it->second;
	return ret;
}

bool PacketManager::_buildDefaultMessage( int opcode, ::google::protobuf::Message* msg)
{
	mDefaultMessageMap.insert(std::make_pair(opcode,msg));
	return true;
}

::google::protobuf::Message* PacketManager::_getDefaultMessage( int opcode )
{
	DEFAULT_MESSAGE_MAP::iterator it = mDefaultMessageMap.find(opcode);
	if(it!=mDefaultMessageMap.end())
	{
		return it->second;
	}
	return 0;
}

bool PacketManager::registerPacketSendListener( PacketManagerListener* listener)
{
	if(mPacketManagerListenerList.find(listener) == mPacketManagerListenerList.end())
		mPacketManagerListenerList.insert(listener);
	return true;
}

void PacketManager::removePacketSendListener( PacketManagerListener* listener)
{
	if(mPacketManagerListenerList.find(listener)!=mPacketManagerListenerList.end())
		mPacketManagerListenerList.erase(listener);
}

/*
void PacketManager::onReceivePacket(unsigned int opcode, const std::string& msgStr )
{
	CCLOG("[NetWork] [PacketManager::onReceivePacket] opcode = %d, msgStr = %s",opcode, msgStr.c_str());

	if ((getPmState() == PM_Loging ||getPmState() == PM_ReLoging) && opcode == mLoginInfo.mRecOpcode)
	{
		//isReConnect = false;
		FIRE_EVENT_FOR_LISTENER(onLoginSuccuss());
		setPmState(PM_Logined);
		mReloginCount = 0;
		needReConnect = false;
	}
	_boardcastReceive(opcode, msgStr);
}
*/
void PacketManager::onReceiveFailed()
{
	CCLOG("[NetWork] [PacketManager::onReceiveFailed]");
	/*
	if ((getPmState() == PM_Loging ||getPmState() == PM_ReLoging))
	{
		if (getPmState() == PM_Loging)
		{
			PM_EVENT_FOR_LISTENER(onLoginError());
			setPmState(PM_LogingError);
		}
		else if(getPmState() == PM_ReLoging)
		{
			PM_EVENT_FOR_LISTENER(onReLoginError());
			reconnect();
		}
		return;
	}
	*/
	//reconnect();
	_boardcastReceiveFailed();
}

void PacketManager::onSendFailed(unsigned int opcode )
{
	CCLOG("[NetWork] [PacketManager::onSendFailed] opcode = %d ",opcode);
	/*
	if ((getPmState() == PM_Loging ||getPmState() == PM_ReLoging))
	{
		if (getPmState() == PM_Loging)
		{
			PM_EVENT_FOR_LISTENER(onLoginError());
			setPmState(PM_LogingError);
		}
		else if(getPmState() == PM_ReLoging)
		{
			PM_EVENT_FOR_LISTENER(onReLoginError());
			reconnect();
		}
		return;
	}
	*/
	reconnect();
	_boardcastSendFailed(opcode);
}

void PacketManager::onConnectionFailed( std::string ip, unsigned int port )
{
	CCLOG("[NetWork] [PacketManager::onConnectionFailed] ip = %s, port = %d",ip.c_str(), port);

	if(getPmState() == PM_Connecting)
	{
		PM_EVENT_FOR_LISTENER(onConnectionError());
		setPmState(PM_ConnectError);
	}
	else if(getPmState() == PM_ReConnecting)
	{
		reconnect();
	}
}

void PacketManager::onConnectionSuccess( std::string ip, unsigned int port )
{
	CCLOG("[NetWork] [PacketManager::onConnectionSuccuss] ip = %s, port = %d",ip.c_str(), port);

	PM_EVENT_FOR_LISTENER(onConnectionSuccess());
	
	if(getPmState() == PM_Connecting)
	{
		setPmState(PM_Connected);
	}
	else if(getPmState() == PM_ReConnecting)
	{
		setPmState(PM_ReConnected);
	}
	mReconnectCount = 0;
}

void PacketManager::setPmState( PM_STATE state )
{
	CCLOG("PacketManager Change state = %d", state);
	mPMState = state;
}

void PacketManager::setPacketOpcodeWaitReason(int opcode,int targetOpcode)
{
	if(targetOpcode==0)
	{
		targetOpcode=opcode+1;
	}
	PACKET_WAIT_OPCODE_MAP::iterator it=mWaitReason.find(opcode);
	if(it!=mWaitReason.end())
	{
		if(it->second!=targetOpcode&&targetOpcode!=(opcode+1))
		{
			it->second=targetOpcode;
		}
	}
	else
	{
		mWaitReason.insert(std::make_pair(opcode,targetOpcode));
	}
}

int PacketManager::getPacketWaitOpcode(int opcode)
{
	PACKET_WAIT_OPCODE_MAP::iterator it=mWaitReason.find(opcode);
	if(it!=mWaitReason.end())
	{
		return it->second;
	}
	return opcode+1;
}

#ifndef _UTILITY_USE_
#define RUN_SCRIPT_FUN(funname) \
	if(mScriptFunHandler) \
{ \
	cocos2d::CCLuaEngine* pEngine = cocos2d::CCLuaEngine::defaultEngine(); \
	pEngine->executeEvent(mScriptFunHandler,funname,this,"PacketScriptHandler"); \
}
#else
#define RUN_SCRIPT_FUN(funname) 
#endif
PacketScriptHandler::PacketScriptHandler( int opcode, int nHandler ) : mRecOpcode(opcode)
	, mScriptFunHandler(nHandler)
{
	PacketManager::Get()->registerPacketHandler(mRecOpcode,this);
}

PacketScriptHandler::~PacketScriptHandler()
{
	PacketManager::Get()->removePacketHandler(mRecOpcode,this);

	if (mScriptFunHandler)
	{
		CCScriptEngineManager::sharedManager()->getScriptEngine()->removeScriptHandler(mScriptFunHandler);
		mScriptFunHandler = 0;
	}
}

void PacketScriptHandler::onReceivePacket( const int opcode, const ::google::protobuf::Message* packet )
{
	//先注释，不需要，影响编译，google的protobuf删除，导致编译不过
	/*std::string str;
	packet->SerializeToString(&str);

	mPktBuffer = str;
	mRecOpcode = opcode;

	RUN_SCRIPT_FUN("luaReceivePacket");*/
}

void PacketScriptHandler::onReceivePacket( const int opcode, const std::string& str )
{
	mPktBuffer = str;
	mRecOpcode = opcode;

	RUN_SCRIPT_FUN("luaReceivePacket");
}

void PacketScriptHandler::onSendPacketFailed( const int opcode )
{
	RUN_SCRIPT_FUN("luaSendPacketFailed");
}

void PacketScriptHandler::onConnectFailed( std::string ip, int port )
{
	RUN_SCRIPT_FUN("luaConnectFailed");
}

void PacketScriptHandler::onTimeout( const int opcode )
{
	RUN_SCRIPT_FUN("luaTimeout");
}

void PacketScriptHandler::onPacketError( const int opcode )
{
	RUN_SCRIPT_FUN("luaPacketError");
}
