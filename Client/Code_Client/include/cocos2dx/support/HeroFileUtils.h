//
//  HeroFileUtils.h
//  cocos2dx
//
//  Created by dany on 14-6-16.
//

#ifndef __cocos2dx__HeroFileUtils__
#define __cocos2dx__HeroFileUtils__

#ifdef __cplusplus

extern "C" {
#endif
    void encypt_file_data(unsigned  char *data, unsigned long sz);
	//bool decodeFileData(unsigned  char *data, unsigned long* sz, unsigned char* outBuffer);
    void HGGetDeployFileName(const char *inputFileName, char *outfileName);
    char * HGFindFile(const char *inputFileName);
    /**
     Free String return by HGFindFile
     */
    void HGFreeString(char *str);
    
    int  HGForceRemoveDictory(const char * dir);
    
    int  HGCheckDirectoryExists(const char * dir);
    /*
     @return 
        0 is ok 
        else none zero
    */
    int  HGCheckFileDataHash(const char *expectHash, long expectSize, const char *fileName);

    unsigned char * HGGetFileContents(const char *inputFileName, unsigned long *sz);
    unsigned char * HGLoadScriptFileContents(const char *inputFileName, unsigned long *sz);
    void HGFreeFileContents(char *data);
    
    long HGGetFileModifyTime(const char *szFile);

#ifdef __cplusplus
}


#include <string>
#include <vector>
inline std::string HGFindFileCpp(const char *inputFileName)
{
    std::string ret ;
    char *szfile =HGFindFile(inputFileName);
    if(szfile)
    {
        ret = szfile;
        HGFreeString(szfile);
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
