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
#ifndef __CC_FILEUTILS_ANDROID_H__
#define __CC_FILEUTILS_ANDROID_H__

#include "platform/CCFileUtils.h"
#include "platform/CCPlatformMacros.h"
#include "ccTypes.h"
#include "ccTypeInfo.h"
#include <string>
#include <vector>

NS_CC_BEGIN

/**
 * @addtogroup platform
 * @{
 */

//! @brief  Helper class to handle file operations
class CC_DLL CCFileUtilsAndroid : public CCFileUtils
{
    friend class CCFileUtils;
    CCFileUtilsAndroid();
public:
    virtual ~CCFileUtilsAndroid();

    /* override funtions */
    bool init();
	//--context difference from version 2.1.3 at com4loves@2013
	virtual unsigned char* getFileData(const char* pszFileName, const char* pszMode, unsigned long * pSize, bool isShowBox = true, unsigned short* crc = 0, bool isEncFileName = false, bool isEncFilePath = false, bool SuffixFlag = true);
    virtual std::string getWritablePath();
    virtual bool isFileExist(const std::string& strFilePath);
    virtual bool isAbsolutePath(const std::string& strPath);
    virtual std::string getResourcePath();
    struct ZipEntryInfo* getZipFileEntry(const std::string &fileName);
    int getFileDescriptor(const char * filename, off_t & start, off_t & length);
    /** This function is android specific. It is used for CCTextureCache::addImageAsync(). 
     Don't use it in your codes.
     */
    unsigned char* getFileDataForAsync(const char* pszFileName, const char* pszMode, unsigned long * pSize);
    
private:
    //我们在Android下的资源定位策略:优先找外部存储资源,而非apk里assets的zip压缩资源,并且内更新更新到此目录
    std::string 	m_strAppExternalStorageResourcesPath;
	std::string 	m_strAppExternalStoragePath;
    //
    std::string 	m_strApkAssetsZipPathPrefix;
	unsigned char* doGetFileData(const char* pszFileName, const char* pszMode, unsigned long * pSize, bool isShowBox = true, unsigned short* crc = 0, bool forAsync = false, bool isEncFileName = false, bool isEncFilePath = false, bool SuffixFlag = true);
};

// end of platform group
/// @}

NS_CC_END

#endif    // __CC_FILEUTILS_ANDROID_H__

