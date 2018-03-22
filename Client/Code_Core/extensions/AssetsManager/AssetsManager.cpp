/****************************************************************************
 Copyright (c) 2013 cocos2d-x.org
 
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

#include "AssetsManager.h"
#include "cocos2d.h"

#include <curl/curl.h>
#include <curl/easy.h>
#include <stdio.h>
#include <vector>

#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#endif

#include "support/zip_support/unzip.h"
#include "HeroFileUtils.h"


using namespace cocos2d;
using namespace std;

NS_CC_EXT_BEGIN;

#define KEY_OF_VERSION   "current-version"
#define KEY_OF_LATEST_VERSION "latest-version"
//#define KEY_OF_DOWNLOADED_VERSION    "downloaded-version"
#define TEMP_PATCHES_DIR    "patches_tmp"
#define PATCHES_DIR    "patches"

#define BUFFER_SIZE    8192
#define MAX_FILENAME   512


#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
static int   s_requestQueueMutex_inited = 0;
static pthread_mutex_t  s_requestQueueMutex;
static pthread_t        s_networkDownloadThread;
static pthread_t        s_networkCheckVersionThread;
static pthread_mutex_t  s_workerThreadMutex;
static int              s_currentFileIndex = -1;
#endif


int AssetsManager::_checkingThreadRunning = 0;

void AssetsManager::checkStoragePath()
{
    if (_storagePath.size() > 0 && _storagePath[_storagePath.size() - 1] != '/')
    {
        _storagePath.append("/");
    }
    
}

static size_t getVersionCode(void *ptr, size_t size, size_t nmemb, void *userdata)
{
    string *version = (string*)userdata;
#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
    pthread_mutex_lock(&s_requestQueueMutex); //Get request task from queue
#endif
    version->append((char*)ptr, size * nmemb);
#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
    pthread_mutex_unlock(&s_requestQueueMutex);
#endif
    
    return (size * nmemb);
    
    
}

bool AssetsManager::isBinaryUpdated()
{
   return this->_binaryUpdated;
}

void AssetsManager::reset()
{
    _binaryUpdated = false;
    _currentStatusCode = AMG_STATUS_NONE;
    _bytesTotoal = 0;
    _bytesLoaded = 0;
    _fileList.clear();
    _onCompleteCalled  = true;
    _checkingThreadRunning  =0;
    _pendingUpdateCall = false;
    _isApplyDownloadFiles = 0;
    _isDownloading = 0;
}


float AssetsManager::getProgress()
{
    if(_currentStatusCode==AMG_STATUS_NONE)
    {
        
        return 0.0f;
    }
   
    if(_currentStatusCode==AMG_STATUS_DOWNLOAD_FINISHED)
    {
        return 1.0f;
    }
    
    if(_bytesTotoal==0)
        return 0.0f;
    
    if(_currentStatusCode==AMG_STATUS_DOWNLOADING)
    {
         char sztmp[100];
        if(_isApplyDownloadFiles)
        {
            
           
            sprintf(sztmp, "Apply Patching files(%d/%d)", _numFilesApplies/2, _totalFiles/2);
            
            _downloadDesc = sztmp;
            
            return ((double)_numFilesApplies)/((double)_totalFiles);
        }
        else
        {
       
            if( (_bytesTotoal/1024/1024) > 0)
            {
                sprintf(sztmp, "Downloading %0.1fMB/%0.1fMB", ((double)_bytesLoaded)/1024.0/1024.0, ((double)_bytesTotoal)/1024.0/1024.0 );
            }
            else{
                 sprintf(sztmp, "Downloading %0.1fKB/%0.1fKB", ((double)_bytesLoaded)/1024.0, ((double)_bytesTotoal)/1024.0 );
            }
            _downloadDesc = sztmp;
            
            return ((double)_bytesLoaded)/((double)_bytesTotoal);
        }
    }
    
    return 0.0f;
}



int   AssetsManager::getStatusCode()
{
    return _currentStatusCode;
}

bool  AssetsManager::isNeedUpdate()
{
    if(_currentStatusCode == AMG_STATUS_NONE)
    {
        return false;
    }
    
    if(_currentStatusCode >= AMG_STATUS_VERSION_CHECKED )
    {
        if(this->_binaryUpdated || !this->_fileList.empty() )
        {
            return true;
        }
    }
    
    return false;
}

int AssetsManager::isDownloading()
{
    return _isDownloading;
}

int AssetsManager::isCheckingVersionRunning()
{
    
    int t = 0;
#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
    pthread_mutex_lock(&s_requestQueueMutex); //Get request task from queue
#endif
    t = _checkingThreadRunning;
#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
    pthread_mutex_unlock(&s_requestQueueMutex);
#endif
    
    return t;
}


void AssetsManager::setCheckVersionRunning(int val)
{
#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
    pthread_mutex_lock(&s_requestQueueMutex); //Get request task from queue
#endif
    _checkingThreadRunning =val;
#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
    pthread_mutex_unlock(&s_requestQueueMutex);
#endif
}


bool AssetsManager::requestLatestVersion()
{
    
    
    if (_versionFileUrl.empty()  || _recordedVersion.empty())
    {
        return false;
    }
    
    
    std::string requestUrl   = _versionFileUrl+"&client_version="+_recordedVersion;
    //requestUrl = "https://asfsf.com/afdd.php";
    CURL *_curl;
    _curl = curl_easy_init();
    if (! _curl)
    {
        CCLOG("can not init curl");
        return false;
    }
#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
     pthread_mutex_lock(&s_requestQueueMutex); //Get request task from queue
#endif
        // Clear _version before assign new value.
        _versionResponse.clear();
#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
    pthread_mutex_unlock(&s_requestQueueMutex);
#endif
    
    // Clear _version before assign new value.
    _versionResponse.clear();
    
    CURLcode res;
    curl_easy_setopt(_curl, CURLOPT_NOSIGNAL, 1);
    curl_easy_setopt(_curl, CURLOPT_URL, requestUrl.c_str());
    curl_easy_setopt(_curl, CURLOPT_SSL_VERIFYPEER, 0L);
    curl_easy_setopt(_curl, CURLOPT_WRITEFUNCTION, getVersionCode);
    curl_easy_setopt(_curl, CURLOPT_WRITEDATA, &_versionResponse);
    res = curl_easy_perform(_curl);
    
    if (res != 0)
    {
        CCLOG("can not get version file content, error code is %d", res);


        curl_easy_cleanup(_curl);
        return false;
    }
    
    int responseCode;
    int code = curl_easy_getinfo(_curl, CURLINFO_RESPONSE_CODE, &responseCode);
    if (code != CURLE_OK || responseCode != 200) {
        CCLOG("error when download package status code %d , return code %d ", responseCode,code);
        curl_easy_cleanup(_curl);
        return false;
    }
    
    curl_easy_cleanup(_curl);
    return true;
}



void AssetsManager::checkUpdate()
{
    if(_currentStatusCode >= AMG_STATUS_CHECKING_VERSION || isCheckingVersionRunning() )
    {
        return ;
    }

    _recordedVersion = CCUserDefault::sharedUserDefault()->getStringForKey(KEY_OF_VERSION);

    
    
#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
    _downloadDesc  = "Checking Latest Version";
    setCheckVersionRunning(1);
    
    _currentStatusCode = AMG_STATUS_CHECKING_VERSION;
    pthread_create(&s_networkCheckVersionThread, NULL, networkCheckVersionThread, NULL);
    pthread_detach(s_networkCheckVersionThread);
#endif
    
}


void AssetsManager::onVersionCheckComplete()
{
 
    
    CCLOG("update response %s \n", _versionResponse.c_str());
    
    void *jsonObj = create_json_obj_frome_string(_versionResponse.c_str());
    if(jsonObj==NULL)
    {
        _currentStatusCode = AMG_STATUS_DOWNLOADED_FAILED;
        return;
    }
    _bytesLoaded = 0;
   
    _latestVersion = json_value_to_string( json_get_value(jsonObj, "latest_version") );
    
    CCUserDefault::sharedUserDefault()->setStringForKey(KEY_OF_LATEST_VERSION, _latestVersion);
    CCUserDefault::sharedUserDefault()->flush();
    _currentStatusCode = AMG_STATUS_VERSION_CHECKED;
    
    int binUpdated = json_value_to_integer(json_get_value(jsonObj, "binary_updated"));
    if(binUpdated)
    {
        _binaryUpdated = true;
    }
    
    std::vector<void *> patch_servers= json_get_array(jsonObj, "patch_servers");
    
    if(!patch_servers.empty())
    {
        this->_serverDirs.clear();
        for(size_t i = 0;i < patch_servers.size();i++)
        {
            _serverDirs.push_back(json_value_to_string( patch_servers[i] ) );
        }
    }
    
    
    std::vector<void *> ls = json_get_array(jsonObj,"data_updated_list");
    
    _bytesTotoal = 0;
    for(size_t i = 0;i < ls.size();i++)
    {
        AssetsFileInfo item;
        item.file= json_value_to_string(json_get_value(ls[i], "filename"));
        item.hash = json_value_to_string(json_get_value(ls[i], "hash"));
        item.size = json_value_to_integer(json_get_value(ls[i], "size"));
        _bytesTotoal += item.size;
        _fileList.push_back(item);
        
    }
    
    _numFilesApplies = 0;
    _totalFiles = _fileList.size()*2;
    free_json_obj(jsonObj);
    
    
    
    
    if (_recordedVersion == _latestVersion)
    {
        CCLOG("there is not new version");
        _currentStatusCode = AMG_STATUS_DOWNLOAD_FINISHED;
        // Set resource search path.
        setSearchPath();
        return;
    }
    
    
    CCLOG("there is a new version: %s", _latestVersion.c_str());
}

bool AssetsManager::isPatchDataExist()
{
    string patchesDir =_storagePath + PATCHES_DIR;
    return LegendCheckDirectoryExists(patchesDir.c_str())!=0;

}

int AssetsManager::removePatchesData()
{
    string patchesDir =_storagePath + PATCHES_DIR;
    int ret = LegendForceRemoveDictory(patchesDir.c_str());
    if(ret)
    {
         CCLOG("remove dir failed: %s", patchesDir.c_str());
    }
    return ret;
}


void* AssetsManager::networkCheckVersionThread(void *data)
{
#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
    AssetsManager * mgr = AssetsManager::sharedManager();
    
    mgr->requestLatestVersion();

    setCheckVersionRunning(0);
    pthread_exit(NULL);
#endif
 return 0;
}

// Worker thread
void* AssetsManager::networkDownloadThread(void *data)
{
    
    AssetsManager * mgr = AssetsManager::sharedManager();
    
    if (! mgr->downLoad())
    {
        mgr->_currentStatusCode = AMG_STATUS_DOWNLOADED_FAILED;

    }
    else if(!mgr->applyPatchFiles())
    {
        mgr->_currentStatusCode = AMG_STATUS_DOWNLOADED_FAILED;
    }
    
    mgr->_isDownloading = 0;
    
#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
    pthread_exit(NULL);
#endif

    return 0;
}


bool AssetsManager::isPendingUpdateCall()
{
    return _pendingUpdateCall;
}

void AssetsManager::update()
{
    if( _currentStatusCode==AMG_STATUS_NONE)
    {
        _currentStatusCode =AMG_STATUS_DOWNLOADED_FAILED;
        return ;
    }
    
    if(_currentStatusCode == AMG_STATUS_CHECKING_VERSION)
    {
        _pendingUpdateCall = true;
        return ;
    }
    
    if(_currentStatusCode==AMG_STATUS_DOWNLOADING)
    {
        return ;
    }
    
    _onCompleteCalled = false;
    _pendingUpdateCall = false;
    _isDownloading = 1;
    _isApplyDownloadFiles = false;
    // Is package already downloaded?
    _currentStatusCode = AMG_STATUS_DOWNLOADING;
    _downloadDesc   = "Updating to v" + _latestVersion;
    
    if(_fileList.empty())
    {
        _isDownloading = 0;
        return ;
    }
    
   
  //  string downloadedVersion = CCUserDefault::sharedUserDefault()->getStringForKey(KEY_OF_DOWNLOADED_VERSION);
 //   if (downloadedVersion != _latestVersion)
 //   {
#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
        pthread_create(&s_networkDownloadThread, NULL, networkDownloadThread, NULL);
        pthread_detach(s_networkDownloadThread);
#endif

    
    
}

bool AssetsManager::uncompress()
{
#if 0
    // Open the zip file
    string outFileName = _storagePath + TEMP_PACKAGE_FILE_NAME;
    unzFile zipfile = unzOpen(outFileName.c_str());
    if (! zipfile)
    {
        CCLOG("can not open downloaded zip file %s", outFileName.c_str());
        return false;
    }
    
    // Get info about the zip file
    unz_global_info global_info;
    if (unzGetGlobalInfo(zipfile, &global_info) != UNZ_OK)
    {
        CCLOG("can not read file global info of %s", outFileName.c_str());
        unzClose(zipfile);
    }
    
    // Buffer to hold data read from the zip file
    char readBuffer[BUFFER_SIZE];
    
    CCLOG("start uncompressing");
    
    // Loop to extract all files.
    uLong i;
    for (i = 0; i < global_info.number_entry; ++i)
    {
        // Get info about current file.
        unz_file_info fileInfo;
        char fileName[MAX_FILENAME];
        if (unzGetCurrentFileInfo(zipfile,
                                  &fileInfo,
                                  fileName,
                                  MAX_FILENAME,
                                  NULL,
                                  0,
                                  NULL,
                                  0) != UNZ_OK)
        {
            CCLOG("can not read file info");
            unzClose(zipfile);
            return false;
        }
        
        string fullPath = _storagePath + fileName;
        
        // Check if this entry is a directory or a file.
        const size_t filenameLength = strlen(fileName);
        if (fileName[filenameLength-1] == '/')
        {
            // Entry is a direcotry, so create it.
            // If the directory exists, it will failed scilently.
            if (!createDirectory(fullPath.c_str()))
            {
                CCLOG("can not create directory %s", fullPath.c_str());
                unzClose(zipfile);
                return false;
            }
        }
        else
        {
            // Entry is a file, so extract it.
            
            // Open current file.
            if (unzOpenCurrentFile(zipfile) != UNZ_OK)
            {
                CCLOG("can not open file %s", fileName);
                unzClose(zipfile);
                return false;
            }
            
            // Create a file to store current file.
            FILE *out = fopen(fullPath.c_str(), "wb");
            if (! out)
            {
                CCLOG("can not open destination file %s", fullPath.c_str());
                unzCloseCurrentFile(zipfile);
                unzClose(zipfile);
                return false;
            }
            
            // Write current file content to destinate file.
            int error = UNZ_OK;
            do
            {
                error = unzReadCurrentFile(zipfile, readBuffer, BUFFER_SIZE);
                if (error < 0)
                {
                    CCLOG("can not read zip file %s, error code is %d", fileName, error);
                    unzCloseCurrentFile(zipfile);
                    unzClose(zipfile);
                    return false;
                }
                
                if (error > 0)
                {
                    fwrite(readBuffer, error, 1, out);
                }
            } while(error > 0);
            
            fclose(out);
        }
        
        unzCloseCurrentFile(zipfile);
        
        // Goto next entry listed in the zip file.
        if ((i+1) < global_info.number_entry)
        {
            if (unzGoToNextFile(zipfile) != UNZ_OK)
            {
                CCLOG("can not read next file");
                unzClose(zipfile);
                return false;
            }
        }
    }
    
    CCLOG("end uncompressing");
#endif
    return true;
}

/*
 * Create a direcotry is platform depended.
 */
bool AssetsManager::createDirectory(const char *path)
{
#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
    mode_t processMask = umask(0);
    int ret = mkdir(path, S_IRWXU | S_IRWXG | S_IRWXO);
    umask(processMask);
    if (ret != 0 && (errno != EEXIST))
    {
        return false;
    }
    
    return true;
#else
    BOOL ret = CreateDirectoryA(path, NULL);
	if (!ret && ERROR_ALREADY_EXISTS != GetLastError())
	{
		return false;
	}
    return true;
#endif
}

bool AssetsManager::applyPatchFiles()
{
    
    _isApplyDownloadFiles = true;
    
    string tmpDir =_storagePath + TEMP_PATCHES_DIR;
    string patchesDir =_storagePath + PATCHES_DIR;
    if(!createDirectory(patchesDir.c_str()))
        return false;
    
    if(!createPatchesSubDirs(patchesDir.c_str()))
    {
        return false;
    }
    
    
    
    
    for(size_t i=0;i<_fileList.size();i++)
    {
        AssetsFileInfo & info=_fileList[i];
        string srcFileName = tmpDir + "/" + info.file ;
        _numFilesApplies ++;
    }
    
    for(size_t i=0;i<_fileList.size();i++)
    {
        AssetsFileInfo & info=_fileList[i];
        
        // Create a file to save package.
        string srcFileName = tmpDir + "/" + info.file ;
        string dstFileName =patchesDir + "/" +info.file;
        _numFilesApplies ++;
        int res = rename(srcFileName.c_str(),dstFileName.c_str());
        if(res != 0)
        {
            CCLOG("can not rename  %s as %s", srcFileName.c_str(), dstFileName.c_str());
            return false;
        }
    }
    
    
    
    return true;
}

bool AssetsManager::createPatchesSubDirs(const char *rootPath)
{
    const char * subdirs[]={
        "/0","/1","/2","/3",
        "/4","/5","/6","/7",
        "/8","/9","/a","/b",
        "/c","/d","/e","/f"
    };
    
    for(int i=0;i<16;i++)
    {
        string subDir = rootPath;
        subDir+=subdirs[i];
        if(!createDirectory(subDir.c_str()))
        {
            return false;
        }
    }
    return true;
}

void AssetsManager::addBytesLoade(size_t n)
{
    _bytesLoaded += n;
}

void AssetsManager::setSearchPath()
{
    vector<string> searchPaths = CCFileUtils::sharedFileUtils()->getSearchPaths();
    vector<string>::iterator iter = searchPaths.begin();
    searchPaths.insert(iter, _storagePath);
    CCFileUtils::sharedFileUtils()->setSearchPaths(searchPaths);
}

AssetsManager *AssetsManager::m_instance = NULL;
AssetsManager * AssetsManager::sharedManager()
{
    return m_instance;
}

static size_t downLoadPackage(void *ptr, size_t size, size_t nmemb, void *userdata)
{
    FILE *fp = (FILE*)userdata;
    size_t written = fwrite(ptr, size, nmemb, fp);
#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
    pthread_mutex_lock(&s_workerThreadMutex); //Get request task from queue
    AssetsManager::sharedManager()->addBytesLoade(written);
    pthread_mutex_unlock(&s_workerThreadMutex);
    
#endif
    return written;
}

static int progressFunc(void *ptr, double totalToDownload, double nowDownloaded, double totalToUpLoad, double nowUpLoaded)
{
   // CCLOG("downloading... %d%%", (int)(nowDownloaded/totalToDownload*100));
    
    return 0;
}




void* AssetsManager::downloadWorker(void *data)
{

#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
   
    void* ret = NULL;
    CURL *_curl;
    _curl = curl_easy_init();
    
    AssetsManager *mgr =AssetsManager::sharedManager();
    string tmpDir =mgr->_storagePath + TEMP_PATCHES_DIR;
    while(true)
    {
        AssetsFileInfo * info=NULL;
        pthread_mutex_lock(&s_workerThreadMutex);
        s_currentFileIndex ++;
        if(s_currentFileIndex < mgr->_fileList.size())
        {
            info  = &mgr->_fileList[s_currentFileIndex];
        }
        pthread_mutex_unlock(&s_workerThreadMutex);
        
        if(info==NULL)
        {
            break;
        }
        
        // Create a file to save package.
        string outFileName = tmpDir + "/" + info->file ;
        if(CCFileUtils::sharedFileUtils()->isFileExist(outFileName.c_str()))
        {
			/*
			if(LegendCheckFileDataHash(info->hash.c_str(), info->size, outFileName.c_str())==0)
            {
                CCLOG("Local downloaded file %s found", outFileName.c_str());
                mgr->addBytesLoade(info->size);
                continue;
            }
			*/
            
        }
        
        FILE *fp = fopen(outFileName.c_str(), "wb");
        if (! fp)
        {
            CCLOG("can not create file %s", outFileName.c_str());
            ret = (void*)-1;
            break;
        }
        
        std::string fileUrl =mgr->_serverDirs[0] + info->file;
        
        // Download pacakge
        CURLcode res;
        
        curl_easy_setopt(_curl, CURLOPT_SSL_VERIFYPEER, 0);
        curl_easy_setopt(_curl, CURLOPT_NOSIGNAL, 1);
        curl_easy_setopt(_curl, CURLOPT_URL, fileUrl.c_str());
        curl_easy_setopt(_curl, CURLOPT_WRITEFUNCTION, downLoadPackage);
        curl_easy_setopt(_curl, CURLOPT_WRITEDATA, fp);
        curl_easy_setopt(_curl, CURLOPT_NOPROGRESS, false);
        curl_easy_setopt(_curl, CURLOPT_PROGRESSFUNCTION, progressFunc);
        res = curl_easy_perform(_curl);
        
        if (res != CURLE_OK)
        {
            CCLOG("error when download package");
            fclose(fp);
            ret = (void*)-1;
            break;
        }
        
        int responseCode;
        int code = curl_easy_getinfo(_curl, CURLINFO_RESPONSE_CODE, &responseCode);
        if (code != CURLE_OK || responseCode != 200) {
            CCLOG("error when download package status code %d , return code %d ", responseCode,code);
            fclose(fp);
            ret = (void*)-1;
            break;
        }
        
        
        CCLOG("succeed downloaded file %s", fileUrl.c_str());
        
        fclose(fp);
    }
    curl_easy_cleanup(_curl);
    
    pthread_exit(ret);
#endif
    return 0;
}


bool AssetsManager::downLoad()
{
     bool result = true;
#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
    string tmpDir =_storagePath + TEMP_PATCHES_DIR;
    if(!createDirectory(tmpDir.c_str()))
        return false;
    
    if(!createPatchesSubDirs(tmpDir.c_str()))
    {
        return false;
    }
    
    int numThread = _fileList.size()>10?10:_fileList.size();
//    static pthread_mutex_t  s_workerThreadMutex;
//    static int              s_currentFileIndex = -1;
//

    pthread_t *thrArr = new pthread_t[numThread];
    s_currentFileIndex = -1;
    for(int i=0;i<numThread;i++)
    {
        pthread_create(&thrArr[i], NULL, downloadWorker, NULL);
      
    }
    
   
    for(int i=0;i<numThread;i++)
    {
        void*status =NULL;
        
        pthread_join(thrArr[i],&status);
        if(status!=NULL)
        {
            result = false;
        }
        
    }

#endif
    
    return result;
}

void AssetsManager::onDownloadComplete()
{
    if(_onCompleteCalled)
        return;
    // Record downloaded version.
    

    _onCompleteCalled = true;
    
    
    if(getStatusCode()!= AMG_STATUS_DOWNLOADED_FAILED)
    {
        // Record new version code.
        CCUserDefault::sharedUserDefault()->setStringForKey(KEY_OF_VERSION, _latestVersion.c_str());
    }

}

bool AssetsManager::isScriptChanged()
{
    return  _onCompleteCalled && getStatusCode()!= AMG_STATUS_DOWNLOADED_FAILED &&  !_fileList.empty();
}


const char* AssetsManager::getStoragePath() const
{
    return _storagePath.c_str();
}

void AssetsManager::setStoragePath(const char *storagePath)
{
    _storagePath = storagePath;
    checkStoragePath();
}

const char* AssetsManager::getVersionFileUrl() const
{
    return _versionFileUrl.c_str();
}

void AssetsManager::setVersionFileUrl(const char *versionFileUrl)
{
    _versionFileUrl = versionFileUrl;
}

string AssetsManager::getVersion()
{
    return CCUserDefault::sharedUserDefault()->getStringForKey(KEY_OF_VERSION);
}

void AssetsManager::deleteVersion()
{
    CCUserDefault::sharedUserDefault()->setStringForKey(KEY_OF_VERSION, "");
}


std::string& AssetsManager::getVersionServer()
{
    return _serverDirs[0];
}


unsigned char* AssetsManager::getFileFromVersionServer(const char* file, size_t *pSize)
{
//    _packageUrl =getVersionServer()+"/"+file;
//    downLoad();
//    string outFileName = _storagePath + TEMP_PACKAGE_FILE_NAME;
    if(strcmp("serverlist.txt",file)!=0)
        return NULL;
    unsigned char *data = CCFileUtils::sharedFileUtils()->getFileData("serverlist.txt", "rb", (unsigned long *)pSize);
    return data;
}

AssetsManager::~AssetsManager()
{
//#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
//   pthread_mutex_destroy(&s_requestQueueMutex);
//#endif
}

bool AssetsManager::curl_global_inited = false;

AssetsManager::AssetsManager(std::string& storagePath, std::vector<std::string > & serverDirs,const char* versionFileUrl)
{
    
    if(!curl_global_inited)
    {
        curl_global_init(CURL_GLOBAL_ALL);
        curl_global_inited = true;
    }
    
#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
    if(s_requestQueueMutex_inited==0)
    {
    	s_requestQueueMutex_inited = 1;
    	pthread_mutex_init(&s_requestQueueMutex, NULL);
    	pthread_mutex_init(&s_workerThreadMutex, NULL);

    }
#endif
    if(m_instance!=NULL)
    {
        delete m_instance;
        m_instance = NULL;
    }
    m_instance = this;
    _versionFileUrl = versionFileUrl;
    reset();

    _storagePath = storagePath;
    _serverDirs =serverDirs;
    checkStoragePath();
    
}

bool AssetsManager::isOnCompleteCalled()
{
    return _onCompleteCalled;
}


std::string & AssetsManager::getProgressDesc()
{
    return _downloadDesc;
}


 size_t AssetsManager::getScripteFileListSize()
{
    return _fileList.size();
}

NS_CC_EXT_END;
