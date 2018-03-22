//
#include "stdafx.h"

#include "SeverConsts.h"
#include "Concurrency.h"
#include "GameMaths.h"
#include "GamePlatform.h"
#include "json/json.h"
#include "cocos2d.h"
#include "GameEncryptKey.h"
//#include "libOS.h"
#include "Language.h"
#include "libPlatform.h"
#include "StringConverter.h"
#include "inifile.h"
#include "../../cocos2dx/platform/CCCommon.h"
#include "GameEncryptKey.h"
const std::string TEMP_SEVER_FILE_DOWNLOADED = "_tempSeverFile.cfg";
const std::string TEMP_UPDATE_FILE_DOWNLOADED = "_tempUpdateFile.cfg";
const std::string TEMP_CONFIG_FILE_BACKUP = "_tempConfigFile.cfg";
const std::string SERVER_BACKUP_FILE = "_serverBackupFile.cfg";

class SeverCheckingFileTask : public ThreadTask
{
public:
	SeverCheckingFileTask(){}
	int run()
	{
		SeverConsts::FILELIST& mFiles = SeverConsts::Get()->_lockFileList();
		SeverConsts::FILELIST checkList;
		SeverConsts::FILELIST addList;
		checkList.swap(mFiles);
		SeverConsts::FILELIST::iterator it = checkList.begin();

		for(;it!=checkList.end();++it)
		{
			unsigned long filesize;
			unsigned short checkedCRC = 0;
			char* pBuffer = (char*)getFileData((*it)->checkpath.c_str(),"rb",&filesize,&checkedCRC,false);

			if(!pBuffer || checkedCRC != (*it)->crc)
				addList.push_back(*it);
			else
				delete *it;

			CC_SAFE_DELETE_ARRAY(pBuffer);
		}
		
		mFiles.swap(addList);
		SeverConsts::Get()->_unlockFileList();
		SeverConsts::Get()->_notifyFileCheckDone();
		
		return 0;
	}
};

std::string SeverConsts::languageTyoes[18] = {
	"en-US",
	"zh-CN",
	"fr-FR",
	"it-IT",
	"de-DE",
	"es-ES",
	"ru-RU",
	"ko-KR",
	"ja-JP",
	"pt-BR",
	"ms-MY",
	"nb-NO",
	"nl-NL",
	"th-TH",
	"tr-TR",
	"vi-VN",
	"id-ID"
};

void SeverConsts::init( const std::string& configfile )
{
	m_bIsInLoading = true;
	libOS::getInstance()->registerListener(this);
	setOriginalSearchPath();

	CurlDownload::Get()->addListener(this);
    
    std::string desFile(cocos2d::CCFileUtils::sharedFileUtils()->getWritablePath());
	desFile=desFile+"/"+TEMP_SEVER_FILE_DOWNLOADED;
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	desFile = cocos2d::CCFileUtils::sharedFileUtils()->getResourcePath();
	desFile = desFile + TEMP_SEVER_FILE_DOWNLOADED;
#endif
    //desFile=desFile+"/"+TEMP_SEVER_FILE_DOWNLOADED;
    remove(desFile.c_str());
    
    std::string desFile2(cocos2d::CCFileUtils::sharedFileUtils()->getWritablePath());
	desFile2 = desFile2 + "/" + TEMP_UPDATE_FILE_DOWNLOADED;
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	desFile2 = cocos2d::CCFileUtils::sharedFileUtils()->getResourcePath();
	desFile2 = desFile2 + TEMP_UPDATE_FILE_DOWNLOADED;
#endif
  //desFile2=desFile2+"/"+TEMP_UPDATE_FILE_DOWNLOADED;
    remove(desFile2.c_str());
    
	mConfigFile = configfile;
    mUnEncConfigFile = configfile;
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_IOS)//modify by cooper
	if (EncFilePath && EncFileNameFlag && !ShowSuffixFlag)
	{
		mConfigFile = rc4EncFileName(configfile.c_str());
	}
#endif	
	std::string bundleVersion = "";
	std::string newVersion = "";
	//cocos2d::CCApplication::sharedApplication()->getResourceRootPath();
	//cocos2d::CCFileUtils::sharedFileUtils()->setSearchPaths()
	std::string bundleConfigFile = cocos2d::CCFileUtils::sharedFileUtils()->fullPathForFilename(mConfigFile.c_str());
	mCfgFilePath = bundleConfigFile;
	CCLOG("0 parse bundleConfigFile: %s", bundleConfigFile.c_str());
	if(_parseConfigFile(bundleConfigFile))
		bundleVersion = mLocalVerson;
	CCLOG("bundleVersion: %s", bundleVersion.c_str());
	
	/*
		in our DreamOnePiece android program, bundle unziped path is same with CCFileUtils::sharedFileUtils()->getWritablePath()
		in android bundleConfigFile == searchpath1
	*/

	//std::string searchpath1 = cocos2d::CCFileUtils::sharedFileUtils()->getWritablePath()+"/"+mAdditionalSearchPath + "/" + configfile;
	std::string searchpath1 = cocos2d::CCFileUtils::sharedFileUtils()->getWritablePath() + "/" + configfile;
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	searchpath1 = cocos2d::CCFileUtils::sharedFileUtils()->getResourcePath() + configfile;
#endif
	CCLOG("1 try to parse localConfigFile: %s", searchpath1.c_str());
	std::string searchpath2 = cocos2d::CCFileUtils::sharedFileUtils()->getWritablePath()+"/"+TEMP_CONFIG_FILE_BACKUP;
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	searchpath2 = cocos2d::CCFileUtils::sharedFileUtils()->getResourcePath() + TEMP_CONFIG_FILE_BACKUP;
#endif
	CCLOG("2 try to parse localConfigFile: %s", searchpath2.c_str());
	
	if(bundleConfigFile != searchpath1 && _parseConfigFile(searchpath1.c_str()))
	{
		CCLOG("1 parse localConfigFile: %s", searchpath1.c_str());
		newVersion = mLocalVerson;
	}
	else if(bundleConfigFile != searchpath2 && _parseConfigFile(searchpath2.c_str()))
	{
		CCLOG("2 parse localConfigFile: %s", searchpath2.c_str());
		newVersion = mLocalVerson;
	}
	CCLOG("newVersion: %s", newVersion.c_str());

	setAdditionalSearchPath();

	if(bundleVersion!="" && newVersion!="")
	{
		int bundleGameVersion,bundleAppVersion,bundleResVersion;
		int LocalGameVersion,LocalAppVersion,LocalResVersion;
		checkVersion(bundleVersion,bundleGameVersion,bundleAppVersion,bundleResVersion);
		checkVersion(newVersion,LocalGameVersion,LocalAppVersion,LocalResVersion);

		//-DANDROID in Android's Aplication.mk
#if !defined(ANDROID)
		/*
			our dreamonepiece android program have check and process apk(bundle) version to resource version
		*/
		//check if bundle version is larger-equal to resource version
		if(bundleGameVersion>LocalGameVersion || bundleAppVersion>LocalAppVersion || bundleVersion == newVersion)
		{
			clearVersion();
            cocos2d::CCFileUtils::sharedFileUtils()->purgeCachedEntries();
			//use bundle config again
			_parseConfigFile(bundleConfigFile);
		}
#endif
	}
	
	mNeedUpdateTotalBytes = 0u;

}


void SeverConsts::start()
{
	std::string desFile(cocos2d::CCFileUtils::sharedFileUtils()->getWritablePath());
	desFile=desFile+"/"+TEMP_SEVER_FILE_DOWNLOADED;
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	desFile = cocos2d::CCFileUtils::sharedFileUtils()->getResourcePath();
	desFile = desFile + TEMP_SEVER_FILE_DOWNLOADED;
#endif
	
	CurlDownload::Get()->downloadFile(mSeverFile+_getTimeStamp(mSeverFile),desFile);
	mCheckState = CS_CHECKING;
}

bool SeverConsts::_parseConfigFile( const std::string& configfile )
{
	Json::Value root;
	Json::Reader jreader;
	Json::Value data;
	unsigned long filesize;
    
	char* pBuffer = (char*)getFileData(configfile.c_str(),"rt",&filesize,0,false);

	bool openSuccessful = true;
	if(!pBuffer)
	{
		char msg[256];
		sprintf(msg,"Failed open file: %s !!",configfile.c_str());
		//cocos2d::CCMessageBox(msg,Language::Get()->getString("@ShowMsgBoxTitle").c_str());
		openSuccessful = false;
	}
	else
	{
		std::string str(pBuffer,filesize);
		openSuccessful = jreader.parse(str,data,false);
		if(openSuccessful && data["version"].asInt()==1 && !data["localVerson"].empty() && !data["sever"].empty())
		{
			mLocalVerson = data["localVerson"].asString();
			mSeverFile = data["sever"].asString();

			if(!data["inStoreUpdate"].empty() && data["inStoreUpdate"].isString())
			{
				mInStoreUpdate = data["inStoreUpdate"].asString();
			}
			if(!data["severBackup"].empty() && data["severBackup"].isString())
			{
				mSeverBackup = data["severBackup"].asString();
			}
			else
				mSeverBackup = "";
			//
			if (!data["androidApk"].empty() && data["androidApk"].isObject())
			{
				Json::Value androidApk = data["androidApk"];
				std::string platform_str = libPlatformManager::getPlatform()->getClientChannel();
				if (!androidApk["rootAddress"].empty() && !androidApk[platform_str].empty())
				{
					mDirectDownloadUrl = androidApk["rootAddress"].asString() + androidApk[platform_str].asString();
					//cocos2d::CCLog("if SeverConsts::_parseConfigFile-----> mDirectDownloadUrl:%s -----> platform_str:%s",mDirectDownloadUrl.c_str(),platform_str.c_str());
				}
				if (!androidApk["downloadMsg"].empty())
				{
					mDirectDownloadMsg = androidApk["downloadMsg"].asString();
					//cocos2d::CCLog("else SeverConsts::_parseConfigFile-----> mDirectDownloadUrl:%s -----> platform_str:%s", mDirectDownloadUrl.c_str(), platform_str.c_str());
				}
			}
			//

			//some android platform has its own server,read the server address
			if (!data["androidServer"].empty() && data["androidServer"].isObject())
			{
				Json::Value androidServer = data["androidServer"];
				std::string platform_str = libPlatformManager::getPlatform()->getClientChannel();
				char serverStr[128];
				char serverBackupStr[128];
				sprintf(serverStr,"%s_sever",platform_str.c_str());
				sprintf(serverBackupStr,"%s_severBackup",platform_str.c_str());
				if (!androidServer[serverStr].empty())
				{
					mSeverFile =  androidServer[serverStr].asString();
				}
				if(!androidServer[serverBackupStr].empty()&&androidServer[serverBackupStr].isString())
				{
					mSeverBackup = androidServer[serverBackupStr].asString();
				}
			}
		}
		else
			openSuccessful = false;
		CC_SAFE_DELETE_ARRAY(pBuffer);
        
	}
	return openSuccessful;
}


void SeverConsts::update( float dt )
{

	CurlDownload::Get()->update(dt);
	if(mUpdateState == US_CHECKING && _waitThreadFileCheck == FCS_DONE)
	{
		mUpdateState = US_DOWNLOADING;

		AutoRelaseLock _autolock(_waitThreadFileCheckMutex);
		_waitThreadFileCheck = FCS_NOTSTART;
		
		mCheckFileThread.shutdown();

		cocos2d::CCFileUtils::sharedFileUtils()->setPopupNotify(_isPopNotifyWhenFileNotFound);
		_downloadFiles();
	}
}

void SeverConsts::downloaded( const std::string& url,const std::string& filename )
{
	if(url.find(mSeverFile)!=url.npos)
	{
		_parseSeverFile(filename);
	}
	else if(url.find(mUpdateFile)!=url.npos)
	{
		_parseUpdateFile(filename);
		_checkUpdateFile();
		//_downloadFiles();
	}
	else
	{
		AutoRelaseLock autolock(mFileListMutex);

		FILELIST filelist;
		filelist.swap(mFileList);
		FILELIST::iterator it = filelist.begin();
		for(;it!=filelist.end();++it)
		{
			if((*it)->filename == filename)
			{
				mUpdatedCount+=(*it)->size;
				delete (*it);
			}
			else
			{
				mFileList.push_back(*it);
			}
		}
		if(mFileList.empty())
		{
			if(mDownloadFailedList.empty())
			{
				//mUpdateState = US_OK;
				//_finishUpdate();

				mUpdateState = US_NOT_STARTED;
				cocos2d::CCFileUtils::sharedFileUtils()->purgeCachedEntries();
				updateResources();
			}
			else
			{
				FILELIST::iterator it = mFileListFailed.begin();
				for(;it!=mFileListFailed.end();++it)
				{
					if((*it)->filename == filename)
					{
		
						mFailedName=(*it)->realFileName;
					}
				}
				mUpdateState=US_CHECKING;;
				_retryShowDownFaildMsgBox(DownOtherFile,CODE_LIST_FILE_DOWNLOADED);
			}
		}
	}
}

void SeverConsts::downloadFailed( const std::string& url, const std::string& filename )
{
	if(url.find(mSeverFile)!=url.npos)
	{
		static int _serveFileErrCount=0;
		if(_serveFileErrCount<=30)
		{
			CurlDownload::Get()->reInit();
			//modify by dylan at 20130905
			//cocos2d::CCMessageBox("1 FAILED to get Sever file!!","ERROR!");
			_retryShowDownFaildMsgBox(DownSeverFile,CODE_SEVER_FAILD_C);
			_serveFileErrCount++;
		}
		else
		{
			if(_getSeversWithBackupAddress())
			{
				return;
			}
			else
			{
				mCheckState = CS_FAILED;
			}
		}
	}
	else if(url.find(mUpdateFile) != url.npos)
	{
		static int _updateFileErrCount=0;
		if(_updateFileErrCount<=30)
		{
			CurlDownload::Get()->reInit();
			//modify by dylan at 20130905
			_retryShowDownFaildMsgBox(DownUpdateFile,CODE_UPDATE_FAILD_C);
			_updateFileErrCount++;
		}
		else
		{
			mUpdateState = US_FAILED;
		}
	}
	else
	{
		AutoRelaseLock autolock(mFileListMutex);
		FILELIST filelist;
		filelist.swap(mFileList);
		FILELIST::iterator it = filelist.begin();
		for(;it!=filelist.end();++it)
		{
			if((*it)->filename == filename)
			{
				mDownloadFailedList.push_back(filename);
				mFileListFailed.push_back(*it);
				//delete (*it);
				mFailedName=(*it)->realFileName;
			}
			else
			{
				mFileList.push_back(*it);
			}
		}
		if(mFileList.empty() && !mDownloadFailedList.empty())
		{
			//mUpdateState = US_FAILED;
			_retryShowDownFaildMsgBox(DownOtherFile,CODE_LIST_FILE_FAILED);
		}
	}
}


void SeverConsts::exitServerConst()
{
	CurlDownload::Get()->removeListener(this);
	libOS::getInstance()->removeListener(this);
}

void SeverConsts::_parseSeverFile( const std::string& severfile )
{
	Json::Value root;
	Json::Reader jreader;
	Json::Value data;
	unsigned long filesize;
	char* pBuffer = (char*)getFileData(
		cocos2d::CCFileUtils::sharedFileUtils()->fullPathForFilename(severfile.c_str()).c_str(),
		"rt",&filesize,0,false);

	if(!pBuffer)
	{
		if(_getSeversWithBackupAddress())
			return;
		else
		{
			//modify by dylan at 20130905
			//cocos2d::CCMessageBox("1 FAILED to get Sever file!!","ERROR!");
			mCheckState = CS_SEVERFAILED;
			_retryShowDownFaildMsgBox(DownSeverFile,CODE_SEVER_FAILD_A);
			CC_SAFE_DELETE_ARRAY(pBuffer);
			return;
		}
	}
	std::string str(pBuffer,filesize);
	bool ret = jreader.parse(str,data,false);
	if(	
		!ret ||
		data["version"].empty() || 
		data["version"].asInt()!=1 ||
		data["severs"].empty() ||
		!data["severs"].isArray() ||
		data["severVerson"].empty() ||
		data["updateAddress"].empty() ||
		data["defaultSeverID"].empty() ||
		data["rootAddress"].empty())
	{
		if(_getSeversWithBackupAddress())
			return;
		else
		{
			//modify by dylan at 20130905
			//cocos2d::CCMessageBox("2 FAILED to get Sever file!!","ERROR!");
			mCheckState = CS_SEVERFAILED;
			//add by cooper.x 当服务器列表获取失败时，使用缓存的服务器列表，如果是用户第一次进游戏，弹框
			//_retryShowDownFaildMsgBox(DownSeverFile,CODE_SEVER_FAILD_B);
			CC_SAFE_DELETE_ARRAY(pBuffer);
			//return;
		}
	}
	//--begin xinzheng 2013-7-17
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID) || defined(WIN32)
	if (!data["androidApk"].empty() && data["androidApk"].isObject())
	{
		Json::Value androidApk = data["androidApk"];
		std::string platform_str = libPlatformManager::getPlatform()->getClientChannel();
		if (!androidApk["rootAddress"].empty() && !androidApk[platform_str].empty())
		{
			mDirectDownloadUrl = androidApk["rootAddress"].asString() + androidApk[platform_str].asString();
			//cocos2d::CCLog("else SeverConsts::_parseSeverFile-----> mDirectDownloadUrl:%s -----> platform_str:%s", mDirectDownloadUrl.c_str(), platform_str.c_str());

		}
		if (!androidApk["downloadMsg"].empty())
		{
			mDirectDownloadMsg = androidApk["downloadMsg"].asString();
			//cocos2d::CCLog("else SeverConsts::_parseSeverFile-----> mDirectDownloadUrl:%s -----> platform_str:%s", mDirectDownloadUrl.c_str(), platform_str.c_str());
		}
	}
#else
	if (!data["iosIpa"].empty() && data["iosIpa"].isObject())
	{
		Json::Value iosIpa = data["iosIpa"];
		std::string platform_str = libPlatformManager::getPlatform()->getClientChannel();
		if (!iosIpa["rootAddress"].empty() && !iosIpa[platform_str].empty())
		{
			mDirectDownloadUrl = iosIpa["rootAddress"].asString() + iosIpa[platform_str].asString();
		}
		if (!iosIpa["downloadMsg"].empty())
		{
			mDirectDownloadMsg = iosIpa["downloadMsg"].asString();
		}
	}
#endif
	if (!data["updateByteSize"].empty())
	{
		mNeedUpdateTotalBytes = data["updateByteSize"].asUInt();
	}
	if (!data["updateMsg"].empty())
	{
		mNeedUpdateMsg = data["updateMsg"].asString();
	}
	else
		mNeedUpdateMsg = "";
	//--end
	cleanup();
	Json::Value severs = data["severs"];

	//保存servers到本地
	if (severs.size()>0)
	{
		std::string writePath = cocos2d::CCFileUtils::sharedFileUtils()->getWritablePath();
		std::string serverBackupFile = SERVER_BACKUP_FILE;
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
			serverBackupFile = rc4EncFileName(serverBackupFile.c_str());
#endif
		std::string desFile = writePath + "/" + serverBackupFile;
		remove(desFile.c_str());//删除旧文件

		std::string serverStr = severs.toStyledString();

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
		int encryptBufferSize = 0;
		unsigned char* res = 0;
		//modify by cooper.x
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
		res = encryptRC4DocumentForIOS((unsigned char*)serverStr.c_str(), serverStr.size(), encryptBufferSize, mUnEncConfigFile.c_str());
#else
		res = encryptRC4DocumentForAndroid((unsigned char*)serverStr.c_str(), serverStr.size(), encryptBufferSize, mUnEncConfigFile.c_str());
#endif
		if (res)
		{
			saveFileInPath(desFile, "wb", (const unsigned char*)res, encryptBufferSize);
		}
#else
		saveFileInPath(desFile, "wb", (const unsigned char*)serverStr.c_str(), serverStr.size());
#endif
		/*FILE* fp = std::fopen(desFile.c_str(), "at+");
		CCAssert(fp != NULL, "file open error");

		int length = serverStr.length();
		fwrite(serverStr.c_str(), length, 1, fp);
		fclose(fp);*/
	}//服务器列表下载失败后,从本地读取 add by cooper.x
	else
	{
		std::string serverBackupFile = SERVER_BACKUP_FILE;
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
		serverBackupFile = rc4EncFileName(serverBackupFile.c_str());
#endif
		std::string serverFilePath = cocos2d::CCFileUtils::sharedFileUtils()->fullPathForFilename(serverBackupFile.c_str());
		unsigned long fileSize = 0;
		char* pBuffer = (char*)getFileData(serverFilePath.c_str(), "rt", &fileSize, 0, false);
		if (pBuffer)
		{
			Json::Value jsonData;
			std::string str(pBuffer, fileSize);
			bool ret = jreader.parse(str, jsonData, false);
			if (ret && jsonData.size()>0)
			{
				for (int j = 0; j < jsonData.size(); ++j)
				{
					if (!jsonData[j]["name"].empty() &&
						!jsonData[j]["address"].empty() &&
						!jsonData[j]["port"].empty() &&
						!jsonData[j]["id"].empty() &&
						!jsonData[j]["state"].empty())
					{
						SEVER_ATTRIBUTE* severAtt = new SEVER_ATTRIBUTE;
						severAtt->name = jsonData[j]["name"].asString();
						severAtt->address = jsonData[j]["address"].asString();
						severAtt->port = jsonData[j]["port"].asInt();
						severAtt->id = jsonData[j]["id"].asInt();
						if (jsonData[j]["state"].asString() == "general")
							severAtt->state = SS_GENERAL;
						else if (jsonData[j]["state"].asString() == "new")
							severAtt->state = SS_NEW;
						else if (jsonData[j]["state"].asString() == "full")
							severAtt->state = SS_FULL;
						mSeverList.insert(std::make_pair(severAtt->id, severAtt));
					}
					
				}
				
			}
			else
			{
				if (mCheckState == CS_SEVERFAILED)
				{
					_retryShowDownFaildMsgBox(DownSeverFile, CODE_SEVER_FAILD_B);
					return;
				}
			}
		}
		else
		{
			if (mCheckState == CS_SEVERFAILED)
			{
				_retryShowDownFaildMsgBox(DownSeverFile, CODE_SEVER_FAILD_B);
				return;
			}
		}
	}

	for(int i=0;i<severs.size();++i)
	{
		if(	!severs[i]["name"].empty() &&
			!severs[i]["address"].empty() &&
			!severs[i]["port"].empty() &&
			!severs[i]["id"].empty() &&
			!severs[i]["state"].empty() )
		{
			SEVER_ATTRIBUTE* severAtt = new SEVER_ATTRIBUTE;
			severAtt->name = severs[i]["name"].asString();
			severAtt->address = severs[i]["address"].asString();
			severAtt->port = severs[i]["port"].asInt();
			severAtt->id = severs[i]["id"].asInt();
			if(severs[i]["state"].asString() == "general")
				severAtt->state = SS_GENERAL;
			else if(severs[i]["state"].asString() == "new")
				severAtt->state = SS_NEW;
			else if(severs[i]["state"].asString() == "full")
				severAtt->state = SS_FULL;
			if(severs[i]["order"].empty())
			{
				severAtt->order=severAtt->id;
			}
			else
			{
				severAtt->order=severs[i]["order"].asInt(); 
			}
			mSeverList.insert(std::make_pair(severAtt->id,severAtt));
		}
	}
	mUpdateFile = data["updateAddress"].asString();
	mSeverVerson = data["severVerson"].asString();
	mUpdateRootAddress = data["rootAddress"].asString();
	mSeverDefaultID = data["defaultSeverID"].asInt();
    
    if(!data["inStoreUpdate"].empty() && data["inStoreUpdate"].isString())
    {
        mInStoreUpdate = data["inStoreUpdate"].asString();
    }
    
	//add by xinghui
	int languageIndex = (int)cocos2d::CCApplication::sharedApplication()->getCurrentLanguage();
	std::string langType = languageTyoes[languageIndex];

	if(	!data["announcement"].empty() )
	{
		mAnnouncement = data["announcement"].asString();
	}

	//灰度停服更新内容
	std::string serverInGeyKey = "serverInGray" + langType;
	if (!data[serverInGeyKey].empty())
	{
		mServerInGrayMsg = data[serverInGeyKey].asString();
		CCLOG("ServerInGrayTipMsg: %s", mServerInGrayMsg.c_str());
	}
	else
	{
		if (!data["serverInGrayen-US"].empty())
		{
			mServerInGrayMsg = data["serverInGrayen-US"].asString();
		}
		else
		{
			mServerInGrayMsg = "";
		}
		CCLOG("serverInGeyKey: %s is not found!", serverInGeyKey.c_str());
	}

	//公告内容
	std::string annKey = "internalAnnouncementFilePath" + langType;
	if(!data[annKey].empty())
	{
		mInternalAnnouncementFilePath=data[annKey].asString();
	}
	else
	{
		if (!data["internalAnnouncementFilePathen-US"].empty())
		{
			mInternalAnnouncementFilePath = data["internalAnnouncementFilePathen-US"].asString();
		}
		else
		{
			mInternalAnnouncementFilePath = "";
		}
		CCLOG("internalAnnouncementFilePathKey: %s is not found!", annKey.c_str());
	}

	if(!data["internalAnnouncementVersion"].empty())
	{
		mInternalAnnouncementVersion=data["internalAnnouncementVersion"].asUInt();
	}
	else
	{
		mInternalAnnouncementVersion=0;
	}

	//停服更新内容
	std::string serverInUpdatKey = "serverInUpdate" + langType;
	if (!data[serverInUpdatKey].empty())
	{
		mServerInUpdateMsg = data[serverInUpdatKey].asString();
		if (!mServerInUpdateMsg.empty())
			mServerInUpdateCode = true;
	}
	else
	{
		if (!data["serverInUpdateen-US"].empty())
		{
			mServerInUpdateMsg = data["serverInUpdateen-US"].asString();
			if (!mServerInUpdateMsg.empty())
				mServerInUpdateCode = true;
		}
		else
		{
			mServerInUpdateCode = false;
		}
	}

	int SeverGameVersion,SeverAppVersion,SeverResVersion;
	int LocalGameVersion,LocalAppVersion,LocalResVersion;
	checkVersion(mSeverVerson,SeverGameVersion,SeverAppVersion,SeverResVersion);
	checkVersion(mLocalVerson,LocalGameVersion,LocalAppVersion,LocalResVersion);
	if(SeverGameVersion>LocalGameVersion || SeverAppVersion>LocalAppVersion)
	{
		mCheckState = CS_NEED_STORE_UPDATE;
		CC_SAFE_DELETE_ARRAY(pBuffer);
        remove(cocos2d::CCFileUtils::sharedFileUtils()->fullPathForFilename(severfile.c_str()).c_str());
        
		return;
	}
	if(SeverGameVersion==LocalGameVersion && SeverAppVersion==LocalAppVersion &&SeverResVersion>LocalResVersion)
	{
		mCheckState = CS_NEED_UPDATE;
		CC_SAFE_DELETE_ARRAY(pBuffer);
        remove(cocos2d::CCFileUtils::sharedFileUtils()->fullPathForFilename(severfile.c_str()).c_str());
        return;
	}
	mCheckState = CS_OK;
	CC_SAFE_DELETE_ARRAY(pBuffer);
    remove(cocos2d::CCFileUtils::sharedFileUtils()->fullPathForFilename(severfile.c_str()).c_str());
}

void SeverConsts::cleanup()
{
	for(SEVERLIST::iterator it = mSeverList.begin();it!=mSeverList.end();++it)
		if(it->second)delete it->second;
	mSeverList.clear();
}

void SeverConsts::checkVersion( const std::string& versionStr ,int &GameVersion, int &appVersion, int& resVersion)
{
	std::string chechStr = versionStr;

	int firstMaohao = versionStr.find_first_of(':');
	if(firstMaohao<versionStr.size() && firstMaohao!=std::string::npos)
		chechStr = versionStr.substr(firstMaohao+1,versionStr.length()-firstMaohao-1);
	
	int offset = 0;
	int lastOffset = chechStr.find_first_of('.',offset);
	std::string val = chechStr.substr(offset,lastOffset);
	sscanf(val.c_str(),"%d",&GameVersion);
	offset = lastOffset+1;

	lastOffset = chechStr.find_first_of('.',offset);
	val = chechStr.substr(offset,lastOffset);
	sscanf(val.c_str(),"%d",&appVersion);
	offset = lastOffset+1;

	lastOffset = chechStr.find_first_of('.',offset);
	val = chechStr.substr(offset,lastOffset);
	sscanf(val.c_str(),"%d",&resVersion);
	offset = lastOffset+1;
}

void SeverConsts::updateResources()
{
	if(mUpdateState == US_NOT_STARTED)
	{
		mUpdateState = US_CHECKING;
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
		std::string desFile(cocos2d::CCFileUtils::sharedFileUtils()->getResourcePath());
		desFile = desFile + TEMP_UPDATE_FILE_DOWNLOADED;
		//cocos2d::CCLog("@@SeverConsts::updateResources()@@@@  desFile:%s ***** url:%s", desFile.c_str(), (mUpdateFile + _getTimeStamp(mUpdateFile)).c_str());
		CurlDownload::Get()->downloadFile(mUpdateFile + _getTimeStamp(mUpdateFile), desFile);
#else
		std::string desFile(cocos2d::CCFileUtils::sharedFileUtils()->getWritablePath());
		desFile = desFile + "/" + TEMP_UPDATE_FILE_DOWNLOADED;
		CurlDownload::Get()->downloadFile(mUpdateFile + _getTimeStamp(mUpdateFile), desFile);
#endif
	}
}

void SeverConsts::_retryUpdateFile()
{
	//mUpdateState = US_CHECKING;
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	std::string desFile(cocos2d::CCFileUtils::sharedFileUtils()->getResourcePath());
	desFile = desFile + TEMP_UPDATE_FILE_DOWNLOADED;
	//cocos2d::CCLog("@@SeverConsts::updateResources()@@@@  desFile:%s ***** url:%s", desFile.c_str(), (mUpdateFile + _getTimeStamp(mUpdateFile)).c_str());
	CurlDownload::Get()->downloadFile(mUpdateFile + _getTimeStamp(mUpdateFile), desFile);
#else
	std::string desFile(cocos2d::CCFileUtils::sharedFileUtils()->getWritablePath());
	desFile = desFile + "/" + TEMP_UPDATE_FILE_DOWNLOADED;
	CurlDownload::Get()->downloadFile(mUpdateFile + _getTimeStamp(mUpdateFile), desFile);
#endif
}

void SeverConsts::_parseUpdateFile( const std::string& severfile )
{
	Json::Value root;
	Json::Reader jreader;
	Json::Value data;
	unsigned long filesize;
	char* pBuffer = (char*)getFileData(
		cocos2d::CCFileUtils::sharedFileUtils()->fullPathForFilename(severfile.c_str()).c_str(),
		"rt",&filesize,0,false);
	//cocos2d::CCLog("******SeverConsts::_parseUpdateFile****** %s",severfile.c_str());

	if(!pBuffer)
	{
		//modify by dylan at 20130905
		//cocos2d::CCMessageBox("FAILED to get Update file!!","ERROR!");
		//cocos2d::CCLog("******SeverConsts::FAILED to get Update file!!******");
		mUpdateState = CS_UPDATEFAILED;
		_retryShowDownFaildMsgBox(DownUpdateFile,CODE_UPDATE_FAILD_A);
		CC_SAFE_DELETE_ARRAY(pBuffer);
		return;
	}

	std::string str(pBuffer,filesize);
	bool ret = jreader.parse(str,data,false);
	if(	!ret ||
		data["version"].empty() || 
		data["version"].asInt()!=1 ||
		data["severVersion"].empty() ||
		data["files"].empty() ||
		!data["files"].isArray())
	{
		//modify by dylan at 20130905
		//cocos2d::CCMessageBox("FAILED to parse Update file!!","ERROR!");
		mUpdateState = CS_UPDATEFAILED;

		//by chenpanhua at 2014.10.31
		bool restartGame = cocos2d::CCUserDefault::sharedUserDefault()->getBoolForKey("restartGame", false);
		if (!restartGame)
		{
			_retryShowDownFaildMsgBox(DownUpdateFile, CODE_UPDATE_FAILD_B);
		}
		CC_SAFE_DELETE_ARRAY(pBuffer);
		return;
	}
	if(data["severVersion"].asString()!=mSeverVerson)
	{
		//modify by dylan at 20130905
		int SeverGameVersion,SeverAppVersion,SeverResVersion;
		int updateGameVersion,updateAppVersion,updateResVersion;
		checkVersion(mSeverVerson,SeverGameVersion,SeverAppVersion,SeverResVersion);
		checkVersion(data["severVersion"].asString(),updateGameVersion,updateAppVersion,updateResVersion);
		//if updateResVersion > SeverResVersion and other is same then allow dowload
		if(SeverGameVersion==updateGameVersion && SeverAppVersion==updateAppVersion )
		{
			if(SeverResVersion>updateResVersion)
			{
				//cocos2d::CCMessageBox("Sever Version different!!","ERROR!");
				mUpdateState = CS_UPDATEFAILED;
				_retryShowDownFaildMsgBox(DownUpdateFile,CODE_SU_DIFF);
				CC_SAFE_DELETE_ARRAY(pBuffer);
				return;
			}
		}
		else
		{
			//cocos2d::CCMessageBox("Sever Version different!!","ERROR!");
			mUpdateState = CS_UPDATEFAILED;
			_retryShowDownFaildMsgBox(DownUpdateFile,CODE_SU_DIFF);
			CC_SAFE_DELETE_ARRAY(pBuffer);
			return;
		}
	}
	unsigned long long totalSize = 0;
	{
		AutoRelaseLock autolock(mFileListMutex);

		Json::Value files = data["files"];
		for(int i=0;i<files.size();++i)
		{
			if(	!files[i]["c"].empty() &&
				!files[i]["f"].empty() &&
				!files[i]["s"].empty())
			{
				FILE_ATTRIBUTE* fileatt = new FILE_ATTRIBUTE;
				fileatt->filename = files[i]["f"].asString();
				if(fileatt->filename.find_first_of("/\\") == 0)
				{
					fileatt->filename = fileatt->filename.substr(1,fileatt->filename.size());
				}
				fileatt->crc = files[i]["c"].asInt();
				fileatt->size = files[i]["s"].asInt();

				totalSize+=fileatt->size;

				mFileList.push_back(fileatt);
			}
		}
	}
    remove(	cocos2d::CCFileUtils::sharedFileUtils()->fullPathForFilename(severfile.c_str()).c_str());

	CC_SAFE_DELETE_ARRAY(pBuffer);

	long long freespace = game_getFreeSpace();
	if(freespace>0 && totalSize > freespace)
	{
		_retryShowDownFaildMsgBox(DownUpdateFile,CODE_NO_SPACE);
	}
	else
	{
		mUpdateState = US_CHECKING;
	}
	mNeedUpdateTotalBytes = totalSize;

}

void SeverConsts::_checkUpdateFile()
{
	AutoRelaseLock _autolock(_waitThreadFileCheckMutex);
	_waitThreadFileCheck = FCS_CHECKING;

	_isPopNotifyWhenFileNotFound = cocos2d::CCFileUtils::sharedFileUtils()->isPopupNotify();
	cocos2d::CCFileUtils::sharedFileUtils()->setPopupNotify(false);

	AutoRelaseLock _autolockFiles(mFileListMutex);
	FILELIST::iterator it = mFileList.begin();
	for(;it!=mFileList.end();++it)
	{
        //CCLOG((*it)->filename.c_str());
		std::string filepath = cocos2d::CCFileUtils::sharedFileUtils()->fullPathForFilename((*it)->filename.c_str());
		(*it)->checkpath = filepath;
	}


	mCheckFileThread.execute(new SeverCheckingFileTask);

}

void SeverConsts::_downloadFiles()
{
	AutoRelaseLock autolock(mFileListMutex);
	FILELIST::iterator it = mFileList.begin();
	mUpdateTotalCount = 0;
	mUpdatedCount=0;
	for(;it!=mFileList.end();++it)
	{
		std::string url = mUpdateRootAddress+(*it)->filename;
		if((*it)->realFileName.length()<=0)
		{
			(*it)->realFileName=(*it)->filename;
			//(*it)->filename =cocos2d::CCFileUtils::sharedFileUtils()->getWritablePath() +"/"+ mAdditionalSearchPath+ "/" +(*it)->filename;
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
			(*it)->filename = cocos2d::CCFileUtils::sharedFileUtils()->getResourcePath() + (*it)->filename;
#else
			(*it)->filename = cocos2d::CCFileUtils::sharedFileUtils()->getWritablePath() + "/" + (*it)->filename;
#endif
		}
		else
		{
			url = mUpdateRootAddress+(*it)->realFileName;
		}
		CurlDownload::Get()->downloadFile(url+_getTimeStamp(url),(*it)->filename,(*it)->crc);
		mUpdateTotalCount+=(*it)->size;
	}
	if(mFileList.empty())
	{
		_finishUpdate();
	}
	else
		mUpdateState = US_DOWNLOADING;
}

SeverConsts::FILELIST& SeverConsts::_lockFileList()
{
	mFileListMutex.lock();
	return mFileList;
}

void SeverConsts::_unlockFileList()
{
	mFileListMutex.unlock();
}

void SeverConsts::_notifyFileCheckDone()
{
	AutoRelaseLock _autolock(_waitThreadFileCheckMutex);
	_waitThreadFileCheck = FCS_DONE;
}
void SeverConsts::clearVersion()
{
    std::string tempFile(cocos2d::CCFileUtils::sharedFileUtils()->getWritablePath());
	tempFile.append("/");
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	tempFile = cocos2d::CCFileUtils::sharedFileUtils()->getResourcePath();
#endif
 	//tempFile.append("/");
 	tempFile.append(TEMP_CONFIG_FILE_BACKUP);
	remove(tempFile.c_str());
    
	std::string desFile(cocos2d::CCFileUtils::sharedFileUtils()->getWritablePath());
	desFile.append("/");
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	desFile = cocos2d::CCFileUtils::sharedFileUtils()->getResourcePath();
#endif
	//desFile.append("/");
 //   desFile.append(mAdditionalSearchPath);
	//desFile.append("/");

#if !defined(ANDROID)
	/*
		for android, desfile path is bundle unziped path, we do not remove it
	*/
	bool isRmDir = true;
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)

	cocos2d::CCLog("SeverConsts::clearVersion getWritablePath:%s", cocos2d::CCFileUtils::sharedFileUtils()->getWritablePath().c_str());
	cocos2d::CCLog("SeverConsts::clearVersion getResourcePath:%s", cocos2d::CCFileUtils::sharedFileUtils()->getResourcePath().c_str());
	if (cocos2d::CCFileUtils::sharedFileUtils()->getWritablePath() == (cocos2d::CCFileUtils::sharedFileUtils()->getResourcePath()+"/"))
	{
		isRmDir = false;
	}
	isRmDir = false;//temp
#endif
	if (isRmDir) game_rmdir(desFile.c_str());
#endif
    CCLOG("clearVersion dir:%s",desFile.c_str());
}
void SeverConsts::_finishUpdate()
{
	std::string tempFile(cocos2d::CCFileUtils::sharedFileUtils()->getWritablePath());
	tempFile.append("/");
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	tempFile = cocos2d::CCFileUtils::sharedFileUtils()->getResourcePath();
#endif
	//tempFile.append("/");
	tempFile.append(TEMP_CONFIG_FILE_BACKUP);

	std::string desFile(cocos2d::CCFileUtils::sharedFileUtils()->getWritablePath());
	desFile.append("/");
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	desFile = cocos2d::CCFileUtils::sharedFileUtils()->getResourcePath();
#endif
	//desFile.append("/");
	//desFile.append(mAdditionalSearchPath);
	//desFile.append("/");
	desFile.append(mConfigFile);
	//cocos2d::CCLog("SeverConsts::_finishUpdate() *************%s", desFile.c_str());
	//{
		Json::Value root;
		Json::Reader jreader;
		Json::Value data;
		unsigned long filesize;

		char* pBuffer = (char*)getFileData(mCfgFilePath.c_str(),
			"rt",&filesize,0,false);

		bool openSuccessful = true;
		if(!pBuffer)
		{
			char msg[256] = {0};
			sprintf(msg,"_finishUpdate Failed read file: %s !!",mCfgFilePath.c_str());
			//cocos2d::CCMessageBox(msg,Language::Get()->getString("@ShowMsgBoxTitle").c_str());
			CCLOG(msg);

			openSuccessful = false;
		}
		else
		{
			std::string str(pBuffer,filesize);
			openSuccessful = jreader.parse(pBuffer,data,false);
		}
		CC_SAFE_DELETE_ARRAY(pBuffer);
		if (!openSuccessful)
		{
			CCLOG("_finishUpdate Failed parse file: %s !!", mCfgFilePath.c_str());
		}
	//}
	if (openSuccessful)
	{
		
		data["version"] = 1;
		data["localVerson"] = mSeverVerson;
		data["sever"] = mSeverFile;
		Json::StyledWriter writer;
		std::string outstr = writer.write(data);
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_IOS)//modify by cooper
		int encryptBufferSize = 0;
		unsigned char* res = 0;
		//modify by cooper.x
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
		res = encryptRC4DocumentForIOS((unsigned char*)outstr.c_str(), outstr.size(),encryptBufferSize,mUnEncConfigFile.c_str());
#else
		res = encryptRC4DocumentForAndroid((unsigned char*)outstr.c_str(), outstr.size(),encryptBufferSize,mUnEncConfigFile.c_str());
#endif
		if (res)
		{			
			saveFileInPath(desFile, "wb", (const unsigned char*)res, encryptBufferSize);
		}

#else
		saveFileInPath(desFile, "wb", (const unsigned char*)outstr.c_str(), outstr.size());
#endif

#if !defined(ANDROID)
		//android not use that tempFile
		saveFileInPath(tempFile,"wb",(const unsigned char*)outstr.c_str(),outstr.size());				
#endif
		
	//	cocos2d::CCLog("SeverConsts::saveFileInPath************ %s",tempFile.c_str());
	}

	mUpdateState = US_OK;
	mCheckState  = CS_OK;
	FILELIST::iterator it = mFileListFailed.begin();
	for(;it!=mFileListFailed.end();++it)
	{
		delete (*it);
	}
	mFileListFailed.clear(); 
	FILELIST fileList;
	fileList.swap(mFileListFailed);
	libOS::getInstance()->removeListener(this);
	CurlDownload::Get()->removeListener(this);

	//modify by dylan at 20140612 内更新字体后乱码修复，原因是字体文件CCTextureCache被purge掉了但是fnt文件没有重新加载
	cocos2d::FNTConfigRemoveCache();

}

bool SeverConsts::isServerInUpdatingCode()
{
	return mServerInUpdateCode;
}

void SeverConsts::initSearchPath()
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	mAdditionalSearchPath = "Assets";
#else
//	mAdditionalSearchPath = "_additionalSearchPath";
#endif
	const std::vector<std::string>& paths = cocos2d::CCFileUtils::sharedFileUtils()->getSearchPaths();
	cocos2d::CCFileUtils::sharedFileUtils()->setDecodeBufferFun(getEncodeBuffer, rc4EncFileName,getGameEncFilePath);
	cocos2d::CCFileUtils::sharedFileUtils()->setEncFlags(EncFileNameFlag,EncFilePath,ShowSuffixFlag);
	mOriSearchPath.assign(paths.begin(),paths.end());
	cocos2d::CCFileUtils::sharedFileUtils()->purgeCachedEntries();
}

void SeverConsts::setOriginalSearchPath()
{
	cocos2d::CCFileUtils::sharedFileUtils()->setSearchPaths(mOriSearchPath);

#if ((CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID) || (CC_TARGET_PLATFORM == CC_PLATFORM_IOS) )
	//CCFileUtilsAndroid.cpp
	std::string searchpath = "data";
	cocos2d::CCFileUtils::sharedFileUtils()->addSearchPath(searchpath.c_str());
#else

	std::string searchpath = "/data";
#endif
	cocos2d::CCFileUtils::sharedFileUtils()->purgeCachedEntries();

}

void SeverConsts::setAdditionalSearchPath()
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	return;//CCFileUtilsAndroid.cpp
#endif
	std::vector<std::string> paths;
	
	//std::string searchpath = cocos2d::CCFileUtils::sharedFileUtils()->getWritablePath()+"/"+mAdditionalSearchPath;
	std::string searchpath = cocos2d::CCFileUtils::sharedFileUtils()->getWritablePath();
#if  (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID) 
	searchpath = cocos2d::CCFileUtils::sharedFileUtils()->getResourcePath();
#endif
	paths.push_back(searchpath.c_str());
	//searchpath = cocos2d::CCFileUtils::sharedFileUtils()->getWritablePath()+"/"+mAdditionalSearchPath+"/data";
	searchpath = cocos2d::CCFileUtils::sharedFileUtils()->getWritablePath() + "/data";
#if  (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID) 
	searchpath = cocos2d::CCFileUtils::sharedFileUtils()->getResourcePath() + "/data";;
#endif
	paths.push_back(searchpath.c_str());
	for(std::vector<std::string>::iterator it = mOriSearchPath.begin();it!=mOriSearchPath.end();++it)
		paths.push_back(*it);
    
#if  (CC_TARGET_PLATFORM == CC_PLATFORM_IOS) 
	searchpath = "data";
	paths.push_back(searchpath.c_str());
#else
	searchpath = "/data";
	paths.push_back(searchpath.c_str());
#endif

	cocos2d::CCFileUtils::sharedFileUtils()->setSearchPaths(paths);

	cocos2d::CCFileUtils::sharedFileUtils()->purgeCachedEntries();
}

bool SeverConsts::_getSeversWithBackupAddress()
{
	if(mSeverBackup!="" && mSeverBackup!=mSeverFile)
	{
		mSeverFile = mSeverBackup;
		start();
		return true;
	}
	return false;
}

void SeverConsts::_retryShowDownFaildMsgBox(FileType _fileType,ERROR_MESSAGE_DOWNLOAD_CODE _errCode)
{
	if(libOS::getInstance()->getNetWork()==NotReachable)
	{
		libOS::getInstance()->showMessagebox(Language::Get()->getString("@NoNetWork"),_fileType==DownSeverFile?CODE_NETWORDDISABLED_SERVER:CODE_NETWORDDISABLED_UPDATE);
	}
	else
	{
		std::string errMsg="@UpdateDescriptionCheckingFailed";
		int _tempCode=_errCode;
		if(_errCode==CODE_SEVER_FAILD_A||_errCode==CODE_SEVER_FAILD_B||_errCode==CODE_SEVER_FAILD_C)
		{
			errMsg="@SeverConstsSeverFileFailedMsg";
		}
		else if(_errCode==CODE_UPDATE_FAILD_A||_errCode==CODE_UPDATE_FAILD_B||_errCode==CODE_SEVER_FAILD_C)
		{
			errMsg="@SeverConstsUpdateFileFailedMsg";
		}
		else if(_errCode==CODE_SU_DIFF)
		{
			errMsg="@SeverConstsFileDiffMsg";
		}
		else if(_errCode==CODE_NO_SPACE)
		{
			errMsg="@NotEnoughSpaceForUpdateMsg";
		}
		else if(_errCode==CODE_LIST_FILE_FAILED||_errCode==CODE_LIST_FILE_DOWNLOADED)
		{
			errMsg="@UpdateFileListFailed";
			libOS::getInstance()->showMessagebox(Language::Get()->getString(errMsg)+mFailedName+"["+StringConverter::toString(_errCode)+"]",_errCode);
		}
		else
		{
			errMsg="@UpdateFileListException";
			_tempCode=CODE_OTHER_ERROR;
		}
		if(_errCode!=CODE_LIST_FILE_FAILED)
		{
			libOS::getInstance()->showMessagebox(Language::Get()->getString(errMsg)+"["+StringConverter::toString(_errCode)+"]",_tempCode);
		}
	}
}

void SeverConsts::onMessageboxEnter(int tag)
{
	if(tag==CODE_NETWORDDISABLED_SERVER||tag==CODE_SEVER_FAILD_A||tag==CODE_SEVER_FAILD_B||tag==CODE_SEVER_FAILD_C)
	{
		start();
	}
	else if(tag==CODE_NETWORDDISABLED_UPDATE||tag==CODE_UPDATE_FAILD_A||tag==CODE_UPDATE_FAILD_B||tag==CODE_SU_DIFF||tag==CODE_UPDATE_FAILD_C)
	{
		_retryUpdateFile();
	}
	else if(tag==CODE_NO_SPACE||tag==CODE_OTHER_ERROR)
	{
		mUpdateState=US_FAILED;
	}
	else if(tag==CODE_LIST_FILE_FAILED||tag==CODE_LIST_FILE_DOWNLOADED)
	{//list file failed retry download
		
        {
            AutoRelaseLock autolock(mFileListMutex);
            mFileList.swap(mFileListFailed);
            mDownloadFailedList.clear();
            std::list<std::string > _tempList;
            _tempList.swap(mDownloadFailedList);
        }
		if(mFileList.empty())
		{
			mUpdateState = US_NOT_STARTED;
			cocos2d::CCFileUtils::sharedFileUtils()->purgeCachedEntries();
			updateResources();
		}
		else
		{
			mUpdateState=US_CHECKING;
			_downloadFiles();
		}
	}
}

std::string SeverConsts::_getTimeStamp(std::string _url)
{
	std::string _retTimestamp="";
	time_t t = time(0); 
	std::string::size_type index=_url.find_last_of("?");
	if(index!=_url.npos)
	{
		_retTimestamp="&timestamp="+StringConverter::toString(t);
	}
	else
	{
		_retTimestamp="?timestamp="+StringConverter::toString(t);
	}
	return _retTimestamp;
}

const std::string SeverConsts::getServerInfoByLua()
{
	std::string serverInfoStr = "";
	for (SEVERLIST::iterator it = mSeverList.begin(); it != mSeverList.end(); ++it)
	{
		char tmp[64] = { 0 };
		sprintf(tmp, "%d_%s_%s_%d_%d_%d:", it->second->id, it->second->name.c_str(), it->second->address.c_str(), it->second->port, it->second->state, it->second->order);
		serverInfoStr += tmp;
	}
	serverInfoStr = serverInfoStr.substr(0, serverInfoStr.length() - 1);
	return serverInfoStr;
}

SeverConsts* SeverConsts::getInstance()
{
	return SeverConsts::Get();
}

void SeverConsts::setIsInLoading(bool isInLoading)
{
	m_bIsInLoading = isInLoading;
}