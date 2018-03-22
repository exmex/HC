
#include "stdafx.h"

#include <cstdio>
#include "rc4.h"
#include "GameEncryptKey.h"
#ifdef _WINDOWS
#include <direct.h>
#include "zlib/zlib.h"
#else
#include<sys/types.h>
#include<sys/stat.h>
//#include<sys/statfs.h>
#include "zlib.h"
#endif

#include <string>
#include "cocos2d.h"
#include "AES.h"
#include "md5.h"
#include "Base64.h"

bool decBuffer(unsigned long inSize , unsigned char* inBuffer, unsigned long& outSize, unsigned char*& outBuffer)
{

	unsigned char* decbuffer = new unsigned char[inBuffer[0]*blocksize];
	outSize = inBuffer[0]*blocksize;
	if(decbuffer)
	{
		int keyflag=0;
		int keylength = strlen((char *) gamekey);
		for(int i=0;i<inSize;++i)
		{
			*(inBuffer+i)=(*(inBuffer+i)^gamekey[keyflag]);
			keyflag = (keyflag+1)%keylength;
		}
		int ret = uncompress(decbuffer,&outSize,inBuffer+1,inSize-1);

		outBuffer = new unsigned char[outSize];
		if(ret == Z_OK && outBuffer!=0)
		{
			memcpy(outBuffer,decbuffer,outSize);
			delete[] decbuffer;
			return true;
		}

		delete[] decbuffer;
	}
	return false;
}


bool encBuffer(unsigned long inSize , unsigned char* inBuffer, unsigned long& outSize, unsigned char*& outBuffer)
{
	outBuffer = new unsigned char[inSize+1];
	outSize = inSize;
	int ret = compress(outBuffer+1,&outSize,inBuffer,inSize);

	if(ret == Z_OK && outBuffer!=0)
	{
		int keyflag=0;
		int keylength = strlen((char *)(gamekey));
		for(int i=0;i<inSize;++i)
		{
			*(outBuffer+i)=(*(outBuffer+i)^gamekey[keyflag]);
			keyflag = (keyflag+1)%keylength;
		}
		outBuffer[0]=inSize/blocksize + 1;//record number of blocks on the first byte
		outSize++;
		return true;
	}
	return false;
}

unsigned char* rc4DocumentBuffer(unsigned long inSize,unsigned char* inBuffer,unsigned long* outSize,const char* fileName)
{
	unsigned long inBufferSize = inSize;
	unsigned char* outBuffer = NULL;
	AVRC4 rc4_key;
	std::string sourceFilePath = fileName;
	std::string::size_type pos = sourceFilePath.find_last_of("/");
	std::string name = sourceFilePath.substr(pos + 1, sourceFilePath.length());
	unsigned char key[10];
	for (int i = 0; i < 10; ++i)
	{
		key[i] = name[i * 2];
	}
	av_rc4_init(&rc4_key, key, 10 * 8);

	if (inSize > 50000)
	{
		outBuffer = new unsigned char[DATA_BUFFER_SIZE*3];
	}
	else
	{
		outBuffer = new unsigned char[DATA_BUFFER_SIZE];
	}

	unsigned char* decOut = new unsigned char[inBufferSize - MARK_SIZE];
	av_rc4_crypt(&rc4_key,decOut,inBuffer + MARK_SIZE,inBufferSize - MARK_SIZE);
	unsigned long dataBufferSize = DATA_BUFFER_SIZE;
	if (inSize > 50000)
	{
		dataBufferSize = DATA_BUFFER_SIZE * 3;
	}
	int ret = uncompress(outBuffer,&dataBufferSize,decOut,inBufferSize - MARK_SIZE);
	if (Z_OK == ret)
	{
		*outSize = dataBufferSize;
		inBuffer = NULL;
		//inBuffer = outBuffer;
		//delete[] inBuffer;
		delete[] decOut;
		return outBuffer;
	}
	else
	{
		inBuffer=NULL;
		delete[] decOut;
		return outBuffer;
	}
}

unsigned char* rc4FilePath(unsigned long inSize, unsigned char* inBuffer,unsigned long* outSize,const unsigned char* key)
{
	unsigned long inBufferSize = inSize;
	unsigned char* outBuffer = NULL;
	AVRC4 rc4_key;
	av_rc4_init(&rc4_key, key, strlen((char*)key) * 8);

	unsigned long data_buffer_size = 128;
	outBuffer = new unsigned char[128];
	memset(outBuffer, 0, data_buffer_size);

	unsigned char* decOut = new unsigned char[inBufferSize];
	av_rc4_crypt(&rc4_key, decOut, inBuffer, inBufferSize);
	unsigned long dataBufferSize = data_buffer_size;

	memcpy(outBuffer, decOut, inBufferSize);
	*outSize = inBufferSize;
	delete[] decOut;
	return outBuffer;
}

unsigned char*  rc4TextureBuffer(unsigned long inSize,unsigned char* inBuffer,unsigned long* outSize,const char* fileName)
{
	unsigned char* outBuffer = 0;
	unsigned long inBufferSize = inSize;
	AVRC4 rc4_key;
	memset(&rc4_key,0,sizeof(AVRC4));
	std::string sourceFilePath = fileName;
	std::string::size_type pos = sourceFilePath.find_last_of("/");
	std::string name = sourceFilePath.substr(pos + 1, sourceFilePath.length());
	unsigned char key[10];
	for (int i = 0; i < 10; ++i)
	{
		key[i] = name[i * 2];
	}
	av_rc4_init(&rc4_key, key, 10 * 8);

	outBuffer = new unsigned char[inBufferSize - MARK_SIZE];

	int encodeBufferSize = 0;
	int encodeSize = 0x80;
	((inBufferSize - MARK_SIZE) > encodeSize) ? encodeBufferSize = encodeSize : encodeBufferSize = inBufferSize - MARK_SIZE;
	av_rc4_crypt(&rc4_key,outBuffer,inBuffer + MARK_SIZE,encodeBufferSize);
	if (encodeBufferSize < inBufferSize - MARK_SIZE)
	{
		memcpy(outBuffer + encodeSize,inBuffer + encodeSize + MARK_SIZE,inBufferSize - encodeSize - MARK_SIZE);
	}
	*outSize = inBufferSize - MARK_SIZE;
	delete[] inBuffer;
	return outBuffer;
}

/************************************************************************/
/* 解密                                                                 */
/************************************************************************/
unsigned char* getEncodeBuffer( unsigned long* inSize,unsigned char* buffer,const char * fileName,const char* pszMode)
{
	if (buffer && buffer[0] == 0xef && buffer[1] == 0xfe)
	{//发现是加密文件
		if (fileName != NULL&&pszMode!=NULL&&strcmp(pszMode, "rb") != 0)
		{//但是不是二进制文件读取的方式 
			std::string fileNameStr = fileName;
			delete[] buffer;
			//buffer = cocos2d::CCFileUtils::sharedFileUtils()->getFileData(fileName,"rb",inSize,false);//getFileData会再次调用getEncodeBuffer，需要return
			buffer = cocos2d::CCFileUtils::sharedFileUtils()->getFileData(fileName, "rb", inSize);//getFileData会再次调用getEncodeBuffer，需要return
			return buffer;
		}
		if (buffer[2] == 0x80)
		{
			buffer = rc4TextureBuffer(*inSize, buffer, inSize,fileName);
			return buffer;
		}
		else if (buffer[2] == 0xff)
		{
			buffer = rc4DocumentBuffer(*inSize, buffer, inSize,fileName);
			return buffer;
		}
		else
		{
			unsigned long outBufferSize = 0;
			unsigned char* outBuffer = 0;
			if (decBuffer(*inSize - 2, buffer + 2, outBufferSize, outBuffer))
			{
				delete[]buffer;
				*inSize = outBufferSize;
				return outBuffer;
			}
		}

		delete[]buffer;
		buffer = NULL;
		return buffer;
	}
	return buffer;
}


unsigned char*  decodeLuaFile(unsigned long* inSize, unsigned char* inBuffer,const char* filename)
{
	return getEncodeBuffer(inSize,inBuffer,filename,NULL);
	//return inBuffer;
}


std::string rc4EncFileName(const char *oriFileName)
{
	std::string oriFileStr(oriFileName);
	std::string retEncFile = "";
	std::string::size_type pointPos = oriFileStr.find_last_of(".");
	if (pointPos != 0 && pointPos != std::string::npos)
	{
		std::string::size_type pos = oriFileStr.find_last_of("/");
		std::string fileName = oriFileName;
		if (pos != 0 && pos != std::string::npos)
		{
			fileName = oriFileStr.substr(pos + 1, oriFileStr.length());
		}

		std::string encFileName = core_base64Encode((const unsigned char*)(fileName.c_str()), strlen(fileName.c_str()));
		MD5 md5(encFileName);

		if (pos != 0 && pos != std::string::npos)
		{
			std::string tmp = oriFileStr.substr(0, pos + 1).c_str();
			retEncFile = tmp;
		}
		std::string rc4 = encFileNameRc4(md5.md5().c_str());
		retEncFile += rc4;
		std::string fileNameSuffix = oriFileStr.substr(pointPos + 1, oriFileStr.length());
		if (ShowSuffixFlag || (!ShowSuffixFlag&&(fileNameSuffix=="mp3" || fileNameSuffix == "m4a")))
		{
			retEncFile += "." + fileNameSuffix;
		}
	}
	else
	{
		return oriFileStr;
	}
	return retEncFile;
}


std::string encFilePath(const char *oriFilePath)
{
	std::string oriFileStr(oriFilePath);
	std::string encFileName = core_base64Encode((const unsigned char*)(oriFileStr.c_str()), strlen(oriFileStr.c_str()));
	unsigned char fileBuffer[128];
	memcpy(fileBuffer,encFileName.c_str(),encFileName.length());
	unsigned long outSize;
	unsigned char key[16];
	memset(key, 0, 16);
	memcpy(key, encFileName.c_str(), 10);
	unsigned char* outBuffer = rc4FilePath(encFileName.length(), fileBuffer,&outSize,key);
	std::string name;
	for (unsigned int i = 0; i < outSize; ++i)
	{
		unsigned char ch = *(outBuffer + i);
		if ((ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z'))
		{
			name.push_back(ch);
		}		
		else
		{
			unsigned char tmp = ch % 10 + '0';
			name.push_back(tmp);
		}
	}
	return name;
}

std::string encFileNameRc4(const char *oriFilePath)
{
	std::string oriFileStr(oriFilePath);
	std::string encFileName = core_base64Encode((const unsigned char*)(oriFileStr.c_str()), strlen(oriFileStr.c_str()));
	unsigned char fileBuffer[128];
	memcpy(fileBuffer, encFileName.c_str(), encFileName.length());
	unsigned long outSize;
	unsigned char key[16];
	memset(key, 0, 16);
	memcpy(key, encFileName.c_str(), 10);
	unsigned char* outBuffer = rc4FilePath(encFileName.length(), fileBuffer, &outSize,key);
	std::string name;
	for (unsigned int i = 0; i < outSize; ++i)
	{
		unsigned char ch = *(outBuffer + i);
		if ((ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z'))
		{
			name.push_back(ch);
		}
		else
		{
			unsigned char tmp = ch % 10 + '0';
			name.push_back(tmp);
		}
	}
	return name;
}

std::string encShortFilePath(const char *oriFilePath)
{
	std::string oriFileStr(oriFilePath);
	std::string encFileName = core_base64Encode((const unsigned char*)(oriFileStr.c_str()), strlen(oriFileStr.c_str()));
	MD5 md5(encFileName);
	std::string str = md5.md5();
	std::string name = str.substr(0, 3) + str.substr(10,2) + str.substr(15, 1) + str.substr(20,1) + str.substr(23, 5);
	return name;
}

void setEncFlag(bool encFileNameFlag, bool encFilePathFlag, bool suffixFlag)
{
	EncFileNameFlag = encFileNameFlag;
	EncFilePath = encFilePathFlag;
	ShowSuffixFlag = suffixFlag;
}


std::string getGameEncFilePath(std::string filePath)
{
	if (cocos2d::CCFileUtils::sharedFileUtils()->canEncFilePath(EncFilePath))
	{
		std::string encFilePathStr = "";
		std::string backFilePath = filePath;
		std::string::size_type posSplit = filePath.find_first_of("/");
        if (posSplit == std::string::npos)
        {
            return "";
        }
		for (unsigned int i=0; posSplit != std::string::npos;++i)
		{
			encFilePathStr +="/"+ encFilePath(filePath.substr(0, posSplit).c_str());
			filePath = filePath.substr(posSplit + 1, filePath.length());
			posSplit = filePath.find_first_of("/");
		}

		posSplit = filePath.find_first_of(".");
		if (posSplit != 0 && posSplit != std::string::npos)
		{
			encFilePathStr = encShortFilePath(encFilePathStr.c_str());
			encFilePathStr += "/" + filePath;
		}
		else
		{
			encFilePathStr += "/" + encFilePath(filePath.c_str());
			encFilePathStr = encShortFilePath(encFilePathStr.c_str());
		}
		if (backFilePath.find("data") != std::string::npos)
		{
			encFilePathStr = "9df2ac2i4s8fs/" + encFilePathStr;
		}
		return encFilePathStr;

	}
	return filePath;
}


unsigned char* encryptRC4DocumentForIOS(unsigned char* codeBuffer, int sourceBufferSize, int& outSize,const char* filename)
{
	return encryptRC4DocumentForAndroid(codeBuffer, sourceBufferSize, outSize,filename);
}

unsigned char* encryptRC4DocumentForAndroid(unsigned char* codeBuffer, int sourceBufferSize,int& outSize,const char* filename)
{
	unsigned char* dataOut = NULL;
	const int pngEncodeSize = 128;
	const int dataBufferSize = 1024 * 1024;
	unsigned long writeBufferSize = 0;
	std::string fileName = filename;
	std::string encFileName = core_base64Encode((const unsigned char*)(fileName.c_str()), strlen(fileName.c_str()));
	MD5 md5(encFileName);
	std::string rc4 = encFileNameRc4(md5.md5().c_str());
	unsigned char key[10];
	for (int i = 0; i < 10; ++i)
	{
		key[i] = rc4[i * 2];
	}
	AVRC4 rc4_key;
	memset(&rc4_key, 0, sizeof(AVRC4));
	av_rc4_init(&rc4_key, key, 10 * 8);
	int markSize = 3;
	unsigned long compressSize = (unsigned long)(sourceBufferSize * 1.5);
	unsigned char* compressData = new unsigned char[compressSize];
	int ret = compress(compressData, &compressSize, codeBuffer, sourceBufferSize);
	if (ret == Z_OK)
	{
		dataOut = new unsigned char[compressSize + 3];
		outSize = compressSize + 3;
		dataOut[0] = 0xef;
		dataOut[1] = 0xfe;
		dataOut[2] = 0xff;
		av_rc4_crypt(&rc4_key, dataOut + 3, compressData, compressSize);
		writeBufferSize = compressSize + 3;

		delete[] compressData;

		return dataOut;
	}
	else
	{
		delete[] dataOut;
		delete[] codeBuffer;
		delete[] compressData;		
		return NULL;
	}
}