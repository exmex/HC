#pragma once
#include "cocos-ext.h"
#include "cocos2d.h"
#include "CurlDownload.h"
#include "SeverConsts.h"
#include "apiforlua.h"
USING_NS_CC;
const std::string INTERNAL_ANNOUNCEMENT_FILE_DOWNLOADED = "announcementCfg.json";
const std::string INTERNAL_ANNOUNCEMENT_VERSION_KEY="internalAnnouncementVersion";
const std::string INTERNAL_ANNOUNCEMENT_DWONLOAD_TIME_KEY="internalAnnouncementDownloadTime";
class AnnouncementNewPage :public CurlDownload::DownloadListener
	, public libOSListener, public Singleton<AnnouncementNewPage>,public CCObject
{
public:
	AnnouncementNewPage(void);
	~AnnouncementNewPage(void);
	void startDown();
	void downInternalAnnouncementFile();
	void downloaded(const std::string& url,const std::string& filename);
	void downloadFailed(const std::string& url, const std::string& filename);
	virtual void update(float dt);
	static AnnouncementNewPage* getInstance();
private:
	bool isNeedDown();
	bool isInStartDown;
	int mFileErrCount;
	bool mDownloadFile;
	std::string mInternalAnnouncementFilePath;
	unsigned int mInternalAnnouncementVersion;
	void callLuaToShowAnnouncement(const std::string& announcementFile);
	float mHeight;
};