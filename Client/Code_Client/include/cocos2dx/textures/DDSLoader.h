#ifndef DDS_LOADER_h
#define DDS_LOADER_h

#include <stdio.h>
#include <string>

#include "DDSLoaderHelp.h"

using namespace std;

bool LoadDDS(const char* _fileName, tScratchImage& tImage);
bool LoadDDS(const wchar_t* _fileName, tScratchImage& tImage);


#endif