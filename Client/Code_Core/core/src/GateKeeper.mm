//
//  GateKeeper.cpp
//  hero
//
//  Created by dany on 14-6-13.
//
//

#include "GateKeeper.h"

int  gk_get_gamecenter_enabled()
{
    return 0;
}


int  gk_is_alpha_version()
{
    if( [[[NSBundle mainBundle] bundleIdentifier ]  compare:@"com.ucool.heroalpha"] == NSOrderedSame )
    {
        return 1;
    }
    
    return 0;
}