
#include "stdafx.h"

#include "TableReader.h"
#include "cocos2d.h"
#include "GamePlatform.h"
#include "StringConverter.h"
#include "GameEncryptKey.h"

bool TableReader::parse( const std::string& filename , int jumplines)
{
	//TableReaderManager::Get()->getTableReader(filename.c_str());

	bool ret = false;
	unsigned long filesize;
	char* pBuffer = (char*)getFileData(
		cocos2d::CCFileUtils::sharedFileUtils()->fullPathForFilename(filename.c_str(), EncFileNameFlag, EncFilePath, ShowSuffixFlag).c_str(),
		"rt",&filesize);
	if(!pBuffer)
		return false;
	char* newData = new char[filesize+1];
	if(newData)
	{
		memcpy(newData,pBuffer,filesize);
		newData[filesize]=0;

		unsigned char* dataPtr = (unsigned char*)newData;
		if (filesize >= 2 && dataPtr[0] == 0xFF && dataPtr[1] == 0xFE)
			ret = parseFromBuffer(newData + 2,jumplines);
		else if (filesize >= 3 && dataPtr[0] == 0xEF && dataPtr[1] == 0xBB && dataPtr[1] == 0xBF)
			ret = parseFromBuffer(newData + 3,jumplines);
		else
			ret = parseFromBuffer(newData,jumplines);

		delete[] newData;
	}
	CC_SAFE_DELETE_ARRAY(pBuffer);
	
	return ret;
}

bool TableReader::parseFromBuffer(const char* fileBuffer, int jumplines)
{
	std::stringstream filestream(fileBuffer);
	std::string str;

	try
	{
		for(int i=0;i<jumplines;++i)
		{
			std::getline(filestream,str);
		}
		while(!filestream.eof())
		{
			std::getline(filestream,str);
			if(str.length()<=0)
				break;
			//std::getline(line,str,'\t');
			std::stringstream line1(str);
			readline(str);
			readline(line1);
		}
		return true;
	}
	catch(...)
	{
		cocos2d::CCMessageBox("Parse Table failed!","error");
		return false;
	}
}

TableReader::~TableReader()
{

}


void TableAutoReader::readline( const std::string& str )
{
	std::vector<std::string> line;

	size_t firstPos = 0;
	size_t secondPos = str.find_first_of("\t\n\r\0");
	std::string subStr;
	
	line.reserve(8);
	do
	{
		subStr = str.substr(firstPos,secondPos - firstPos);
		
		line.push_back(subStr);

		firstPos = (secondPos!=std::string::npos)?secondPos+1:std::string::npos;
		secondPos = str.find_first_of("\t\n\r\0",firstPos);
	}while(firstPos!=std::string::npos);

	mTable.push_back(line);
	int id = StringConverter::parseInt(line[0],-1);
	if(id!=-1)
		mIdIndex.insert(std::make_pair(id,mTable.size()-1));
}

bool TableAutoReader::seekLine( int line )
{
	if(mTable.size()>line)
	{
		mSeekedLine = line;
		return true;
	}
	return false;
}

bool TableAutoReader::seekIndex( int index )
{
	if(index == mCurrentIndex && index>=0)
		return true;

	std::map<int,int>::iterator it = mIdIndex.find(index);
	if(it!=mIdIndex.end() && it->second<mTable.size())
	{
		mSeekedLine = it->second;
		return true;
	}
	return false;
}

bool TableAutoReader::hasRow( int row )
{
	if(mSeekedLine<mTable.size())
	{
		std::vector<std::string>& line = mTable[mSeekedLine];
		if(line.size()>row)
			return true;
	}
	return false;
}

const char* TableAutoReader::getDataInRow( int row )
{
	if(mSeekedLine<mTable.size())
	{
		std::vector<std::string>& line = mTable[mSeekedLine];
		if(line.size()>row)
			return line[row].c_str();
	}
	return 0;
}

const char* TableAutoReader::getData( int line,int row )
{
	seekLine(line);
	return getDataInRow(row);
}

const char* TableAutoReader::getDataIndex( int index,int row )
{
	seekIndex(index);
	return getDataInRow(row);
}

bool TableAutoReader::parse( const std::string& filename, int jumplines /*= 0*/ )
{
	bool ret = false;
	unsigned long filesize;
	char* pBuffer = (char*)getFileData(
		cocos2d::CCFileUtils::sharedFileUtils()->fullPathForFilename(filename.c_str()).c_str(),
		"rt",&filesize);
	if(!pBuffer)
		return false;
	char* newData = new char[filesize+1];
	if(newData)
	{
		memcpy(newData,pBuffer,filesize);
		newData[filesize]=0;

		ret = parseFromBuffer(newData,jumplines);		
		delete[] newData;
	}
	CC_SAFE_DELETE_ARRAY(pBuffer);
	mSeekedLine = 1;
	mCurrentIndex = -1;
	return ret;
}

TableAutoReader::~TableAutoReader()
{

}

int TableAutoReader::getLineCount()
{
	return mTable.size();
}

bool XMLReader::parse(const std::string& filename, int jumplines /* = 0 */)
{
	tinyxml2::XMLDocument doc;  
	std::string fullpath = cocos2d::CCFileUtils::sharedFileUtils()->fullPathForFilename(filename.c_str());
	doc.LoadFile(fullpath.c_str());
	XMLElement* root= doc.RootElement();
	if (!root)
	{
		CCLOG("load %s error",filename.c_str());
		return false;
	}
	XMLElement* e = root->FirstChildElement();
	while(e)
	{
		this->readline(e);
		for (int line = 0; line < jumplines; line ++)
			e = e->NextSiblingElement();
	}
	return true;
}

TableAutoReader* TableReaderManager::getTableReader( const char* filename )
{
	if(mTableReaders.find(filename)!=mTableReaders.end())
		return mTableReaders[filename];
	else
	{
		TableAutoReader* reader = new TableAutoReader;
		reader->parse(filename);
		mTableReaders[filename] = reader;
		return reader;
	}
}

void TableReaderManager::reloadAllReader()
{
	std::map<std::string,TableAutoReader*>::iterator it = mTableReaders.begin();
	for(;it!=mTableReaders.end();++it)
	{
		if(it->second)
			it->second->parse(it->first);
	}
}
