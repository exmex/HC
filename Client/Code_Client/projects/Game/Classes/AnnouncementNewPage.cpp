#include "stdafx.h"
#include "AnnouncementNewPage.h"
#include "StringConverter.h"
#include "libOS.h"
#include "GamePlatform.h"
#include "SeverConsts.h"
#include "../../../include/jsoncpp/json/json.h"
USING_NS_CC;
USING_NS_CC_EXT;


AnnouncementNewPage::AnnouncementNewPage(void)
{
	mDownloadFile=false;
	CCDirector::sharedDirector()->getScheduler()->scheduleUpdateForTarget(this, 0, false);
	mFileErrCount=0;
}


AnnouncementNewPage::~AnnouncementNewPage(void)
{
	mDownloadFile=false;
	mFileErrCount=0;
}
void AnnouncementNewPage::update(float dt)
{
	if (mDownloadFile)
	{
		CurlDownload::Get()->update(0);
	}
}

/*
void AnnouncementNewPage::Exit( MainFrame* )
{
	isInStartDown=false;
	mDownloadFile=false;
	mFileErrCount=0;
	libOS::getInstance()->removeListener(this);
	CurlDownload::Get()->removeListener(this);
}
*/
AnnouncementNewPage* AnnouncementNewPage::getInstance()
{
	return AnnouncementNewPage::Get();
}
void AnnouncementNewPage::startDown()
{
	
	if (mDownloadFile)
	{
		return;
	}
	mDownloadFile = true;
	libOS::getInstance()->registerListener(this);
	CurlDownload::Get()->addListener(this);
	downInternalAnnouncementFile();

}

void AnnouncementNewPage::downInternalAnnouncementFile()
{
	mInternalAnnouncementFilePath=SeverConsts::Get()->getInternalAnnouncementFilePath();
	if(mInternalAnnouncementFilePath=="")
	{
		CCLOG("announcement file name is null-----error");
	}
	else
	{
		std::string desFile(cocos2d::CCFileUtils::sharedFileUtils()->getWritablePath());
		desFile=desFile+"/"+INTERNAL_ANNOUNCEMENT_FILE_DOWNLOADED;
		if (isNeedDown())
		{
			remove(cocos2d::CCFileUtils::sharedFileUtils()->fullPathForFilename(desFile.c_str()).c_str());
			CurlDownload::Get()->downloadFile(mInternalAnnouncementFilePath, desFile);
		}
		else
		{
			mDownloadFile = false;
			callLuaToShowAnnouncement(desFile);
		}
		
	}
}


void AnnouncementNewPage::downloaded( const std::string& url,const std::string& filename )
{
	if(url.find(mInternalAnnouncementFilePath)!=url.npos)
	{
		mDownloadFile=false;
		//下载成功了，保存一些东西吧
		cocos2d::CCUserDefault::sharedUserDefault()->setIntegerForKey(INTERNAL_ANNOUNCEMENT_VERSION_KEY.c_str(), SeverConsts::Get()->getInternalAnnouncementVersion());
		//下载时间，以秒为单位
		struct cc_timeval now;
		if (CCTime::gettimeofdayCocos2d(&now, NULL) != 0)
		{
			CCMessageBox("Error in gettimeofday", "error");
			return;
		}
		cocos2d::CCUserDefault::sharedUserDefault()->setIntegerForKey(INTERNAL_ANNOUNCEMENT_DWONLOAD_TIME_KEY.c_str(), now.tv_sec);
		cocos2d::CCUserDefault::sharedUserDefault()->flush();
		callLuaToShowAnnouncement(filename);
	}
}

void AnnouncementNewPage::downloadFailed( const std::string& url, const std::string& filename )
{
	if(url.find(mInternalAnnouncementFilePath)!=url.npos)
	{
		mDownloadFile = false;
		
		//下载公告失败
		showAnnouncementDownloadFailed();
	}
}

void AnnouncementNewPage::callLuaToShowAnnouncement(const std::string& announcementFile)
{
	//modify by cooper.x
	unsigned long len = 0;
	unsigned  char* pBuffer = (CCFileUtils::sharedFileUtils()->getFileData(announcementFile.c_str(), "rt", &len));

	if (pBuffer)
	{
		Json::Value root;
		Json::Reader jreader;
		Json::Value data;
		bool openSuccessful = true;
		std::string str((char*)pBuffer, len);
		openSuccessful = jreader.parse(str, data, false);
		if (openSuccessful)
		{
			Json::Value msgStr = data["announcementConfig"];
			std::string annStr = "";
			for (int i = 0; i < msgStr.size(); ++i)
			{
				annStr += data["announcementConfig"][i]["Msg"].asString();
			}
			if (str != "")
			{
				showAnnouncement2(annStr);
			}
		}
		/*if (pBuffer != 0 && len != 0)
		{
		showAnnouncement(std::string((char*)pBuffer));
		}*/
		delete[]pBuffer;
	}
}
/************************************************************************/
/* //版本号变更后或者距离上次获取公告时间超过30分钟后重新获取           */
/************************************************************************/
bool AnnouncementNewPage::isNeedDown()
{
	bool ret = true;
	unsigned int lastDownloadTime = CCUserDefault::sharedUserDefault()->getIntegerForKey(INTERNAL_ANNOUNCEMENT_DWONLOAD_TIME_KEY.c_str(), -2000);
	struct cc_timeval now;
	if (CCTime::gettimeofdayCocos2d(&now, NULL) != 0)
	{
		CCMessageBox("Error in gettimeofday", "error");
		return ret;
	}
	unsigned int intervalTime = now.tv_sec - lastDownloadTime;
	unsigned int localCacheVersion = CCUserDefault::sharedUserDefault()->getIntegerForKey(INTERNAL_ANNOUNCEMENT_VERSION_KEY.c_str(), 0);
	//版本号变更后或者距离上次获取公告时间超过10分钟后重新获取
	if (SeverConsts::Get()->getInternalAnnouncementVersion() > localCacheVersion || intervalTime > 0 && (intervalTime / 60) > 10)
	{
		ret = true;
	}
	else
	{
		ret = false;
	}
	return ret;
}