/****************************************************************************
Copyright (c) 2010 cocos2d-x.org

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
#include "CCFileUtilsAndroid.h"
#include "support/zip_support/ZipUtils.h"
#include "platform/CCCommon.h"
#include "jni/Java_org_cocos2dx_lib_Cocos2dxHelper.h"
#include "support/zip_support/unzip.h"

      #include <sys/types.h>
       #include <sys/stat.h>
       #include <fcntl.h>
#include <stdio.h>


using namespace std;

NS_CC_BEGIN

// record the zip on the resource path
static ZipFile *s_pZipFile = NULL;

CCFileUtils* CCFileUtils::sharedFileUtils()
{
    if (s_sharedFileUtils == NULL)
    {
        s_sharedFileUtils = new CCFileUtilsAndroid();
        s_sharedFileUtils->init();
        std::string resourcePath = getApkPath();
        s_pZipFile = new ZipFile(resourcePath, "assets/");
    }
    return s_sharedFileUtils;
}

CCFileUtilsAndroid::CCFileUtilsAndroid()
{
}

CCFileUtilsAndroid::~CCFileUtilsAndroid()
{
    CC_SAFE_DELETE(s_pZipFile);
}

bool CCFileUtilsAndroid::init()
{
	m_strAppExternalStoragePath = std::string(getAppExternalStoragePath()) + "/";
	m_strAppExternalStorageResourcesPath = std::string(getAppExternalStoragePath()) + "/Assets/";
	//m_searchPathArray.push_back(m_strAppExternalStorageResourcesPath);
	//m_strDefaultResRootPath = m_strAppExternalStorageResourcesPath;
	//不再这里动searchpath了，只到真正从assets zip查文件前，额外先组合一个外部存储资源路径查raw文件
	m_strDefaultResRootPath = "assets/";
	m_strApkAssetsZipPathPrefix = "assets/";
	//
	bool bResult = false;
    bResult = CCFileUtils::init();
    //
    //m_searchPathArray.push_back(m_strApkAssetsZipPathPrefix);
    //
    return bResult;
}

bool CCFileUtilsAndroid::isFileExist(const std::string& strFilePath)
{
    if (0 == strFilePath.length())
    {
        return false;
    }

    bool bFound = false;
    
    // Check whether file exists in apk.
    if (strFilePath[0] != '/')
    {
    	//--begin xinzheng 2013-05-18
    	//先尝试补成外部存储资源路径看下
    	std::string strFullPath = m_strAppExternalStoragePath + strFilePath;//不需要添加PathPrefix，自带了assets/
		CCLOGINFO("CCFileUtilsAndroid::isFileExist 1: %s", strFullPath.c_str());
    	FILE *fp = fopen(strFullPath.c_str(), "r");
		if(fp)
		{
			CCLOGINFO("found CCFileUtilsAndroid::isFileExist 1: %s", strFullPath.c_str());
			bFound = true;
			fclose(fp);
			return bFound;
		}
    	//--end xinzheng 2013-05-18

        std::string strPath = strFilePath;
        //if (strPath.find(m_strDefaultResRootPath) != 0)
        if (strPath.find(m_strApkAssetsZipPathPrefix) != 0)
        {// Didn't find "assets/" at the beginning of the path, adding it.
            //strPath.insert(0, m_strDefaultResRootPath);
        	strPath.insert(0, m_strApkAssetsZipPathPrefix);
        }
		CCLOGINFO("CCFileUtilsAndroid::isFileExist 2: %s", strPath.c_str());
        if (s_pZipFile->fileExists(strPath))
        {
			CCLOGINFO("found CCFileUtilsAndroid::isFileExist 2: %s", strPath.c_str());
            bFound = true;
        } 
    }
    else
    {
		CCLOGINFO("CCFileUtilsAndroid::isFileExist 3: %s", strFilePath.c_str());
        FILE *fp = fopen(strFilePath.c_str(), "r");
        if(fp)
        {
			CCLOGINFO("found CCFileUtilsAndroid::isFileExist 3: %s", strFilePath.c_str());
            bFound = true;
            fclose(fp);
        }
    }
    return bFound;
}

bool CCFileUtilsAndroid::isAbsolutePath(const std::string& strPath)
{
    // On Android, there are two situations for full path.
    // 1) Files in APK, e.g. assets/path/path/file.png
    // 2) Files not in APK, e.g. /data/data/org.cocos2dx.hellocpp/cache/path/path/file.png, or /sdcard/path/path/file.png.
    // So these two situations need to be checked on Android.
    //if (strPath[0] == '/' || strPath.find(m_strDefaultResRootPath) == 0)
	if (strPath[0] == '/' || strPath.find(m_strApkAssetsZipPathPrefix) == 0)
    {
        return true;
    }
	CCLOGINFO("CCFileUtilsAndroid::isAbsolutePath : %s", strPath.c_str());
    return false;
}


unsigned char* CCFileUtilsAndroid::getFileData(const char* pszFileName, const char* pszMode, unsigned long * pSize, bool isShowBox, unsigned short* crc, bool isEncFileName, bool isEncFilePath, bool SuffixFlag)
{    
    return doGetFileData(pszFileName, pszMode, pSize, isShowBox, crc, false,isEncFileName,isEncFilePath,SuffixFlag);
}

unsigned char* CCFileUtilsAndroid::getFileDataForAsync(const char* pszFileName, const char* pszMode, unsigned long * pSize)
{
    return doGetFileData(pszFileName, pszMode, pSize, false, NULL, true);
}

unsigned char* CCFileUtilsAndroid::doGetFileData(const char* pszFileName, const char* pszMode, unsigned long * pSize, bool isShowBox/*=true*/, unsigned short* crc/*=0*/, bool forAsync/*=false*/, bool isEncFileName, bool isEncFilePath, bool SuffixFlag)
{
	
    std::string strAppExternalStoragePath = m_strAppExternalStoragePath; 
    unsigned char * pData = 0;
	
    if ((! pszFileName) || (! pszMode) || 0 == strlen(pszFileName))
    {
        return 0;
    }
	CCLOGINFO("CCFileUtilsAndroid::getFileData: %s", pszFileName);
	std::string encFileName = getEncFilePath(pszFileName, isEncFileName, isEncFilePath, SuffixFlag);
	std::string backupName = encFileName;
	if (encFileName.c_str()[0] != '/')
    {
		
    	//--begin xinzheng 2013-05-18
		//先尝试补成外部存储资源路径看下
		//add by cooper.x		
		std::string sub = encFileName.substr(0,6);
		if (sub == "assets")
		{
			encFileName = "A" + encFileName.substr(1,encFileName.length()-1);
		}
		std::string strFullPath = strAppExternalStoragePath + encFileName.c_str();
		//std::string strFullPath = m_strAppExternalStoragePath + isEncFileName?encFileName.c_str():pszFileName;//不需要添加PathPrefix，自带了assets/
		CCLOGINFO("GETTING FILE RELATIVE DATA 1: %s", strFullPath.c_str());
		FILE *fp = fopen(strFullPath.c_str(), pszMode);
		if(fp)
		{
	        do
	        {
	            // read rrom other path than user set it
		        //CCLOG("GETTING FILE ABSOLUTE DATA: %s", pszFileName);
	            //FILE *fp = fopen(pszFileName, pszMode);
	            //CC_BREAK_IF(!fp);

	            unsigned long size;
	            fseek(fp,0,SEEK_END);
	            size = ftell(fp);
	            fseek(fp,0,SEEK_SET);
	            pData = new unsigned char[size];
	            size = fread(pData,sizeof(unsigned char), size,fp);
	            fclose(fp);

	            if (pSize)
	            {
	                *pSize = size;
	            }
	        } while (0);
			CCLOGINFO("got CCFileUtilsAndroid::getFileData 1: %s", strFullPath.c_str());
		}
		else
		{
			//--end xinzheng 2013-05-18
			//CCLOG("GETTING FILE RELATIVE DATA: %s", pszFileName);
			encFileName = backupName;
			string fullPath = encFileName;
			//CCLOG("GETTING FILE RELATIVE DATA 2: %s", fullPath.c_str());
			if (fullPath.find(m_strApkAssetsZipPathPrefix) != 0)
			{// Didn't find "assets/" at the beginning of the path, adding it.
				//strPath.insert(0, m_strDefaultResRootPath);
				CCLog("is file exits,insert assets:%s------", fullPath.c_str());
				fullPath.insert(0, m_strApkAssetsZipPathPrefix);
			}
			if (forAsync)
        	{
				//pData = s_pZipFile->getFileData(fullPath.c_str(), pSize, s_pZipFile->_dataThread);
				pData = s_pZipFile->getFileData(fullPath.c_str(), pSize);
        	}
        	else
        	{
				pData = s_pZipFile->getFileData(fullPath.c_str(), pSize);
			}
			CCLOGINFO("got CCFileUtilsAndroid::getFileData 2: %s", fullPath.c_str());
		}
    }
    else
    {
        do 
        {
            // read rrom other path than user set it CCLOGINFO
			CCLOGINFO("GETTING FILE ABSOLUTE DATA: oriName:%s,Mode:%s,EncFileName:%s", pszFileName, pszMode, encFileName.c_str());
			FILE *fp = fopen(encFileName.c_str(), pszMode);
            CC_BREAK_IF(!fp);

            unsigned long size;
            fseek(fp,0,SEEK_END);
            size = ftell(fp);
            fseek(fp,0,SEEK_SET);
            pData = new unsigned char[size];
            size = fread(pData,sizeof(unsigned char), size,fp);
            fclose(fp);

            if (pSize)
            {
                *pSize = size;
            }           
			CCLOGINFO("got CCFileUtilsAndroid::getFileData 3: oriName:%s,encName:%s", pszFileName, encFileName.c_str());
        } while (0);    
    }

    if (! pData)
    {
        std::string msg = "Get data from file(";
        msg.append(pszFileName).append(") failed!");
        CCLOG(msg.c_str());
		//add by dylan at 20131015  file not found show messagebox
		if(isShowBox&&msg.find(".msg")==std::string::npos&&msg!=".ccbi")
		{
			if(msg.find(".")!=std::string::npos)
			{
				CCMessageBox(msg.c_str(),"File Not Found");
			}
			
			bool isPNG=msg.find(".png")!=std::string::npos||msg.find(".PNG")!=std::string::npos;
			
			if(isPNG||msg.find(".jpg")!=std::string::npos||msg.find(".JPG")!=std::string::npos)
			{
				std::string fileName="empty.jpg";
				if(isPNG)
				{//如果是png类型文件,找一下jpg对应的文件名字是否存在
					std::string searchFile=pszFileName;
					searchFile=searchFile.substr(0,searchFile.find(".png"))+".jpg";
					searchFile = getEncFilePath(searchFile.c_str(), true, true, false);
					bool isHavFile=isFileExist(fullPathForFilename(searchFile.c_str()).c_str());
					if(isHavFile)
					{
						return getFileData(searchFile.c_str(), pszMode, pSize, isShowBox, crc);
					}
					fileName="empty.png";
				}
				do
				{
					// read the file from hardware

					isEncFileName = canEncFileName(isEncFileName);
					if (isEncFileName)
					{
						fileName = (m_rc4FileName)(fileName.c_str());
					}

					std::string fullPath = strAppExternalStoragePath + fileName;//m_strAppExternalStoragePath + fullPathForFilename("mainScene/empty.png");
					FILE *fp = fopen(fullPath.c_str(), pszMode);
					CC_BREAK_IF(!fp);

					unsigned long size;
					fseek(fp,0,SEEK_END);
					size = ftell(fp);
					fseek(fp,0,SEEK_SET);
					pData = new unsigned char[size];
					size = fread(pData,sizeof(unsigned char), size,fp);
					fclose(fp);

					if (pSize)
					{
						*pSize = size;
					}
				} while (0);
			}
		}
		//
    }

	if (crc != 0)
	{
		*crc = GetCRC16((unsigned char*)pData, *pSize);
	}

	if (pData&&m_decodeBuff)
	{
		return (m_decodeBuff)(pSize, pData, pszFileName, pszMode);
	}
    return pData;
}


/************************************************************************/
/* 确保返回的路径以‘/’结尾 modify by xinghui                          */
/************************************************************************/
string CCFileUtilsAndroid::getWritablePath()
{

	//--begin xinzheng 2013-5-20
	//modify by xinghui
	string writePath = getAppExternalStoragePath();
	if ((*writePath.rbegin()) != '\\' && (*writePath.rbegin()) != '/')
	{
		//todo... 2014.10.10 by chenpanhua
		//writePath += "/";
	}
	
	return writePath;
	//--end
    // Fix for Nexus 10 (Android 4.2 multi-user environment)
    // the path is retrieved through Java Context.getCacheDir() method
  //  string dir("");
  //  string tmp = getFileDirectoryJNI();

  //  if (tmp.length() > 0)
  //  {
		////todo... 2014.10.10 by chenpanhua
  //      dir.append(tmp).append("/Assets/");

  //      return dir;
  //  }
  //  else
  //  {
  //      return "";
  //  }
}

std::string CCFileUtilsAndroid::getResourcePath()
{
	//2014.10.08 by chenpanhua 
	string dir("");
	string tmp = getFileDirectoryJNI();

	if (tmp.length() > 0)
	{
		dir.append(tmp).append("/Assets/");

		return dir;
	}
	else
	{
		return "";
	}
	//return "/storage/sdcard0/Android/data/com.nuclear.dragonb.platform.uc/files/Assets/";    
}

int CCFileUtilsAndroid::getFileDescriptor(const char * _filename, off_t & start, off_t & length)
{


	   if (_filename[0] != '/')
	   {

		   std::string strPath = _filename;
			if (strPath.find(m_strDefaultResRootPath) != 0)
			{// Didn't find "assets/" at the beginning of the path, adding it.
				strPath.insert(0, m_strDefaultResRootPath);
			}
			const char * filename = strPath.c_str();
			
			//todo... 2014.10.10 by chenpanhua
			//struct ZipEntryInfo* entry=NULL;
			//entry=this->getZipFileEntry(filename);

			//if(entry==NULL)
			//{
			//	return -1;
			//}

			//start  = entry->pos.pos_in_zip_directory;
			//length = entry->pos.num_of_file;
			//delete entry;

			int ret = open(getApkPath(),O_RDONLY);
			  CCLOG("open zipped file %s ret %d (%u,%u)",filename,ret,start,length);
			return ret;
	   }
	   else
	   {
		   const char * filename = _filename;
		   FILE * fp = fopen(filename, "rb");
		      if(fp==NULL)
		          return -1;
		      fseek(fp,0,SEEK_END);

		      size_t sz = ftell(fp);
		      fseek(fp,0,SEEK_SET);
		      fclose(fp);
		      start = 0;
		      length =sz;

		   int ret = open(getApkPath(),O_RDONLY);
		   CCLOG("open normal file %s ret %d (%u,%u)",filename,ret,start,length);

		   return ret;
	   }
}
NS_CC_END
