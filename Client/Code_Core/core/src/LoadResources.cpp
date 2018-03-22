//
//  LoadResources.cpp
//  HelloLua
//
//  Created by eboz on 14-4-30.
//
//

#include "LoadResources.h"
#include "AssetsManager.h"
#include "CCLuaEngine.h"



USING_NS_CC;
USING_NS_CC_EXT;




std::vector<LoadResources*> LoadResources::createdList;

 void LoadResources::load()
{
    printf("LoadResources::update()");
}

float LoadResources::getProgress()
{
    return 1.0f;
#if ENABLE_AUTO_UPDATING
    float f=  AssetsManager::sharedManager()->getProgress();
    //  printf("LoadResources::getProgress %f\n",f);
    return f;
#else
	return 1.0;
#endif
  
}

bool LoadResources::isEnd()
{
    return true;
#if ENABLE_AUTO_UPDATING
    
    int c = AssetsManager::sharedManager()->getStatusCode();
    if( (c==AMG_STATUS_DOWNLOAD_FINISHED || c==AMG_STATUS_DOWNLOADED_FAILED) )
    {
        return true;
    }
    
    if(c==AMG_STATUS_DOWNLOADING && ! AssetsManager::sharedManager()->isDownloading())
    {
        return true;
    }
    
    return false;
#else
    return true;
#endif
}

LoadResources  *LoadResources::create()
{
    return LoadResources::create(0);
}

LoadResources *  LoadResources::create(size_t len)
{
    return NULL;
   
    AssetsManager::sharedManager()->reset();
        
    CCLog("LoadResources::create %u\n", len);
    LoadResources * res   = new LoadResources();
    res->retain();
    createdList.push_back(res);
#if ENABLE_AUTO_UPDATING
    if(AssetsManager::sharedManager()->getStatusCode() == AMG_STATUS_DOWNLOADED_FAILED)
    {
        AssetsManager::sharedManager()->reset();
    }
    
	if (AssetsManager::sharedManager()->getStatusCode() == AMG_STATUS_NONE)
    {
        AssetsManager::sharedManager()->checkUpdate();
        
    }
#endif  
    return res;
}

 void LoadResources::update()
{
    return;
	 CCLog("LoadResources::update()\n");
#if ENABLE_AUTO_UPDATING
  
    AssetsManager::sharedManager()->update();
#endif
}
 int LoadResources::getCode()
{
    return 0;
#if ENABLE_AUTO_UPDATING
    AssetsManager *mgr = AssetsManager::sharedManager();
    
    //printf("LoadResources::getCode %d\n", mgr->getStatusCode());

    if(mgr->getStatusCode()==AMG_STATUS_CHECKING_VERSION)
    {
        if(!mgr->isCheckingVersionRunning())
        {
            mgr->onVersionCheckComplete();
            
            if(mgr->getStatusCode()== AMG_STATUS_VERSION_CHECKED )
            {
                
                if(mgr->isBinaryUpdated() && mgr->isPatchDataExist() && mgr->getScripteFileListSize()==0)
                {
                    mgr->removePatchesData();
                    CCApplication::sharedApplication()->restart();
                    return mgr->getStatusCode();
                }
                
                if(mgr->isPendingUpdateCall())
                {
                    mgr->update();
                }
                
            }
            
        }
        
        return mgr->getStatusCode();
    }
    
    
    
    
    if(mgr->getStatusCode()==AMG_STATUS_DOWNLOADING
       && !mgr->isDownloading())
    {
        AssetsManager::sharedManager()->onDownloadComplete();
     //   CCApplication::sharedApplication()->restart();
    }
    
    return mgr->getStatusCode();
#endif

	return AMG_STATUS_DOWNLOAD_FINISHED;
    
}



 int LoadResources::getStep()
{
   // printf("LoadResources::getStep()\n");
    return  1;
}

 bool LoadResources::checkUpdate()
{
    return false;
#if ENABLE_AUTO_UPDATING
    CCLog("LoadResources::checkUpdate()\n");
    return AssetsManager::sharedManager()->isNeedUpdate();
    
#else
    return false;
#endif
}

 std::string LoadResources::getDes()
{
    return "";
    std::string ret= AssetsManager::sharedManager()->getProgressDesc();
	return ret;
}

void LoadResources::releaseMemory()
{
    printf("LoadResources::releaseMemory\n");
    for(size_t  i = 0;i < createdList.size();i++)
    {
        LoadResources *res = createdList[i];
        res->release();
    }
    
    createdList.clear();
}

void LoadResources::insert(const char*param1)
{
    printf("LoadResourcesLoading::insert(%s)\n",param1);
}

bool LoadResources::isBinaryUpdated()
{
    return false;
    return AssetsManager::sharedManager()->isBinaryUpdated();
}


bool LoadResources::isScriptChanged()
{
    return false;
    return AssetsManager::sharedManager()->isScriptChanged();
}


