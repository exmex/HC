/****************************************************************************
Copyright (c) 2010-2013 cocos2d-x.org

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

#include "CCFileUtils.h"
#include "CCDirector.h"
#include "cocoa/CCDictionary.h"
#include "cocoa/CCString.h"
#include "CCSAXParser.h"
#include "support/tinyxml2/tinyxml2.h"
#include "support/zip_support/unzip.h"
#include "HeroFileUtils.h"
#include <stack>
#include <algorithm>

using namespace std;

#if (CC_TARGET_PLATFORM != CC_PLATFORM_IOS) && (CC_TARGET_PLATFORM != CC_PLATFORM_MAC)

NS_CC_BEGIN

void cc_safe_delete_array(void * p)
{
	//do
	//{ 
	//	if(p)
	//	{
	//		delete[] (p);
	//		(p) = 0; 
	//	} 
	//}
	//while(0);
}
typedef enum 
{
	SAX_NONE = 0,
	SAX_KEY,
	SAX_DICT,
	SAX_INT,
	SAX_REAL,
	SAX_STRING,
	SAX_ARRAY
}CCSAXState;

typedef enum
{
	SAX_RESULT_NONE = 0,
	SAX_RESULT_DICT,
	SAX_RESULT_ARRAY
}CCSAXResult;

class CCDictMaker : public CCSAXDelegator
{
public:
	CCSAXResult m_eResultType;
	CCArray* m_pRootArray;
	CCDictionary *m_pRootDict;
	CCDictionary *m_pCurDict;
	std::stack<CCDictionary*> m_tDictStack;
	std::string m_sCurKey;   ///< parsed key
	std::string m_sCurValue; // parsed value
	CCSAXState m_tState;
	CCArray* m_pArray;

	std::stack<CCArray*> m_tArrayStack;
	std::stack<CCSAXState>  m_tStateStack;

public:
	CCDictMaker()
		: m_eResultType(SAX_RESULT_NONE),
		m_pRootArray(NULL),
		m_pRootDict(NULL),
		m_pCurDict(NULL),
		m_tState(SAX_NONE),
		m_pArray(NULL)
	{
	}

	~CCDictMaker()
	{
	}

	CCDictionary* dictionaryWithData(unsigned char const* data, unsigned long  size)
	{
		m_eResultType = SAX_RESULT_DICT;
		CCSAXParser parser;

		if (false == parser.init("UTF-8"))
		{
			return NULL;
		}
		parser.setDelegator(this);

		parser.parse((const char *)data, size);
		return m_pRootDict;

	}

	CCDictionary* dictionaryWithContentsOfFile(const char *pFileName)
	{
		m_eResultType = SAX_RESULT_DICT;
		CCSAXParser parser;

		if (false == parser.init("UTF-8"))
		{
			return NULL;
		}
		parser.setDelegator(this);

		parser.parse(pFileName);
		return m_pRootDict;
	}



	CCArray* arrayWithContentsOfFile(const char* pFileName)
	{
		m_eResultType = SAX_RESULT_ARRAY;
		CCSAXParser parser;

		if (false == parser.init("UTF-8"))
		{
			return NULL;
		}
		parser.setDelegator(this);

		parser.parse(pFileName);
		return m_pArray;
	}

	void startElement(void *ctx, const char *name, const char **atts)
	{
		CC_UNUSED_PARAM(ctx);
		CC_UNUSED_PARAM(atts);
		std::string sName((char*)name);
		if (sName == "dict")
		{
			m_pCurDict = new CCDictionary();
			if (m_eResultType == SAX_RESULT_DICT && m_pRootDict == NULL)
			{
				// Because it will call m_pCurDict->release() later, so retain here.
				m_pRootDict = m_pCurDict;
				m_pRootDict->retain();
			}
			m_tState = SAX_DICT;

			CCSAXState preState = SAX_NONE;
			if (!m_tStateStack.empty())
			{
				preState = m_tStateStack.top();
			}

			if (SAX_ARRAY == preState)
			{
				// add the dictionary into the array
				m_pArray->addObject(m_pCurDict);
			}
			else if (SAX_DICT == preState)
			{
				// add the dictionary into the pre dictionary
				CCAssert(!m_tDictStack.empty(), "The state is wrong!");
				CCDictionary* pPreDict = m_tDictStack.top();
				pPreDict->setObject(m_pCurDict, m_sCurKey.c_str());
			}

			m_pCurDict->release();

			// record the dict state
			m_tStateStack.push(m_tState);
			m_tDictStack.push(m_pCurDict);
		}
		else if (sName == "key")
		{
			m_tState = SAX_KEY;
		}
		else if (sName == "integer")
		{
			m_tState = SAX_INT;
		}
		else if (sName == "real")
		{
			m_tState = SAX_REAL;
		}
		else if (sName == "string")
		{
			m_tState = SAX_STRING;
		}
		else if (sName == "array")
		{
			m_tState = SAX_ARRAY;
			m_pArray = new CCArray();
			if (m_eResultType == SAX_RESULT_ARRAY && m_pRootArray == NULL)
			{
				m_pRootArray = m_pArray;
				m_pRootArray->retain();
			}
			CCSAXState preState = SAX_NONE;
			if (!m_tStateStack.empty())
			{
				preState = m_tStateStack.top();
			}

			if (preState == SAX_DICT)
			{
				m_pCurDict->setObject(m_pArray, m_sCurKey.c_str());
			}
			else if (preState == SAX_ARRAY)
			{
				CCAssert(!m_tArrayStack.empty(), "The state is wrong!");
				CCArray* pPreArray = m_tArrayStack.top();
				pPreArray->addObject(m_pArray);
			}
			m_pArray->release();
			// record the array state
			m_tStateStack.push(m_tState);
			m_tArrayStack.push(m_pArray);
		}
		else
		{
			m_tState = SAX_NONE;
		}
	}

	void endElement(void *ctx, const char *name)
	{
		CC_UNUSED_PARAM(ctx);
		CCSAXState curState = m_tStateStack.empty() ? SAX_DICT : m_tStateStack.top();
		std::string sName((char*)name);
		if (sName == "dict")
		{
			m_tStateStack.pop();
			m_tDictStack.pop();
			if (!m_tDictStack.empty())
			{
				m_pCurDict = m_tDictStack.top();
			}
		}
		else if (sName == "array")
		{
			m_tStateStack.pop();
			m_tArrayStack.pop();
			if (!m_tArrayStack.empty())
			{
				m_pArray = m_tArrayStack.top();
			}
		}
		else if (sName == "true")
		{
			CCString *str = new CCString("1");
			if (SAX_ARRAY == curState)
			{
				m_pArray->addObject(str);
			}
			else if (SAX_DICT == curState)
			{
				m_pCurDict->setObject(str, m_sCurKey.c_str());
			}
			str->release();
		}
		else if (sName == "false")
		{
			CCString *str = new CCString("0");
			if (SAX_ARRAY == curState)
			{
				m_pArray->addObject(str);
			}
			else if (SAX_DICT == curState)
			{
				m_pCurDict->setObject(str, m_sCurKey.c_str());
			}
			str->release();
		}
		else if (sName == "string" || sName == "integer" || sName == "real")
		{
			CCString* pStrValue = new CCString(m_sCurValue);

			if (SAX_ARRAY == curState)
			{
				m_pArray->addObject(pStrValue);
			}
			else if (SAX_DICT == curState)
			{
				m_pCurDict->setObject(pStrValue, m_sCurKey.c_str());
			}

			pStrValue->release();
			m_sCurValue.clear();
		}

		m_tState = SAX_NONE;
	}

	void textHandler(void *ctx, const char *ch, int len)
	{
		CC_UNUSED_PARAM(ctx);
		if (m_tState == SAX_NONE)
		{
			return;
		}

		CCSAXState curState = m_tStateStack.empty() ? SAX_DICT : m_tStateStack.top();
		CCString *pText = new CCString(std::string((char*)ch, 0, len));

		switch (m_tState)
		{
		case SAX_KEY:
			m_sCurKey = pText->getCString();
			break;
		case SAX_INT:
		case SAX_REAL:
		case SAX_STRING:
		{
						   if (curState == SAX_DICT)
						   {
							   CCAssert(!m_sCurKey.empty(), "key not found : <integer/real>");
						   }

						   m_sCurValue.append(pText->getCString());
		}
			break;
		default:
			break;
		}
		pText->release();
	}
};

CCDictionary* CCFileUtils::createCCDictionaryWithContentsOfFile(const std::string& filename)
{
    std::string fullPath = fullPathForFilename(filename.c_str());
    CCDictMaker tMaker;
    return tMaker.dictionaryWithContentsOfFile(fullPath.c_str());
}

CCArray* CCFileUtils::createCCArrayWithContentsOfFile(const std::string& filename)
{
    std::string fullPath = fullPathForFilename(filename.c_str());
    CCDictMaker tMaker;
    return tMaker.arrayWithContentsOfFile(fullPath.c_str());
}

/*
 * forward statement
 */
static tinyxml2::XMLElement* generateElementForArray(cocos2d::CCArray *array, tinyxml2::XMLDocument *pDoc);
static tinyxml2::XMLElement* generateElementForDict(cocos2d::CCDictionary *dict, tinyxml2::XMLDocument *pDoc);

/*
 * Use tinyxml2 to write plist files
 */
bool CCFileUtils::writeToFile(cocos2d::CCDictionary *dict, const std::string &fullPath)
{
    //CCLOG("tinyxml2 CCDictionary %d writeToFile %s", dict->m_uID, fullPath.c_str());
    tinyxml2::XMLDocument *pDoc = new tinyxml2::XMLDocument();
    if (NULL == pDoc)
        return false;
    
    tinyxml2::XMLDeclaration *pDeclaration = pDoc->NewDeclaration("xml version=\"1.0\" encoding=\"UTF-8\"");
    if (NULL == pDeclaration)
    {
        delete pDoc;
        return false;
    }
    
    pDoc->LinkEndChild(pDeclaration);
    tinyxml2::XMLElement *docType = pDoc->NewElement("!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\"");
    pDoc->LinkEndChild(docType);
    
    tinyxml2::XMLElement *pRootEle = pDoc->NewElement("plist");
    pRootEle->SetAttribute("version", "1.0");
    if (NULL == pRootEle)
    {
        delete pDoc;
        return false;
    }
    pDoc->LinkEndChild(pRootEle);
    
    tinyxml2::XMLElement *innerDict = generateElementForDict(dict, pDoc);
    if (NULL == innerDict )
    {
        delete pDoc;
        return false;
    }
    pRootEle->LinkEndChild(innerDict);
    
    bool bRet = tinyxml2::XML_SUCCESS == pDoc->SaveFile(fullPath.c_str());
    
    delete pDoc;
    return bRet;
}

/*
 * Generate tinyxml2::XMLElement for CCObject through a tinyxml2::XMLDocument
 */
static tinyxml2::XMLElement* generateElementForObject(cocos2d::CCObject *object, tinyxml2::XMLDocument *pDoc)
{
    // object is CCString
    if (CCString *str = dynamic_cast<CCString *>(object))
    {
        tinyxml2::XMLElement* node = pDoc->NewElement("string");
        tinyxml2::XMLText* content = pDoc->NewText(str->getCString());
        node->LinkEndChild(content);
        return node;
    }
    
    // object is CCArray
    if (CCArray *array = dynamic_cast<CCArray *>(object))
        return generateElementForArray(array, pDoc);
    
    // object is CCDictionary
    if (CCDictionary *innerDict = dynamic_cast<CCDictionary *>(object))
        return generateElementForDict(innerDict, pDoc);
    
    CCLOG("This type cannot appear in property list");
    return NULL;
}

/*
 * Generate tinyxml2::XMLElement for CCDictionary through a tinyxml2::XMLDocument
 */
static tinyxml2::XMLElement* generateElementForDict(cocos2d::CCDictionary *dict, tinyxml2::XMLDocument *pDoc)
{
    tinyxml2::XMLElement* rootNode = pDoc->NewElement("dict");
    
    CCDictElement *dictElement = NULL;
    CCDICT_FOREACH(dict, dictElement)
    {
        tinyxml2::XMLElement* tmpNode = pDoc->NewElement("key");
        rootNode->LinkEndChild(tmpNode);
        tinyxml2::XMLText* content = pDoc->NewText(dictElement->getStrKey());
        tmpNode->LinkEndChild(content);
        
        CCObject *object = dictElement->getObject();
        tinyxml2::XMLElement *element = generateElementForObject(object, pDoc);
        if (element)
            rootNode->LinkEndChild(element);
    }
    return rootNode;
}

/*
 * Generate tinyxml2::XMLElement for CCArray through a tinyxml2::XMLDocument
 */
static tinyxml2::XMLElement* generateElementForArray(cocos2d::CCArray *array, tinyxml2::XMLDocument *pDoc)
{
    tinyxml2::XMLElement* rootNode = pDoc->NewElement("array");
    
    CCObject *object = NULL;
    CCARRAY_FOREACH(array, object)
    {
        tinyxml2::XMLElement *element = generateElementForObject(object, pDoc);
        if (element)
            rootNode->LinkEndChild(element);
    }
    return rootNode;
}


#else
NS_CC_BEGIN

/* The subclass CCFileUtilsIOS and CCFileUtilsMac should override these two method. */
CCDictionary* CCFileUtils::createCCDictionaryWithContentsOfFile(const std::string& filename) {return NULL;}
bool CCFileUtils::writeToFile(cocos2d::CCDictionary *dict, const std::string &fullPath) {return NULL;}
CCArray* CCFileUtils::createCCArrayWithContentsOfFile(const std::string& filename) {return NULL;}

#endif /* (CC_TARGET_PLATFORM != CC_PLATFORM_IOS) && (CC_TARGET_PLATFORM != CC_PLATFORM_MAC) */


CCFileUtils* CCFileUtils::s_sharedFileUtils = NULL;
CCFileUtils::DecodeBuffFun CCFileUtils::m_decodeBuff = NULL;
CCFileUtils::EncFileNameFun CCFileUtils::m_rc4FileName = NULL;
CCFileUtils::EncFilePathFun CCFileUtils::m_rc4FilePath = NULL;
void CCFileUtils::purgeFileUtils()
{
	CC_SAFE_DELETE(s_sharedFileUtils);
    s_sharedFileUtils =  NULL;
}

CCFileUtils::CCFileUtils()
: m_pFilenameLookupDict(NULL)
{
	m_isEncFileName = false;
}

CCFileUtils::~CCFileUtils()
{
	CC_SAFE_RELEASE(m_pFilenameLookupDict);
}

bool CCFileUtils::init()
{
	m_searchPathArray.push_back(m_strDefaultResRootPath);
	m_searchResolutionsOrderArray.push_back("");
	return true;
}

void CCFileUtils::purgeCachedEntries()
{
	m_fullPathCache.clear();
}
//--context difference from version 2.1.3 at com4loves@2013
unsigned char* CCFileUtils::getFileData(const char* pszFileName, const char* pszMode, unsigned long * pSize, bool isShowBox, unsigned short* crc, bool isEncFileName, bool isEncFilePath, bool SuffixFlag)
{
    unsigned char * pBuffer = NULL;
    CCAssert(pszFileName != NULL && pSize != NULL && pszMode != NULL, "Invalid parameters.");
    *pSize = 0;

	std::string encFileName = getEncFilePath(pszFileName, isEncFileName, isEncFilePath, SuffixFlag);

    do
    {
        // read the file from hardware
		std::string fullPath = fullPathForFilename(encFileName.c_str());
        FILE *fp = fopen(fullPath.c_str(), pszMode);
        CC_BREAK_IF(!fp);
        
        fseek(fp,0,SEEK_END);
        *pSize = ftell(fp);
        fseek(fp,0,SEEK_SET);
        pBuffer = new unsigned char[*pSize];
        *pSize = fread(pBuffer,sizeof(unsigned char), *pSize,fp);
		fclose(fp);
    } 
	while (0);
    
    if (! pBuffer)
    {
        std::string msg = "Get data from file(";
        msg.append(pszFileName).append(") failed|Converting PNG file to JPG Reload!");
        
        CCLOG(msg.c_str());
		//add by dylan at 20131015  file not found show messagebox
		if(isShowBox&&msg.find(".msg")==std::string::npos&&msg!=".ccbi")
		{
			if(msg.find(".")!=std::string::npos)
			{
				bool isShowErrorBox=false;
#ifdef _DEBUG 
				isShowErrorBox = true;
#endif	
#ifdef WIN32 
				isShowErrorBox = true;
#endif	
				if (isShowErrorBox)CCMessageBox(msg.c_str(), "File Not Found");
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
					std::string fullPath = LegendFindFileCpp(fileName.c_str());
					FILE *fp = fopen(fullPath.c_str(), pszMode);
					CC_BREAK_IF(!fp);

					fseek(fp,0,SEEK_END);
					*pSize = ftell(fp);
					fseek(fp,0,SEEK_SET);
					pBuffer = new unsigned char[*pSize];
					*pSize = fread(pBuffer,sizeof(unsigned char), *pSize,fp);
					fclose(fp);
				} while (0);
			}
		}
    }
	if(crc!=0)
	{
		*crc = GetCRC16((unsigned char*)pBuffer,*pSize);
	}

	if (pBuffer&&m_decodeBuff)
	{
		return (m_decodeBuff)(pSize,pBuffer,pszFileName,pszMode);
	}
	return pBuffer;
}

unsigned char* CCFileUtils::getFileDataFromZip(const char* pszZipFilePath, const char* pszFileName, unsigned long * pSize)
{
	unsigned char * pBuffer = NULL;
	unzFile pFile = NULL;
	*pSize = 0;

	do
	{
		CC_BREAK_IF(!pszZipFilePath || !pszFileName);
		CC_BREAK_IF(strlen(pszZipFilePath) == 0);

		pFile = unzOpen(pszZipFilePath);
		CC_BREAK_IF(!pFile);

		int nRet = unzLocateFile(pFile, pszFileName, 1);
		CC_BREAK_IF(UNZ_OK != nRet);

		char szFilePathA[260];
		unz_file_info FileInfo;
		nRet = unzGetCurrentFileInfo(pFile, &FileInfo, szFilePathA, sizeof(szFilePathA), NULL, 0, NULL, 0);
		CC_BREAK_IF(UNZ_OK != nRet);

		nRet = unzOpenCurrentFile(pFile);
		CC_BREAK_IF(UNZ_OK != nRet);

		pBuffer = new unsigned char[FileInfo.uncompressed_size];
		int CC_UNUSED nSize = unzReadCurrentFile(pFile, pBuffer, FileInfo.uncompressed_size);
		CCAssert(nSize == 0 || nSize == (int)FileInfo.uncompressed_size, "the file size is wrong");

		*pSize = FileInfo.uncompressed_size;
		unzCloseCurrentFile(pFile);
	} while (0);

	if (pFile)
	{
		unzClose(pFile);
	}

	return pBuffer;
}






unsigned char*  CCFileUtils::getFileDataFromZipData(unsigned char* zipData, unsigned long zipDataSize, char const* pszFileName, unsigned long * pSize, const char * password)
{
	unsigned char * pBuf = NULL;
	unzFile pFile = NULL;
	*pSize = 0;

	do
	{

		pFile = unzOpenBuffer(zipData, zipDataSize);
		CC_BREAK_IF(!pFile);

		int nRet = unzLocateFile(pFile, pszFileName, 1);
		CC_BREAK_IF(UNZ_OK != nRet);

		char szFilePathA[260];
		unz_file_info FileInfo;
		nRet = unzGetCurrentFileInfo(pFile, &FileInfo, szFilePathA, sizeof(szFilePathA), NULL, 0, NULL, 0);
		CC_BREAK_IF(UNZ_OK != nRet);


		nRet = unzOpenCurrentFilePassword(pFile, (password == NULL) ? NULL : ((*password == 0) ? NULL : password));
		CC_BREAK_IF(UNZ_OK != nRet);

		pBuf = new unsigned char[FileInfo.uncompressed_size];
		int  nSize = unzReadCurrentFile(pFile, pBuf, FileInfo.uncompressed_size);
		CCAssert(nSize == 0 || nSize == (int)FileInfo.uncompressed_size, "the file size is wrong");

		*pSize = FileInfo.uncompressed_size;
		unzCloseCurrentFile(pFile);
	} while (0);

	if (pFile)
	{
		unzClose(pFile);
	}
	//  printf("%lx\n",pBuf);
	return pBuf;
}


CCDictionary * CCFileUtils::createCCDictionaryWithData(unsigned char const* data, unsigned long size)
{
#if (CC_TARGET_PLATFORM != CC_PLATFORM_IOS) && (CC_TARGET_PLATFORM != CC_PLATFORM_MAC)
	CCDictMaker mk;
	return mk.dictionaryWithData(data, size);
#else
	return NULL;
#endif
}



std::string CCFileUtils::getNewFilename(const char* pszFileName)
{
	const char* pszNewFileName = NULL;
	// in Lookup Filename dictionary ?
	CCString* fileNameFound = m_pFilenameLookupDict ? (CCString*)m_pFilenameLookupDict->objectForKey(pszFileName) : NULL;
	if (NULL == fileNameFound || fileNameFound->length() == 0) {
		pszNewFileName = pszFileName;
	}
	else {
		pszNewFileName = fileNameFound->getCString();
		//CCLOG("FOUND NEW FILE NAME: %s.", pszNewFileName);
	}
	return pszNewFileName;
}

std::string CCFileUtils::getPathForFilename(const std::string& filename, const std::string& resolutionDirectory, const std::string& searchPath)
{
	std::string file = filename;
	std::string file_path = "";
	size_t pos = filename.find_last_of("/");
	if (pos != std::string::npos)
	{
		file_path = filename.substr(0, pos + 1);
		file = filename.substr(pos + 1);
	}

	// searchPath + file_path + resourceDirectory
	std::string path = searchPath;
	path += file_path;
	path += resolutionDirectory;

	path = getFullPathForDirectoryAndFilename(path, file);

	//CCLOG("getPathForFilename, fullPath = %s", path.c_str());
	return path;
}

std::string CCFileUtils::fullPathForAudioFile(const char* pszFileName)
{
	if (!pszFileName)
	{
		return pszFileName;
	}
	std::string fullpath = pszFileName; // (CCFileUtils::sharedFileUtils()->fullPathFromRelativePath(path));

	fullpath = LegendFindFileCpp(fullpath.c_str());
	
	if (CCFileUtils::sharedFileUtils()->isFileExist(fullpath))
	{
		return fullpath.c_str();
	}
	// The file wasn't found, return the file name passed in.
	return pszFileName;
}

std::string CCFileUtils::getEncFilePath(const char *oriFileName, bool isEncFileName, bool isEncFilePath, bool SuffixFlag)
{
	std::string strFileName = oriFileName;
	isEncFilePath = canEncFilePath(isEncFilePath);
	if (isEncFilePath)
	{
		strFileName = getAbsEncFilePath(oriFileName);
	}

	isEncFileName = canEncFileName(isEncFileName);
	if (isEncFileName)
	{
		strFileName = (m_rc4FileName)(strFileName.c_str());
	}
	return strFileName;
}


std::string CCFileUtils::fullPathForFilename(const char* pszFileName, bool isEncFileName, bool isEncFilePath , bool SuffixFlag)
{
	CCAssert(pszFileName != NULL, "CCFileUtils: Invalid path");

	std::string strFileName = getEncFilePath(pszFileName,isEncFileName,isEncFilePath,SuffixFlag);

	if (isAbsolutePath(strFileName.c_str()))
	{
		return strFileName.c_str();
	}

	// Already Cached ?
	std::map<std::string, std::string>::iterator cacheIter = m_fullPathCache.find(strFileName.c_str());
	if (cacheIter != m_fullPathCache.end())
	{
		//CCLOG("Return full path from cache: %s", cacheIter->second.c_str());
		return cacheIter->second;
	}

	// Get the new file name.
	std::string newFilename = getNewFilename(strFileName.c_str());

	string fullpath = "";

	for (std::vector<std::string>::iterator searchPathsIter = m_searchPathArray.begin();
		searchPathsIter != m_searchPathArray.end(); ++searchPathsIter) {
		for (std::vector<std::string>::iterator resOrderIter = m_searchResolutionsOrderArray.begin();
			resOrderIter != m_searchResolutionsOrderArray.end(); ++resOrderIter) {

			//CCLOG("\n\nSEARCHING: %s, %s, %s", newFilename.c_str(), resOrderIter->c_str(), searchPathsIter->c_str());

			fullpath = this->getPathForFilename(newFilename, *resOrderIter, *searchPathsIter);

			if (fullpath.length() > 0)
			{
				// Using the filename passed in as key.
				m_fullPathCache.insert(std::pair<std::string, std::string>(strFileName.c_str(), fullpath));
				//CCLOG("Returning path: %s", fullpath.c_str());
				return fullpath;
			}
		}
	}

	// The file wasn't found, return the file name passed in.
	return strFileName.c_str();
}

const char* CCFileUtils::fullPathFromRelativeFile(const char *pszFilename, const char *pszRelativeFile)
{
	std::string relativeFile = pszRelativeFile;
	CCString *pRet = CCString::create("");
	pRet->m_sString = relativeFile.substr(0, relativeFile.rfind('/') + 1);
	pRet->m_sString += getNewFilename(pszFilename);
	return pRet->getCString();
}

void CCFileUtils::setSearchResolutionsOrder(const std::vector<std::string>& searchResolutionsOrder)
{
	bool bExistDefault = false;
	m_searchResolutionsOrderArray.clear();
	for (std::vector<std::string>::const_iterator iter = searchResolutionsOrder.begin(); iter != searchResolutionsOrder.end(); ++iter)
	{
		std::string resolutionDirectory = *iter;
		if (!bExistDefault && resolutionDirectory == "")
		{
			bExistDefault = true;
		}

		if (resolutionDirectory.length() > 0 && resolutionDirectory[resolutionDirectory.length() - 1] != '/')
		{
			resolutionDirectory += "/";
		}

		m_searchResolutionsOrderArray.push_back(resolutionDirectory);
	}
	if (!bExistDefault)
	{
		m_searchResolutionsOrderArray.push_back("");
	}
}

void CCFileUtils::addSearchResolutionsOrder(const char* order)
{
	m_searchResolutionsOrderArray.push_back(order);
}

const std::vector<std::string>& CCFileUtils::getSearchResolutionsOrder()
{
	return m_searchResolutionsOrderArray;
}

const std::vector<std::string>& CCFileUtils::getSearchPaths()
{
	return m_searchPathArray;
}

void CCFileUtils::setSearchPaths(const std::vector<std::string>& searchPaths)
{
	bool bExistDefaultRootPath = false;

    m_fullPathCache.clear();
    m_searchPathArray.clear();
    for (std::vector<std::string>::const_iterator iter = searchPaths.begin(); iter != searchPaths.end(); ++iter)
    {
        std::string strPrefix;
        std::string path;
        if (!isAbsolutePath(*iter))
        { // Not an absolute path
            strPrefix = m_strDefaultResRootPath;
        }
        path = strPrefix+(*iter);
        if (path.length() > 0 && path[path.length()-1] != '/')
        {
            path += "/";
        }
        if (!bExistDefaultRootPath && path == m_strDefaultResRootPath)
        {
            bExistDefaultRootPath = true;
        }
        m_searchPathArray.push_back(path);
    }
    
    if (!bExistDefaultRootPath)
    {
        //CCLOG("Default root path doesn't exist, adding it.");
        m_searchPathArray.push_back(m_strDefaultResRootPath);
    }
}

void CCFileUtils::addSearchPath(const char* path_)
{
	std::string strPrefix;
	std::string path(path_);
	if (!isAbsolutePath(path))
	{ // Not an absolute path
		strPrefix = m_strDefaultResRootPath;
	}
	path = strPrefix + path;
	if (path.length() > 0 && path[path.length() - 1] != '/')
	{
		path += "/";
	}
	m_searchPathArray.push_back(path);
}

void CCFileUtils::removeSearchPath(const char *path_)
{
	std::string strPrefix;
	std::string path(path_);
	if (!isAbsolutePath(path))
	{ // Not an absolute path
		strPrefix = m_strDefaultResRootPath;
	}
	path = strPrefix + path;
	if (path.length() > 0 && path[path.length()-1] != '/')
	{
		path += "/";
	}
	std::vector<std::string>::iterator iter = std::find(m_searchPathArray.begin(), m_searchPathArray.end(), path);
	m_searchPathArray.erase(iter);
}

void CCFileUtils::removeAllPaths()
{
	m_searchPathArray.clear();
}
void CCFileUtils::setFilenameLookupDictionary(CCDictionary* pFilenameLookupDict)
{
    m_fullPathCache.clear();
    CC_SAFE_RELEASE(m_pFilenameLookupDict);
    m_pFilenameLookupDict = pFilenameLookupDict;
    CC_SAFE_RETAIN(m_pFilenameLookupDict);
}

void CCFileUtils::loadFilenameLookupDictionaryFromFile(const char* filename)
{
	std::string fullPath = this->fullPathForFilename(filename);
	if (fullPath.length() > 0)
	{
		CCDictionary* pDict = CCDictionary::createWithContentsOfFile(fullPath.c_str());
		if (pDict)
		{
			CCDictionary* pMetadata = (CCDictionary*)pDict->objectForKey("metadata");
			int version = ((CCString*)pMetadata->objectForKey("version"))->intValue();
			if (version != 1)
			{
				CCLOG("cocos2d: ERROR: Invalid filenameLookup dictionary version: %ld. Filename: %s", (long)version, filename);
				return;
			}
			setFilenameLookupDictionary((CCDictionary*)pDict->objectForKey("filenames"));
		}
	}
}

std::string CCFileUtils::getFullPathForDirectoryAndFilename(const std::string& strDirectory, const std::string& strFilename)
{
	std::string ret = strDirectory + strFilename;
	if (!isFileExist(ret)) {
		ret = "";
	}
	return ret;
}

bool CCFileUtils::isAbsolutePath(const std::string& strPath)
{
	return strPath[0] == '/' ? true : false;
}

//////////////////////////////////////////////////////////////////////////
// Notification support when getFileData from invalid file path.
//////////////////////////////////////////////////////////////////////////
static bool s_bPopupNotify = true;

void CCFileUtils::setPopupNotify(bool bNotify)
{
	s_bPopupNotify = bNotify;
}

bool CCFileUtils::isPopupNotify()
{
	return s_bPopupNotify;
}

bool CCFileUtils::canEncFileName(bool isEncFileName)
{
	bool isDebug = false;
	bool isWin32 = false;
#ifdef _DEBUG 
	isDebug = true;
#endif	
#ifdef WIN32 
	isWin32 = true;
#endif	

	if (m_isEncFileName&&(!isWin32 || (isWin32&&!isDebug)) && isEncFileName&&m_rc4FileName)
	{
		//
	}
	else
	{
		isEncFileName = false;
	}
	return isEncFileName;
}

bool CCFileUtils::canEncFilePath(bool isEncFilePath)
{
	bool isDebug = false;
	bool isWin32 = false;
#ifdef _DEBUG 
	isDebug = true;
#endif	
#ifdef WIN32 
	isWin32 = true;
#endif	

	if (m_isEncFilePath && (!isWin32 || (isWin32&&!isDebug)) && isEncFilePath)
	{
		//
	}
	else
	{
		isEncFilePath = false;
	}
	return isEncFilePath;
}

bool CCFileUtils::showSuffixFlag(bool suffixFlag)
{
	bool isDebug = false;
	bool isWin32 = false;
#ifdef _DEBUG 
	isDebug = true;
#endif	
#ifdef WIN32 
	isWin32 = true;
#endif	

	if (!m_isSuffixFlag && (!isWin32 || (isWin32&&!isDebug)) && !suffixFlag)
	{
		//
		suffixFlag = false;
	}
	else
	{
		suffixFlag = true;
	}
	return suffixFlag;
}

std::string CCFileUtils::getAbsEncFilePath(std::string filePathOri)
{
	std::string filePath = filePathOri;

	std::string::size_type namePos = filePath.find_last_of("/");
	std::string fileName = filePath;
	//获取文件名
	if (namePos != 0 && namePos != std::string::npos)
	{
		fileName = filePath.substr(namePos + 1);
	}

	//查找当前路径是否已经进行加密，如加密直接进行使用
	EncFilePathList::iterator it = mEncFilePathList.find(filePathOri);
	if (it != mEncFilePathList.end())
	{
		filePath = it->second + fileName;
	}
	else
	{
		//文件路径加密;
		if (m_rc4FilePath) filePath = (m_rc4FilePath)(filePath);

		std::string::size_type filePathSplitPos = filePath.find_last_of("/");
		if (filePathSplitPos != 0 && filePathSplitPos != std::string::npos)
		{
			filePath = filePath.substr(0, filePathSplitPos + 1);
		}
		//缓存文件加密后路径
		mEncFilePathList.insert(std::make_pair(filePathOri, filePath));
		filePath = filePath + fileName;
	}
	return filePath;
}
void CCFileUtils::setDecodeBufferFun(DecodeBuffFun bufferFun, EncFileNameFun rc4FileNameFun,EncFilePathFun rc4FilePathFun)
{
	m_decodeBuff = bufferFun;
	m_rc4FileName = rc4FileNameFun;
	m_rc4FilePath = rc4FilePathFun;
}

void CCFileUtils::setEncFlags(bool isEncFileName, bool isEncFilePath, bool isShowSuffixFlag)
{
	m_isEncFileName = isEncFileName;
	m_isEncFilePath = isEncFilePath;
	m_isSuffixFlag = isShowSuffixFlag;
}
unsigned short CCFileUtils::GetCRC16( 
	const unsigned char *p, /* points to chars to process */ 
	int n,/* how many chars to process */ 
	int start /*= 0 /* starting value */ )
{
	static unsigned int crcl6_table[16] = /* CRC-16s */
	{
		0x0000, 0xCC01, 0xD801, 0x1400,
		0xF001, 0x3C00, 0x2800, 0xE401,
		0xA001, 0X6C00, 0x7800, 0xB401,
		0x5000, 0x9C01, 0x8801, 0x4400
	};
	unsigned short int total; /* the CRC-16 value we compute */
	int r1;
	total = start;
	/* process each byte */
	while ( n-- > 0 )
	{
		/* do the lower four bits */
		r1 = crcl6_table[ total & 0xF ];
		total = ( total >> 4 ) & 0x0FFF;
		total = total ^ r1 ^ crcl6_table[ *p & 0xF ];
		/* do the upper four bits */
		r1 = crcl6_table[ total & 0xF ];
		total = ( total >> 4 ) & 0x0FFF;
		total = total ^ r1 ^ crcl6_table[ ( *p >> 4 ) & 0xF ];
		/* advance to next byte */
		p++;
	}
	return total;
}
NS_CC_END

