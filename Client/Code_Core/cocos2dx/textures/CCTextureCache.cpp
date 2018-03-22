/****************************************************************************
Copyright (c) 2010-2012 cocos2d-x.org
Copyright (c) 2008-2010 Ricardo Quesada
Copyright (c) 2011      Zynga Inc.

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

#include "CCTextureCache.h"
#include "CCTexture2D.h"
#include "ccMacros.h"
#include "CCDirector.h"
#include "platform/platform.h"
#include "platform/CCFileUtils.h"
#include "platform/CCThread.h"
#include "platform/CCImage.h"
#include "support/ccUtils.h"
#include "shaders/CCShaderCache.h"
#include "CCScheduler.h"
#include "cocoa/CCString.h"
#include <errno.h>
#include <stack>
#include <string>
#include <cctype>
#include <queue>
#include <list>
#include <pthread.h>
#include "sprite_nodes/CCSpriteFrameCache.h"
#include <semaphore.h>
#include "HeroFileUtils.h"
#include "GameEncryptKey.h"

#define kCCShader_PositionTextureColor_Palette "ShaderPositionTextureColor_Palette"//difference from version 2.1.3 at com4loves@2013

using namespace std;

NS_CC_BEGIN
//--begin difference from version 2.1.3 at com4loves@2013
unsigned int getPowsize(unsigned int size)
{
	unsigned int Powsize = 1;
	while(size !=1 )
	{
		size = ceil((float)size / 2.0);
		Powsize = Powsize * 2;
	}
	return Powsize;
}
//--end difference from version 2.1.3 at com4loves@2013
typedef struct _AsyncStruct
{
    std::string            filename;
    CCObject    *target;
    SEL_CallFuncO        selector;
} AsyncStruct;

typedef struct _ImageInfo
{
    AsyncStruct *asyncStruct;
    CCImage        *image;
    CCImage::EImageFormat imageType;
} ImageInfo;

static pthread_t s_loadingThread;

static pthread_mutex_t      s_asyncStructQueueMutex;
static pthread_mutex_t      s_ImageInfoMutex;

static sem_t* s_pSem = NULL;
static unsigned long s_nAsyncRefCount = 0;

#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
    #define CC_ASYNC_TEXTURE_CACHE_USE_NAMED_SEMAPHORE 1
#else
    #define CC_ASYNC_TEXTURE_CACHE_USE_NAMED_SEMAPHORE 0
#endif
    

#if CC_ASYNC_TEXTURE_CACHE_USE_NAMED_SEMAPHORE
    #define CC_ASYNC_TEXTURE_CACHE_SEMAPHORE "ccAsync"
#else
    static sem_t s_sem;
#endif


static bool need_quit = false;

static std::queue<AsyncStruct*>* s_pAsyncStructQueue = NULL;
static std::queue<ImageInfo*>*   s_pImageQueue = NULL;

static CCImage::EImageFormat computeImageFormatType(string& filename)
{
    CCImage::EImageFormat ret = CCImage::kFmtUnKnown;

    if ((std::string::npos != filename.find(".jpg")) || (std::string::npos != filename.find(".jpeg")))
    {
        ret = CCImage::kFmtJpg;
    }
    else if ((std::string::npos != filename.find(".png")) || (std::string::npos != filename.find(".PNG")))
    {
        ret = CCImage::kFmtPng;
    }
    else if ((std::string::npos != filename.find(".tiff")) || (std::string::npos != filename.find(".TIFF")))
    {
        ret = CCImage::kFmtTiff;
    }
    else if ((std::string::npos != filename.find(".webp")) || (std::string::npos != filename.find(".WEBP")))
    {
        ret = CCImage::kFmtWebp;
    }
   
    return ret;
}

static void* loadImage(void* data)
{
    AsyncStruct *pAsyncStruct = NULL;

    while (true)
    {
        // create autorelease pool for iOS
        CCThread thread;
        thread.createAutoreleasePool();
        
        // wait for rendering thread to ask for loading if s_pAsyncStructQueue is empty
        int semWaitRet = sem_wait(s_pSem);
        if( semWaitRet < 0 )
        {
            CCLOG( "CCTextureCache async thread semaphore error: %s\n", strerror( errno ) );
            break;
        }

        std::queue<AsyncStruct*> *pQueue = s_pAsyncStructQueue;

        pthread_mutex_lock(&s_asyncStructQueueMutex);// get async struct from queue
        if (pQueue->empty())
        {
            pthread_mutex_unlock(&s_asyncStructQueueMutex);
            if (need_quit)
                break;
            else
                continue;
        }
        else
        {
            pAsyncStruct = pQueue->front();
            pQueue->pop();
            pthread_mutex_unlock(&s_asyncStructQueueMutex);
        }        

        const char *filename = pAsyncStruct->filename.c_str();

        // compute image type
        CCImage::EImageFormat imageType = computeImageFormatType(pAsyncStruct->filename);
        if (imageType == CCImage::kFmtUnKnown)
        {
            CCLOG("unsupported format %s",filename);
            delete pAsyncStruct;
            
            continue;
        }
        
        // generate image            
        CCImage *pImage = new CCImage();
        if (pImage && !pImage->initWithImageFileThreadSafe(filename, imageType))
        {
            CC_SAFE_RELEASE(pImage);
            CCLOG("can not load %s", filename);
            continue;
        }

        // generate image info
        ImageInfo *pImageInfo = new ImageInfo();
        pImageInfo->asyncStruct = pAsyncStruct;
        pImageInfo->image = pImage;
        pImageInfo->imageType = imageType;

        // put the image info into the queue
        pthread_mutex_lock(&s_ImageInfoMutex);
        s_pImageQueue->push(pImageInfo);
        pthread_mutex_unlock(&s_ImageInfoMutex);    
    }
    
    if( s_pSem != NULL )
    {
    #if CC_ASYNC_TEXTURE_CACHE_USE_NAMED_SEMAPHORE
        sem_unlink(CC_ASYNC_TEXTURE_CACHE_SEMAPHORE);
        sem_close(s_pSem);
    #else
        sem_destroy(s_pSem);
    #endif
        s_pSem = NULL;
        delete s_pAsyncStructQueue;
        delete s_pImageQueue;
    }
    
    return 0;
}

// implementation CCTextureCache

// TextureCache - Alloc, Init & Dealloc
static CCTextureCache *g_sharedTextureCache = NULL;

CCTextureCache * CCTextureCache::sharedTextureCache()
{
    if (!g_sharedTextureCache)
    {
        g_sharedTextureCache = new CCTextureCache();
    }
    return g_sharedTextureCache;
}

CCTextureCache::CCTextureCache()
{
    CCAssert(g_sharedTextureCache == NULL, "Attempted to allocate a second instance of a singleton.");
    
	m_pTextures = new CCResourceCache();
	//--begin difference from version 2.1.3 at com4loves@2013
	//add by zhenhui, to get the image which will use png8 precedure.
	if (CCFileUtils::sharedFileUtils()->isFileExist("shader/png_handle.plist")){
		m_pPNG8Files = CCDictionary::createWithContentsOfFileThreadSafe("shader/png_handle.plist");
		m_pPNG8Files->retain();
	}else{
		m_pPNG8Files = CCDictionary::create();
		m_pPNG8Files->retain();
	}

	infoDirty = false;
	enablePalette = false;
	info_totalBytes = 0;
	info_max_totalBytes = 0;
	max_cache_bytes = MAX_CACHETEXTURE_BYTESIZE;

	CCDirector::sharedDirector()->getScheduler()->scheduleUpdateForTarget(this,0,false);
	//--end difference from version 2.1.3 at com4loves@2013
}

CCTextureCache::~CCTextureCache()
{
    CCLOGINFO("cocos2d: deallocing CCTextureCache.");
    need_quit = true;
    if (s_pSem != NULL)
    {
        sem_post(s_pSem);
    }
    
    CC_SAFE_RELEASE(m_pTextures);
	CC_SAFE_RELEASE(m_pPNG8Files);//difference from version 2.1.3 at com4loves@2013
	CCDirector::sharedDirector()->getScheduler()->unscheduleAllForTarget(this);//difference from version 2.1.3 at com4loves@2013
}

void CCTextureCache::purgeSharedTextureCache()
{
    CC_SAFE_RELEASE_NULL(g_sharedTextureCache);
}

const char* CCTextureCache::description()
{
    return CCString::createWithFormat("<CCTextureCache | Number of textures = %u>", m_pTextures->count())->getCString();
}

bool CCTextureCache::isPaletteTextureEnable() const
{
	return enablePalette;
}

bool CCTextureCache::initPaletteGLProgram(const GLchar* vShaderByteArray, const GLchar* fShaderByteArray)
{
	CCGLProgram* pGLProgram = CCShaderCache::sharedShaderCache()->programForKey(kCCShader_PositionTextureColor_Palette);
	if (!pGLProgram && vShaderByteArray && fShaderByteArray)
	{
		pGLProgram = new CCGLProgram();
		if (!pGLProgram->initWithVertexShaderByteArray(vShaderByteArray, fShaderByteArray))
		{
			CC_SAFE_RELEASE_NULL(pGLProgram);
			return false;
		}

		pGLProgram->addAttribute(kCCAttributeNamePosition, kCCVertexAttrib_Position);
		pGLProgram->addAttribute(kCCAttributeNameColor, kCCVertexAttrib_Color);
		pGLProgram->addAttribute(kCCAttributeNameTexCoord, kCCVertexAttrib_TexCoords);

		if (!pGLProgram->link())
		{
			CC_SAFE_RELEASE_NULL(pGLProgram);
			return false;
		}

		pGLProgram->updateUniforms();

		CCShaderCache::sharedShaderCache()->addProgram(pGLProgram, kCCShader_PositionTextureColor_Palette);
		CC_SAFE_RELEASE_NULL(pGLProgram);

		enablePalette = true;
		CCImage::setImgPaletteEnable(enablePalette);
	}

	return pGLProgram != 0;
}

CCGLProgram* CCTextureCache::getPaletteGLProgram()
{
	return CCShaderCache::sharedShaderCache()->programForKey(kCCShader_PositionTextureColor_Palette);
}

CCDictionary* CCTextureCache::snapshotTextures()
{ 
    CCDictionary* pRet = new CCDictionary();
    CCDictElement* pElement = NULL;
    CCDICT_FOREACH(m_pTextures, pElement)
    {
        pRet->setObject(pElement->getObject(), pElement->getStrKey());
    }
    pRet->autorelease();
    return pRet;
}

void CCTextureCache::addImageAsync(const char *path, CCObject *target, SEL_CallFuncO selector)
{
    CCAssert(path != NULL, "TextureCache: fileimage MUST not be NULL");    

    CCTexture2D *texture = NULL;

    // optimization

    std::string pathKey = path;

    pathKey = CCFileUtils::sharedFileUtils()->fullPathForFilename(pathKey.c_str());
    texture = (CCTexture2D*)m_pTextures->objectForKey(pathKey.c_str());

    std::string fullpath = pathKey;
    if (texture != NULL)
    {
        if (target && selector)
        {
            (target->*selector)(texture);
        }
        
        return;
    }

    // lazy init
    if (s_pSem == NULL)
    {             
#if CC_ASYNC_TEXTURE_CACHE_USE_NAMED_SEMAPHORE
        s_pSem = sem_open(CC_ASYNC_TEXTURE_CACHE_SEMAPHORE, O_CREAT, 0644, 0);
        if( s_pSem == SEM_FAILED )
        {
            CCLOG( "CCTextureCache async thread semaphore init error: %s\n", strerror( errno ) );
            s_pSem = NULL;
            return;
        }
#else
        int semInitRet = sem_init(&s_sem, 0, 0);
        if( semInitRet < 0 )
        {
            CCLOG( "CCTextureCache async thread semaphore init error: %s\n", strerror( errno ) );
            return;
        }
        s_pSem = &s_sem;
#endif
        s_pAsyncStructQueue = new queue<AsyncStruct*>();
        s_pImageQueue = new queue<ImageInfo*>();        
        
        pthread_mutex_init(&s_asyncStructQueueMutex, NULL);
        pthread_mutex_init(&s_ImageInfoMutex, NULL);
        pthread_create(&s_loadingThread, NULL, loadImage, NULL);

        need_quit = false;
    }

    if (0 == s_nAsyncRefCount)
    {
        CCDirector::sharedDirector()->getScheduler()->scheduleSelector(schedule_selector(CCTextureCache::addImageAsyncCallBack), this, 0, false);
    }

    ++s_nAsyncRefCount;

    if (target)
    {
        target->retain();
    }

    // generate async struct
    AsyncStruct *data = new AsyncStruct();
    data->filename = fullpath.c_str();
    data->target = target;
    data->selector = selector;

    // add async struct into queue
    pthread_mutex_lock(&s_asyncStructQueueMutex);
    s_pAsyncStructQueue->push(data);
    pthread_mutex_unlock(&s_asyncStructQueueMutex);

    sem_post(s_pSem);
}

void CCTextureCache::addImageAsyncCallBack(float dt)
{
    // the image is generated in loading thread
    std::queue<ImageInfo*> *imagesQueue = s_pImageQueue;

    pthread_mutex_lock(&s_ImageInfoMutex);
    if (imagesQueue->empty())
    {
        pthread_mutex_unlock(&s_ImageInfoMutex);
    }
    else
    {
        ImageInfo *pImageInfo = imagesQueue->front();
        imagesQueue->pop();
        pthread_mutex_unlock(&s_ImageInfoMutex);

        AsyncStruct *pAsyncStruct = pImageInfo->asyncStruct;
        CCImage *pImage = pImageInfo->image;

        CCObject *target = pAsyncStruct->target;
        SEL_CallFuncO selector = pAsyncStruct->selector;
        const char* filename = pAsyncStruct->filename.c_str();

        // generate texture in render thread
        CCTexture2D *texture = new CCTexture2D();
#if 0 //TODO: (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
        texture->initWithImage(pImage, kCCResolutioniPhone);
#else
        texture->initWithImage(pImage);
#endif

#if CC_ENABLE_CACHE_TEXTURE_DATA
       // cache the texture file name

       const char *pext = strrchr(filename,'.');
       if(pext ==NULL ) pext = "";

//    	CCLog("CCTextureCache::addImageAsyncCallBack CACHE_TEXTURE_DATA %s extentsion: %s  mask:%s ",
//    			filename , pext, "");

       VolatileTexture::addImageTexture(texture, filename, pImageInfo->imageType,pext,"");
#endif

        // cache the texture
        m_pTextures->setObject(texture, filename);
        texture->autorelease();

        if (target && selector)
        {
            (target->*selector)(texture);
            target->release();
        }        

        pImage->release();
        delete pAsyncStruct;
        delete pImageInfo;

        --s_nAsyncRefCount;
        if (0 == s_nAsyncRefCount)
        {
            CCDirector::sharedDirector()->getScheduler()->unscheduleSelector(schedule_selector(CCTextureCache::addImageAsyncCallBack), this);
        }
    }
}

CCImage * createNewImage(const char *fullpath,CCImage::EImageFormat eImageFormat)
{
      CCImage *pImage;
      pImage = new CCImage();

      unsigned long nSize = 0;
    //TODO:文件查找 后面需要统一，以及文件名加密
      unsigned char* pBuffer = CCFileUtils::sharedFileUtils()->getFileData(fullpath, "rb", &nSize,true,0);

      bool bRet = pImage->initWithImageData((void*)pBuffer, nSize, eImageFormat);
      CC_SAFE_DELETE_ARRAY(pBuffer);
    
	  if (!bRet)
	  {
		  CC_SAFE_RELEASE(pImage);
		  return NULL;
	  }
      return pImage;

}



CCTexture2D * CCTextureCache::addImage(const char * path,CCTexture2DPixelFormat format)
{
    
   // CCLOG("CCTextureCache::addImage: %s format %d",path,format);
    CCAssert(path != NULL, "TextureCache: fileimage MUST not be NULL");
    
    CCTexture2D * texture = NULL;
    CCImage* pImage = NULL;
    CCImage* pImageMask = NULL;
    
    // Split up directory and filename
    // MUTEX:
    // Needed since addImageAsync calls this method from a different thread
    
    //pthread_mutex_lock(m_pDictLock);

    std::string pathKey = path;



	texture = (CCTexture2D*)this->textureForKey(pathKey.c_str());
    
    if (! texture) 
    {
		std::string fullpath;

		const char* lastdot = strrchr(path, '.');
		std::string filenoExt = pathKey.substr(0, lastdot - path);

		//先根据原路径找，如果未找到则跟换后缀名，继续查找
		const char*pextFound = lastdot;
		const char* full = LegendFindFile(path);
		if (full)
		{
			fullpath = full;
		}
		std::string maskFullPath;
		
		if (full == NULL)
		{
			if (strcmp(pextFound,".jpg") == 0 || strcmp(pextFound,".jpep") == 0)
			{
				pextFound = ".png";
				std::string tempFullPath = filenoExt + ".png";
				full = LegendFindFile(tempFullPath.c_str());
				if (full)
				{
					fullpath = full;
				}
			}
			else if (strcmp(pextFound,".png") == 0)
			{
				pextFound = ".jpg";
				std::string tempFullPath = filenoExt + ".jpg";
				full = LegendFindFile(tempFullPath.c_str());
				if (full)
				{
					fullpath = full;
				}
			}
		}
		if (full == NULL)
		{
			std::string msg = "[CCTextureCache|addImage]  Get data from file(";
			msg.append(path).append(") failed|get empty.jpg to run");
			CCLOG("%s", msg.c_str());

			pextFound = ".jpg";
			fullpath = LegendFindFileCpp("empty.jpg");
			bool isShowErrorBox = false;
#ifdef _DEBUG 
			isShowErrorBox = true;
#endif	
#ifdef WIN32 
			isShowErrorBox = true;
#endif	
			if (isShowErrorBox)CCMessageBox(msg.c_str(), "File Not Found");
			//return texture;
		}

        std::string lowerCase(pathKey);
        for (unsigned int i = 0; i < lowerCase.length(); ++i)
        {
            lowerCase[i] = tolower(lowerCase[i]);
        }
        // all images are handled by UIImage except PVR extension that is handled by our own handler
        do 
        {
            if (!strcmp(pextFound,".pvr") ||!strcmp(pextFound,".pvr.ccz") )
            {
                texture = this->addPVRImage(fullpath.c_str(),pextFound);
            }
            else
            {
                CCImage::EImageFormat eImageFormat = CCImage::kFmtUnKnown;
                if (!strcmp(pextFound,".png"))
                {
                    eImageFormat = CCImage::kFmtPng;
                }
                else if (!strcmp(pextFound,".jpg") || !strcmp(pextFound,".jpeg"))
                {
                    eImageFormat = CCImage::kFmtJpg;

                    maskFullPath = LegendFindFileCpp( (filenoExt + "_alpha_mask").c_str());
					//这里需要明确看一下，mask是做什么的，是否需要，文件名要进行调整
                    if(!maskFullPath.empty())
                    {
                        pImageMask = createNewImage(maskFullPath.c_str(), CCImage::kFmtPng);
                    }
                }
                else if (!strcmp(pextFound,".tif") || !strcmp(pextFound,".tiff"))
                {
                    eImageFormat = CCImage::kFmtTiff;
                }
                else if (!strcmp(pextFound,".webp"))
                {
                    eImageFormat = CCImage::kFmtWebp;
                }
                pImage = createNewImage(fullpath.c_str(), eImageFormat);
                CC_BREAK_IF(NULL == pImage);

                texture = new CCTexture2D();
                
                if( texture 
                     )
                {
                    bool btmp = false;
                    if(pImageMask)
                    {

                        btmp = texture->initWithImage(pImage,format,pImageMask);
                    }
                    else
                    {
                        btmp = texture->initWithImage(pImage);
                    }
                
                    if(btmp)
                    {
#if CC_ENABLE_CACHE_TEXTURE_DATA
                        // cache the texture file name
                    	//CCLog("CCTextureCache::addImage CACHE_TEXTURE_DATA %s extentsion: %s  mask:%s ",fullpath.c_str() , pextFound, maskFullPath.c_str());
                       VolatileTexture::addImageTexture(texture, fullpath.c_str(), eImageFormat,pextFound, maskFullPath.c_str());
#endif
                        m_pTextures->setObject(texture, fullpath.c_str());
                        texture->release();
                    }
                }
                else
                {
                    CCLOG("cocos2d: Couldn't create texture for file:%s in CCTextureCache", path);
                }
            }
        } while (0);
    }

    CC_SAFE_RELEASE(pImageMask);
    CC_SAFE_RELEASE(pImage);

    //pthread_mutex_unlock(m_pDictLock);
    return texture;
}

#ifdef CC_SUPPORT_PVRTC
CCTexture2D* CCTextureCache::addPVRTCImage(const char* path, int bpp, bool hasAlpha, int width)
{
    CCAssert(path != NULL, "TextureCache: fileimage MUST not be nil");
    CCAssert( bpp==2 || bpp==4, "TextureCache: bpp must be either 2 or 4");

    CCTexture2D * texture;

    std::string temp(path);
    
    if ( (texture = (CCTexture2D*)m_pTextures->objectForKey(temp.c_str())) )
    {
        return texture;
    }
    
    // Split up directory and filename
    std::string fullpath( CCFileUtils::sharedFileUtils()->fullPathForFilename(path) );

    unsigned long nLen = 0;
    unsigned char* pData = CCFileUtils::sharedFileUtils()->getFileData(fullpath.c_str(), "rb", &nLen);

    texture = new CCTexture2D();
    
    if( texture->initWithPVRTCData(pData, 0, bpp, hasAlpha, width,
                                   (bpp==2 ? kCCTexture2DPixelFormat_PVRTC2 : kCCTexture2DPixelFormat_PVRTC4)))
    {
        m_pTextures->setObject(texture, temp.c_str());
        texture->autorelease();
    }
    else
    {
        CCLOG("cocos2d: Couldn't add PVRTCImage:%s in CCTextureCache",path);
    }
    CC_SAFE_DELETE_ARRAY(pData);

    return texture;
}
#endif // CC_SUPPORT_PVRTC

bool CCTextureCache::imgInPalettePlist(const char* fileimage){
	if (m_pPNG8Files == NULL)
	{
		return false;
	}
	//
	static bool alltrue = false;
	if (alltrue)
		return true;
	//
	int filesize = m_pPNG8Files->count();
	if (filesize>0)
	{
		static bool needcheck = true;
		if (!alltrue && needcheck)
		{
			CCObject* object = m_pPNG8Files->objectForKey("alltrue");
			if (object ==NULL)
			{
				needcheck = false;
				alltrue = false;
			}
			else
			{
				CCString * pString =dynamic_cast<CCString*> (object);
				if (!pString)
				{
					alltrue = false;
				}
				else
				{
					if (pString->compare("true") == 0)
					{
						alltrue = true;
					}else{
						alltrue = false;
					}
				}
			}
		}
		//
		CCObject* object = m_pPNG8Files->objectForKey(fileimage);
		if (object ==NULL)
		{
			return false;
		}

		CCString * pString =dynamic_cast<CCString*> (object);
		if (!pString)
		{
			return false;
		}

		if (pString->compare("true") == 0)
		{
			return true;
		}else{
			return false;
		}
	}
	return false;
}
//--end difference from version 2.1.3 at com4loves@2013
CCTexture2D * CCTextureCache::addPVRImage(const char* path, const char *szType)
{
    CCAssert(path != NULL, "TextureCache: fileimage MUST not be nil");

    CCTexture2D* texture = NULL;
    std::string key(path);
    
    if( (texture = (CCTexture2D*)m_pTextures->objectForKey(key.c_str())) ) 
    {
        return texture;
    }

    // Split up directory and filename
    std::string fullpath = CCFileUtils::sharedFileUtils()->fullPathForFilename(key.c_str());
    texture = new CCTexture2D();
    if(texture != NULL && texture->initWithPVRFile(fullpath.c_str(),szType))
    {
#if CC_ENABLE_CACHE_TEXTURE_DATA

        VolatileTexture::addImageTexture(texture, fullpath.c_str(), CCImage::kFmtRawData,szType,"");
#endif
        m_pTextures->setObject(texture, key.c_str());
        texture->autorelease();
    }
    else
    {
        CCLOG("cocos2d: Couldn't add PVRImage:%s in CCTextureCache",key.c_str());
        CC_SAFE_DELETE(texture);
    }

    return texture;
}

CCTexture2D* CCTextureCache::addUIImage(CCImage *image, const char *key)
{
    CCAssert(image != NULL, "TextureCache: image MUST not be nil");

    CCTexture2D * texture = NULL;
    // textureForKey() use full path,so the key should be full path
    std::string forKey;
    if (key)
    {
        forKey = CCFileUtils::sharedFileUtils()->fullPathForFilename(key);
    }

    // Don't have to lock here, because addImageAsync() will not 
    // invoke opengl function in loading thread.

    do 
    {
        // If key is nil, then create a new texture each time
        if(key && (texture = (CCTexture2D *)m_pTextures->objectForKey(forKey.c_str())))
        {
            break;
        }

        // prevents overloading the autorelease pool
        texture = new CCTexture2D();
        texture->initWithImage(image);

        if(key && texture)
        {
            m_pTextures->setObject(texture, forKey.c_str());
            texture->autorelease();
        }
        else
        {
            CCLOG("cocos2d: Couldn't add UIImage in CCTextureCache");
        }

    } while (0);

#if CC_ENABLE_CACHE_TEXTURE_DATA
    VolatileTexture::addCCImage(texture, image);
#endif
    
    return texture;
}

// TextureCache - Remove

void CCTextureCache::removeAllTextures()
{
    m_pTextures->removeAllObjects();
}

void CCTextureCache::removeUnusedTextures()
{
    /*
    CCDictElement* pElement = NULL;
    CCDICT_FOREACH(m_pTextures, pElement)
    {
        CCLOG("cocos2d: CCTextureCache: texture: %s", pElement->getStrKey());
        CCTexture2D *value = (CCTexture2D*)pElement->getObject();
        if (value->retainCount() == 1)
        {
            CCLOG("cocos2d: CCTextureCache: removing unused texture: %s", pElement->getStrKey());
            m_pTextures->removeObjectForElememt(pElement);
        }
    }
     */
    
    /** Inter engineer zhuoshi sun finds that this way will get better performance
     */    
    if (m_pTextures->count())
    {   
        // find elements to be removed
        CCDictElement* pElement = NULL;
        list<CCDictElement*> elementToRemove;
        CCDICT_FOREACH(m_pTextures, pElement)
        {
            CCTexture2D *value = (CCTexture2D*)pElement->getObject();
			CCLOG("cocos2d: CCTextureCache: texture: %s (%d)", pElement->getStrKey(), value->retainCount());
            if (value->retainCount() == 1)
            {
                elementToRemove.push_back(pElement);
            }
        }
        
        // remove elements
        for (list<CCDictElement*>::iterator iter = elementToRemove.begin(); iter != elementToRemove.end(); ++iter)
        {
            CCLOG("cocos2d: CCTextureCache: removing unused texture: %s", (*iter)->getStrKey());
            m_pTextures->removeObjectForElememt(*iter);
        }
    }
}

void CCTextureCache::removeTexture(CCTexture2D* texture)
{
    if( ! texture )
    {
        return;
    }

    CCArray* keys = m_pTextures->allKeysForObject(texture);
    m_pTextures->removeObjectsForKeys(keys);
}

void CCTextureCache::removeTextureForKey(const char *textureKeyName)
{
    if (textureKeyName == NULL)
    {
        return;
    }

    string fullPath = CCFileUtils::sharedFileUtils()->fullPathForFilename(textureKeyName,EncFileNameFlag,EncFilePath,ShowSuffixFlag);
    m_pTextures->removeObjectForKey(fullPath);
}

CCTexture2D* CCTextureCache::textureForKey(const char* key)
{
    return (CCTexture2D*)m_pTextures->objectForKey(LegendFindFileCpp(key));
}


void CCTextureCache::reloadAllTextures()
{
#if CC_ENABLE_CACHE_TEXTURE_DATA
    VolatileTexture::reloadAllTextures();
#endif
}

void CCTextureCache::setGcTime(double time)
{
    CCLOG("CCTextureCache::setGcTime %f",time);
	m_pTextures->setGCTime(time);
}

void CCTextureCache::gc(double passTime)
{
	m_pTextures->gc(passTime, 1);
//#if 0
//	dumpCachedTextureInfo();
//#endif
	//this->removeUnusedTextures();
}


void CCTextureCache::dumpCachedTextureInfo()
{
    unsigned int count = 0;
    unsigned int totalBytes = 0;
	unsigned int totalPowBytes = 0;

    CCDictElement* pElement = NULL;
    CCDICT_FOREACH(m_pTextures, pElement)
    {
        CCTexture2D* tex = (CCTexture2D*)pElement->getObject();
        unsigned int bpp = tex->bitsPerPixelForFormat();
        // Each texture takes up width * height * bytesPerPixel bytes.
        unsigned int bytes = tex->getPixelsWide() * tex->getPixelsHigh() * bpp / 8;
        totalBytes += bytes;
		unsigned int Powbytes = getPowsize(tex->getPixelsWide()) * getPowsize(tex->getPixelsHigh()) * bpp / 8;
		totalPowBytes += Powbytes;
        count++;
        CCLOG("cocos2d: \"%s\" rc=%lu id=%lu %lu x %lu @ %ld bpp => %lu KB %lu KB",
               pElement->getStrKey(),
               (long)tex->retainCount(),
               (long)tex->getName(),
               (long)tex->getPixelsWide(),
               (long)tex->getPixelsHigh(),
               (long)bpp,
               (long)bytes / 1024,
			   (long)Powbytes / 1024);
		//
		CCArray* pSpriteFrames = CCSpriteFrameCache::sharedSpriteFrameCache()->getSpriteFramesFromTexture(tex);
		{
			CCObject* pObj = NULL;
			CCARRAY_FOREACH(pSpriteFrames, pObj)
			{
				CCSpriteFrame* pFrame = (CCSpriteFrame*)pObj;
#if COCOS2D_DEBUG > 0
				pFrame->loginfo();
#endif
			}
		}
    }

    CCLOG("cocos2d: CCTextureCache dumpDebugInfo: %ld textures, for %lu KB (%.2f MB) PowSize = %.2f MB", (long)count, (long)totalBytes / 1024, totalBytes / (1024.0f*1024.0f), totalPowBytes / (1024.0f*1024.0f));
}

unsigned int CCTextureCache::getTextrueTotalBytes()
{
	if(infoDirty)
	{
		infoDirty = false;
		info_totalBytes = 0;
		CCDictElement* pElement = NULL;
		CCDICT_FOREACH(m_pTextures, pElement)
		{
			CCTexture2D* tex = (CCTexture2D*)pElement->getObject();
			unsigned int bpp = tex->bitsPerPixelForFormat();
			//unsigned int bytes = tex->getPixelsWide() * tex->getPixelsHigh() * bpp / 8;
			unsigned int bytes = getPowsize(tex->getPixelsWide()) * getPowsize(tex->getPixelsHigh()) * bpp / 8;
			info_totalBytes += bytes;
			info_max_totalBytes = info_max_totalBytes > info_totalBytes? info_max_totalBytes : info_totalBytes;
		}
	}
	return info_totalBytes/* / (1024.0f*1024.0f)*/;
}

unsigned int CCTextureCache::getMaxTextrueTotalBytes()
{
	return info_max_totalBytes;
}

bool CCTextureCache::checkUpdateRemove( CCTexture2D* pTex )
{
	if (m_elementToRemove.size())
	{
		std::list<CCDictElement*>::iterator iter = m_elementToRemove.begin();
		for (; iter != m_elementToRemove.end(); ++iter)
		{
			if ((*iter)->getObject() == pTex)
			{
				m_elementToRemove.erase(iter);
				return true;
			}
		}
	}
	return false;
}

//--end difference from version 2.1.3 at com4loves@2013

#if CC_ENABLE_CACHE_TEXTURE_DATA

std::list<VolatileTexture*> VolatileTexture::textures;
bool VolatileTexture::isReloading = false;

VolatileTexture::VolatileTexture(CCTexture2D *t)
: texture(t)
, m_eCashedImageType(kInvalid)
, m_pTextureData(NULL)
, m_PixelFormat(kTexture2DPixelFormat_RGBA8888)
, m_strFileName("")
, m_FmtImage(CCImage::kFmtPng)
, uiImage(NULL)
, m_strText("")
#ifdef ENABLE_TEXT_SHADOW_AND_STROKE
, m_pFontDef(NULL)
#else
, m_alignment(kCCTextAlignmentCenter)
, m_vAlignment(kCCVerticalTextAlignmentCenter)
, m_strFontName("")
, m_fFontSize(0.0f)
#endif
{
#ifndef ENABLE_TEXT_SHADOW_AND_STROKE
    m_size = CCSizeMake(0, 0);
#endif
    m_texParams.minFilter = GL_LINEAR;
    m_texParams.magFilter = GL_LINEAR;
    m_texParams.wrapS = GL_CLAMP_TO_EDGE;
    m_texParams.wrapT = GL_CLAMP_TO_EDGE;
    textures.push_back(this);

}

VolatileTexture::~VolatileTexture()
{
    textures.remove(this);
    CC_SAFE_RELEASE(uiImage);
    CC_SAFE_DELETE(m_pFontDef);

}

void VolatileTexture::addImageTexture(CCTexture2D *tt, const char* imageFileName, CCImage::EImageFormat format, const char *pFileExtension,  const char *pImageMaskFile)
{
    if (isReloading)
    {
        return;
    }

    VolatileTexture *vt = findVolotileTexture(tt);

    vt->m_eCashedImageType = kImageFile;
    vt->m_strFileName = imageFileName;
    vt->m_FmtImage    = format;

    if(strcmp(".ccz",pFileExtension )==0)
    	vt->m_fileExtension = ".pvr.ccz";
    else
    	vt->m_fileExtension = pFileExtension;
    if(pImageMaskFile!=NULL)
    	vt->m_imgMaskFile = pImageMaskFile;

    vt->m_PixelFormat = tt->getPixelFormat();
}

void VolatileTexture::addCCImage(CCTexture2D *tt, CCImage *image)
{
    VolatileTexture *vt = findVolotileTexture(tt);
    image->retain();
    vt->uiImage = image;
    vt->m_eCashedImageType = kImage;
}

VolatileTexture* VolatileTexture::findVolotileTexture(CCTexture2D *tt)
{
    VolatileTexture *vt = 0;
    std::list<VolatileTexture *>::iterator i = textures.begin();
    while (i != textures.end())
    {
        VolatileTexture *v = *i++;
        if (v->texture == tt) 
        {
            vt = v;
            break;
        }
    }
    
    if (! vt)
    {
        vt = new VolatileTexture(tt);
    }
    
    return vt;
}

void VolatileTexture::addDataTexture(CCTexture2D *tt, void* data, CCTexture2DPixelFormat pixelFormat, const CCSize& contentSize)
{
    if (isReloading)
    {
        return;
    }

    VolatileTexture *vt = findVolotileTexture(tt);

    vt->m_eCashedImageType = kImageData;
    vt->m_pTextureData = data;
    vt->m_PixelFormat = pixelFormat;
    vt->m_TextureSize = contentSize;
}

void VolatileTexture::addZipPVRTexture(CCTexture2D *tt,char const *name)
{
	//TODO
	if (isReloading)
	{
		return;
	}

	VolatileTexture *vt = findVolotileTexture(tt);

	vt->m_eCashedImageType = kZipPvr;
	vt->m_strFileName = name;


}

#ifdef ENABLE_TEXT_SHADOW_AND_STROKE
void VolatileTexture::addStringTexture(CCTexture2D *tt, const char* text, ccFontDefinition *pFontDef)
#else
void VolatileTexture::addStringTexture(CCTexture2D *tt, const char* text,

		const CCSize& dimensions, CCTextAlignment alignment,
                                       CCVerticalTextAlignment vAlignment, const char *fontName, float fontSize
                                       )
#endif
{
    if (isReloading )
    {
        return;
    }

    VolatileTexture *vt = findVolotileTexture(tt);

    vt->m_eCashedImageType = kString;
    vt->m_strText     = text;

#ifdef ENABLE_TEXT_SHADOW_AND_STROKE

    CC_SAFE_DELETE(vt->m_pFontDef);
    vt->m_pFontDef  = new ccFontDefinition();
    vt->m_pFontDef->m_fontName      = pFontDef->m_fontName;
    vt->m_pFontDef->m_fontSize      = pFontDef->m_fontSize;
    vt->m_pFontDef->m_dimensions    = pFontDef->m_dimensions;
    vt->m_pFontDef->m_alignment     = pFontDef->m_alignment;
    vt->m_pFontDef->m_vertAlignment = pFontDef->m_vertAlignment;
    vt->m_pFontDef->m_fontFillColor = pFontDef->m_fontFillColor;
  //  vt->m_pFontDef->m_shadow.    =         pFontDef->m_shadow;

    vt->m_pFontDef->m_shadow.m_shadowEnabled=         pFontDef->m_shadow.m_shadowEnabled;
    vt->m_pFontDef->m_shadow.m_shadowOffset=         pFontDef->m_shadow.m_shadowOffset;
    vt->m_pFontDef->m_shadow.m_shadowBlur=         pFontDef->m_shadow.m_shadowBlur;
    vt->m_pFontDef->m_shadow.m_shadowOpacity=         pFontDef->m_shadow.m_shadowOpacity;
    vt->m_pFontDef->m_shadow.m_shadowColor=         pFontDef->m_shadow.m_shadowColor;

    // true if stroke enabled
    vt->m_pFontDef->m_stroke.m_strokeEnabled=       pFontDef->m_stroke.m_strokeEnabled;
       // stroke color
    vt->m_pFontDef->m_stroke.m_strokeColor=       pFontDef->m_stroke.m_strokeColor;
       // stroke size
    vt->m_pFontDef->m_stroke.m_strokeSize=       pFontDef->m_stroke.m_strokeSize;
   // vt->m_pFontDef->m_stroke    ;
#else
    vt->m_size        = dimensions;
    vt->m_strFontName = fontName;
    vt->m_alignment   = alignment;
    vt->m_vAlignment  = vAlignment;
    vt->m_fFontSize   = fontSize;
    vt->m_strText     = text;
#endif

}

void VolatileTexture::setTexParameters(CCTexture2D *t, ccTexParams *texParams) 
{
    VolatileTexture *vt = findVolotileTexture(t);

    if (texParams->minFilter != GL_NONE)
        vt->m_texParams.minFilter = texParams->minFilter;
    if (texParams->magFilter != GL_NONE)
        vt->m_texParams.magFilter = texParams->magFilter;
    if (texParams->wrapS != GL_NONE)
        vt->m_texParams.wrapS = texParams->wrapS;
    if (texParams->wrapT != GL_NONE)
        vt->m_texParams.wrapT = texParams->wrapT;
}

void VolatileTexture::removeTexture(CCTexture2D *t) 
{

    std::list<VolatileTexture *>::iterator i = textures.begin();
    while (i != textures.end())
    {
        VolatileTexture *vt = *i++;
        if (vt->texture == t) 
        {
            delete vt;
            break;
        }
    }
}

void VolatileTexture::reloadAllTextures()
{
    isReloading = true;

    CCLOG("reload all texture");
    std::list<VolatileTexture *>::iterator iter = textures.begin();

    while (iter != textures.end())
    {
        VolatileTexture *vt = *iter++;

        switch (vt->m_eCashedImageType)
        {
        case kImageFile:
            {
            	/*
                std::string lowerCase(vt->m_strFileName.c_str());
                for (unsigned int i = 0; i < lowerCase.length(); ++i)
                {
                    lowerCase[i] = tolower(lowerCase[i]);
                }*/

//            	CCLog(" VolatileTexture::reloadAllTextures %s extentsion: %s mask:%s ",
//            			vt->m_strFileName.c_str() ,
//            			vt->m_fileExtension.c_str(),
//            			vt->m_imgMaskFile.c_str());

                if ( //std::string::npos != lowerCase.find(".pvr") ||
                		vt->m_fileExtension ==".pvr" || vt->m_fileExtension ==".pvr.ccz"  )
                {
                    CCTexture2DPixelFormat oldPixelFormat = CCTexture2D::defaultAlphaPixelFormat();
                    CCTexture2D::setDefaultAlphaPixelFormat(vt->m_PixelFormat);


                    vt->texture->initWithPVRFile(vt->m_strFileName.c_str(),vt->m_fileExtension.c_str());
                    CCTexture2D::setDefaultAlphaPixelFormat(oldPixelFormat);
                } 
                else 
                {
                    CCImage* pImage = new CCImage();
                    unsigned long nSize = 0;
                    unsigned char* pBuffer = CCFileUtils::sharedFileUtils()->getFileData(vt->m_strFileName.c_str(), "rb", &nSize);

                    if (pImage && pImage->initWithImageData((void*)pBuffer, nSize, vt->m_FmtImage))
                    {
                    	CCImage* imageMask = NULL;

                        CCTexture2DPixelFormat oldPixelFormat = CCTexture2D::defaultAlphaPixelFormat();
                        CCTexture2D::setDefaultAlphaPixelFormat(vt->m_PixelFormat);
                        if(!vt->m_imgMaskFile.empty())
                        {
                        	imageMask = createNewImage(vt->m_imgMaskFile.c_str(),CCImage::kFmtPng);
                        }

                        vt->texture->initWithImage(pImage,vt->m_PixelFormat,imageMask);
                        CCTexture2D::setDefaultAlphaPixelFormat(oldPixelFormat);
                    }

                    CC_SAFE_DELETE_ARRAY(pBuffer);
                    CC_SAFE_RELEASE(pImage);
                }
            }
            break;
        case kImageData:
            {
                vt->texture->initWithData(vt->m_pTextureData, 
                                          vt->m_PixelFormat, 
                                          vt->m_TextureSize.width, 
                                          vt->m_TextureSize.height, 
                                          vt->m_TextureSize);
            }
            break;
        case kString:
            {
#ifdef ENABLE_TEXT_SHADOW_AND_STROKE

            	vt->texture->initWithString(vt->m_strText.c_str(),
            	                                            vt->m_pFontDef
            	                                            );
#else
                vt->texture->initWithString(vt->m_strText.c_str(),
                                            vt->m_strFontName.c_str(),
                                            vt->m_fFontSize,
                                            vt->m_size,
                                            vt->m_alignment,
                                            vt->m_vAlignment
                                            );
#endif
            }
            break;
        case kImage:
            {
                vt->texture->initWithImage(vt->uiImage);
            }
            break;
        case kZipPvr:
            {
                    CCFileUtils *fu = CCFileUtils::sharedFileUtils();
                    unsigned long  dataSize = 0;
                    unsigned char * zipData = fu->getFileData(vt->m_strFileName.c_str(), "rb", &dataSize);
                    if(zipData!=NULL)
                     {
                         unsigned long pvrSize = 0;
                         unsigned char * pvrData= fu->getFileDataFromZipData(zipData, dataSize, "sheet.pvr", &pvrSize, "");
                         if(pvrData!=NULL)
                         {
                                 bool isok = vt->texture->initWithPVRData(pvrData, pvrSize);
                         }
                         CC_SAFE_DELETE_ARRAY(zipData);
                     }
                   
            }   
            break;
        default:
            break;
        }
        vt->texture->setTexParameters(&vt->m_texParams);
    }

    isReloading = false;
}



#endif // CC_ENABLE_CACHE_TEXTURE_DATA

NS_CC_END

