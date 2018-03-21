//
//  MovieMgr.cpp
//
//  Created by Liu Longfei on 13-11-13.
//
//

#include "MovieMgr.h"
#include "AppController.h"

static MovieMgr* s_instance = NULL;

MovieMgr::MovieMgr()
{
    
}

MovieMgr::~MovieMgr()
{
    
}

MovieMgr* MovieMgr::instance()
{
    if (!s_instance)
    {
        s_instance = new MovieMgr();
    }
    
    return s_instance;
}

void MovieMgr::playMovie(const char* movie, int need_skip/* = true*/)
{
    AppController* app = [[UIApplication sharedApplication] delegate];
    NSString* str = [NSString stringWithUTF8String:movie];
    [app playMovie:str needSkip:need_skip];
}

void MovieMgr::pauseMovie()
{
    AppController* app = [[UIApplication sharedApplication] delegate];
    
  //  [app playMovie:str];
}

void MovieMgr::replayMovie()
{
    
}

void MovieMgr::stopMovie()
{
    AppController* app = [[UIApplication sharedApplication] delegate];
    
    [app stopMovie];
}







