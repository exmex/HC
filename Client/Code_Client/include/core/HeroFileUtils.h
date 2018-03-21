//
//  HeroFileUtils.h
//  cocos2dx
//
//  Created by eboz on 14-6-16.
//

#ifndef __cocos2dx__HeroFileUtils__
#define __cocos2dx__HeroFileUtils__

#ifdef __cplusplus

extern "C" {
#endif

	unsigned char*  decodeFileData(unsigned  char *data, unsigned long* sz,const char* filename);

    char * LegendFindFile(const char *inputFileName);
    /**
     Free String return by LegendFindFile
     */
    void LegendFreeString(char *str);
    
    int  LegendForceRemoveDictory(const char * dir);
    
    int  LegendCheckDirectoryExists(const char * dir);
    /*
     @return 
        0 is ok 
        else none zero
    */
    unsigned char * LegendGetFileContents(const char *inputFileName, unsigned long *sz);
    unsigned char * LegendLoadScriptFileContents(const char *inputFileName, unsigned long *sz);
    void LegendFreeFileContents(char *data);
    
    long LegendGetFileModifyTime(const char *szFile);

#ifdef __cplusplus
}


#include <string>
#include <vector>
inline std::string LegendFindFileCpp(const char *inputFileName)
{
    std::string ret ;
    char *szfile =LegendFindFile(inputFileName);
    if(szfile)
    {
        ret = szfile;
        LegendFreeString(szfile);
    }
    return  ret;
}

void * create_json_obj_frome_string(const char *jsonStr);
void * json_get_value(void *json_obj, const char* key);
std::vector<void *> json_get_array(void *json_obj, const char *key);
void free_json_obj(void *json_obj);
std::string json_value_to_string(void *jsonvalue);
int   json_value_to_integer(void *jsonvalue);


#endif

#endif /* defined(__cocos2dx__HeroFileUtils__) */
