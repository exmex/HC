//
//  HeroFileUtils.cpp
//  cocos2dx
//
//  Created by eboz on 14-6-16.
//

#include "HeroFileUtils.h"
#include "cocos2d.h"
#include <stdio.h>
#include <sys/stat.h>
#include "../../scripting/lua/md5/md5.h"
#ifdef _WIN32
#include <windows.h>
#else
#include <unistd.h>
#endif
#include <stdlib.h>
#include <errno.h>
#ifdef _WIN32
#include "support/win_dirent.h"
#else
#include <dirent.h>
#endif
#include <string.h>
#include "GameEncryptKey.h"
#include "../../cocos2dx/platform/CCCommon.h"

unsigned char*  decodeFileData(unsigned  char *data, unsigned long* sz,const char * filename)
{
	return decodeLuaFile(sz, data,filename);
}


void LegendFreeString(char *str)
{
    free(str);
}

extern "C"  void encyptFileData(unsigned char *data, unsigned long sz)
{
	for (size_t i = 0; i < sz; i++)
	{
		data[i] = data[i] ^ 0xdd;
	}
}

extern "C"  void encGetDeployFileName(const char *inputFileName, char *outfileName)
{
#define ALPHA_MASK_EXT "_alpha_mask"
#define DEPLOY_FILE_NAME_PREFIX "wmss_hero_project_2014/"

	if(cocos2d::CCFileUtils::sharedFileUtils()->isAbsolutePath(inputFileName))
	{
		strcpy(outfileName, inputFileName);
		return;
	}

	char filename[512] = DEPLOY_FILE_NAME_PREFIX;

	const char *pext = strrchr(inputFileName, '.');

	if (pext != NULL && (strcmp(".ddx", pext) == 0 || strcmp(".ddv", pext) == 0))
	{
		strcpy(outfileName, inputFileName);
		return;
	}

	char rawmd5[16];
	strcat(filename, inputFileName);
	md5(filename, strlen(filename), rawmd5);

	for (int i = 0; i < 16; i++)
	{
		sprintf(outfileName + 2 + i * 2, "%02x", (unsigned char)rawmd5[i]);
	}

	if (pext != NULL && strcmp(".ogg", pext) == 0)
		strcpy(outfileName + 2 + 32, ".ddv");
	else
		strcpy(outfileName + 2 + 32, ".ddx");

	outfileName[0] = outfileName[2];
	outfileName[1] = '/';
}

extern "C"  char * LegendFindFile(const char *inputFileName)
{
	clock_t start, end;
	start = clock();
	//这个部分提出去
	std::string mAdditionalSearchPath;
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	mAdditionalSearchPath = "Assets";
#else
	//mAdditionalSearchPath = "_additionalSearchPath";
#endif
	//此处用一map存储起来，节省性能开销，需要考虑多出调用getGameEncFilePath
	std::string filePath = cocos2d::CCFileUtils::sharedFileUtils()->getEncFilePath(inputFileName,EncFileNameFlag, EncFilePath, ShowSuffixFlag);
	//CCLOG("[HeroFileUtils|LegendFindFile] convert file path to enc oriPath:%s,encPath:%s", inputFileName, filePath.c_str());

    cocos2d::CCFileUtils *futil = cocos2d::CCFileUtils::sharedFileUtils();
	if (futil->isAbsolutePath(filePath.c_str()))
    {
		if (futil->isFileExist(filePath.c_str()))
			return strdup(filePath.c_str());
		//CCLOG("[HeroFileUtils|LegendFindFile]LegendFind File not found %s,encFileName:%s", inputFileName, filePath.c_str());
        return NULL;
    }
    std::string patch_path = futil->getWritablePath() ;
    std::string bundle_path = futil->getResourcePath();
    
    if(patch_path[patch_path.length()-1]!='/' && patch_path[patch_path.length()-1]!='\\' )
    {
#ifdef _WIN32
        patch_path = patch_path+"\\";
#else
		patch_path = patch_path + "/";
#endif
    }

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    
#else
    if(bundle_path[bundle_path.length()-1]!='/' && bundle_path[bundle_path.length()-1]!='\\' )
    {
#ifdef _WIN32
		bundle_path = bundle_path + "\\";
#else
        bundle_path = bundle_path+"/";
#endif
    }
#endif



	std::string ret;

//#ifdef _WIN32&&_DEBUG
#if 0
	//Windows 版本优先查找原始资源
	bool isPng = false;
	patch_path = patch_path + "deploy_res/";
	std::string fileNameTemp = inputFileName;
	std::string szInputFileName = inputFileName;
	std::string::size_type splitPos = fileNameTemp.find(".lua");
	bool isLua = false;
	if (splitPos != std::string::npos)
	{
		isLua = true;
		szInputFileName = fileNameTemp + "c";
	}
	bool isFile = false;
	char deployName[50];

	splitPos = fileNameTemp.find(".png");
	if (splitPos != std::string::npos)
	{
		isPng = true;
		encGetDeployFileName(szInputFileName.c_str(), deployName);
		cocos2d::CCLog("Decode [HeroFileUtils|LegendFindFile ] ori:%s,convert:%s,encName,%s", inputFileName, szInputFileName.c_str(), deployName);
		ret = bundle_path + "deploy_res/deploy_res/" + deployName;
		if (futil->isFileExist(ret))
		{
			if (isPng)fileNameTemp = szInputFileName;
			cocos2d::CCLog("Decode ok 0 [HeroFileUtils|LegendFindFile ] ori:%s,encName:%s,findFile:%s", inputFileName, deployName, ret.c_str());
			isFile = true;
		}
		if (!isFile)
		{
			szInputFileName = fileNameTemp.substr(0, splitPos) + "." + "jpg";
		}
		
	}

	if (!isFile)
	{
		encGetDeployFileName(szInputFileName.c_str(), deployName);
		cocos2d::CCLog("Decode [HeroFileUtils|LegendFindFile ] ori:%s,convert:%s,encName,%s", inputFileName, szInputFileName.c_str(), deployName);

		ret = bundle_path + "deploy_res/deploy_res/" + deployName;
		if (futil->isFileExist(ret))
		{
			if (isPng)fileNameTemp = szInputFileName;
			cocos2d::CCLog("Decode ok 1 [HeroFileUtils|LegendFindFile ] ori:%s,encName:%s,findFile:%s", inputFileName, deployName, ret.c_str());
			isFile = true;
		}
		else
		{
			if (isPng)
			{
				fileNameTemp = fileNameTemp.substr(0, splitPos) + ".pvr.ccz";
			}
			encGetDeployFileName(fileNameTemp.c_str(), deployName);
			ret = bundle_path + "deploy_res/deploy_res/" + deployName;
			if (futil->isFileExist(ret))
			{
				cocos2d::CCLog("Decode ok 2 [HeroFileUtils|LegendFindFile ] ori:%s,encName:%s,findFile:%s", inputFileName, deployName, ret.c_str());
				isFile = true;
			}
			else
			{
				cocos2d::CCLog("Decode Failed Not Found 2 [HeroFileUtils|LegendFindFile ] ori:%s", inputFileName);
			}
		}
	}
	
	if(isFile)
	{
		unsigned long sz = 0;
		unsigned char* data = cocos2d::CCFileUtils::sharedFileUtils()->getFileData(ret.c_str(), "rb", &sz);

		if (isLua)
		{
			std::string temp = bundle_path + "deploy_res/" + fileNameTemp+"enc";
			FILE* fp = fopen(temp.c_str(), "wb"); //
			if (fp)
			{
				size_t return_size = fwrite(data, 1, sz, fp);
			}
			fclose(fp);
			encyptFileData(data, sz);
		}

		std::string destPath = bundle_path + "deploy_res/" + fileNameTemp;
		FILE* fp = fopen(destPath.c_str(), "wb"); //
		if (fp)
		{
			size_t return_size = fwrite(data, 1, sz, fp);
		}
		fclose(fp);
		cocos2d::CCLog("decFileName:%s", destPath.c_str());
	}

#endif

#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 || CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_MAC)
	ret = patch_path + filePath;
	//cocos2d::CCLog("********[HeroFileUtil|LegendFindFile]: file start | oriFileName:%s", inputFileName);
	if (futil->isFileExist(ret))
	{
		//cocos2d::CCLog("[HeroFileUtils|LegendFindFile]::addition file file  %s", ret.c_str());
		return strdup(ret.c_str());
	}

	ret = bundle_path + filePath;
	if (futil->isFileExist(ret))
	{
		//cocos2d::CCLog("[HeroFileUtils|LegendFindFile]::bundle file file  %s", ret.c_str());
		return strdup(ret.c_str());
	}

	//多语言版本美术资源目录
	std::string language = cocos2d::CCUserDefault::sharedUserDefault()->getStringForKey("client_language");
	if (language == "")
	{
		language = "en-US";
	}
	std::string tmpDir = "multilanguage/" + language + "/" + inputFileName;
	std::string dir =  cocos2d::CCFileUtils::sharedFileUtils()->getEncFilePath(tmpDir.c_str(),EncFileNameFlag, EncFilePath, ShowSuffixFlag);
	//先找内更新目录
	ret = patch_path + dir;
	if (futil->isFileExist(ret))
	{
		return strdup(ret.c_str());
	}

	ret = bundle_path + dir;
	if (futil->isFileExist(ret))
	{
		end = clock();
		CCLOG("find multilange file use time:%d", (int)(end - start));
		return strdup(ret.c_str());
	}
	//如果对应语言找不到的话，就使用英文目录的
	language = "en-US";
	tmpDir = "multilanguage/" + language + "/" + inputFileName;
	dir =  cocos2d::CCFileUtils::sharedFileUtils()->getEncFilePath(tmpDir.c_str(),EncFileNameFlag, EncFilePath, ShowSuffixFlag);


	ret = bundle_path + dir;
	if (futil->isFileExist(ret))
	{
		return strdup(ret.c_str());
	}
#else
	ret = bundle_path + filePath;
	if (futil->isFileExist(ret))
	{
		//cocos2d::CCLog("[HeroFileUtils|LegendFindFile]::bundle file file  %s", ret.c_str());
		return strdup(ret.c_str());
	}
	else if (futil->isFileExist(filePath))
	{
		return strdup(filePath.c_str());
	}

	//多语言版本美术资源目录
	std::string language = cocos2d::CCUserDefault::sharedUserDefault()->getStringForKey("client_language");
	if (language == "")
	{
		language = "en-US";
	}
	std::string tmpDir = "multilanguage/" + language + "/"+inputFileName;
	std::string dir = cocos2d::CCFileUtils::sharedFileUtils()->getEncFilePath(tmpDir.c_str(), EncFileNameFlag, EncFilePath, ShowSuffixFlag);
	
	//先找内更新目录
	ret = patch_path + dir;
	if (futil->isFileExist(ret))
	{
		return strdup(ret.c_str());
	}

	std::string tempFilePath = filePath;
	ret = bundle_path + dir;
	filePath = dir;
	if (futil->isFileExist(ret))
	{
		return strdup(ret.c_str());
	}
	else if (futil->isFileExist(filePath))
	{
		return strdup(filePath.c_str());
	}
	//如果对应语言找不到的话，就使用英文目录的
	language = "en-US";
	tmpDir = "multilanguage/" + language + "/"+inputFileName;
	dir = cocos2d::CCFileUtils::sharedFileUtils()->getEncFilePath(tmpDir.c_str(), EncFileNameFlag, EncFilePath, ShowSuffixFlag);
	ret = bundle_path + dir;
	filePath = dir;
	if (futil->isFileExist(ret))
	{
		return strdup(ret.c_str());
	}
	else if (futil->isFileExist(filePath))
	{ 
		return strdup(filePath.c_str());
	}
#endif

#ifdef _DEBUG 
	cocos2d::CCLog("[FileUtil|LegendFindFile]: File Not Found :%s,%s", filePath.c_str(),inputFileName);
#endif

	//cocos2d::CCLog("********[HeroFileUtil|LegendFindFile]: file not found end | oriFileName:%s,encFilePath:%s", inputFileName,ret.c_str());

#if WIN32

#else
//	char errMsg[256] = {0};
//	sprintf(errMsg, "[HeroFileUtil|LegendFindFile]: file not found :%s", ret.c_str());
//	cocos2d::CCMessageBox(errMsg, "File Not Found!");
#endif
	
	return NULL;
}

 unsigned char * LegendLoadScriptFileContents(const char *inputFileName, unsigned long *sz)
{
    unsigned char * data = NULL;
    std::string scriptFileName = "data/";
    char szInputFileName[255];
    strcpy(szInputFileName,inputFileName);
    char *p = szInputFileName;
    while(*p!=0)
    {
        if(*p=='.')
        {
            *p = '/';
        }
        p++;
    }
    
    scriptFileName = scriptFileName+ szInputFileName + ".lua";
    
    std::string path = LegendFindFileCpp(scriptFileName.c_str());
    cocos2d::CCFileUtils *futil = cocos2d::CCFileUtils::sharedFileUtils();
    if(path.empty())
    {
        scriptFileName = "data/";
        scriptFileName = scriptFileName+ szInputFileName + ".lua";
        path = LegendFindFileCpp(scriptFileName.c_str());
        if(path.empty())
            return NULL;
    }
 
    
    data = futil->getFileData(path.c_str(), "rb", sz);
    
    return data;
}

void LegendFreeFileContents(char *data)
{
    delete []data;
}

 unsigned char  * LegendGetFileContents(const char *inputFileName, unsigned long *sz)
 {
     std::string path = LegendFindFileCpp(inputFileName);
      cocos2d::CCFileUtils *futil = cocos2d::CCFileUtils::sharedFileUtils();
     if(path.empty())
     {
         return futil->getFileData(inputFileName, "rb", sz);
     }
     else
     {
         return futil->getFileData(path.c_str(), "rb", sz);
     }
 }


long LegendGetFileModifyTime(const char *szFile)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_MAC)
     struct stat buf={0};
    if(stat("/etc/hosts", &buf)!=0)
          return 0;
    return buf.st_mtimespec.tv_sec;
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
     struct stat buf={0};
    if(stat("/etc/hosts", &buf)!=0)
          return 0;
    return buf.st_mtime;
#else 
    struct _stat buf;
    if(_stat("/etc/hosts", &buf)!=0)
          return 0;
    return buf.st_mtime;
#endif
}


int change_path(const char *path)
{
#ifdef _WIN32
	return 0;
#else
    //printf("Leave %s Successed . . .\n",getcwd(NULL,0));
    if(chdir(path)==-1)
        return -1;
    return 0;
#endif
   // printf("Entry %s Successed . . .\n",getcwd(NULL,0));
}
int  LegendCheckDirectoryExists(const char * path)
{
 #ifdef _WIN32
    return 0;
#else
    DIR *dir;
    if((dir=opendir(path))==NULL)
        return 0;
    closedir(dir);
    return 1;
#endif
}
int LegendForceRemoveDictory(const char *path)
{
#ifdef _WIN32
	return 0;
#else
    DIR *dir;
    struct dirent *dirp;
    struct stat buf;
    char *p=getcwd(NULL,0);
    
    if((dir=opendir(path))==NULL)
        return -1;
    
    change_path(path);
    
    while(true)
    {
        dirp=readdir(dir);
        if(dirp==NULL)
            break;
        
        if((strcmp(dirp->d_name,".")==0) || (strcmp(dirp->d_name,"..")==0))
            continue;
        
        if(stat(dirp->d_name,&buf)==-1)
            return  -1;
        
        if(S_ISDIR(buf.st_mode))
        {
            LegendForceRemoveDictory(dirp->d_name);
            /*if(rmdir(dirp->d_name)==-1)
             error_quit("rmdir");
             printf("rm %s Successed . . .\n",dirp->d_name);*/
            continue;
        }
        
        if(remove(dirp->d_name)==-1)
           return -1;
        
       // printf("rm %s Successed . . .\n",dirp->d_name);
    }
    
    closedir(dir);
    change_path(p);
    
    if(rmdir(path)==-1)
        return -1;
    return 0;
#endif   
    //printf("rm %s Successed . . .\n",path);
}


//#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
void * create_json_obj_frome_string(const char *jsonStr)
{
    return NULL;
}

void * json_get_value(void *json_obj, const char* key)
{
    return NULL;
}


std::vector<void * > json_get_array(void *json_obj, const char *key)
{
    return std::vector<void *>();
}
void free_json_obj(void *json_obj)
{
    
}

std::string json_value_to_string(void *jsonvalue)
{
    std::string ret;
    return ret;
}
int    json_value_to_integer(void *jsonvalue)
{
    return 0;
}


//#endif


