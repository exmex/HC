#include "..\include\libPP.h"
#include <windows.h>
#include "libOS.h"
#include "libPlatform.h"

bool libPP_mLogined = false;



void libPP::init(bool privateLogin)
{
	libPP_mLogined = false;
	_boardcastUpdateCheckDone(true,"");
}
bool libPP::getLogined()
{
	return libPP_mLogined;
}

static std::string loginName = "";
void libPP::login()
{
	class myListener: public libOSListener
	{
	public:
		virtual void onInputboxEnter(const std::string& content)
		{
			loginName = content;
			libPlatformManager::getPlatform()->_boardcastLoginResult(true,"");
		}
	}_listener;
	while(loginName == "")
	{
		libOS::getInstance()->registerListener(&_listener);
		libOS::getInstance()->showInputbox(false);//_InputBox(L"input your uin");
		libOS::getInstance()->removeListener(&_listener);
	}
	libPP_mLogined = true;
	
}

//in win32 return a number caculated by computer name
const std::string& libPP::loginUin()
{	
	return loginName;
}
const std::string& libPP::sessionID()
{
	static TCHAR chBuf[128];
	DWORD dwRet=128;
	GetComputerName(chBuf,&dwRet);
    static std::string ret;
    ret = (char*)chBuf;
	return ret;
}
const std::string& libPP::nickName()
{
	static TCHAR chBuf[128];
	DWORD dwRet=128;
	GetComputerName(chBuf,&dwRet);
    static std::string ret;
    ret = (char*)chBuf;
	return ret;
}
void libPP::switchUsers()
{
	loginName="";
    login();
}
void libPP::logout()
{

}

void libPP::buyGoods( BUYINFO& info)
{
	MessageBox(0,L"Bought a item!!",L"shop",MB_OK);
	char ser[128];
	sprintf(ser,"%d",timeGetTime());
	info.cooOrderSerial = ser;
	_boardcastBuyinfoSent(true,info,"success");
}


void libPP::openBBS()
{
	MessageBox(0,L"open a bbs!!",L"url",MB_OK);
}

void libPP::userFeedBack()
{

}

void libPP::gamePause()
{

}

void libPP::updateApp()
{

}

void libPP::final()
{

}

const std::string libPP::getClientChannel()
{
	return "PP";
}

const unsigned int libPP::getPlatformId()
{
	return 0u;
}

std::string libPP::getPlatformMoneyName()
{
	return "PP_bi";
}
