/****************************************************************************
Copyright (c) 2011 cocos2d-x.org

http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/
#include "Cocos2dxLuaLoader.h"
#include <string>

using namespace cocos2d;

extern "C"
{
    int loader_Android(lua_State *L)
    {
        std::string filename(luaL_checkstring(L, 1));
        filename.append(".lua");

        CCString* pFileContent = CCString::createWithContentsOfFile(filename.c_str());

        if (pFileContent)
        {
            if (luaL_loadstring(L, pFileContent->getCString()) != 0)
            {
                luaL_error(L, "error loading module %s from file %s :\n\t%s",
                    lua_tostring(L, 1), filename.c_str(), lua_tostring(L, -1));
            }
        }
        else
        {
            CCLog("can not get file data of %s", filename.c_str());
        }

        return 1;
    }

	int cocos2dx_lua_loader(lua_State *L)
	{
		std::string filename(luaL_checkstring(L, 1));
		size_t pos = filename.rfind(".lua");
		if (pos != std::string::npos)
		{
			filename = filename.substr(0, pos);
		}

		pos = filename.find_first_of(".");
		while (pos != std::string::npos)
		{
			filename.replace(pos, 1, "/");
			pos = filename.find_first_of(".");
		}

		std::string usingname = filename + ".lua";

		struct cc_timeval beginLoad;
		CCTime::gettimeofdayCocos2d(&beginLoad, NULL);
		clock_t beginClock, endclock;
		beginClock = clock();

		unsigned long codeBufferSize = 0;
		unsigned char* codeBuffer = CCFileUtils::sharedFileUtils()->getFileData(cocos2d::CCFileUtils::sharedFileUtils()->fullPathForFilename(usingname.c_str()).c_str(),
			"rb", &codeBufferSize, true);
		if (codeBuffer)
		{
			if (luaL_loadbuffer(L, (char*)codeBuffer, codeBufferSize, usingname.c_str()) != 0)
			{
				luaL_error(L, "Cocos2dxLuaLoader:cocos2dx_lua_loader | error loading module %s from file %s :\n\t%s",
					lua_tostring(L, 1), usingname.c_str(), lua_tostring(L, -1));
			}
			delete[] codeBuffer;
		}
		else
		{
			CCLog("Cocos2dxLuaLoader:cocos2dx_lua_loader | can not get lua file data of %s", usingname.c_str());
		}

		struct cc_timeval endLoad;
		CCTime::gettimeofdayCocos2d(&endLoad, NULL);
		float deletaTime = (endLoad.tv_sec - beginLoad.tv_sec) + (endLoad.tv_usec - beginLoad.tv_usec) / 1000000.0f;
		endclock = clock();
		if (true)
		{
			CCLog("Cocos2dxLuaLoader:cocos2dx_lua_loader | load lua filename:%s cost: %f second,%d ", filename.c_str(), deletaTime, endclock - beginClock);
		}
		return 1;
	}
}
