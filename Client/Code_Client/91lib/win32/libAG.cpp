#include "..\include\libAG.h"
#include <windows.h>
#include "libOS.h"
#include "libPlatform.h"

bool libAG_mLogined = false;



void libAG::init(bool privateLogin)
{
	libAG_mLogined = false;
	_boardcastUpdateCheckDone(true,"");
}
bool libAG::getLogined()
{
	return libAG_mLogined;
}

static std::string loginName = "";
void libAG::login()
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
	libAG_mLogined = true;
	
}

//in win32 return a number caculated by computer name
const std::string& libAG::loginUin()
{	
	return loginName;
}
const std::string& libAG::sessionID()
{
	static TCHAR chBuf[128];
	DWORD dwRet=128;
	GetComputerName(chBuf,&dwRet);
    static std::string ret;
    ret = (char*)chBuf;
	return ret;
}
const std::string& libAG::nickName()
{
	static TCHAR chBuf[128];
	DWORD dwRet=128;
	GetComputerName(chBuf,&dwRet);
    static std::string ret;
    ret = (char*)chBuf;
	return ret;
}
void libAG::switchUsers()
{
	loginName="";
    login();
}
void libAG::logout()
{

}

void libAG::buyGoods( BUYINFO& info)
{
	MessageBox(0,L"Bought a item!!",L"shop",MB_OK);
	char ser[128];
	sprintf(ser,"%d",timeGetTime());
	info.cooOrderSerial = ser;
	_boardcastBuyinfoSent(true,info,"success");
}


void libAG::openBBS()
{
	MessageBox(0,L"open a bbs!!",L"url",MB_OK);
}

void libAG::userFeedBack()
{

}

void libAG::gamePause()
{

}

void libAG::updateApp()
{

}

void libAG::final()
{

}

const std::string libAG::getClientChannel()
{
	return "AG";
}

const unsigned int libAG::getPlatformId()
{
	return 0u;
}

std::string libAG::getPlatformMoneyName()
{
	return "AG_bi";
}
