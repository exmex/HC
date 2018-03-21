#pragma once

#include <string>

void saveFileInPath(const std::string& fileInPath, const char* mode, const unsigned char* data, unsigned long size);

unsigned char* getFileData(const char* pszFileName, const char* pszMode, unsigned long * pSize, unsigned short* crc = 0, bool isShowBox = true, bool isEncFileName = false,bool isEncFilePath=false, bool SuffixFlag=true);

void game_rmdir(const char* path);

long long game_getFreeSpace();