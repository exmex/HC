#pragma once

/** 

config file example:
----------verson.cfg---------

{  
"version": 1,  
"localVerson" : "1.0.0",
"sever":  "127.0.0.1/verson91/sever.cfg",
"inStoreUpdate": "http://www.baidu.com"
}

sever file example:
----------sever.cfg(http://127.0.0.1/verson91/sever.cfg)----------

{  
"version": 1,
"severVerson":"1.0.1",
"updateAddress":"http://localhost:8080/verson91/update.cfg", 
"rootAddress" : "http://localhost:8080/verson91/", 
"defaultSeverID" : 1,
"severs" :
[
{"id":1, "name":"一帆风顺" , "address":"127.0.0.1", "port":9999, "state":"full"},
{"id":2, "name":"传到桥头" , "address":"127.0.0.1", "port":9998, "state":"general"},
{"id":3, "name":"风调雨顺" , "address":"127.0.0.1", "port":9998, "state":"new"},
]
} 

update file example(c means crc check, f means file, s means size):
----------update.cfg(http://127.0.0.1/verson91/update.cfg)----------
{
	"version" : 1
	"severVerson" : "1.0.1",
	"files" : 
	[
		{"c" : 16067,	"f" : "/battle/s_battle.jpg",	"s":13578},
		{"c" : 44753,	"f" : "/battle/s_battle_frame1.png", "s":54789},
	],
}

*/

#include <string>
#include <map>
#include "Singleton.h"
#include "CurlDownload.h"
#include "Concurrency.h"
#include "libOS.h"
/**

SeverConsts::Get()->init("version.cfg);	//start download version file and parse
SeverConsts::Get()->update(dt);			//call this function every frame to make it working;
SeverConsts::Get()->checkUpdateInfo();	//call this after init, get to know checking state.
SeverConsts::Get()->getSeverList()		//Sever list can be got after checkUpdate return CS_OK.
SeverConsts::Get()->updateResources();	//Should do this after checkUpdate return CS_NEED_UPDATE
SeverConsts::Get()->checkUpdateState();	//get whether update downloaded all files

*/
class SeverConsts 
	: public Singleton<SeverConsts>
	, public CurlDownload::DownloadListener
	, public libOSListener
{
public:
	//add by xinghui:same to LocalString.lua
	static std::string languageTyoes[18];
	enum CHECK_STATE
	{
		CS_NOT_STARTED,
		CS_OK,
		CS_CHECKING,
		CS_NEED_UPDATE,
		CS_NEED_STORE_UPDATE,
		CS_FAILED,
		CS_SEVERFAILED,
		//
		//问题，没法放灰度号、内部号进入，暂不实现
		//CS_SERVER_STATE_WAITING,	//xinzheng 2013-07-15 在server的区服配置上 标示该区GameServer的当前状态，1正常，0弹一个msg阻止进入
		//
	};
	enum UPDATE_STATE
	{
		US_NOT_STARTED,
		US_CHECKING,
		US_DOWNLOADING,
		US_OK,
		US_FAILED,
		CS_UPDATEFAILED,
	};

	enum SEVER_STATE
	{
		SS_GENERAL,
		SS_NEW,
		SS_FULL,
	};
	struct SEVER_ATTRIBUTE
	{
		int id;
		std::string name;
		std::string address;
		int port;
		SEVER_STATE state;
		int order;
		bool operator < (SEVER_ATTRIBUTE b) {
			return order > b.order;
      }
	};
	enum ERROR_MESSAGE_DOWNLOAD_CODE
	{
		CODE_NETWORDDISABLED_SERVER=201,
		CODE_SEVER_FAILD_A,
		CODE_SEVER_FAILD_B,
		CODE_SEVER_FAILD_C,
		CODE_NETWORDDISABLED_UPDATE,
		CODE_UPDATE_FAILD_A,
		CODE_UPDATE_FAILD_B,
		CODE_UPDATE_FAILD_C,
		CODE_SU_DIFF,
		CODE_NO_SPACE,
		CODE_LIST_FILE_FAILED,
		CODE_LIST_FILE_DOWNLOADED,
		CODE_OTHER_ERROR,
	};
	enum FileType
	{
		DownSeverFile,
		DownUpdateFile,
		DownOtherFile,
	};
	typedef std::map<int,SEVER_ATTRIBUTE*> SEVERLIST;
	typedef std::list<SEVER_ATTRIBUTE* > SEVERLISTVec;
	virtual void onMessageboxEnter(int tag);
	void init(const std::string& configfile );
	void start();
	void update(float dt);
	void cleanup();

	CHECK_STATE checkUpdateInfo(){return mCheckState;}

	/**Sever list can be got after checkUpdate return CS_OK*/
	const SEVERLIST& getSeverList(){return mSeverList;}
	const std::string getServerInfoByLua();//add by xinghui
	static SeverConsts* getInstance();//add by xinghui
	const SEVERLISTVec& getSeverListVec();
	
	UPDATE_STATE checkUpdateState(){return mUpdateState;}
	
	/** Should do this after checkUpdate return CS_NEED_UPDATE*/
	void updateResources();


	unsigned long getUpdatedCount(){return mUpdatedCount;}
	unsigned long getUpdateTotalCount(){return mUpdateTotalCount;}
	int getSeverDefaultID(){return mSeverDefaultID;}
	const std::string & getInStoreUpdateAddress(){return mInStoreUpdate;}
	const std::string & getDirectDownloadUrl(){return mDirectDownloadUrl;};
	const std::string & getDirectDownloadMsg(){return mDirectDownloadMsg;};
	const unsigned long long getNeedUpdateTotalBytes(){return mNeedUpdateTotalBytes;};
	const std::string & getNeedUpdateMsg(){return mNeedUpdateMsg;};


	void initSearchPath();
	void setOriginalSearchPath();
	void setAdditionalSearchPath();

	const std::string & getAnnouncement(){return mAnnouncement;}
public://not used for client
	struct FILE_ATTRIBUTE
	{
		std::string realFileName;
		std::string filename;
        std::string checkpath;
		int crc;
		int size;
	};
	typedef std::list<FILE_ATTRIBUTE*> FILELIST;

	SeverConsts(void):
		mCheckState(CS_NOT_STARTED),mUpdateState(US_NOT_STARTED),
		mUpdatedCount(0),mUpdateTotalCount(0),_waitThreadFileCheck(FCS_NOTSTART),
		mSeverDefaultID(-1)
	   {};

	void downloaded(const std::string& url,const std::string& filename);
	void downloadFailed(const std::string& url, const std::string& filename);
	const std::string getFailedName() { return mFailedName;};

	void exitServerConst();

	FILELIST& _lockFileList();
	void _unlockFileList();
	void _notifyFileCheckDone();
	const std::string& getVersion(){return mLocalVerson;}
	void clearVersion();
	void checkVersion( const std::string& versionStr ,int &GameVersion, int &appVersion, int& resVersion);
	bool isServerInUpdatingCode();
	const std::string & getServerInUpdateMsg() const {return mServerInUpdateMsg;}
	const std::string & getServerInGrayMsg() const {return mServerInGrayMsg;}
	const std::string & getInternalAnnouncementFilePath() const { return mInternalAnnouncementFilePath;}
	const unsigned int getInternalAnnouncementVersion() const { return mInternalAnnouncementVersion;}

	const std::string & getBaseVersion() const { return mSeverVerson; }

	void setIsInLoading(bool isInLoading);
	const bool GetIsInLoading(){ return m_bIsInLoading; }
private:

	std::vector<std::string> mOriSearchPath;

	CHECK_STATE mCheckState;
	UPDATE_STATE mUpdateState;

	std::string mLocalVerson;
	std::string mSeverVerson;
	std::string mSeverFile;
	std::string mSeverBackup;
	std::string mUpdateFile;
	std::string mConfigFile;
	std::string mUnEncConfigFile;
	std::string mInStoreUpdate;
	std::string mAnnouncement;
	std::string mFailedName;
	std::string mCfgFilePath;	//bundle的version_xx.cfg文件全路径
	//
	/*
		大版本下载
	*/
	std::string mDirectDownloadUrl;	//对应本客户端系统（IOS、Android）及平台（nd91、uc、pp...）的最新包的直接下载链接地址
	std::string mDirectDownloadMsg;	//例如：游戏更新了，点击确定，下载最新V1.3版本！
	//
	/*
		内更新
	*/
	unsigned long long mNeedUpdateTotalBytes;	//内更新大小，字节数
	std::string mNeedUpdateMsg;	//内更新提示信息
	//

	int mSeverDefaultID;
	bool mServerInUpdateCode;
	std::string mServerInUpdateMsg;
	std::string mServerInGrayMsg;
	SEVERLIST mSeverList;
	SEVERLISTVec mSeverListVec;
	bool m_bIsInLoading;

	Mutex mFileListMutex;
	FILELIST mFileList;
	FILELIST mFileListFailed;
	std::list<std::string> mDownloadFailedList;
	std::string mUpdateRootAddress;
	unsigned long mUpdateTotalCount;
	unsigned long mUpdatedCount;
	std::string mInternalAnnouncementFilePath;
	unsigned int mInternalAnnouncementVersion;
	enum FILECHECKSTATE
	{
		FCS_NOTSTART,
		FCS_CHECKING,
		FCS_DONE,
	} _waitThreadFileCheck;
	Mutex _waitThreadFileCheckMutex;
	ThreadService mCheckFileThread;
	bool _isPopNotifyWhenFileNotFound;
	std::string mAdditionalSearchPath;
private:
	bool _parseConfigFile(const std::string& configfile);
	bool _getSeversWithBackupAddress();
	void _parseSeverFile(const std::string& severfile);
	void _parseUpdateFile(const std::string& severfile);
	void _checkUpdateFile();
	void _downloadFiles();
	void _finishUpdate();
	void _retryUpdateFile();
	void _retryShowDownFaildMsgBox(FileType _fileType,ERROR_MESSAGE_DOWNLOAD_CODE _errCode);
	std::string _getTimeStamp(std::string _url);
	static bool _sortServerList(SEVER_ATTRIBUTE* a,SEVER_ATTRIBUTE* b);
};

