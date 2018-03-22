#pragma once

#include <string>

const unsigned char gamekey[]="f*%dj#@jde";
const int blocksize = 1024*8;
const int DATA_BUFFER_SIZE = 1024*1024;
const int MARK_SIZE = 3;


//文件名加密标志位
static bool EncFileNameFlag = false;
//文件路径加密标志位e
static bool EncFilePath = false;
//文件名后缀是否展现标志位
static bool ShowSuffixFlag = false;

bool encBuffer(unsigned long inSize , unsigned char* inBuffer, unsigned long& outSize, unsigned char*& outBuffer);

bool decBuffer(unsigned long inSize , unsigned char* inBuffer, unsigned long& outSize, unsigned char*& outBuffer);

unsigned char* rc4DocumentBuffer(unsigned long inSize,unsigned char* inBuffer,unsigned long* outSize,const char* fileName);

unsigned char* rc4FilePath(unsigned long inSize, unsigned char* inBuffer,unsigned long* outSize,const unsigned char* key);

unsigned char* rc4TextureBuffer(unsigned long inSize,unsigned char* inBuffer,unsigned long* outSize,const char* fileName);

unsigned char* getEncodeBuffer( unsigned long* inSize,unsigned char* buffer,const char * fileName,const char* pszMode);

unsigned char*  decodeLuaFile(unsigned long* inSize, unsigned char* inBuffer,const char* filename);

std::string rc4EncFileName(const char *oriFileName);

std::string encFilePath(const char *oriFilePath);

std::string encFileNameRc4(const char *oriFilePath);

std::string encShortFilePath(const char *oriFilePath);

void setEncFlag(bool encFileNameFlag, bool encFilePathFlag, bool suffixFlag);

std::string getGameEncFilePath(std::string filePath);

unsigned char* encryptRC4DocumentForAndroid(unsigned char* codeBuffer, int sourceBufferSize, int& outSize,const char* filenmae);

unsigned char* encryptRC4DocumentForIOS(unsigned char* codeBuffer, int sourceBufferSize, int& outSize,const char* filename);