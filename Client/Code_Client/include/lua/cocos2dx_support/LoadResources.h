//
//  LoadResources.h
//  HelloLua
//
//  Created by dany on 14-4-30.
//
//

#ifndef __HelloLua__LoadResources__
#define __HelloLua__LoadResources__

#include <iostream>
#include "cocos2d.h"
#include <vector>
namespace cocos2d
{



class LoadResources: public CCObject
{
public:
    static void load();
    static float getProgress();
    static  bool isEnd();
    static  LoadResources *create(size_t len);
    static  LoadResources *create();
    static void update();
    static int getCode();
    static int getStep();
    static std::string getDes();
    static  void releaseMemory();
    static bool checkUpdate();
    static  std::vector<LoadResources *> createdList;
    static bool isBinaryUpdated();
    static bool isScriptChanged();
    void insert(const char*param1);
    

};

}
#endif /* defined(__HelloLua__LoadResources__) */
