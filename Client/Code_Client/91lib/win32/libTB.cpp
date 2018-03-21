#include "..\include\libTB.h"
#include <windows.h>
#include "libOS.h"
#include "libPlatform.h"

bool libTB_mLogined = false;
DWORD libTB_mLoginTime = 0;



void libTB::init(bool privateLogin)
{
	libTB_mLogined = false;
	_boardcastUpdateCheckDone(true,"");
}
bool libTB::getLogined()
{
	if(libTB_mLoginTime>0 && timeGetTime() - libTB_mLoginTime>2000)
	{
		libTB_mLogined = true;
		//_boardcastLoginResult(true,"success");
	}
	return libTB_mLogined;
}

static std::string loginName = "";
void libTB::login()
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
	libTB_mLoginTime = timeGetTime();
	if(loginName == "")
	{
		libOS::getInstance()->registerListener(&_listener);
		libOS::getInstance()->showInputbox(false);//_InputBox(L"input your uin");
		libOS::getInstance()->removeListener(&_listener);
	}
	
}

//in win32 return a number caculated by computer name
const std::string& libTB::loginUin()
{	
	return loginName;
}
const std::string& libTB::sessionID()
{
	static TCHAR chBuf[128];
	DWORD dwRet=128;
	GetComputerName(chBuf,&dwRet);
    static std::string ret;
    ret = (char*)chBuf;
	return ret;
}
const std::string& libTB::nickName()
{
	static TCHAR chBuf[128];
	DWORD dwRet=128;
	GetComputerName(chBuf,&dwRet);
    static std::string ret;
    ret = (char*)chBuf;
	return ret;
}
void libTB::switchUsers()
{
	loginName="";
    login();
}
void libTB::logout()
{

}

void libTB::buyGoods( BUYINFO& info)
{
	MessageBox(0,L"Bought a item!!",L"shop",MB_OK);
	char ser[128];
	sprintf(ser,"%d",timeGetTime());
	info.cooOrderSerial = ser;
	_boardcastBuyinfoSent(true,info,"success");
}


void libTB::openBBS()
{
	MessageBox(0,L"open a bbs!!",L"url",MB_OK);
}

void libTB::userFeedBack()
{

}

void libTB::gamePause()
{

}

void libTB::updateApp()
{

}

void libTB::final()
{

}

const std::string libTB::getClientChannel()
{
	return "TB";
}


const unsigned int libTB::getPlatformId()
{
	return 0u;
}

std::string libTB::getPlatformMoneyName()
{
	return "tb_bi";
}
