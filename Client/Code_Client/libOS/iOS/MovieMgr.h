//
//  MovieMgr.h
//  Sanguo2
//
//  Created by Liu Longfei on 13-11-13.
//
//

#ifndef __Sanguo2__MovieMgr__
#define __Sanguo2__MovieMgr__

class MovieMgr
{
public:
    MovieMgr();
    ~MovieMgr();
    
    static MovieMgr* instance();
    
public:
    
    void playMovie(const char* movie, int need_skip = 0);
    void pauseMovie();
    void replayMovie();
    void stopMovie();
};

#endif /* defined(__Sanguo2__MovieMgr__) */
