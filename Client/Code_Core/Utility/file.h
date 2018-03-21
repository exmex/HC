#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <io.h>
#include <direct.h>
#include <malloc.h>
#include <sys/stat.h>
#include <map>
#include <vector>
#include <tchar.h>
#include <Windows.h>
#include <winnt.h>

int	PathExist(char *strPath);
int	CreateMultDir(const char *dir);

struct File_Struct{
	std::string mFileName;
	std::string mPathStr;
	File_Struct(std::string& fileName,std::string& pathStr)
	{
		mFileName = fileName;
		mPathStr = pathStr;
	}

};
//遍历文件夹函数
void TraverseFolder(const std::string& sourthPath,const std::string& subpath,std::vector<File_Struct>& pathMap,
	std::vector<std::string>& fileFliterVec,std::vector<std::string>& pathFliterVec);